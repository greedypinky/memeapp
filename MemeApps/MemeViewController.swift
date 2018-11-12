//
//  ViewController.swift
//  MemeApps
//
//  Created by Man Wai  Law on 2018-10-21.
//  Copyright © 2018 Rita's company. All rights reserved.
//
import UIKit

class MemeViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var upperTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    //@IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    var memedImage: UIImage?
    
    var originalViewHight:CGFloat = 0
    
    // define the text attributes for the Upper and the Buttom text
    let memeTextAttributes:[NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.red,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 36)!,
        NSAttributedString.Key.strokeWidth: -2.0]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) // need to disable the camera button if not available in the Simulator
        // sampleTextField.center = CGPoint(x: value1, y: value2)
        subscribeToKeyboardNotifications()
        upperTextField.delegate = self
        bottomTextField.delegate = self
        
        originalViewHight = view.frame.origin.y
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(share))
        // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "share", style: UIBarButtonItem.Style.action, target: self, action: #selector(share))
        
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        upperTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        upperTextField.attributedPlaceholder = NSAttributedString(string: "Upper text",
                                                               attributes: memeTextAttributes)
        
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "Bottom text",
                                                                  attributes: memeTextAttributes)
    }

//    @IBAction func pickAnImage(_ sender: Any) {
//
//        let imagePicker = UIImagePickerController()
//        // add the delegate to handle after picking the image
//        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
//        present(imagePicker, animated: true, completion: nil)
//    }
    
    @IBAction func pickAnImageCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        // add the delegate to handle after picking the image
        imagePicker.delegate = self
        if let _ = sender as? UIBarButtonItem {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        // add the delegate to handle after picking the image
        imagePicker.delegate = self
        let button = sender as? UIButton
        if (button?.titleLabel?.text == "album") {
            print("set the source to album")
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerController methods
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage = info[.originalImage] as? UIImage {
            // set the image to the imageview
            imageView.image = originalImage
            imageView.contentMode = .scaleAspectFill
            
            dismiss(animated: true, completion: nil)
            
            // enable the Share button
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            
        }
    }
    

    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // shift up the frame to the hight of the keyboard's hight when keyboard is up
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y -= getKeyboardHeight(notification)
        
    }
    
//    // shift the frame back to the original
//    @objc func resetKeyboard(_ notification:Notification) {
//
//        view.frame.origin.y -= getKeyboardHeight(notification)
//
//
//    }

    // return the keyboard's height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO: Clear the textfield content
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textField.resignFirstResponder()
        //save()
    }
    
    // Limit the width is not more than the current view's width
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        var newTextString = oldText.replacingCharacters(in: range, with: string)
        
        return true
    }
    
    // If user presses return button, generate the memed image and enable the share button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.frame.origin.y = originalViewHight
        memedImage = generateMemedImage()
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//        view.frame.origin.y = originalViewHight
//    }
    
    
    func save() {
        
        let _ = MyMeme(original: imageView.image!, memed: memedImage!, upperText: upperTextField.text!,
                                bottomText: bottomTextField.text!)
    }
    
    @objc func share() {
        // check if the memedImage is generated, if it is generated we will share the content
        guard memedImage != nil else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
       // typealias CompletionWithItemsHandler = (UIActivity.ActivityType?, Bool, [Any]?, Error?) -> Void
        activityViewController.completionWithItemsHandler = {
            (activity, success, returnedItems, activityError) in
            
            if (success) {
                self.save()
            }
        }
        present(activityViewController, animated: true, completion: nil)
       
    }
    
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        toolBar.isHidden = true;
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // TODO: Hide toolbar and navbar
        self.hidesBottomBarWhenPushed = false
        toolBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        return memedImage
    }
    
    func disableShare(bool:Bool) {
        
        navigationItem.leftBarButtonItem?.isEnabled = bool
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        print("tap around to dismiss keyboard!")
        view.endEditing(true)
        view.frame.origin.y = self.originalViewHight
        self.memedImage = self.generateMemedImage()
        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
}

