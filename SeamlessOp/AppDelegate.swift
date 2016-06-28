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
                    lastRegion = region
                case .Near:
//                    print("Ranged Near \(region.identifier) beacon")
                    break
                default:
//                    print("don't care")
                    break
                }
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
        
        let beaconIdentifier = "AllBeacons"
        let allBeaconsRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)
        beaconManager.startMonitoringForRegion(allBeaconsRegion)
        
        let beacon1Major :CLBeaconMajorValue = 39380
        let beacon1Minor :CLBeaconMinorValue = 44024
        let beacon1Identifier = "purpleBeacon"
        let purpleBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: beacon1Major, minor: beacon1Minor, identifier: beacon1Identifier)
        beaconManager.startRangingBeaconsInRegion(purpleBeaconRegion)
        
        let beacon2Major :CLBeaconMajorValue = 31640
        let beacon2Minor :CLBeaconMinorValue = 65404
        let beacon2Identifier = "blueBeacon"
        let blueBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: beacon2Major, minor: beacon2Minor, identifier: beacon2Identifier)
        beaconManager.startRangingBeaconsInRegion(blueBeaconRegion)
        
        let beacon3Major :CLBeaconMajorValue = 34909
        let beacon3Minor :CLBeaconMinorValue = 15660
        let beacon3Identifier = "greenBeacon"
        let greenBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: beacon3Major, minor: beacon3Minor, identifier: beacon3Identifier)
        beaconManager.startRangingBeaconsInRegion(greenBeaconRegion)
        
        let beacon4Major :CLBeaconMajorValue = 36714
        let beacon4Minor :CLBeaconMinorValue = 8751
        let beacon4Identifier = "mint2Beacon"
        let mint2BeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: beacon4Major, minor: beacon4Minor, identifier: beacon4Identifier)
        beaconManager.startRangingBeaconsInRegion(mint2BeaconRegion)
        
        let beacon5Major :CLBeaconMajorValue = 20431
        let beacon5Minor :CLBeaconMinorValue = 33870
        let beacon5Identifier = "mint1Beacon"
        let mint1BeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: beacon5Major, minor: beacon5Minor, identifier: beacon5Identifier)
        beaconManager.startRangingBeaconsInRegion(mint1BeaconRegion)
        
        let beacon6Major :CLBeaconMajorValue = 49845
        let beacon6Minor :CLBeaconMinorValue = 13037
        let beacon6Identifier = "ice1Beacon"
        let ice1BeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: beacon6Major, minor: beacon6Minor, identifier: beacon6Identifier)
        beaconManager.startRangingBeaconsInRegion(ice1BeaconRegion)
        
        let beacon7Major :CLBeaconMajorValue = 36561
        let beacon7Minor :CLBeaconMinorValue = 52481
        let beacon7Identifier = "ice2Beacon"
        let ice2BeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: beacon7Major, minor: beacon7Minor, identifier: beacon7Identifier)
        beaconManager.startRangingBeaconsInRegion(ice2BeaconRegion)
        
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


