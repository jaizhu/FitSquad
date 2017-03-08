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
import FBSDKLoginKit
import FacebookCore
import FacebookLogin

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
        
        var userId = String()
        
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            } else {
                // You successfully got the email of yourself, print it
                let response = result as AnyObject?
                let email = response?.object(forKey: "id") as AnyObject?
                if let unwrapped = email {
                    userId = unwrapped as! String
                }
            }
        if let image = self.imageView.image {
            let user = "testUser1"   // TODO: Get User
            var data: NSData = NSData()
            
            // Save photo to Firebase
            data = UIImageJPEGRepresentation(image, 0.1)! as NSData
            
            let base64String = data.base64EncodedString()
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateStyle = .medium
            let dateString = dateFormatter.string(from: Date()) // TODO: Should it be full date & time?
            
            let photo: NSDictionary = ["user": userId,"date": dateString, "photoBase64":base64String]
            
            // Write
            self.firebase.ref.child("photos").childByAutoId().setValue(photo)
            
            }
        })
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
            })
        }
    }
}
