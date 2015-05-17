//
//  MemeTextDelegate.swift
//  testImagePicker
//
//  Created by Christopher Johnson on 5/16/15.
//  Copyright (c) 2015 Christopher Johnson. All rights reserved.
//

import Foundation
import UIKit

class MemeTextDelegate : NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}