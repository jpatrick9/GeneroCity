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
                let need = itemSnap.value
                print("need: \(need ?? "need for shelter")")
                newNeeds.append(need as! String)
            }
            self.needsList = newNeeds
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NeedCell", for: indexPath) as? NeedCell{
            cell.configCell(gPlace: needsPlace, need: inSearchMode ? filteredNeedsList[indexPath.row] : needsList[indexPath.row])
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
}
