//
//  ViewController.swift
//  MemeBuilder
//
//  Created by Ramiro Trejo on 1/7/17.
//  Copyright © 2017 Ramiro Trejo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectCamera: UIButton!
    @IBOutlet weak var selectLibrary: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectCamera.isEnabled = false
        
        self.selectCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showPhotoLibraryViewController(_ sender: UIButton) {
        // Show the photo library
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func showCameraViewController(_ sender: UIButton) {
        // Show the camera 
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
}

