//
//  OpsDetailViewController.swift
//  SeamlessOp
//
//  Created by Demond Childers on 6/14/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

import UIKit
import AVFoundation

class OpsDetailViewController: UIViewController, UIPickerViewDelegate {
    
    
    
    
    let backendless = Backendless.sharedInstance()
    var currentUser = BackendlessUser()
    var newOperation  :Operations?
    
    
    
    
    @IBOutlet private weak var opSiteNameLabel          :UILabel!
    @IBOutlet private weak var opZoneTextField          :UITextField!
    @IBOutlet private weak var opAuditCompleteSwitch    :UISwitch!
    @IBOutlet private weak var specialNotesTextView     :UITextView!
    @IBOutlet private weak var urgencySegControl        :UISegmentedControl!
    @IBOutlet private weak var completeDatePicker       :UIDatePicker!
    @IBOutlet private weak var siteImageView            :UIImageView!
    
    
    
    
    
    
    
    //MARK: - INTERACTIVITY METHODS
    
    
    @IBAction private func addRecordWithAdmin() {
        let newOperation = Operations()
        
        
        newOperation.opSiteName = "Assembly Lines 1-6"
//        newOperation.opCompleteDate = NSDate(NSDateFormatter: yyyy:MM:dd, MM:HH:SS)
        newOperation.ownerID = currentUser.objectId
        newOperation.opUrgency = 0
        newOperation.opNotesPreview = "Lines 2 and 3 are down, no cleaning needed. Be sure to power was lne 6 and remove oil from control panel."
        
        
    
    }
    
    
    @IBAction func saveButtonPressed(button: UIBarButtonItem)  {
        print("Save Pressed")
        guard let operations = newOperation else {
            return
        }
        
        operations.opSiteName = opSiteNameLabel.text!
        operations.opUrgency = urgencySegControl.selectedSegmentIndex
        operations.opZone = opZoneTextField.text!
        operations.opNotesPreview = specialNotesTextView.text!
        operations.opCompleteDate = completeDatePicker.date
        operations.opAuditor = opAuditCompleteSwitch.on
        
        
        saveNewOperation(operations)
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    
    @IBAction private func trashButtonPressed (button: UIBarButtonItem) {
        print("Operations Details Record Removed")
        if let operationSelected = newOperation {
            backendless.delete(operationSelected)
//            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
        // Saves New Operation Details

    private func saveNewOperation(newOperation: Operations){
        print("Attempting to Save")
        let dataStore = backendless.data.of(Operations.ofClass())
        dataStore.save(newOperation, response: { (result) in
            print("Operation has been saved")
            
        }) { (error) in
            print("Operation not saved Error:\(error)")
            
        }
        
    }
    

    //MARK: - LIFE CYCLE METHODS
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRecordWithAdmin()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let operations = newOperation {
            opSiteNameLabel.text = operations.opSiteName
            opZoneTextField.text = operations.opZone
            specialNotesTextView.text = operations.opNotesPreview
            opAuditCompleteSwitch.on = operations.opAuditor
            urgencySegControl.selectedSegmentIndex = operations.opUrgency
            completeDatePicker.date = NSDate()
            
        } else {
            newOperation = Operations()
            opSiteNameLabel.text = ""
            opZoneTextField.text = ""
            opAuditCompleteSwitch.on = false
            urgencySegControl.selectedSegmentIndex = 0
            completeDatePicker.date = NSDate()
            
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
