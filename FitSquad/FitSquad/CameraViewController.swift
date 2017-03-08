//
//  CameraViewController.swift
//  FitSquad
//
//  Created by Jaimie Zhu on 3/4/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import AVFoundation

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    let firebase = FIRDatabase.database().reference()
    
    @IBAction func takePhoto(_ sender: Any) {
        askPermission()
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] {
            imagePicker.dismiss(animated: true, completion: nil)
            imageView.image = image as? UIImage
        }

    }
    
    @IBAction func save(_ sender: Any) {
        if let image = imageView.image {
            let user = "testUser1"   // TODO: Get User
            var data: NSData = NSData()
            
            // Save photo to Firebase
            data = UIImageJPEGRepresentation(image, 0.1)! as NSData
            
            let base64String = data.base64EncodedString()
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateStyle = .medium
            let dateString = dateFormatter.string(from: Date()) // TODO: Should it be full date & time?
            
            let photo: NSDictionary = ["user": user,"date": dateString, "photoBase64":base64String]
            
            // Write
            firebase.ref.child("photos").childByAutoId().setValue(photo)
            
        }

    }
  
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // Camera permission
    func askPermission() {
        let cameraPermissionStatus =  AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch cameraPermissionStatus {
        case .authorized:
            print("already authorized")
        case .denied:
            print("denied")
            
            let alert = UIAlertController(title: "Sorry :(" , message: "But  could you please grant permission for camera within device settings",  preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel,  handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        case .restricted:
            print("restricted")
        default:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {
                [weak self]
                (granted :Bool) -> Void in
                
                if granted == true {
                    // User granted
                    print("User granted")
                    DispatchQueue.main.async(){
                        //Do smth that you need in main thread
                    }
                }
                else {
                    // User Rejected
                    print("User Rejected")
                    
                    DispatchQueue.main.async(){
                        let alert = UIAlertController(title: "WHY?" , message:  "Camera it is the main feature of our application", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alert.addAction(action)
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            });
        }
    }
    
    @IBAction func test(_ sender: Any) {
        getCompetitionPhotos(teamName: "team 1")
    }
    
    func extendArray(old: inout Array<String>, new: Array<String>) {
        old += new
        print(old)
    }
    
    func getCompetitionPhotos(teamName : String) -> [String : String] {   // team name and get back Name & Photo for
        
        // Get team members
        var users = [String]()
        
        firebase.ref.child("teams")
            .queryOrdered(byChild: "name")
            .queryEqual(toValue: teamName)
            .observe(.value, with: {(snapshot : FIRDataSnapshot) in
                if let dict = snapshot.value as? NSDictionary {
                    let teamData = dict.allValues.first! as? NSDictionary
                    let newUsers = (teamData!["users"]! as! NSArray).flatMap({ $0 as? String})
                    [self.users addObject: newUsers];
                    
                    users = (teamData!["users"]! as! NSArray).flatMap({ $0 as? String})
                    
                    var photos = [String : String]()
                    
                    var name : String?
                    name = nil
                    
                    var photoBase64 : String?
                    photoBase64 = nil
                    
                    
                    for user in users {
                        print(user)
                        self.firebase.ref.child("users")
                            .queryOrderedByKey()
                            .queryEqual(toValue: user)
                            .observe(.value, with: { (snapshot : FIRDataSnapshot) in
                                if let dict = snapshot.value as? NSDictionary {
                                    let userData = dict.allValues.first! as? NSDictionary
                                    name = userData!["name"]! as! String
                                }
                                
                                
                            })
                        
                        firebase.ref.child("photos")
                            .queryOrdered(byChild: user as! String)
                            .queryEqual(toValue: user)
                            .observe(.value, with: { snapshot in
                                if let snapshotValue = snapshot.value as? [String:Any] {
                                    photoBase64 = snapshotValue["photoBase64"] as! String
                                }
                            })
                        photos[name!] = photoBase64!
                    }
                    
                    return photos
                }

                }
            })
        
        var photos = [String : String]()
        var name : String?
        name = nil
        var photoBase64 : String?
        photoBase64 = nil
        
        print(users)
        
        
        for user in users {
            print(user)
            firebase.ref.child("users")
                .queryOrderedByKey()
                .queryEqual(toValue: user as! String)
                .observe(.value, with: { (snapshot : FIRDataSnapshot) in
                    if let dict = snapshot.value as? NSDictionary {
                        print(dict["users"])
                    }
                })
            
            firebase.ref.child("photos")
                .queryOrdered(byChild: user as! String)
                .queryEqual(toValue: user)
                .observe(.value, with: { snapshot in
                    if let snapshotValue = snapshot.value as? [String:Any] {
                        photoBase64 = snapshotValue["photoBase64"] as! String
                    }
                })
            photos[name!] = photoBase64!
        }
        
        return photos
    }
    
//    func getUserPhotos(){
//        firebase.ref.child("photos").queryOrdered(byChild:)
//        
//        
//    }

}


