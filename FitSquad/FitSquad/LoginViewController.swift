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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("login view loaded")
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        // Check if user is already logged in
        if let accessToken = AccessToken.current {
            print("-- User already logged in")
            print(accessToken.userId ?? "NO ID")
            fbLoginSuccess = true
        } else {
            print("-- User not logged in")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true) {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: "mainTabBar") as UIViewController
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func FBLoginButtonPressed(_ sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil) {
                let fbLoginResult : FBSDKLoginManagerLoginResult = result!
                if (fbLoginResult.grantedPermissions == nil) {
                    if (fbLoginResult.grantedPermissions.contains("email")) {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                        self.fbLoginSuccess = true
                        print("LOGGED IN")
                    }
                }
            }
        }
    }
    
    func getFBUserData() {
        if ((FBSDKAccessToken.current()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
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
