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
import Firebase

class ProfileViewController: UIViewController {
    
    // Storyboard items
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var streak: UILabel!
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var losses: UILabel!
    @IBOutlet weak var photosScrollView: UIScrollView!
    
    let firebase = FIRDatabase.database().reference()
    
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
        
        getStreak()
        
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
    
    func getStreak() {
        print("--------------- getting user streak")
        
//        let ref = firebase.root.child("users").child(USERID)
//        
//        ref.observe(of: .value, with: { (snapshot: FIRDataSnapshot) in
//            if snapshot.hasChildren() {
//                print("has children")
//            }
//        })
//        
//        print("hi")
        
        
//        firebase.ref.observeSingleEvent(of: .value, with: {(snapshot: FIRDataSnapshot) in
//            
//            if !snapshot.exists() {return}
//            
////            if let thing = snapshot.value["streak"] as? String {
////                print(thing)
////            }
//            
//            print(type(of: snapshot.value))
//            print(snapshot.value)
//            
//            if snapshot.hasChildren() {
//                let thing = snapshot.childSnapshot(forPath: "streak").value as! String
//            }
//            
//            print("hi")
//            
//        })
        
        
//        firebase.ref.child("users")
//            .queryOrdered(byChild: "name")
//            .queryEqual(toValue: teams[0])
//            .observe(.value, with: {(snapshot : FIRDataSnapshot) in
//                if let dict = snapshot.value as? NSDictionary {
//                    let teamData = dict.allValues.first! as? NSDictionary
//                    t1UserIds = (teamData!["users"]! as! NSArray).flatMap({ $0 as? String})
//                    
//                    var name : String?
//                    name = nil
//                    var photoBase64 : String?
//                    photoBase64 = nil
//                    
//                    for userId in t1UserIds {
//                        self.firebase.ref.child("users").child(userId)
//                            .observe(.value, with: { (snapshot : FIRDataSnapshot) in
//                                let dict = snapshot.value as! NSDictionary
//                                name = dict["name"]! as! String
//                                
//                                var newUser = Member(name: name!, photo: UIImage(named: "DefaultPhoto"), participated: false)
//                                self.firebase.ref.child("photos")
//                                    .queryOrdered(byChild: "user")
//                                    .queryEqual(toValue: userId)
//                                    .observe(.value, with: { snapshot in
//                                        if snapshot.value is NSNull {  // User has no photos
//                                            self.t1Users.append(newUser!)
//                                        } else {
//                                            if let dict = snapshot.value as? NSDictionary {
//                                                photoBase64 = nil
//                                                for pic in dict.allValues {
//                                                    var picData = pic as! NSDictionary
//                                                    if (picData["date"] as! String) == dateString { // User has photo from today
//                                                        photoBase64 = picData["photoBase64"] as! String
//                                                    }
//                                                }
//                                                
//                                                if photoBase64 == nil { // User has no photos from today
//                                                    self.t1Users.append(newUser!)
//                                                } else {    // User has photo from today
//                                                    let dataDecoded:NSData = NSData(base64Encoded: photoBase64!, options: NSData.Base64DecodingOptions(rawValue: 0))!
//                                                    let decodedImage:UIImage = UIImage(data: dataDecoded as Data)!
//                                                    
//                                                    //                                                guard let newUser = Member(name: name!, photo: decodedImage, participated: true) else {
//                                                    //                                                    fatalError("Unable to instantiate user") }
//                                                    newUser!.photo = decodedImage
//                                                    newUser!.participated = true
//                                                    self.t1Users.append(newUser!)
//                                                }
//                                            }
//                                        }
//                                        
//                                        if(self.t1Users.count == 3) {
//                                            self.tableView.reloadData()
//                                        }
//                                    })
//                            })
//                    }
//                }
//                
//            })
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

