//
//  GoogleDataProvider.swift
//  Generocity
//
//  Created by Dante  Lacey-Thompson on 12/22/17.
//  Copyright © 2017 Dante  Lacey-Thompson. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation
import SwiftKeychainWrapper

class GoogleDataProvider {
    
    var placesTask:URLSessionDataTask?
    var session: URLSession{
        return URLSession.shared
    }
    //search_preference , distance_slider
    var searchPref: String {
        return UserDefaults.standard.string(forKey: "search_preference")!
    }
    
    var distancePref: Int {
        return UserDefaults.standard.integer(forKey: "distance_slider")
    }
    
    func fetchPlacesNearCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (([GooglePlace]) -> Void)) -> ()
    {
        //        let retrievedString: String? = KeychainWrapper.standard.string(forKey: "GMAK")
        if let gmpwk: String = KeychainWrapper.standard.string(forKey: "GMPWK"){
            print("got gmpwk")
            let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(String(distancePref))&keyword=\(searchPref)&key=\(gmpwk)"
            if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
                task.cancel()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            placesTask = session.dataTask(with: URL(string: urlString)!, completionHandler: { data, response, error in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                var placeArray = [GooglePlace]()
                if let aData = data {
                    let json = JSON(data:aData, options:JSONSerialization.ReadingOptions.mutableContainers, error:nil)
                    if let results = json["results"].arrayObject as? [[String: AnyObject]]{
                        print(json["results"])
                        for rawPlace in results {
                            let place = GooglePlace(dictionary: rawPlace)
                            placeArray.append(place)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(placeArray)
                }
            })
            placesTask?.resume()
        }
    }
    
    func checkPreferences(){
        print(searchPref, distancePref)
    }
}
