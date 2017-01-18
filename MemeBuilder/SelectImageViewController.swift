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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide image and text until editing begins
        topText.isHidden = true
        bottomText.isHidden = true
        imageView.isHidden = true
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.blue,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:40)!,
            NSStrokeWidthAttributeName: NSNumber(value: 4.0)
        ]
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
    
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
        
        // Dismiss the imagePickerController
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showShareViewController() {
        
        // Add segue 
        let image = UIImage()
        let shareViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareViewController, animated: true, completion: nil)
    }
}

