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
    
    var competitions = [[String]]()   // [[team1, team2], [team1, team3]]
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == competitionSegueIdentifier,
            let destination = segue.destination as? TeamMemberTableViewController,
            let competitionIndex = tableView.indexPathForSelectedRow?.row
        {
            destination.teams = competitions[competitionIndex] // [team1, team2] passed to single competition view
        }
    }
    
    // Add competition described in dict to competition list on competition screen
    private func addCompetition(dict: NSDictionary) {
        
        for comp in dict.allValues {
            let compData = comp as! NSDictionary
            let newComp = [compData["team1_name"]!, compData["team2_name"]!]
            self.competitions.append(newComp as! [String])
        }

//        // Get actual team names instead of unique ids
//        self.firebase.ref.child("teams")
//            .child(user_team) //HERE
//            .observe(.value, with: {(snapshot : FIRDataSnapshot) in
//                if let team_dict = snapshot.value as? NSDictionary {
//                    print("@@@@@@@@@@@@@@@@@@@ADDING NEW COMPETITION!! TEAM INFO: ")
//                    print(team_dict)
//                }
//            })
    
        self.tableView.reloadData()
        
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
            
            // Get the list of user's competitions from firebase
            // TODO: This should really be on ChildAdded instead of just checking everything every time but I don't really care enough to change it
            self.competitions.removeAll()
            USERID = userId
            
            self.firebase.ref.child("users").child(userId)
                .observe(.value, with: {(snapshot : FIRDataSnapshot) in
                    if let dict = snapshot.value as? NSDictionary {
                        
                        let competition_list = (dict["teams"]! as! NSDictionary).allValues
                        for team in competition_list {
                        
                            // Check team1
                            self.firebase.ref.child("competitions")
                                .queryOrdered(byChild: "team1")
                                .queryEqual(toValue: team)
                                .observe(.value, with: {(snapshot : FIRDataSnapshot) in
                                    if let comp_dict = snapshot.value as? NSDictionary {
                                        self.addCompetition(dict: comp_dict)
                                    }
                                    
                                    // Check team2
                                    self.firebase.ref.child("competitions")
                                        .queryOrdered(byChild: "team2")
                                        .queryEqual(toValue: team)
                                        .observe(.value, with: {(snapshot : FIRDataSnapshot) in
                                            if let comp_dict = snapshot.value as? NSDictionary {
                                                self.addCompetition(dict: comp_dict)
                                            }
                                        })
                                })
                        }
                    }
                })
        })
    }
}
