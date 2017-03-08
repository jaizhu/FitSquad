//
//  PickTeamViewController.swift
//  FitSquad
//
//  Created by Jaimie Zhu on 3/7/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin

class PickTeamViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Select Teammates"
        
        self.getUserFriends()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserFriends() {
        if ((FBSDKAccessToken.current()) != nil) {
            
            let params = ["fields": "first_name, last_name, email"]
            let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: params)
            
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                if ((error) != nil) {
                    // Process error
                    print("Error: \(error)")
                } else {
                    print("==========")
                    print(result ?? "NO RESULT")
                }
            })
        }
    }
    
}
