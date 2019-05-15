import Foundation
import MapKit

class ARAnnotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    
    init(coord: CLLocationCoordinate2D, named: String, detail: String) {
        coordinate = coord
        title = named
        subtitle = detail
        
        super.init()
    }
    
}
