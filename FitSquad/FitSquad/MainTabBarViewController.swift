//
//  MainTabBarViewController.swift
//  FitSquad
//
//  Created by Jaimie Zhu on 3/8/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    
    @IBOutlet weak var myMainTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("HAYYYYYY YAAA")
        
        myMainTabBar.items?[0].selectedImage = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[0].image = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        
        myMainTabBar.items?[1].selectedImage = UIImage(named: "user")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].image = UIImage(named: "user")?.withRenderingMode(.alwaysOriginal)
        
        myMainTabBar.items?[2].selectedImage = UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].image = UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
