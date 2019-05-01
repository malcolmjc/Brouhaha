//
//  ExploreViewController.swift
//  final_project
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GooglePlaces
import SwiftyJSON
import CoreLocation

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var groupList = [Group]()
    var searchActive: Bool = false
    var filteredGroupList: [Group] = []
    
    var databaseRef: DatabaseReference!
    
    var placesClient: GMSPlacesClient!
    
    var locationManager = CLLocationManager()
    
    //5 miles
    private let searchRadius: Double = 8047
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.placeholder = "Search groups..."
        
        placesClient = GMSPlacesClient.shared()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        let status = CLLocationManager.authorizationStatus()
        if (status == CLAuthorizationStatus.authorizedAlways) {
           getCurrentPlace()
        }
    }
    
    private var placesTask: URLSessionDataTask?
    private var session: URLSession {
        return URLSession.shared
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            getCurrentPlace()
        }
    }
    
    var searchedTypes = ["school"]
    let apiKey = "AIzaSyAC41BkTpzweP8yYCeECwWwZ7u0ZZW-Kv0"
    
    func getPlacesUrl(_ coordinate: CLLocationCoordinate2D, radius: Double, types: [String]) -> URL? {
        var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true&key=\(apiKey)"
        
        let typesString = types.joined(separator: "|")
        urlString += "&types=\(typesString)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
        
        print(urlString)
        
        return URL(string: urlString)
    }
    
    func getNearbyPlaces(_ coordinate: CLLocationCoordinate2D, radius: Double, types: [String]) -> Void {
        if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
            task.cancel()
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        guard let url = getPlacesUrl(coordinate, radius: radius, types: types) else {
            return
        }
        
        placesTask = session.dataTask(with: url) { data, response, error in
            var placesArray: [GooglePlace] = []
            self.groupList = []
            defer {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
            }
            guard let data = data,
                let json = try? JSON(data: data, options: .mutableContainers),
                let results = json["results"].arrayObject as? [[String: Any]] else {
                    return
            }
        
            results.forEach {
                let place = GooglePlace(dictionary: $0, acceptedTypes: types)
                placesArray.append(place)
                self.groupList.append(Group(place.name))
                /*if let reference = place.photoReference {
                    self.fetchPhotoFromReference(reference) { image in
                        place.photo = image
                    }
                }*/
            }
        }
        placesTask?.resume()
    }

    
    func getCurrentPlace() {
        getNearbyPlaces(locationManager.location!.coordinate, radius: searchRadius, types: searchedTypes)
    }
    
    func retrieveGroups() {
        databaseRef?.observe(.value, with: { snapshot in
                
                self.groupList = []
                
                for item in snapshot.children {
                    let actItem = item as? DataSnapshot
                    self.groupList.append(Group(snapshot: actItem!))
                }
                
                self.tableView.reloadData()
        })
    }
    
    @IBAction func addGroupButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "addGroup", sender: self)
    }
    
    @IBAction func sortPressed(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Group Type", preferredStyle: .actionSheet)
        
        let schoolAction = UIAlertAction(title: "School", style: .default, handler: optionSelected)
        let cafeAction = UIAlertAction(title: "Cafe", style: .default, handler: optionSelected)
        let barAction = UIAlertAction(title: "Bar", style: .default, handler: optionSelected)
        let churchAction = UIAlertAction(title: "Church", style: .default, handler: optionSelected)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(schoolAction)
        optionMenu.addAction(cafeAction)
        optionMenu.addAction(barAction)
        optionMenu.addAction(churchAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func optionSelected(action: UIAlertAction) {
        getNearbyPlaces(locationManager.location!.coordinate, radius: searchRadius,
                        types: [action.title!.lowercased()])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchActive = false
        } else {
            searchActive = true
            filteredGroupList = []
            for group in groupList {
                if group.name.lowercased().contains(searchText.lowercased()) {
                    filteredGroupList.append(group)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    var currentGroup: Group?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentGroup = groupList[indexPath.row]
        performSegue(withIdentifier: "getSubgroups", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchActive ? filteredGroupList.count : groupList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell
    
        let group = searchActive ? filteredGroupList[indexPath.row] : groupList[indexPath.row]

        cell?.groupLabel.text = group.name
        
        return cell!
    }
    
    @IBAction func unwindToExplore(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getSubgroups" {
            let destVC = segue.destination as? GroupViewController
            destVC?.groupName = currentGroup!.name
        }
    }
}
