//
//  AppDelegate.swift
//  Generocity
//
//  Created by Dante  Lacey-Thompson on 11/21/17.
//  Copyright © 2017 Dante  Lacey-Thompson. All rights reserved.
//

import UIKit
import Firebase
import Google
import GoogleMaps
import GooglePlaces
import SwiftKeychainWrapper


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    var retrieveStatus = [(stringVal: String, stringKeyVal: String, retrievalStatus: Bool)]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        GIDSignIn.sharedInstance().delegate = self
        FirebaseApp.configure()
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        let defaults = UserDefaults.standard
//        let defaultValues : [String: Any] = ["distance_slider": 5, "search_preference": "shelter"]
        if (defaults.string(forKey: "search_preference") == nil && defaults.integer(forKey: "distance_slider") == 0) {
            setDefaultsFromSettingsBundle()
        }
        retrieveStatus = retrieveFromKC()
        var retrieveStatusStrings = retrieveStatus.map({$0.stringVal})
//        print(writeStatus)
        print(retrieveStatus)
        print(retrieveStatusStrings)
        GMSServices.provideAPIKey(retrieveStatusStrings[0])
        GMSPlacesClient.provideAPIKey(retrieveStatusStrings[1])
        
        
        
//        print(retrieveStatusArray)
        
//        let filterMK = retrieveStatus.filter{$0.1 = key}
//        let filterDK = retrieveStatus.filter{$0.1 = key2}
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func setDefaultsFromSettingsBundle() {
        //Read PreferenceSpecifiers from Root.plist in Settings.Bundle
        if let settingsURL = Bundle.main.url(forResource: "Root", withExtension: "plist", subdirectory: "Settings.bundle"),
            let settingsPlist = NSDictionary(contentsOf: settingsURL),
            let preferences = settingsPlist["PreferenceSpecifiers"] as? [NSDictionary] {
            
            for prefSpecification in preferences {
                
                if let key = prefSpecification["Key"] as? String, let value = prefSpecification["DefaultValue"] {
                    
                    //If key doesn't exists in userDefaults then register it, else keep original value
                    if UserDefaults.standard.value(forKey: key) == nil {
                        
                        UserDefaults.standard.set(value, forKey: key)
                        print("registerDefaultsFromSettingsBundle: Set following to UserDefaults - (key: \(key), value: \(value), type: \(type(of: value)))")
                    }
                }
            }
        } else {
            print("registerDefaultsFromSettingsBundle: Could not find Settings.bundle")
        }
    }
    
    
    
    func retrieveFromKC() -> [(String, String, Bool)] {
        var retrieveStatusArray = [(String, String, Bool)]()
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: "GMAK")
        let retrievedString2: String? = KeychainWrapper.standard.string(forKey: "GPAK")
//        let retrievedString3: String? = KeychainWrapper.standard.string(forKey: "GDAK")
//        retrieveStatusArray.append(retrievedString, "GMAK", true)
//        retrieveStatusArray.append(retrievedString2, "GPAK", true)
//        retrieveStatusArray.append(retrievedString, "GDAK", true)
        retrieveStatusArray.append((retrievedString!, "GMAK", true))
        retrieveStatusArray.append((retrievedString2!, "GPAK", true))
//        retrieveStatusArray.append((retrievedString3!, "GDAK", true))
        return retrieveStatusArray
    }

}

