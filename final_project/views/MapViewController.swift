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
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "arPostIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            
            let arAnnotation = annotation as? ARAnnotation
            // Resize image if it exists and use it as a thumbnail
            if let anno = arAnnotation {
                let pinImage = anno.pngImage
                if let image = pinImage {
                    var size = CGSize(width: 50, height: 50)
                    UIGraphicsBeginImageContext(size)
                    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    var resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                    //annotationView?.image = resizedImage
                    //annotationView?.layer.cornerRadius = (annotationView?.frame.size.width)! / 2
                    //annotationView?.clipsToBounds = true
                    
                    var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    imageView.image = resizedImage
                    imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
                    imageView.layer.masksToBounds = true
                    annotationView?.addSubview(imageView)
                    annotationView?.frame = imageView.frame
                    
                    annotationView?.canShowCallout = true
                    size = CGSize(width: 248, height: 248)
                    UIGraphicsBeginImageContext(size)
                    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                    resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                    imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 248, height: 248))
                    imageView.image = resizedImage
                    annotationView?.detailCalloutAccessoryView = imageView
                }
            }
        }
        else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
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
                if !self.alreadyUsedUrls.contains(newARAnno.worldMapDataLink) {
                    self.addNewARAnnotation(newARAnno)
                }
            })
        })
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setRegion(MKCoordinateRegion.init(center: (mapView.userLocation.location?.coordinate)!,
         span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
    }
    
    var alreadyUsedUrls = Set<String>()
    func addNewARAnnotation(_ arAnnotation: ARAnnotation) {
        DispatchQueue.main.async {
            self.alreadyUsedUrls.insert(arAnnotation.worldMapDataLink)
            arAnnotation.getImageData(completion: { () in self.map.addAnnotation(arAnnotation) })
        }
    }
    
    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
    }
    
    let another = CLLocationCoordinate2D(latitude: 35.903529, longitude: -120.662795)
    let campusMarket = CLLocationCoordinate2D(latitude: 35.303529, longitude: -120.662795)
    let cscBuilding = CLLocationCoordinate2D(latitude: 35.300066, longitude: -120.662065)
    
    @IBAction func cameraButton(_ sender: Any) {
        performSegue(withIdentifier: "showARCamera", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showARCamera" {
            let destVC = segue.destination as? ARViewController
            destVC?.geoFire = self.geoFire
        }
    }
}
