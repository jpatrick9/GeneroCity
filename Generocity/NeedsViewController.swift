//
//  NeedsViewController.swift
//  Generocity
//
//  Created by Dante  Lacey-Thompson on 12/26/17.
//  Copyright © 2017 Dante  Lacey-Thompson. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NeedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var needsPlace: GooglePlace!
    var needsList = [String]()
    var filteredNeedsList = [String]()
    var needsDictionary = [String: String]()
    var inSearchMode = false
    let ref = Database.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        print("In Needs View Controller")
        self.navigationItem.title = "\(needsPlace.name) Needs"
        self.ref.child("place-list").child(needsPlace.placeID).child("needs").observe(.value, with: {
            snapshot in
            var newNeeds: [String] = []
            for item in snapshot.children{
                let itemSnap = item as! DataSnapshot
                let itemId = itemSnap.key //the id of each need
                let need = itemSnap.value
                print("need: \(need ?? "need for shelter")")
                newNeeds.append(need as! String)
                self.needsDictionary.updateValue(need as! String, forKey: itemId)
            }
//            print(self.needsDictionary)
            self.needsList = newNeeds
            self.needsPlace.placeNeeds = newNeeds
            self.filteredNeedsList = newNeeds
            self.tableView.reloadData()
        })
        
    }
    
    //SearchBar Functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
        }else{
            inSearchMode = true
            let search = searchBar.text?.lowercased()
            filteredNeedsList = needsList.filter({$0.range(of: search!) != nil})
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    //TableView and DataSource Functionality
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredNeedsList.count : needsList.count
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .delete
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NeedCell", for: indexPath) as? NeedCell{
            cell.configCell(gPlace: needsPlace, need: inSearchMode ? filteredNeedsList[indexPath.row] : needsList[indexPath.row])
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //make an alert to do delete functionality
        let needAtPlace = needsList[indexPath.row]
        let alertController = UIAlertController(title: "\(needAtPlace)", message: "Would you like to confirm drop off for this need at \(needsPlace.name)", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {action in
            self.deleteNeedFromPlace(needToDelete: needAtPlace)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_) in})
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteNeedFromPlace(needToDelete: String){
        print("In need delete and search function")
        let needKey = self.needsDictionary.someKey(forValue: needToDelete)
//        print(self.ref.child("place-list").child(needsPlace.placeID).child("needs").child(needKey!))
//        self.ref.child("place-list").child(needsPlace.placeID).child("needs").child(needKey!).observeSingleEvent(of: .value, with: {(snapshot) in
//            let val = snapshot.value as! String
//            print("snapshot val: \(val)")
//        })
        self.ref.child("place-list").child(needsPlace.placeID).child("needs").child(needKey!).removeValue(completionBlock: {(error, refer) in
                if error != nil{
                    print(error ?? "error removing value from database")
                }else{
                    print(refer)
                    print("child removed correctly")
            }
            })
    }
    
}

extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
