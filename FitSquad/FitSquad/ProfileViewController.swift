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
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var streak: UILabel!
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var losses: UILabel!
    @IBOutlet weak var photosScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageName = "jabrill.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55))
        self.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Name")
        
        
        let btn1 = UIButton(type: .custom)
        btn1.setTitle("Logout", for: .normal)
//        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(fbLogoutButtonClicked), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        navItem.rightBarButtonItem = item1
        
        navBar.setItems([navItem], animated: false)
        
//        let logoutItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(fbLogoutButtonClicked))
//        logoutItem.title = "Logout"
//        navItem.rightBarButtonItem = logoutItem
//        navBar.setItems([navItem], animated: false)
        
        getProfilePict()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfilePict() {
        print("--------------- getting profile pic")
    }
    
    func getStreak() {
        print("--------------- getting user streak")
    }
    
    func getWinsLosses() {
        print("--------------- getting wins and losses")
    }
    
    func getPhotos() {
        // this should be asynchronous and load as you scroll
        print("--------------- getting photos")
    }
    
    func fbLogoutButtonClicked() {
        print("USER IS LOGGING OUT FUCK")
        // this doesn't do anything yet
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
    }
    
}

