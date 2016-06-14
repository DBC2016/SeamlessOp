//
//  AppDelegate.swift
//  SeamlessOp
//
//  Created by Demond Childers on 6/13/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

import UIKit
import CoreLocation 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {
    
    
    let APP_ID = "BA5D325E-8722-CF7A-FFC2-BD1F26153F00"
    let SECRET_KEY = "77FC2E9D-EE55-65EB-FF75-F06CA2FFDD00"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    let beaconManager = ESTBeaconManager()
    var lastRegion: CLBeaconRegion?

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.beaconManager.delegate = self
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        checkForLocationAuthorization()
        
        return true
    }



}

