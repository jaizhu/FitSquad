//
//  CompetitionTableViewController.swift
//  FitSquad
//
//  Created by Danielle Connolly on 3/7/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import UIKit

import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import Firebase

var USERID = ""

class CompetitionTableViewController: UITableViewController {
    let firebase = FIRDatabase.database().reference()
    
    var competitions = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCompetitions()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return competitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitionCell", for: indexPath)
        
        cell.textLabel?.text = competitions[indexPath.row][0] + " vs. " + competitions[indexPath.row][1]
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
     

    let competitionSegueIdentifier = "CompetitionSegue"
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if  segue.identifier == competitionSegueIdentifier,
            let destination = segue.destination as? TeamMemberTableViewController,
            let competitionIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.teams = competitions[competitionIndex]
        }
    }
    
    private func loadCompetitions() {
        
        var userId = String()
        
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            } else {
                // You successfully got the email of yourself, print it
                let response = result as AnyObject?
                let id = response?.object(forKey: "id") as AnyObject?
                if let unwrapped = id {
                    userId = unwrapped as! String
                }
            }
            
            print("LOGIN INFO: ")
            print(userId)
            USERID = userId
            
            self.firebase.ref.child("users").child(userId)
                .observe(.value, with: {(snapshot : FIRDataSnapshot) in
                    if let dict = snapshot.value as? NSDictionary {
                        let team = dict["team"]! as! String
                        
                        self.firebase.ref.child("competitions")
                        .queryOrdered(byChild: "team1")
                        .queryEqual(toValue: team)
                        .observe(.value, with: {(snapshot : FIRDataSnapshot) in
                                if let dict = snapshot.value as? NSDictionary {
                                    for comp in dict.allValues {
                                        var compData = comp as! NSDictionary
                                        var newComp = [compData["team1"]!, compData["team2"]!]
                                        self.competitions.append(newComp as! [String])
                                    }
                                }
                                
                                self.firebase.ref.child("competitions")
                                    .queryOrdered(byChild: "team2")
                                    .queryEqual(toValue: team)
                                    .observe(.value, with: {(snapshot : FIRDataSnapshot) in
                                        if let dict = snapshot.value as? NSDictionary {
                                            for comp in dict.allValues {
                                                var compData = comp as! NSDictionary
                                                var newComp = [compData["team1"]!, compData["team2"]!]
                                                self.competitions.append(newComp as! [String])
                                            }
                                            self.tableView.reloadData()
                                        }
                                    })
                            })
                    }
                })
        })
    }
}
