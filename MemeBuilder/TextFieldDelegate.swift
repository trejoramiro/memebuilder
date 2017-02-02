//
//  TextFieldDelegate.swift
//  MemeBuilder
//
//  Created by Ramiro Trejo on 1/18/17.
//  Copyright © 2017 Ramiro Trejo. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Textfield did begin editing")
        // Present the keyboard
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Textfield did end editing")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Textfield should return")
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
}
