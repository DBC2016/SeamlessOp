//
//  OpsViewController.swift
//  SeamlessOp
//
//  Created by Demond Childers on 6/14/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

import UIKit

class OpsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
//    @IBOutlet weak var opsAreaTitleLabel        :UILabel!
//    @IBOutlet weak var opsDescripLabel          :UILabel!
//    @IBOutlet weak var opsTodaysDateLabel       :UILabel!
//    @IBOutlet weak var opsImageView             :UIImageView!
    
    
    let backendless = Backendless.sharedInstance()
    var currentUser = BackendlessUser()
    var opsArray = [Operations]()
    var sitesArray = [Sites]()
    var selectedSites   :Sites?
    

    

    @IBOutlet private weak var opsTableView     :UITableView!
    
    
    
    
    let documentsURL = NSURL(
        fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!, isDirectory: true
    )
    
    
    private func getNewImageFilename() -> String {
        return NSProcessInfo.processInfo().globallyUniqueString + ".png"
    }
    
    
    private func getDocumentPathForFile(filename: String) -> String {
        let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        print("Path:\(docPath)")
        return docPath.stringByAppendingPathComponent(filename)
    }
    
    
    
    
    
    //:MARK - TABLE VIEW METHODS
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opsArray.count
        
    }
    
    // Date and description not showing on table view cells
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as!
        OpsTableViewCell
        let newOperation = opsArray[indexPath.row]
        cell.opsAreaTitleLabel.text = newOperation.opSiteName
        cell.opsDescripLabel.text = newOperation.opZone
        cell.opsTodaysDateLabel.text = "\(newOperation.opDueDate)"
//        let selectedSite = sitesArray[indexPath.row]
//        let image : UIImage! = UIImage(named: "\(selectedSite.siteLogo)")!
//        opsImageView.image = image
        
        
//        let image : UIImageView = UIImageView(named: "\(newOperation.opsImageView)")!
//        opsSiteImageView.image = image
    

        
        return cell
    }
    
    
    
    
    
    //:MARK - INTERACTIVITY METHODS
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destController = segue.destinationViewController as! OpsDetailViewController
        destController.currentUser = currentUser
        
        if segue.identifier == "listToDetailSegue" {
            
            let indexPath = self.opsTableView.indexPathForSelectedRow
            let selectedOp = self.opsArray[indexPath!.row]
            destController.newOperation = selectedOp
            self.opsTableView.deselectRowAtIndexPath(indexPath!, animated: true)
            
        } else if segue.identifier == "addDetailSegue" {
            destController.newOperation = nil
            
        }
        
    }
    
    
    //MARK: - FETCH METHODS
    
    
    func findOperations() {
        let dataQuery = BackendlessDataQuery()
        //                let whereClause = "siteBeacon = '\(selectedBeacon)'"
        //                dataQuery.whereClause = whereClause
        
        var error: Fault?
        let bc = backendless.data.of(Operations.ofClass()).find(dataQuery, fault: &error)
        if error == nil {
            opsArray = bc.getCurrentPage() as! [Operations]
            opsTableView.reloadData()
            print("Found \(opsArray.count)")
        } else {
            print("Find Error \(error)")
        }
        
        
    }
    
    func saveOps(ops: Operations){
        
        let dataStore = backendless.data.of(Operations.ofClass())
        dataStore.save(ops, response: { (result) in
            print("Operation has been saved")
            
        }) { (error) in
            print("Operation not saved Error:\(error)")
            
        }
    }
    
    
    func tempAddRecords() {
        print("Temp Records Added")
        
        
                let newOperation = Operations()
        //        newOperation.opSiteName = "Ford Motors"
        //        newOperation.opZone = "Zone 6"
        //        newOperation.opDescrip = "Site owner is disappointed with our cleaning of restrooms, pay special attention to the first and 2nd floors and make sure all glass is cleaned."
                  newOperation.opImage = "fordLogo"
        //        newOperation.opUrgency = 1
        //        newOperation.opNotesPreview = "Power wash assembly lines zone A and B"
        //        newOperation.opDueDate = NSDate()
        //        newOperation.opAuditor = false
        //        newOperation.opBeaconID = "fordBeacon"
        
                saveOps(newOperation)
        
        
        
                let newOperation2 = Operations()
        //        newOperation2.opSiteName = "Fed Ex"
        //        newOperation2.opZone = "Zone 5"
        //        newOperation2.opDescrip = "Empty all trash and recycling. Clean all lines and oil spills. audit assembly lines A thru F."
                  newOperation2.opImage = "fedexLogo"
        //        newOperation2.opUrgency = 3
        //        newOperation2.opNotesPreview = "Site owner is very pleased. He would like us to make sure we pay special attention to oil spills and trash on perimeter"
        //        newOperation2.opDueDate = NSDate()
        //        newOperation2.opAuditor = false
        
                saveOps(newOperation2)
        
        
        
                let newOperation3 = Operations()
        //        newOperation3.opSiteName = "Pepsi"
        //        newOperation3.opZone = "Area 9"
        //        newOperation3.opDescrip = "Paint all doors. Wax floors. Be sure to double check supplies in inventory"
                  newOperation3.opImage = "pepsiLogo"
        //        newOperation3.opUrgency = 1
        //        newOperation3.opNotesPreview = "Site needs major work. Paint on all doors are chipping so let schedudle a project date with facilities manager."
        //        newOperation3.opDueDate = NSDate()
        //        newOperation3.opAuditor = false
        //        newOperation3.opBeaconID = "pepsiBeacon"
        
        
                saveOps(newOperation3)
        
        
                let newOperation4 = Operations()
        //        newOperation4.opSiteName = "Amazon"
        //        newOperation4.opZone = "Sec 8"
        //        newOperation4.opDescrip = "Site looks good but we still have a long way to go. Since this is a new account, consult with facility mangaer to determine needs of client."
                  newOperation4.opImage = "amazonLogo"
        //        newOperation4.opUrgency = 1
        //        newOperation4.opNotesPreview = "Wax all bathroom floors and determine other needs."
        //        newOperation4.opDueDate = NSDate()
        //        newOperation4.opAuditor = false
        
        
                saveOps(newOperation4)
        
        
                let newOperation5 = Operations()
        //        newOperation5.opSiteName = "Iron Yard"
        //        newOperation5.opZone = "First Floor"
        //        newOperation5.opDescrip = "Empty trash cans, vacuum floors, complete dry wall in all classrooms."
                  newOperation5.opImage = "ironyardLogo"
        //        newOperation5.opUrgency = 4
        //        newOperation5.opNotesPreview = "Review site for special projects."
        //        newOperation5.opDueDate = NSDate()
        //        newOperation5.opAuditor = false
        //        newOperation5.opBeaconID = "ironyardBeacon"
        
        
                saveOps(newOperation5)
        
        
    }
    
    
    
    
    
    
    
    
    func beaconInRange(notification: NSNotification) {
        if let region = notification.userInfo?["region"] {
            print("Found: \(region)")
            let tempArray = opsArray.filter {$0.opBeaconID == (region as! String)}
            print("Ops \(tempArray[0].opSiteName)")
            let index = opsArray.indexOf(tempArray.first!)
            let indexPath = NSIndexPath(forRow: index!, inSection: 0)
            opsTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            performSegueWithIdentifier("listToDetailSegue", sender: self)
        } else {
            print("No Region Info Found")
        }
        //            let filteredArray = sitesArray.filter {$0.siteBeacon == region as? String}
        //            let foundOps = filteredArray[0]
        //            print("Selected \(foundOps.siteName)")
        //            opsAreaTitleLabel.text = foundOps.siteArea
        //            opsDescripLabel.text = foundOps.siteDescrip
        //            opsTodaysDateLabel
        
        //put rest of desired label detail here
        
    }
    
    //:MARK - LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(beaconInRange), name: "inRange", object: nil)
        //                findOperations()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        tempAddRecords()
        findOperations()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        print("LR1 \(appDelegate.lastRegion?.identifier)")
        appDelegate.lastRegion = nil
        print("LR2 \(appDelegate.lastRegion?.identifier)")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

