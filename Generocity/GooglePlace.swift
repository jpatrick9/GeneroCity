//
//  GooglePlace.swift
//  Generocity
//
//  Created by Dante  Lacey-Thompson on 12/21/17.
//  Copyright © 2017 Dante  Lacey-Thompson. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class GooglePlace  {
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    var iconURL: String
    var placeID: String
    
    init(dictionary: [String: AnyObject]) {
        let json = JSON(dictionary)
        name = json["name"].stringValue
        address = json["vicinity"].stringValue
        let lat = json["geometry"]["location"]["lat"].doubleValue as CLLocationDegrees
        let lng = json["geometry"]["location"]["lng"].doubleValue as CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        iconURL = json["icon"].stringValue
        placeID = json["place_id"].stringValue
    }
    
}
