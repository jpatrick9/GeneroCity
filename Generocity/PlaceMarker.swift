//
//  PlaceMarker.swift
//  Generocity
//
//  Created by Dante  Lacey-Thompson on 12/21/17.
//  Copyright © 2017 Dante  Lacey-Thompson. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    let gPlace: GooglePlace
    
    init(place: GooglePlace) {
        self.gPlace = place
        super.init()
        
        position = gPlace.coordinate
        if (gPlace.iconURL.range(of: "civic_building") != nil) {
            icon = UIImage(named: "civic_building-71")
        } else {
            icon = UIImage(named: "generic_business-71")
        }
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = GMSMarkerAnimation.pop
    }
}
