//
//  LoginViewController.swift
//  FitSquad
//
//  Created by Jaimie Zhu on 3/5/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {
    
    var dict : [String : AnyObject]!
    var fbLoginSuccess = false
    var tryingToFuckingLogin = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("login view loaded")
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        let horiz = self.view.bounds.width / 2
        let vert = self.view.bounds.height - 100
        let point = CGPoint(x: horiz, y: vert)
        loginButton.center = point
        view.addSubview(loginButton)
        
        // Check if user is already logged in
        if (AccessToken.current != nil) {
            print("-- User already logged in")
            self.fbLoginSuccess = true
        } else {
            print("-- User not logged in")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.tryingToFuckingLogin == 1 || FBSDKAccessToken.current() != nil && self.fbLoginSuccess == true) {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "mainTabBar") as UIViewController
            self.present(viewController, animated: true, completion: nil)
        }
        
        self.tryingToFuckingLogin += 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // actions and methods
    
    func initializeLoginManager() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email, user_friends, public_profile"], from: self) { (result, error) in
            if (error == nil) {
                let fbLoginResult : FBSDKLoginManagerLoginResult = result!
                if (fbLoginResult.grantedPermissions == nil) {
                    if (fbLoginResult.grantedPermissions.contains("email")) {
                        self.getFBUserData()
                        self.fbLoginSuccess = true
                        print("LOGGED IN")
                    }
                }
            }
        }
    }
    
    func getFBUserData() {
        if ((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": ["id", "first_name", "last_name", "picture", "email"]]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    self.dict = result as! [String: AnyObject]
                    print("========")
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
}
