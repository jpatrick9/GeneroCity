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

class UserMap: UIViewController, CLLocationManagerDelegate {
    
//    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    let dataProvider = GoogleDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.delegate = self
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 15.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
        print("map view loaded")
        getLocation()
        dataProvider.checkPreferences()
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
                marker.map = self.mapView
            }
        }
    }
    
}
