//
//  LoginManager.swift
//  SeamlessOp
//
//  Created by Demond Childers on 6/13/16.
//  Copyright © 2016 Demond Childers. All rights reserved.
//

import Foundation

class LoginManager: NSObject {
    
    static let sharedInstance = LoginManager()
    let backendless = Backendless.sharedInstance()
    var currentUser = BackendlessUser()
    
    func isValidLogin(email: String, password: String) -> Bool {
        return email.characters.count > 5 && password.characters.count > 4
    }
    
    func logoutUser() {
        backendless.userService.logout({ (response) in
            print("Success Logging out")
        }) { (error) in
            print("Error Logging Out \(error)")
        }
    }
    
    func registerNewUser(email: String, password: String) {
        let user = BackendlessUser()
        user.email = email
        user.password = password
        backendless.userService.registering(user, response: { (registeredUser) in
            print("Success Registering \(registeredUser.email)")
        }) { (error) in
            print("Error Registering \(error)")
            
        }
        
    }
    
    func loginUser(email: String, password: String) {
        backendless.userService.login(email, password: password, response:
            { (loggedInUser) in
                print("Logged In \(loggedInUser.email)")
                self.currentUser = loggedInUser
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "LoggedInMsg", object: nil))
        }) { (error) in
            print("LogIn Error \(error)")
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "LogInErrorMsg", object: nil))
        }
        
    }
    

    

}
