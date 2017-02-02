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
    
    let textFieldDelegate = TextFieldDelegate()
    
    struct Meme {
        var topText = ""
        var bottomText = ""
        var originalImage:UIImage
        var memedImage:UIImage
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

