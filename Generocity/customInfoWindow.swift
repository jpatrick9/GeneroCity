//
//  customInfoWindow.swift
//  Generocity
//
//  Created by Dante  Lacey-Thompson on 12/24/17.
//  Copyright © 2017 Dante  Lacey-Thompson. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class CustomInfoWindow: UIView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dropButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
        
}
