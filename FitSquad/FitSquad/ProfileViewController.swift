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
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    let firebase = FIRDatabase.database().reference()
    
    // Storyboard items
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var streak: UILabel!
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var losses: UILabel!
    @IBOutlet weak var photosScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set naviation bar
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55))
        self.view.addSubview(navBar)
        let navItem = UINavigationItem()
        
        // set logout button
        let thing = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(fbLogoutButtonClicked))
        navItem.rightBarButtonItem = thing
        navBar.setItems([navItem], animated: false)
        
        getProfileInfoFB(navItem: navItem)
        
        print(USERID)
        
        getUserDBInfo()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfileInfoFB(navItem: UINavigationItem) {
        print("--------------- getting profile pic")
        
        // getting profile picture
        let params = ["fields": "picture.type(large), first_name, id"]
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            } else {
                let recvd_data = result as! NSDictionary?
                
                let firstname = recvd_data?["first_name"] as! NSString?
                navItem.title = firstname as String?
                
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
    
    func getUserDBInfo() {
        print("--------------- getting user streak")
        self.firebase.ref.child("users").child(USERID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary {
                print(dict)
                let streak = dict["streak"] as? NSDecimalNumber ?? 0;
                let wins = dict["wins"] as? NSDecimalNumber  ?? 0;
                let losses = dict["losses"] as? NSDecimalNumber ?? 0;
                
                // Do something with streak, wins, and losses here
            }
        })
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

