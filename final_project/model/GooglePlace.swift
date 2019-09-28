//
//  GooglePlace.swift
//  final_project
//
//  Created by Malcolm Craney on 4/21/19.
//  Copyright © 2019 Malcolm Craney. All rights reserved.
//  Credit to https://www.raywenderlich.com/197-google-maps-ios-sdk-tutorial-getting-started

import UIKit
import Foundation
import CoreLocation
import SwiftyJSON

class GooglePlace {
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    var placeType: String?
    var photoReference: String?
    var photo: UIImage?
    
    init(dictionary: [String: Any], acceptedTypes: [String])
    {
        let json = JSON(dictionary)
        name = json["name"].stringValue
        address = json["vicinity"].stringValue
        
        let latitude = json["geometry"]["location"]["lat"].doubleValue as CLLocationDegrees
        let longitude = json["geometry"]["location"]["lng"].doubleValue as CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        photoReference = json["photos"][0]["photo_reference"].string
        
        placeType = getType(json, acceptedTypes) ?? "n/a"
    }
    
    func getType(_ json: JSON, _ acceptedTypes: [String]) -> String? {
        if let types = json["types"].arrayObject as? [String] {
            for type in types {
                if acceptedTypes.contains(type) {
                    return type
                }
            }
        }
        return nil
    }
}
