//
//  OpsViewController.swift
//  SeamlessOp
//
//  Created by Demond Childers on 6/14/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

import UIKit

class OpsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var opsAreaTitleLabel        :UILabel!
    @IBOutlet weak  var opsDescripLabel         :UILabel!
    @IBOutlet private weak var opsTableView     :UITableView!
    @IBOutlet weak var opsTodaysDateLabel       :UILabel!
    
    
    
    
    let backendless = Backendless.sharedInstance()
    var currentUser = BackendlessUser()
    var opsArray = [Operations]()
    
    

    //:MARK - TABLE VIEW METHODS

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opsArray.count
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as!
        OpsTableViewCell
            let newOperation = opsArray[indexPath.row]
        cell.opsAreaTitleLabel.text = newOperation.opSiteName
        cell.opsDescripLabel.text = newOperation.opSiteName
        cell.opsTodaysDateLabel.text = "\(newOperation)"
        
        return cell
    }
    
    



    //:MARK - INTERACTIVITY METHODS
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destController = segue.destinationViewController as! OpsDetailViewController
        destController.currentUser = currentUser
        
        if segue.identifier == "loginToListSegue" {
        
        let indexPath = self.opsTableView.indexPathForSelectedRow
        let selectedOp = self.opsArray[indexPath!.row]
        destController.newOperation = selectedOp
        self.opsTableView.deselectRowAtIndexPath(indexPath!, animated: true)
    
//        } else if  segue.indentifier == "addDetailSegue" {
//        destController.newOperation = nil
//        
    }

    

}
    
    func findOperations() {
        let dataQuery = BackendlessDataQuery()
        
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




    //:MARK - LIFE CYCLE METHODS


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        findOperations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

