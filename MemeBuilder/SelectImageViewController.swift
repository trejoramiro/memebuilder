//
//  ViewController.swift
//  MemeBuilder
//
//  Created by Ramiro Trejo on 1/7/17.
//  Copyright © 2017 Ramiro Trejo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var selectCamera: UIBarButtonItem!
    @IBOutlet weak var selectLibrary: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var message: UILabel!
    
    let textFieldDelegate = TextFieldDelegate()
    
    struct Meme {
        var topText:String
        var bottomText:String
        var originalImage:UIImage
        var memedImage:UIImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide image and text until editing begins
        topText.isHidden = true
        bottomText.isHidden = true
        imageView.isHidden = true
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:40)!,
            NSStrokeWidthAttributeName: NSNumber(value: -4.5)
            
        ]
        
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        topText.textAlignment = .center
        bottomText.textAlignment = .center
        
        topText.adjustsFontSizeToFitWidth = true
        bottomText.adjustsFontSizeToFitWidth = true
        topText.minimumFontSize = CGFloat(5)
        bottomText.minimumFontSize = CGFloat(5)
        
        topText.delegate = textFieldDelegate
        bottomText.delegate = textFieldDelegate
    
        shareButton.isEnabled = false
        cancelButton.isEnabled = false
        selectCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        message.text = "Start by Selecting an Image"
    }


    @IBAction func showPhotoLibraryViewController(_ sender: UIBarButtonItem) {
        // Show the photo library
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func showCameraViewController(_ sender: UIBarButtonItem) {
        // Show the camera 
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func resetView(_ sender: Any) {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imageView.image = nil
        
        topText.isHidden = true
        bottomText.isHidden = true
        imageView.isHidden = true
        
        cancelButton.isEnabled = false
        
        message.text = "Start by Selecting an Image"
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Add selected image to imageView
        if let image = info["UIImagePickerControllerOriginalImage"] as! UIImage? {
            imageView.image = image
        }
        
        // Display the image view and text fields 
        imageView.isHidden = false
        topText.isHidden = false
        bottomText.isHidden = false
        
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        cancelButton.isEnabled = true
        shareButton.isEnabled = true
        
        message.text = "Edit Placeholder Text"
        
        // Dismiss the imagePickerController
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }

    func save() {
        // Create the meme
//        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
        //save the image to the device
    }

    
    @IBAction func showShareViewController() {
        
        // Create memedImage 
        let memedImage = generateMemedImage()
        
        // Generate a memed image
        let image = Meme(
            topText: topText.text!,
            bottomText: bottomText.text!,
            originalImage: imageView.image!,
            memedImage: memedImage)
        
        // Define an instance of the ActivityController
        let shareViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        shareViewController.completionWithItemsHandler = {
            activity,completed,items,error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }  
        }
        
        // present the ActivityViewController
        present(shareViewController, animated: true, completion: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification:Notification) {
        print("keyboardWillShow")
        print(view.frame.origin.y)
        print(getKeyboardHeight(notification))
        view.frame.origin.y = view.frame.origin.y - (getKeyboardHeight(notification) / 2)
        print(view.frame.origin.y)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = view.frame.origin.y + getKeyboardHeight(notification)
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

