//
//  Dashboard.swift
//  Generocity
//
//  Created by Dante  Lacey-Thompson on 11/22/17.
//  Copyright © 2017 Dante  Lacey-Thompson. All rights reserved.
//

import Foundation
import UIKit

class Dashboard: BaseViewController {
    
    @IBOutlet weak var showMapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        print("In dashboard view")
    }
    
    @IBAction func showUserMap(){
        performSegue(withIdentifier: "dashToMap", sender: self)
    }
}
