//
//  ViewController.swift
//  testImagePicker
//
//  Created by Christopher Johnson on 5/9/15.
//  Copyright (c) 2015 Christopher Johnson. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePanel: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    
    let memeTextDelegate = MemeTextDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = memeTextDelegate
        bottomTextField.delegate = memeTextDelegate
        
        //did not use recommended memeTextAttributes dictionary as when I set as default
        //the default overrode the centered text, and it would not set it back programmatically
        //or in IB...this alternative works
        var oldTextAttributes = topTextField.defaultTextAttributes
        oldTextAttributes.updateValue(UIColor.blackColor(), forKey: NSStrokeColorAttributeName)
        oldTextAttributes.updateValue(UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        oldTextAttributes.updateValue(UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, forKey: NSFontAttributeName)
        oldTextAttributes.updateValue(-3, forKey: NSStrokeWidthAttributeName)
        topTextField.defaultTextAttributes = oldTextAttributes
        
        var oldBotTextAttrib = bottomTextField.defaultTextAttributes
        oldBotTextAttrib.updateValue(UIColor.blackColor(), forKey: NSStrokeColorAttributeName)
        oldBotTextAttrib.updateValue(UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        oldBotTextAttrib.updateValue(UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, forKey: NSFontAttributeName)
        oldBotTextAttrib.updateValue(-3, forKey: NSStrokeWidthAttributeName)
        bottomTextField.defaultTextAttributes = oldBotTextAttrib
    }

    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
        
        verifyImageChosen()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        
        let nextController = UIImagePickerController()
        self.presentViewController(nextController, animated: true, completion: nil)
        nextController.delegate = self
    }

    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        let nextController = UIImagePickerController()
        nextController.delegate = self
        nextController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(nextController, animated: true, completion: nil)
    }
//http://www.codeitive.com/7QNmXejWjV/uiactivityviewcontroller-completion-handler-still-calls-action-if-user-presses-cancel.html
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        var imageOriginal : UIImage! = imagePanel.image
        var memedImage : UIImage = generateMemedImage()
        var textArr : [String] = [topTextField.text, bottomTextField.text]
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = {(activityType, completed : Bool, returnedItems : [AnyObject]!, activityError : NSError!) -> Void in
            if !completed {
                return
            }
            else {
                self.saveMeme(textArr, originalImage: imageOriginal, memeImage: memedImage)
                println("saved a meme somewhere")
                activityController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
    @IBAction func cancelEdit(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePanel.image = image
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //dismiss picker
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y < 0 {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //of CGRect
        return keyboardSize.CGRectValue().height
    }
    func saveMeme(textArray : [String], originalImage : UIImage, memeImage : UIImage) {
        //create the meme
        var newMeme = Meme(textArray: textArray, imageOrg: originalImage, imageMeme: memeImage)
        
        //add meme to memes array in app delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(newMeme)
    }
    func generateMemedImage() -> UIImage {
        
        //TODO: hide toolbar and navbar
        //render view to image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //TODO: show toolbar and navbar
        
        return memedImage
    }
    func verifyImageChosen() {
        if let newImage = imagePanel.image {
            shareMemeButton.enabled = true
        }
        else {
            shareMemeButton.enabled = false
        }
    }
}

