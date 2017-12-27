//
//  NeedCell.swift
//  
//
//  Created by Dante  Lacey-Thompson on 12/26/17.
//
//

import Foundation
import UIKit

class NeedCell: UITableViewCell {
    @IBOutlet weak var needLabel: UILabel!
    var place: GooglePlace!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configCell(gPlace: GooglePlace, need: String){
        self.needLabel.adjustsFontSizeToFitWidth = true
        self.place = gPlace
        self.needLabel.text = need
    }
}
