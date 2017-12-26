//
//  AddNeedsViewController.swift
//  Generocity
//
//  Created by Dante  Lacey-Thompson on 12/26/17.
//  Copyright © 2017 Dante  Lacey-Thompson. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import Firebase


class AddNeedsViewController: FormViewController {
    
    var placeAdd: GooglePlace!
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In add details view controller.")
        self.navigationItem.title = "\(placeAdd.name)"
//        print(placeAdd.name)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTask))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNeed))
        setUpFormView()
    }
    
    func setUpFormView(){
        form +++ Section("\(placeAdd.name) Information")
            <<< TextRow(){
                row in
                row.title = "Name"
                row.tag = "nameRow"
                row.value = placeAdd.name
        }
            <<< TextRow(){
                row in
                row.title = "Address"
                row.tag = "addressRow"
                row.value = placeAdd.address
        }
        +++ Section("\(placeAdd.name): Need Information")
            <<< TextRow(){
                row in
                row.title = "Need"
                row.tag = "needRow"
                row.placeholder = "e.g Food/Clothes/Blankets"
        }
    }
    
    func cancelTask(){
        print("Cancel Button pressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    func addNeed(){
        let row: TextRow? = form.rowBy(tag: "needRow")
        if let value = row?.value {
            print(value)
//            self.ref.child("place-list").child(self.placeAdd.placeID).child("needs").updateChildValues(["needs": value])
            self.ref.child("place-list").child(self.placeAdd.placeID).child("needs").childByAutoId().setValue(value)
            row?.value = ""
        } else{
            //make alert
            print("invalid value")
            let alert = UIAlertController(title: "Alert", message: "Invalid Need Entry. Need Field Needs to Be populated", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
