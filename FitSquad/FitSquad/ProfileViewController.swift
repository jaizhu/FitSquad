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
        
        // set naviation bar
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55))
        self.view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Name")
        
        // set logout button
        let thing = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(fbLogoutButtonClicked))
        navItem.rightBarButtonItem = thing
        navBar.setItems([navItem], animated: false)
        
        getProfilePic()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfilePic() {
        print("--------------- getting profile pic")
        
        // getting profile picture
        let params = ["fields": "picture.type(large)"]
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            } else {
                let recvd_data = result as! NSDictionary?
                
                let dict1 = recvd_data?["picture"] as! NSDictionary?
                let dict1data = dict1?["data"]
                let dict2 = dict1data as! NSDictionary?
                let dict2data = dict2?["url"]
                let realURL = dict2data as! NSString?
                let strURL = realURL as! String
                
                let profileURL = URL(string: strURL)
                self.downloadImage(url: profileURL!)
            }
        })
    }
    
    func downloadImage(url: URL) {
        print("** Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("** Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.profilePic.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
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
        print("USER IS LOGGING OUT")
        // log user out
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        // return to login page
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "loginViewController") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
}

