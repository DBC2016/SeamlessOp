//
//  ViewController.swift
//  SeamlessOp
//
//  Created by Demond Childers on 6/13/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    
    let backendless = Backendless.sharedInstance()
    let loginManager = LoginManager.sharedInstance
    
    var currentUser = BackendlessUser()
    
    
    
    //IBActions for Login Screen
    
    
    @IBOutlet private weak var emailEntry             :UITextField!
    @IBOutlet private weak var passwordEntry          :UITextField!
    @IBOutlet private weak var userRegister           :UIButton!
    @IBOutlet private weak var userLogIn              :UIButton!
//    @IBOutlet private weak var userLogout             :UIButton!
    
    
    
    
    

    
    
    
    //MARK: - User Login Methods
    
    
    
    @IBAction func loginButtonPressed(button: UIButton) {
//        print("1")
        guard let email = emailEntry.text else {
            return
        }
//        print("2")
        guard let password = passwordEntry.text else {
            return
        }
//        print("3")
        
        loginManager.loginUser(email, password: password)
    }
    
    @IBAction func signUpButtonPressed(button: UIButton) {
        guard let email = emailEntry.text else {
            return
        }
        guard let password = passwordEntry.text else {
            return
        }
        
        loginManager.registerNewUser(email, password: password)
    }
    
    @IBAction func textFieldChanged() {
//        print("TFC")
        userRegister.enabled = false
        userLogIn.enabled = false
        
        guard let email = emailEntry.text else {
            return
        }
        guard let password = passwordEntry.text else {
            return
            
        }
        
        if loginManager.isValidLogin(email, password: password) {
//            print("valid")
            userRegister.enabled = true
            userLogIn.enabled = true
        } else {
//            print("invalid")
        }
        
    }
    
    func loginRecv() {
        performSegueWithIdentifier("logToListSegue", sender: self)
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destController = segue.destinationViewController as! OpsViewController
        destController.currentUser = currentUser
    }

    
    
    
    
    //MARK: - Life Cycle Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldChanged()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loginRecv), name: "LoggedInMsg", object: nil)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

