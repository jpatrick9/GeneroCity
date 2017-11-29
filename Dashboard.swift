//
//  Dashboard.swift
//  Generocity
//
//  Created by Dante  Lacey-Thompson on 11/22/17.
//  Copyright © 2017 Dante  Lacey-Thompson. All rights reserved.
//

import Foundation
import UIKit

class Dashboard: UIViewController {
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var showMapButton: UIButton!
    @IBOutlet weak var ProfileButton: UIButton!
    @IBOutlet weak var InfoButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In dashboard view")
    }
    
    @IBAction func showUserMap(){
        performSegue(withIdentifier: "dashToMap", sender: self)
    }
}
