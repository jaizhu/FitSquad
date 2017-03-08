//
//  ProfileViewController.swift
//  FitSquad
//
//  Created by Jaimie Zhu on 3/4/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let button:UIButton = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
        button.backgroundColor = .black
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action:#selector(self.fbLogoutButtonClicked), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fbLogoutButtonClicked(sender:UIButton!) {
        print("USER IS LOGGING OUT FUCK")
        // this doesn't do anything yet
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
    }
    
}

