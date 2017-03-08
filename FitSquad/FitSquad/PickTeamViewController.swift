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

//class PickTeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
class PickTeamViewController: UIViewController {

    
    @IBOutlet weak var friendsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Select Teammates"
        
        self.getUserFriends()
        
//        friendsListTableView.delegate = self
//        friendsListTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // something
//    }
    
    func getUserFriends() {
        if ((FBSDKAccessToken.current()) != nil) {
            
            let params = ["fields": "first_name, last_name, email, picture"]
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
