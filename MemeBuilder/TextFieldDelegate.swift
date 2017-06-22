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
    
    var topTextFieldIsClean = true

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Present the keyboard
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
}
