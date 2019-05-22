import Foundation
import MapKit
import Firebase

class ARAnnotation : NSObject, MKAnnotation {
    let ref: DatabaseReference?
    var latitude: Double
    var longitude: Double
    var imageLink: String
    var worldMapDataLink: String
    var dateCreated: String
    
    init(dateCreated: String, imageLink: String, worldMapDataLink: String, latitude: Double, longitude: Double) {
        self.dateCreated = dateCreated
        self.imageLink = imageLink
        self.worldMapDataLink = worldMapDataLink
        self.latitude = latitude
        self.longitude = longitude
        ref = nil
        
        super.init()
    }
    
    init(key: String, snapshot: DataSnapshot) {
        let snaptemp = snapshot.value as! [String : AnyObject]
        let snapvalues = snaptemp[key] as! [String : AnyObject]

        imageLink = snapvalues["imageLink"] as? String ?? "N/A"
        latitude = snapvalues["latitude"] as? Double ?? 0.0
        longitude = snapvalues["longitude"] as? Double ?? 0.0
        dateCreated = snapvalues["dateCreated"] as? String ?? "N/A"
        worldMapDataLink = snapvalues["worldMapDataLink"] as? String ?? "N/A"
        
        ref = snapshot.ref
        
        super.init()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func toAnyObject() -> Any {
        return [
            "imageLink" : imageLink,
            "worldMapDataLink" : worldMapDataLink,
            "latitude" : latitude,
            "longitude" : longitude,
            "dateCreated": dateCreated
        ]
    }
}
