//
//  OpsDetailViewController.swift
//  SeamlessOp
//
//  Created by Demond Childers on 6/14/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

import UIKit
import AVFoundation

class OpsDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    
    
    let backendless = Backendless.sharedInstance()
    let loginManager = LoginManager.sharedInstance
    var currentUser = BackendlessUser()
    var newOperation  :Operations?
    var sitesArray = [Sites]()
    var areaArray = [Sites]()

    
    @IBOutlet private weak var sitesPicker              :UIPickerView!
    @IBOutlet private weak var areaPicker               :UIPickerView!
    @IBOutlet private weak var opAuditCompleteSwitch    :UISwitch!
    @IBOutlet private weak var specialNotesTextView     :UITextView!
    @IBOutlet private weak var urgencySegControl        :UISegmentedControl!
    @IBOutlet private weak var completeDatePicker       :UIDatePicker!
    @IBOutlet private weak var siteImageView            :UIImageView!
//    @IBOutlet private weak var detailsScrollView        :UIScrollView!
    

    
    
    
    
    
    
    
    
    //MARK: - INTERACTIVITY METHODS
    
    //Use this code if creating an Admin Component
    
    
//    @IBAction private func addRecordWithAdmin() {
//        let newOperation = Operations()
//        
//        
//        newOperation.opSiteName = "Assembly Lines 1-6"
////        newOperation.opCompleteDate = NSDate(NSDateFormatter: yyyy:MM:dd, MM:HH:SS)
//        newOperation.ownerID = currentUser.objectId
//        newOperation.opUrgency = 0
//        newOperation.opNotesPreview = "Lines 2 and 3 are down, no cleaning needed. Be sure to power was lne 6 and remove oil from control panel."
//        
//        
//    
//    }
    
    
    @IBAction func saveButtonPressed(button: UIBarButtonItem)  {
        print("Save Pressed")
        guard let operations = newOperation else {
            return
        }
        
        operations.opSiteName = sitesArray[sitesPicker.selectedRowInComponent(0)].siteName
        operations.opZone = areaArray[areaPicker.selectedRowInComponent(0)].areaName
        operations.opBeaconID = areaArray[areaPicker.selectedRowInComponent(0)].beaconIdentifier
        operations.opUrgency = urgencySegControl.selectedSegmentIndex
        operations.opNotesPreview = specialNotesTextView.text!
        operations.opCompleteDate = completeDatePicker.date
        operations.opAuditor = opAuditCompleteSwitch.on
        
        
        saveNewOperation(operations)
        self.navigationController?.popViewControllerAnimated(true)
        
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
    
    
    @IBAction private func trashButtonPressed (button: UIBarButtonItem) {
        print("Operations Details Record Removed")
        if let operationSelected = newOperation {
            let dataStore = backendless.data.of(Operations.ofClass())
            dataStore.remove(
                operationSelected,
                response: { (result: AnyObject!) -> Void in
                    print("Site has been deleted: \(result)")
                    self.navigationController!.popViewControllerAnimated(true)
                },
                error: { (fault: Fault!) -> Void in
                    print("Server reported an error (2): \(fault)")
            })
        }
        
        
        
    }
    
    //MARK: - PICKERVIEW METHODS
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == sitesPicker {
            return sitesArray.count
        } else if pickerView == areaPicker {
            return areaArray.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == sitesPicker {
            return sitesArray[row].siteName
        } else if pickerView == areaPicker {
            return areaArray[row].areaName
        }
        return "?"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sitesPicker {
            filterAreaArray()
            areaPicker.reloadAllComponents()
        }
    }
    
    //MARK: - BACKENDLESS METHODS

    func filterAreaArray() {
        let index = sitesPicker.selectedRowInComponent(0)
        areaArray = sitesArray.filter {$0.siteName == sitesArray[index].siteName}
    }
    
    func findSites() {
        let dataQuery = BackendlessDataQuery()
        var error: Fault?
        let bc = backendless.data.of(Sites.ofClass()).find(dataQuery, fault: &error)
        if error == nil {
            sitesArray = bc.getCurrentPage() as! [Sites]
            sitesPicker.reloadAllComponents()
            if let operations = newOperation {
                let selectedSite = sitesArray.filter {$0.siteName == operations.opSiteName}
                let siteIndex = sitesArray.indexOf(selectedSite[0])
                sitesPicker.selectRow(siteIndex!, inComponent: 0, animated: true)
                filterAreaArray()
                let selectedArea = areaArray.filter {$0.areaName == operations.opZone}
                let areaIndex = areaArray.indexOf(selectedArea[0])
                areaPicker.selectRow(areaIndex!, inComponent: 0, animated: true)
            }
        } else {
            print("Find Error \(error)")
        }
    }

    
    //MARK: - CAMERA METHODS
    
    //Code to pull photos from Gallery
    
    @IBAction private func galleryButtonTapped(button: UIButton) {
        print("gallery")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .SavedPhotosAlbum
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction private func cameraButtonTapped(button: UIBarButtonItem) {
        print("Camera")
        //Code to bring up Camera App
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .Camera
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            print("No Camera")
            
        }
        
    }
    
    
    // Better Understand difference between these functions and their use
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        siteImageView.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }

    

    //MARK: - LIFE CYCLE METHODS
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addRecordWithAdmin()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let operations = newOperation {
//            let selectedSite = sitesArray.filter {$0.siteName == operations.opSiteName}
//            let siteIndex = sitesArray.indexOf(selectedSite[0])
//            sitesPicker.selectRow(siteIndex!, inComponent: 0, animated: true)
//            
//            print("Area Array \(areaArray.count)")
//            for area in areaArray {
//                print("Area \(area.areaName)")
//            }
//            let selectedArea = areaArray.filter {$0.areaName == operations.opZone}
//            print("SelSite \(selectedArea.first?.areaName)")
//            let areaIndex = areaArray.indexOf(selectedArea[0])
//            areaPicker.selectRow(areaIndex!, inComponent: 0, animated: true)
            
            findSites()
            specialNotesTextView.text = operations.opNotesPreview
            opAuditCompleteSwitch.on = operations.opAuditor
            urgencySegControl.selectedSegmentIndex = operations.opUrgency
            completeDatePicker.date = NSDate()
            
        } else {
            newOperation = Operations()
            specialNotesTextView.text = ""
            opAuditCompleteSwitch.on = false
            urgencySegControl.selectedSegmentIndex = 0
            completeDatePicker.date = NSDate()
            
        }
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
