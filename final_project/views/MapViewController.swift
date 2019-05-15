import UIKit
import FirebaseDatabase
import Firebase
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    let campusMarket = CLLocationCoordinate2D(latitude: 35.303529, longitude: -120.662795)
    
    let cscBuilding = CLLocationCoordinate2D(latitude: 35.300066, longitude: -120.662065)
    
    @IBOutlet weak var map: MKMapView!
    
    var arAnnotations = [ARAnnotation]()
    
    @IBAction func cameraButton(_ sender: Any) {
        performSegue(withIdentifier: "showARCamera", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //databaseRef = Database.database().reference().child("Groups").child(groupName ?? "Cal Poly").child("subgroups").child(subgroupName)
        
        retrieveARAnnotations()
        placeAnnotations()
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let startRegion = MKCoordinateRegion(center: cscBuilding, span: span)
        map.setRegion(startRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationIdentifier = "arPostIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
            
            // Resize image
            let pinImage = UIImage(named: "test.png")
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            annotationView?.image = resizedImage
            
            let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
            annotationView?.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func retrieveARAnnotations() {
        //TODO: do this from a geofire query
        let cscBldg = ARAnnotation(coord: cscBuilding, named: "CSC Building", detail: "Class HQ")
        let campMkt = ARAnnotation(coord: campusMarket, named: "Campus Market", detail: "Food HQ")
        arAnnotations.append(cscBldg)
        arAnnotations.append(campMkt)
    }
    
    func placeAnnotations() {
        map.addAnnotations(arAnnotations)
    }
    
    @IBAction func unwindToMap(segue: UIStoryboardSegue) {
    }
}
