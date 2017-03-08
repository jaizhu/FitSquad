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

class PickTeamTableViewController: UITableViewController {

    // Keeps track of friends
    // Key: User ids
    // Value: name, pictureURL
    var friends = [String: [String]]()
    
    // Team name passed in from TeamNameViewController
    var teamName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.title = "Select Teammates"
        self.title = teamName
        
//        let dynamicTxtField: UITextField = UITextField()
//        dynamicTxtField.backgroundColor = UIColor.lightGray
//        self.view.addSubview(dynamicTxtField)
        
        self.getUserFriends()
        
//        friendsListTableView.delegate = self
//        friendsListTableView.dataSource = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        
        cell.textLabel?.text = "Name yay"
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserFriends() {
        if ((FBSDKAccessToken.current()) != nil) {
            
            let params = ["fields": "name, id, picture"]
            let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: params)
            
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                if ((error) != nil) {
                    // Process error
                    print("Error: \(error)")
                } else {
                    print("==========")
                    
                    // info to be collected
                    
//                    let dict = convertToDictionary(text: str)
                    
                    
                    // get user name
                    // TODO: Add some sort of check that we can do this...
                    let recvd_data = result as! NSDictionary?
                    
                    print(recvd_data?["data"] ?? "BADDDDDD ACCESS: could not fetch friend data")
                    
                    let myArr = recvd_data?["data"] as! NSArray?
                    
                    let myArrLength = myArr?.count ?? 0
                    
                    for i in 0..<myArrLength {
//                        let name = myArr?[i]["name"]
//                        let id = myArr?[i]["id"]
//                        let picture = myArr?[i]["picture"]["picture"]
//                        print(myArr?[i])
                    }
                    
//                    let recvd_data_inner = recvd_data?["data"] as! NSArray?
                    
//                    print(recvd_data_inner?["data"] ?? "NO")
                    

                    
                    
                    print("hi")
                    
                    // get user id
                    
                    // get user profile photo
                }
            })
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
