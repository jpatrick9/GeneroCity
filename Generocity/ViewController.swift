//
//  ViewController.swift
//  Generocity
//
//  Created by Dante  Lacey-Thompson on 11/21/17.
//  Copyright © 2017 Dante  Lacey-Thompson. All rights reserved.
//

import UIKit
import Firebase
import Google
import CoreLocation
import SwiftKeychainWrapper

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, CLLocationManagerDelegate {
    let deviceHeight = UIScreen.main.bounds.height
    
    var locationManager: CLLocationManager!
    let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = #imageLiteral(resourceName: "GenerocityLogin")
        imageView.contentMode = .scaleAspectFit
        
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        signInButton.center = view.center
        
        view.addSubview(signInButton)
        setUpLoc()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            print(userId!)
            let idToken = user.authentication.idToken // Safe to send to the server
            print(idToken!)
            let fullName = user.profile.name
            print(fullName!)
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
            let email = user.profile.email
            print(email!)
            // ...
//            print(JSON(user.profile))
            performSegue(withIdentifier: "showSplash", sender: self)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func setUpLoc(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        print(status)
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        // 3
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
    

}

