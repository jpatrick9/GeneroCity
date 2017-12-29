//
//  UserMap.swift
//  Generocity
//
//  Created by Dante  Lacey-Thompson on 11/23/17.
//  Copyright © 2017 Dante  Lacey-Thompson. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Firebase
import FirebaseDatabase
import SwiftyJSON
import SwiftKeychainWrapper
import Alamofire

class UserMap: BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
//    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    let dataProvider = GoogleDataProvider()
    let placeRef = Database.database().reference(withPath: "place-list")
    let ref = Database.database().reference()
    var destAddress: String!
    var infoWindow = CustomInfoWindow()
    var activePoint: GooglePlace!
    var tempPoint: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
//        locationManager.delegate = self
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        print("map view loaded")
        getLocation()
//        dataProvider.checkPreferences()
    }
    
    
    
    func getLocation(){
        locationManager.delegate = self
        locationManager.distanceFilter = 1
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                mapView.isMyLocationEnabled = true
                locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations.last!
        print("Current location: \(currentLocation)")
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 15.0)
        mapView.animate(to: camera)
//        locationManager.stopUpdatingLocation()
//        if let uniqID = UUIDValue{
//            let pass_me = String("https://bounceapp.online/backend/userTracking.php?lat=\(currentLocation.coordinate.latitude)&lon=\(currentLocation.coordinate.longitude)&dev=\(uniqID)")
//            print("UniqueIDentifier: \(uniqID)")
//            print("URL:\(String(describing: pass_me))")
//            self.bgWebView.loadRequest(URLRequest(url: URL(string: pass_me!)!))
//        }
        fetchNearbyPlaces(coordinate: currentLocation.coordinate)
    }
    
    
    // 2
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        <#code#>
//    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D){
        mapView.clear()
        dataProvider.fetchPlacesNearCoordinate(coordinate) { places in
            for place: GooglePlace in places {
                let marker = PlaceMarker(place: place)
                marker.title = place.name
                marker.userData = place
                marker.map = self.mapView
                let placeJson: Dictionary = [
                    "name": place.name,
                    "address": place.address,
                ]
//                print(placeJson)
                self.ref.child("place-list").observeSingleEvent(of: .value, with: {(snapshot) in
                    if snapshot.hasChild(place.placeID){
                        print("Place exists with ID: \(place.placeID)")
                    }else{
                        print("place doesn't exist with ID: \(place.placeID)")
                        self.ref.child("place-list").child(place.placeID).setValue(placeJson)
                    }
                })
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let gPlace = marker.userData as? GooglePlace{
            if activePoint != nil{
                infoWindow.removeFromSuperview()
                activePoint = nil
            }
            infoWindow = Bundle.main.loadNibNamed("infoWindow", owner: self, options: nil)?.first as! CustomInfoWindow
            infoWindow.nameLabel.text = (marker.userData as! GooglePlace).name
            infoWindow.addressLabel.text = (marker.userData as! GooglePlace).address
            self.destAddress = (marker.userData as! GooglePlace).address
            infoWindow.directionsButton.addTarget(self,  action: #selector(getDirections(_:)), for: .touchUpInside)
            infoWindow.addButton.addTarget(self, action: #selector(goToAdd(_:)), for: .touchUpInside)
            infoWindow.dropButton.addTarget(self, action: #selector(goToNeeds(_:)), for: .touchUpInside)
            infoWindow.center = mapView.projection.point(for: gPlace.coordinate)
            activePoint = gPlace
            self.view.addSubview(infoWindow)
        }
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if activePoint != nil {
            infoWindow.center = mapView.projection.point(for: (activePoint?.coordinate)!)
        }
        
    }
    
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        print("info Window tapped")
//        print(marker.title!)
//        let id = (marker.userData as! GooglePlace).placeID
//        print(id)
//    }
    
//    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        var infoWindow = Bundle.main.loadNibNamed("infoWindow", owner: self, options: nil)?.first as! CustomInfoWindow
//        infoWindow.nameLabel.text = (marker.userData as! GooglePlace).name
//        infoWindow.addressLabel.text = (marker.userData as! GooglePlace).address
//        self.destAddress = (marker.userData as! GooglePlace).address
//        infoWindow.directionsButton.addTarget(self,  action: #selector(getDirections(_:)), for: .touchUpInside)
//        return infoWindow
//    }
    
    func getDirections(_ sender: Any){
        print("In get directions function")
        let origin = "\(mapView.myLocation?.coordinate.latitude ?? 0.0),\(mapView.myLocation?.coordinate.longitude ?? 0.0)"
        print(origin)
        let destination = self.destAddress!.components(separatedBy: .whitespaces).joined()
        print(destination)
//        print(destination)
        let gmdk = KeychainWrapper.standard.string(forKey: "GMDK")
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination )&mode=driving&key=\(gmdk ?? "hiccup in getting key")"
//        print(url)
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.mapView
            }
        }
        infoWindow.removeFromSuperview()
    }
    
    func goToAdd(_ sender: Any){
        print("add button touched")
        performSegue(withIdentifier: "addNeedsSegue", sender: activePoint)
    }
    
    func goToNeeds(_ sender: Any){
        print("Needs Button Touched")
        performSegue(withIdentifier: "needsSegue", sender: activePoint)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNeedsSegue"{
            if let AddNeedsVC = segue.destination as? AddNeedsViewController{
                if let addNeedPlace = sender as? GooglePlace{
                    AddNeedsVC.placeAdd = addNeedPlace
                }
            }
        }
        else if segue.identifier == "needsSegue"{
            if let NeedsVC = segue.destination as? NeedsViewController{
                if let needPlace = sender as? GooglePlace{
                    NeedsVC.needsPlace = needPlace
                }
            }
        }
    }
    
}
