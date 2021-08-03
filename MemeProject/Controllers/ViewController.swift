//
//  ViewController.swift
//  MemeProject
//
//  Created by María Yael Vincennao on 23/7/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var spacingItemToolBar: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.0
    ]
    
    //Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Camera button disabled in the simulator
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
       //Set Top and Bottom textFields
        self.topTextField.delegate = self
        setupTextField(textField: topTextField, text: "TOP")
       
        self.bottomTextField.delegate = self
        setupTextField(textField: bottomTextField, text: "BOTTOM")
        
        // Fixed Space on toolbar items
        spacingItemToolBar.width = self.view.bounds.width - self.toolBar.items![0].width - self.toolBar.items![1].width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func setupTextField(textField: UITextField, text: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
        }

    // Picking Images
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickImage(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickImage(source: .camera)
    }
    
    func pickImage(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
      }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        shareButton.isEnabled = true
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == topTextField && textField.text == "TOP") || (textField == bottomTextField && textField.text == "BOTTOM") {
                   textField.text = " "
               }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
                return true
    }
    
    //Keyboard Stuff
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
// to place our views we use frame. restamos el alto del teclado para mover la view para arriba. el top de la pantalla es y=0
        // no utilizar -= to avoid the accumulation of values.
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        view.frame.origin.y = 0
    }
    
    //Creando el meme y guardandolo en un array de memes
    func save() {
        //update the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        //add it to the memes array on the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        //(UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    
    }
    
    func generateMemedImage() -> UIImage {
            
        // TODO: Hide toolbar and navbar
        hideShow(true)
            
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
            
        // TODO: Show toolbar and navbar
        hideShow(false)
            
        return memedImage
        }
    
    func hideShow(_ isHidden: Bool) {
        toolBar.isHidden = isHidden
        navBar.isHidden = isHidden
        }
    
    //Share Action
    @IBAction func shareMeme(_ sender: Any) {
        let memeImage = generateMemedImage()
            let uiController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
            present(uiController, animated: true, completion: nil)
            
            uiController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
                
                if completed {
                    print ("Success")
                    self.save()
                    self.dismiss(animated: true, completion: nil)
                
                // If the user cancells before sharing, the UI Activity View Controller is dismissed without doing anything.
                } else  {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
}





