//
//  TeamNameViewController.swift
//  FitSquad
//
//  Created by Danielle Connolly on 3/8/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import UIKit

class TeamNameViewController: UIViewController {

    @IBOutlet weak var nameInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let createSegueIdentifier = "CreateTeamSegue"
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if  segue.identifier == createSegueIdentifier,
            let destination = segue.destination as? PickTeamTableViewController,
            let name = nameInput?.text // TODO: Get text input
        {
            destination.teamName = name
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
