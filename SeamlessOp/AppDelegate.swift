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


    extension AppDelegate {
    
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if beacons.count > 0 {
            let nearestBeacon = beacons[0]
            if region != lastRegion {
                switch nearestBeacon.proximity {
                case .Immediate:
                    print("Ranged Immediate \(region.identifier) beacon")
                    NSNotificationCenter.defaultCenter().postNotificationName("inRange", object: nil, userInfo: ["region":region.identifier])
//                                        case .Near:
//                                            print("Ranged Near \(region.identifier) beacon")
                                        case .Far:
                                            print("Ranged Far \(region.identifier) beacon")
//                                        case .Unknown:
//                                        print("Ranged Unknown \(region.identifier) beacon")
                default:
                    return
                                            print("don't care")
                }
                lastRegion = region
                
                
                
            }
            
        }
    }
    
    func beaconManager(manager: AnyObject, didDetermineState state: CLRegionState, forRegion region: CLBeaconRegion) {
        switch state {
        case .Unknown:
            print("Region \(region.identifier) Unknown")
        case .Inside:
            print("Region \(region.identifier) Inside")
        case .Outside:
            print("Region \(region.identifier) Outside")
        }
        
        
    }
    
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        print("Did Enter \(region.identifier)")
    }
    
    func beaconManager(manager: AnyObject, didExitRegion region: CLBeaconRegion) {
        print("Did Exit \(region.identifier)")
        
}
        
        func setUpBeacons() {
            print("Settings Up Beacons")
            let uuidString = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
            let beaconUUID = NSUUID(UUIDString: uuidString)!
            
            let beaconIdentifier = "IronYard"
            let allBeaconsRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)
            beaconManager.startMonitoringForRegion(allBeaconsRegion)
            
            let firstBeaconMajor :CLBeaconMajorValue = 39380
            let firstBeaconMinor :CLBeaconMinorValue = 44024
            let firstBeaconIdentifier = "firstBeacon"
            let purpleBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: firstBeaconMajor, minor: firstBeaconMinor, identifier: firstBeaconIdentifier)
            beaconManager.startRangingBeaconsInRegion(purpleBeaconRegion)
            
            let secondBeaconMajor :CLBeaconMajorValue = 31640
            let secondBeaconMinor :CLBeaconMinorValue = 65404
            let secondBeaconIdentifier = "secondBeacon"
            let blueBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: secondBeaconMajor, minor: secondBeaconMinor, identifier: secondBeaconIdentifier)
            beaconManager.startRangingBeaconsInRegion(blueBeaconRegion)
            
            let thirdBeaconMajor :CLBeaconMajorValue = 34909
            let thirdBeaconMinor :CLBeaconMinorValue = 15660
            let thirdBeaconIdentifier = "thirdBeacon"
            let greenBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: thirdBeaconMajor, minor: thirdBeaconMinor, identifier: thirdBeaconIdentifier)
            beaconManager.startRangingBeaconsInRegion(greenBeaconRegion)
            
        }



    func checkForLocationAuthorization() {
        if CLLocationManager.locationServicesEnabled(){
            print("Loc Services On!")
            switch ESTBeaconManager.authorizationStatus() {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                print("Start Up")
                setUpBeacons()
            case .Denied, .Restricted:
                print("Hey User, turn us on in Settings")
            case .NotDetermined:
                print("Not Determined")
                if beaconManager.respondsToSelector(#selector(CLLocationManager.requestAlwaysAuthorization)){
                    print("Requesting Always")
                    beaconManager.requestAlwaysAuthorization()
                }
            }
        } else {
            print("Turn on Location Services!")
        }
        
    }
    
    func beaconManager(manager: AnyObject, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Did Change Authorization")
        checkForLocationAuthorization()
    }
    
    
}


