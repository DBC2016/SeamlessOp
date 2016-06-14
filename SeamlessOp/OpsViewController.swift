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
    
    
    
    let backendless = Backendless.sharedInstance()
    var currentUser = BackendlessUser()
    var opsArray = [Operations]()
    
    
}

    //:MARK - TABLE VIEW METHODS







//func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return requestArray.count
//    
//}
//
//func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ResidentTableViewCell
//    let  newRequest = requestArray[indexPath.row]
//    cell.resReqTitleLabel.text = newRequest.requestToDo
//    cell.resDescLabel.text = newRequest.requestDescript
//    
//    return cell
//}


    //:MARK - INTERACTIVITY METHOD



    //:MARK - LIFE CYCLE METHODS


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    //    findRequests()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }




