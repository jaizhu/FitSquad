//
//  TeamMemberTableViewController.swift
//  FitSquad
//
//  Created by Danielle Connolly on 3/7/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class TeamMemberTableViewController: UITableViewController {
    
    var teams = [String]()
    var t1Users = [Member]()
    var t2Users = [Member]()
    
    let firebase = FIRDatabase.database().reference()

    @IBOutlet weak var competitionTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleTeam()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return teams.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(t1Users.count, t2Users.count)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < teams.count {
            return teams[section]
        }
        
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TeamMemberTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TeamMemberTableViewCell else {
            fatalError("The dequeued cell is not an instance of TeamMemberTableViewCell.")
        }

        var member : Member
        
        if t2Users.isEmpty {
            member = t1Users[indexPath.row]
        } else {
            member = t2Users[indexPath.row]
        }
        
        cell.nameLabel.text = member.name

        if member.participated {
            cell.checkmarkImageView.image = UIImage(named: "Checkmark")
            cell.gymPhotoImageView.image = member.photo
        }
        else {
            cell.checkmarkImageView.image = UIImage(named: "Xmark")
        }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    // MARK: Private methods
    
    private func loadSampleTeam() {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: Date())
        
        
        print(teams)
        self.title = teams[0] + " vs. " + teams[1]
        
        // Get Team 1 member & photos
        var t1UserIds = [String]()
        
        firebase.ref.child("teams")
        .queryOrdered(byChild: "name")
        .queryEqual(toValue: teams[0])
        .observe(.value, with: {(snapshot : FIRDataSnapshot) in
                if let dict = snapshot.value as? NSDictionary {
                    let teamData = dict.allValues.first! as? NSDictionary
                    t1UserIds = (teamData!["users"]! as! NSArray).flatMap({ $0 as? String})
                    
                    var name : String?
                    name = nil
                    var photoBase64 : String?
                    photoBase64 = nil
                    
                    for userId in t1UserIds {
                        self.firebase.ref.child("users").child(userId)
                            .observe(.value, with: { (snapshot : FIRDataSnapshot) in
                                let dict = snapshot.value as! NSDictionary
                                name = dict["name"]! as! String
                                
                                self.firebase.ref.child("photos")
                                    .queryOrdered(byChild: "user")
                                    .queryEqual(toValue: userId)
                                    .observe(.value, with: { snapshot in
                                        if snapshot.value == nil {  // User has no photos
                                            guard let newUser = Member(name: name!, photo: UIImage(named: "DefaultPhoto"), participated: false)  else {
                                                fatalError("Unable to instantiate user")
                                            }
                                            self.t1Users.append(newUser)
                                        } else {
                                            if let dict = snapshot.value as? NSDictionary {
                                            photoBase64 = nil
                                            for pic in dict.allValues {
                                                var picData = pic as! NSDictionary
                                                if (picData["date"] as! String) == dateString { // User has photo from today
                                                    photoBase64 = picData["photoBase64"] as! String
                                                }
                                            }
                                        
                                            if photoBase64 == nil { // User has no photos from today
                                                guard let newUser = Member(name: name!, photo: UIImage(named: "DefaultPhoto"), participated: false)  else {
                                                        fatalError("Unable to instantiate user")
                                                    }
                                                self.t1Users.append(newUser)
                                            } else {    // User has photo from today
                                                let dataDecoded:NSData = NSData(base64Encoded: photoBase64!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                                                let decodedImage:UIImage = UIImage(data: dataDecoded as Data)!
                                        
                                                guard let newUser = Member(name: name!, photo: decodedImage, participated: true) else {
                                                    fatalError("Unable to instantiate user") }
                                                self.t1Users.append(newUser)
                                                }
                                            }
                                        }
                                        
                                dump(self.t1Users)
                                self.tableView.reloadData()
                            })
                        })
                    }
            }
            
        })
        

        // Get Team 2 member & photos
        var t2UserIds = [String]()
        
        firebase.ref.child("teams")
            .queryOrdered(byChild: "name")
            .queryEqual(toValue: teams[1])
            .observe(.value, with: {(snapshot : FIRDataSnapshot) in
                if let dict = snapshot.value as? NSDictionary {
                    let teamData = dict.allValues.first! as? NSDictionary
                    t2UserIds = (teamData!["users"]! as! NSArray).flatMap({ $0 as? String})
                    
                    var name : String?
                    name = nil
                    
                    var photoBase64 : String?
                    photoBase64 = nil
                    
                    for userId in t2UserIds {
                        self.firebase.ref.child("users").child(userId)
                            .observe(.value, with: { (snapshot : FIRDataSnapshot) in
                                if let dict = snapshot.value as? NSDictionary {
                                    name = dict["name"]! as! String
                                }
                                
                                
                                self.firebase.ref.child("photos")
                                    .queryOrdered(byChild: "user")
                                    .queryEqual(toValue: userId)
                                    .observe(.value, with: { snapshot in
                                        if snapshot.value == nil {  // User has no photos
                                            guard let newUser = Member(name: name!, photo: UIImage(named: "DefaultPhoto"), participated: false)  else {
                                                fatalError("Unable to instantiate user")
                                            }
                                            self.t2Users.append(newUser)
                                        } else {
                                            if let dict = snapshot.value as? NSDictionary {    // TODO: Sort photos by date
                                                photoBase64 = nil
                                                for pic in dict.allValues {
                                                    var picData = pic as! NSDictionary
                                                    if (picData["date"] as! String) == dateString { // User has photo from today
                                                        photoBase64 = picData["photoBase64"] as! String
                                                        break;
                                                    }
                                                }
                                                
                                                if photoBase64 == nil { // User has no photos from today
                                                    guard let newUser = Member(name: name!, photo: UIImage(named: "DefaultPhoto"), participated: false)  else {
                                                        fatalError("Unable to instantiate user")
                                                    }
                                                    self.t2Users.append(newUser)
                                                } else {    // User has photo from today
                                                    let dataDecoded:NSData = NSData(base64Encoded: photoBase64!, options: NSData.Base64DecodingOptions(rawValue: 0))!
                                                    let decodedImage:UIImage = UIImage(data: dataDecoded as Data)!
                                                    
                                                    guard let newUser = Member(name: name!, photo: decodedImage, participated: true) else {
                                                        fatalError("Unable to instantiate user")
                                                    }
                                                    self.t2Users.append(newUser)
                                                }
                                            }
                                            dump(self.t2Users)
                                            self.tableView.reloadData()
                                        }
                                    })
                            })
                    }
                }
                
            })

    }
}
