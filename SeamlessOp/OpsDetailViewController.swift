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
    
    var opsArray  = [Operations]()
    
    
    @IBOutlet private weak var sitesPicker              :UIPickerView!
    @IBOutlet private weak var areaPicker               :UIPickerView!
    @IBOutlet private weak var opAuditCompleteSwitch    :UISwitch!
    @IBOutlet private weak var specialNotesTextView     :UITextView!
    @IBOutlet private weak var urgencySegControl        :UISegmentedControl!
    @IBOutlet private weak var dueDatePicker            :UIDatePicker!
    @IBOutlet private weak var completeDatePicker       :UIDatePicker!
    @IBOutlet private weak var siteImageView            :UIImageView!
    
    
    //    @IBOutlet private weak var detailsScrollView        :UIScrollView!
    
    //    @IBOutlet private weak var capturedImage            : UIImageView!
    
    
    
    
    
    
    
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
    
    
    
    
    //MARK: - INTERACTIVITY METHODS
    
    @IBAction func saveButtonPressed(button: UIBarButtonItem)  {
        print("Save Pressed")
        guard let operations = newOperation else {
            return
        }
        
        operations.opSiteName = sitesArray[sitesPicker.selectedRowInComponent(0)].siteName
        operations.opZone = areaArray[areaPicker.selectedRowInComponent(0)].areaName
        operations.opBeaconID = areaArray[areaPicker.selectedRowInComponent(0)].beaconIdentifier
        operations.opsLogo = areaArray[areaPicker.selectedRowInComponent(0)].defaultLogo
        operations.opUrgency = urgencySegControl.selectedSegmentIndex
        operations.opNotesPreview = specialNotesTextView.text!
        operations.opDueDate = dueDatePicker.date
        operations.opCompleteDate = completeDatePicker.date
        operations.opAuditor = opAuditCompleteSwitch.on
        
//                if let image = siteImageView.image {
//                    let filename = getNewImageFilename()
//                    let imagePath = getDocumentPathForFile(filename)
//                    UIImagePNGRepresentation(image)?.writeToFile(imagePath, atomically: true)
//                    operations.opImage = filename
//        
//                } else {
//                    print("No Image to Save")
//                }
        
        
        
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
    
    //saving methods for camera
    
    @IBAction private func saveButtonXPressed(button: UIButton) {
        if let image = siteImageView.image {
            let imagePath = getDocumentPathForFile(getNewImageFilename())
            
            UIImagePNGRepresentation(image)!.writeToFile(imagePath, atomically: true)
        } else {
            print("No Image to Save")
            
        }
        
        
    }
    
    
    private func getNewImageFilename() -> String {
        return NSProcessInfo.processInfo().globallyUniqueString + ".png"
    }
    
    
    private func getDocumentPathForFile(filename: String) -> String {
        let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        print("Path:\(docPath)")
        return docPath.stringByAppendingPathComponent(filename)
    }
    
    
    
    
    
    
    //Code to pull photos from Gallery
    
    //    @IBAction private func galleryButtonTapped(button: UIButton) {
    //        print("gallery")
    //        let imagePicker = UIImagePickerController()
    //        imagePicker.delegate = self
    //        imagePicker.sourceType = .SavedPhotosAlbum
    //        presentViewController(imagePicker, animated: true, completion: nil)
    //
    //    }
    //
    //
    //
    //    @IBAction private func cameraButtonTapped(button: UIBarButtonItem) {
    //        print("Camera")
    //        //Code to bring up Camera App
    //        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
    //            let imagePicker = UIImagePickerController()
    //            imagePicker.sourceType = .Camera
    //            imagePicker.delegate = self
    //            presentViewController(imagePicker, animated: true, completion: nil)
    //        } else {
    //            print("No Camera")
    //
    //        }
    //
    //    }
    
    
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    //        siteImageView.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
    //        picker.dismissViewControllerAnimated(true, completion: nil)
    //    }
    //
    //
    //
    //    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    //        picker.dismissViewControllerAnimated(true, completion: nil)
    //
    //    }
    
    
    
    
    
    //MARK: - LIFE CYCLE METHODS
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        addRecordWithAdmin()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        findSites()
        
        if let operations = newOperation {
            
//            siteImageView.image = UIImage(named: getDocumentPathForFile(operations.opImage))
            specialNotesTextView.text = operations.opNotesPreview
            opAuditCompleteSwitch.on = operations.opAuditor
            urgencySegControl.selectedSegmentIndex = operations.opUrgency
            dueDatePicker.date = NSDate()
            completeDatePicker.date = NSDate()
            
        } else {
            newOperation = Operations()
            specialNotesTextView.text = ""
            opAuditCompleteSwitch.on = false
            urgencySegControl.selectedSegmentIndex = 0
            dueDatePicker.date = NSDate()
            completeDatePicker.date = NSDate()
//            siteImageView.image = nil 
            

            
        }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
