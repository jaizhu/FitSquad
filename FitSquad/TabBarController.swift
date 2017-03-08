//
//  TabBarController.swift
//  FitSquad
//
//  Created by Rachel Connolly on 3/7/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) -> Bool {
        print("called 2")
        print(viewController)
        if (viewController is CameraViewController) {
            print("Take Photo")
            return false
        } else {
            return true
        }
    }

}
