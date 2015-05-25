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
        //clears text field on selection only if never selected before so user can
        //edit/change their own text without retyping the whole thing
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //makes keyboard go away after hitting return
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        //fills in text field for you (with meme-ish response) if you hit return with no text
        if textField.text == "" {
            textField.text = "WUT"
        }
    }
}