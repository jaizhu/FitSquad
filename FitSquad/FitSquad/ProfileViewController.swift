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
    
    @IBOutlet weak var fakeprofile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this button doesn't display
        let button: UIButton = UIButton()
        button.backgroundColor = .black
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action:#selector(self.fbLogoutButtonClicked), for: .touchUpInside)
        self.view.addSubview(button)
        
        let imageName = "jabrill.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
        fakeprofile.image = image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fbLogoutButtonClicked(sender:UIButton!) {
        print("USER IS LOGGING OUT FUCK")
        // this doesn't do anything yet
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
    }
    
}

