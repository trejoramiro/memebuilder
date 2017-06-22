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
        
        topText.clearsOnBeginEditing = true
        bottomText.clearsOnBeginEditing = true
        
        topText.delegate = textFieldDelegate
        bottomText.delegate = textFieldDelegate
    
        shareButton.isEnabled = false
        cancelButton.isEnabled = false
        selectCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        message.text = "Start by Selecting an Image"
    }


    @IBAction func showPhotoLibraryViewController(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func showCameraViewController(_ sender: UIBarButtonItem) {
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
        
        // remove the keyboard if present
        self.view.endEditing(true)
        
        cancelButton.isEnabled = false
        shareButton.isEnabled = false
        
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
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false

        return memedImage
    }

    func save() {
        // Create the meme
        // let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
        //save the image to the device
    }

    
    @IBAction func showShareViewController() {
        let memedImage = generateMemedImage()
        
        let shareViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        shareViewController.completionWithItemsHandler = {
            activity,completed,items,error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }  
        }
        
        present(shareViewController, animated: true, completion: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification:Notification) {
        print(view.frame.origin.y)
        view.frame.origin.y = -(getKeyboardHeight(notification) / 2)
        print(view.frame.origin.y)
    } 
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0.0;
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

