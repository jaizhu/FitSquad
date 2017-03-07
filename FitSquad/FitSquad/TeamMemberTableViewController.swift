//
//  TeamMemberTableViewController.swift
//  FitSquad
//
//  Created by Danielle Connolly on 3/7/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import UIKit

class TeamMemberTableViewController: UITableViewController {
    
    var members = [Member]()

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
        // TODO: Make this 2 (to display one section for each team)
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TeamMemberTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TeamMemberTableViewCell else {
            fatalError("The dequeued cell is not an instance of TeamMemberTableViewCell.")
        }

        let member = members[indexPath.row]
        
        cell.nameLabel.text = member.name
//        cell.gymPhotoImageView.image = member.photo
//
//        cell.checkmarkImageView.image = UIImage(named: "Xmark")
        
        // TODO: Set checkmark if member has already participated
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
        
        guard let rachel = Member(name: "Rachel", photo: UIImage(named: "RachelGym"), participated: true) else {
            fatalError("Unable to instantiate Rachel")
        }
        
        guard let danielle = Member(name: "Danielle", photo: UIImage(named: "RachelGym"), participated: false) else {
            fatalError("Unable to instantiate Danielle")
        }
        
        guard let jaimie = Member(name: "Jaimie", photo: UIImage(named: "RachelGym"), participated: false) else {
            fatalError("Unable to instantiate Jaimie")
        }
        
        members += [rachel, danielle, jaimie]
    }
}
