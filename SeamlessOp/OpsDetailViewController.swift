//
//  OpsDetailViewController.swift
//  SeamlessOp
//
//  Created by Demond Childers on 6/14/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

import UIKit
import AVFoundation

class OpsDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    
    
    
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
    
    
    
    
    var firstX = 0 as CGFloat
    var firstY = 0 as CGFloat
    var lastScale :CGFloat!
    var lastRotation = 0 as CGFloat
    
    
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
        operations
        
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
    
    
    
    
    
    //MARK: - GESTURE METHODS
    
    @IBAction func imagePanned(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self.view)
        if let view = gesture.view {
            view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
        }
        gesture.setTranslation(CGPointZero, inView: self.view)
    }
    
    @IBAction func imagePinched(gesture: UIPinchGestureRecognizer) {
        if (gesture.state == .Began) {
            lastScale = 1.0
        }
        let scale = 1.0 - (lastScale - gesture.scale)
        let currentTransform = siteImageView.transform
        let newTransform = CGAffineTransformScale(currentTransform, scale, scale)
        siteImageView.transform = newTransform
        lastScale = gesture.scale
    }
    
    @IBAction func imageRotated(gesture: UIRotationGestureRecognizer) {
        if (gesture.state == .Ended) {
            lastRotation = 0.0
            return
        }
        print("rotate 2")
        let rotation = 0.0 - (lastRotation - gesture.rotation)
        print("rotate 3")
        let currentTransform = siteImageView.transform
        print("rotate 4")
        let newTransform = CGAffineTransformRotate(currentTransform, rotation)
        print("rotate 5")
        siteImageView.transform = newTransform
        
        lastRotation = gesture.rotation
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    //MARK: - LIFE CYCLE METHODS
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        addRecordWithAdmin()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        findSites()
        
        if let operations = newOperation {
            
            //        siteImageView.image = UIImage(named: getDocumentPathForFile(operations.opImage))
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
