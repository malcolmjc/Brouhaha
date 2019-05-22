import UIKit
import FirebaseDatabase
import Firebase
import MapKit
import GeoFire

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var databaseRef : DatabaseReference?
    var geoFire : GeoFire?
    var regionQuery : GFRegionQuery?
    
    @IBOutlet weak var map: MKMapView!
    var arAnnotations = [ARAnnotation]()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference().child("ARPosts")
        geoFire = GeoFire(firebaseRef: Database.database().reference().child("GeoFire"))
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        //TODO: uncomment this so map is centered around user's actual location
        //let startRegion = MKCoordinateRegion(center: locationManager.location!.coordinate, span: span)
        let startRegion = MKCoordinateRegion(center: cscBuilding, span: span)
        map.setRegion(startRegion, animated: true)
        
        retrieveARAnnotations()
    }
    
    func geofireConfigure() {
        for anno in arAnnotations {
            geoFire?.setLocation(CLLocation(latitude: anno.latitude,
                                             longitude: anno.longitude), forKey: anno.dateCreated)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationIdentifier = "arPostIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            //annotationView?.canShowCallout = true
            
            // Resize image
            let pinImage = UIImage(named: "test.png")
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            annotationView?.image = resizedImage
        }
        else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        
        updateRegionQuery()
    }
    
    func updateRegionQuery() {
        if let oldQuery = regionQuery {
            oldQuery.removeAllObservers()
        }
        
        regionQuery = geoFire?.query(with: map.region)
        
        regionQuery?.observe(.keyEntered, with: { (key, location) in
            self.databaseRef?.queryOrderedByKey().queryEqual(toValue: key).observe(.value, with: { snapshot in
                
                let newARAnno = ARAnnotation(key:key, snapshot:snapshot)
                self.addNewARAnnotation(newARAnno)
            })
        })
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setRegion(MKCoordinateRegion.init(center: (mapView.userLocation.location?.coordinate)!, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
    }
    
    func addNewARAnnotation(_ arAnnotation: ARAnnotation) {
        DispatchQueue.main.async {
            self.map.addAnnotation(arAnnotation)
        }
    }
    
    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
    }
    
    let another = CLLocationCoordinate2D(latitude: 35.903529, longitude: -120.662795)
    let campusMarket = CLLocationCoordinate2D(latitude: 35.303529, longitude: -120.662795)
    let cscBuilding = CLLocationCoordinate2D(latitude: 35.300066, longitude: -120.662065)
    func retrieveARAnnotations() {
        self.databaseRef!.observeSingleEvent(of: .value, with: { (snapshot) in
            for snap in snapshot.children {
                let snap = snap as! DataSnapshot
                self.arAnnotations.append(ARAnnotation(key: snap.key, snapshot: snapshot))
            }
            
            self.geofireConfigure()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        performSegue(withIdentifier: "showARCamera", sender: self)
    }
}
