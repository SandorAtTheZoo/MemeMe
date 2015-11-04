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
    @IBOutlet weak var thisToolbar: UIToolbar!
    
    let memeTextDelegate = MemeTextDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = memeTextDelegate
        bottomTextField.delegate = memeTextDelegate
        
        //did not use recommended memeTextAttributes dictionary as when I set as default
        //the default overrode the centered text, and it would not set it back programmatically
        //or in IB...this alternative works
        
        updateTextAttributes(topTextField)
        updateTextAttributes(bottomTextField)
    }

    override func viewWillAppear(animated: Bool) {
        //if camera exists, enable camera icon
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //keyboard notifications needed to shift display to see bottom meme text when editing (as keyboard rises and falls)
        self.subscribeToKeyboardNotifications()
        
        //if an image has been chosen, allow user to share it, otherwise prevent accidental sharing
        verifyImageChosen()
    }
    
    override func viewWillDisappear(animated: Bool) {
        //release notification when changing views
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        
        //bring up picker viewController for album browsing
        let nextController = UIImagePickerController()
        self.presentViewController(nextController, animated: true, completion: nil)
        nextController.delegate = self
    }

    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        //view viewController for camera
        let nextController = UIImagePickerController()
        nextController.delegate = self
        nextController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(nextController, animated: true, completion: nil)
    }
    
//http://stackoverflow.com/questions/28169192/ios-swift-uiactivityviewcontroller-completion-handler-returns-success-when-tweet
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let imageOriginal : UIImage! = imagePanel.image
        let memedImage : UIImage = generateMemedImage()
        let textArr : [String] = [topTextField.text!, bottomTextField.text!]
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
        
        //if activity viewController completes with valid selection, save meme, and return to sentMeme view
        activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, activityError) in
            if !completed {
                return
            }
            else {
                self.saveMeme(textArr, originalImage: imageOriginal, memeImage: memedImage)
                activityController.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
    }
    
    //return to sentMeme view on cancel
    @IBAction func cancelEdit(sender: UIBarButtonItem) {

        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //whatever image chosen from album, set the local image to that and dismiss album
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePanel.image = image
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //dismiss album picker on cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //modify text attributes of upper and lower meme text to be meme-ish
    //did not work from table, as centering was overwritten
    func updateTextAttributes(aTextField : UITextField){
        
        //first grab existing defaults (interfaces with IB better)
        var oldBotTextAttrib = aTextField.defaultTextAttributes
        //make attribute mods to defaults which include IB settings
        oldBotTextAttrib.updateValue(UIColor.blackColor(), forKey: NSStrokeColorAttributeName)
        oldBotTextAttrib.updateValue(UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        oldBotTextAttrib.updateValue(UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, forKey: NSFontAttributeName)
        oldBotTextAttrib.updateValue(-3, forKey: NSStrokeWidthAttributeName)
        //set new defaults (including original ones from IB)
        aTextField.defaultTextAttributes = oldBotTextAttrib
    }
    
    //know when keyboard rises and falls
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    //release notification when leaving the view
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    //called as selector from 'subscribeToKeyboardNotifications'
    //adjusts view frame to shift up display when keyboard shows
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    //called as selector from 'subscribeToKeyboardNotifications'
    //adjusts view frame to shift down display when keyboard hides
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y < 0 {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    //find out how tall keyboard is to know how much to shift display when it shows/hides
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //of CGRect
        return keyboardSize.CGRectValue().height
    }
    //instantiate new meme class and add it to the appDelegate meme array
    func saveMeme(textArray : [String], originalImage : UIImage, memeImage : UIImage) {
        //create the meme
        let newMeme = Meme(textArray: textArray, imageOrg: originalImage, imageMeme: memeImage)
        
        //add meme to memes array in app delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(newMeme)
    }
    //take screenshot of memed image
    //alpha adjustment of toolbar done to 'hide' toolbar for the screenshot
    func generateMemedImage() -> UIImage {
        
        //hide toolbar for photo
        self.thisToolbar.alpha = 0
        //render view to image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //show toolbar after photo
        self.thisToolbar.alpha = 1
        
        
        return memedImage
    }
    //support function used to determine if meme image was chosen to prevent accidental sharing
    func verifyImageChosen() {
        if let newImage = imagePanel.image {
            shareMemeButton.enabled = true
        }
        else {
            shareMemeButton.enabled = false
        }
    }
}

