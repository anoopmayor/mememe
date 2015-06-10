//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Jericho on 5/22/15.
//  Copyright (c) 2015 Jericho. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    
   // var memeObj : [Meme]!

    
    
    
    //set common text attributes
    let memeTextAttributes = [
        
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 38)!,
        NSStrokeWidthAttributeName : -2
        
        
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //populating the top text field
        topTextField.defaultTextAttributes=memeTextAttributes
        topTextField.text = "TOP"
        topTextField.textAlignment = .Center
        
        
        //populating the bottom text field
        bottomTextField.defaultTextAttributes=memeTextAttributes
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .Center
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //disable the share button till image is chosen
        if let imageExist = imagePickerView.image {
            
            shareButton.enabled = true
        } else {

            shareButton.enabled = false
        }
        
        
        //disable the camera button if SourceType not available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //subscribe to keyboard notification
        self.subscribeToKeyboardNotification()
    }

    
   override func viewWillDisappear(animated: Bool) {
    
        super.viewWillDisappear(animated)
    
        //unsubscribe from keyboard notification
        self.unsubscribeFromKeyboardNotifications()
        
    }
    
    
    //move the view when the keyboard covers the textField
    func keyboardWillShow (notification: NSNotification){
        if bottomTextField.isFirstResponder(){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //move the view back down when the keyboard disappears
    func keyboardWillHide (notification: NSNotification){
        if bottomTextField.isFirstResponder(){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }

    //get keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    
    
        return keyboardSize.CGRectValue().height
    
    }
    
    
    
    
    
    func subscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //if user taps on text field, the default text is deleted
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
                textField.text = ""
        }
    }

    
    //when the retun key is pressed, the keyboard is dismissed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if (appDelegate.memeObj.count > 0) {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            imagePickerView.image = nil
            shareButton.enabled = false
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
        }

    }
    
    
    
    
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .ScaleAspectFill
            imagePickerView.image = pickedImage
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        
        //if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        let imagePickerCamera = UIImagePickerController()
        imagePickerCamera.delegate = self
        imagePickerCamera.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePickerCamera, animated: true, completion: nil)
    }
    
    
    func save() {
        //update the meme
        var meme = Meme (topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generatedMemedImage())
        
        //add it to the Memes array on the Application Delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memeObj.append(meme)
    
    }
    
    
    
    func generatedMemedImage() -> UIImage {
        
        //hide toolbar and nav bar and clear background Color
        view!.backgroundColor = UIColor.clearColor()
        navigationController?.setNavigationBarHidden(true, animated: true)
        toolBar.hidden=true
        
        //render view to image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        //show toolbar and nav bar and background Color
        toolBar.hidden=false
        navigationController?.setNavigationBarHidden(false, animated: true)
        view!.backgroundColor = UIColor.blackColor()
        
        return memedImage
    }
    
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        //create a meme image and pass it to the activity view controller
        var image = UIImage()
        image = generatedMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        // save the meme to storage
        controller.completionWithItemsHandler = {
            (activity :String!, completed :Bool, items :[AnyObject]!, error :NSError!) -> Void in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        
        self.presentViewController(controller,animated: true, completion: nil)

    }
    
    
    
    
}

