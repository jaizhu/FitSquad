//
//  PickTeamViewController.swift
//  FitSquad
//
//  Created by Jaimie Zhu on 3/7/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FBSDKLoginKit
import FacebookCore
import FacebookLogin

class PickTeamTableViewController: UITableViewController {

    // Value: user id, name, pictureURL
    var friends = [[String]]()
    let firebase = FIRDatabase.database().reference()
    var teamUids = [String]()
    
    // Team name passed in from TeamNameViewController
    var teamName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Teammates"
        self.getUserFriends()
        self.tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        let tappedCell = self.tableView.cellForRow(at: indexPath)
        tappedCell?.setHighlighted(true, animated: false)
        
        // TODO: make UI button
        
        // write to firebase
        let team: NSDictionary = ["name": "Hard-coded-for-now", "users": teamUids]
        self.firebase.ref.child("teams").childByAutoId().setValue(team)
    }
    
    // MARK: - Table view data source
    
    // TODO: make this not hard coded...
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "FriendTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FriendTableViewCell else {
            fatalError("The dequeued cell is not an instance of TeamMemberTableViewCell.")
        }
        
        if (friends.count > 0 && indexPath.row < friends.count) {
            let friend = friends[indexPath.row]
            
            cell.nameLabel.text = friend[1]
            cell.profileImageView.contentMode = .scaleAspectFit
            let photoURL = URL(string: friend[2])
            downloadImage(url: photoURL!, cell: cell)
            
            return cell
        } else {
            return cell
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, cell: FriendTableViewCell) {
        print("** Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("** Download Finished")
            DispatchQueue.main.async() { () -> Void in
                cell.profileImageView.image = UIImage(data: data)
            }
        }
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
                    // get user name
                    // TODO: Add some sort of check that we can do this...
                    let recvd_data = result as! NSDictionary?
                    
                    print(recvd_data?["data"] ?? "BADDDDDD ACCESS: could not fetch friend data")
                    
                    let myArr = recvd_data?["data"] as! NSArray?
                    
                    let myArrLength = myArr?.count ?? 0
                    
                    for i in 0..<myArrLength {
                        let myDict = myArr?[i] as! NSDictionary?
                        
                        let name = myDict?["name"]
                        let nameStr = name as? String
                        let id = myDict?["id"]
                        let idStr = id as? String
                        
                        let pictureAny = myDict?["picture"]
                        let pictureDataDict = pictureAny as! NSDictionary?
                        let pictureDict = pictureDataDict?["data"]
                        let wtf = pictureDict as! NSDictionary?
                        let RU4real = wtf?["url"]
                        let finallyTheURL = RU4real as! NSString?
                        let urlStr = finallyTheURL as! String
                        
                        self.friends.append([idStr!, nameStr!, urlStr])
                    }
                    print("@@@@@@@@@@@@@@@@@@")
                    print(self.friends)
                    print("@@@@@@@@@@@@@@@@@@")
                    // async shit because of completion handler
                    self.tableView.reloadData()
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
