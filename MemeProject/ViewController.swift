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
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.0
    ]
    
    struct Meme {
        var topText: String
        var bottomText: String
        let originalImage: UIImage
        let memedImage: UIImage
    }
    
    //Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        self.topTextField.defaultTextAttributes = memeTextAttributes
        //self.topTextField.background = .none
        self.topTextField.delegate = self
        self.topTextField.text = "TOP"
        self.topTextField.textAlignment = .center
        
        
        
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.delegate = self
        self.bottomTextField.text = "BOTTOM"
        self.bottomTextField.textAlignment = .center
        
        // Fixed Space
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

    // Picking Images
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
    
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
    
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
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
        view.frame.origin.y -= getKeyboardHeight(notification)
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        view.frame.origin.y = 0
    }
    
    //Creando el meme
    func save() {

        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    
    }
    
    func generateMemedImage() -> UIImage {
            
            // TODO: Hide toolbar and navbar
            toolBar.isHidden = true
            navBar.isHidden = true
            
            // Render view to an image
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            // TODO: Show toolbar and navbar
            toolBar.isHidden = false
            navBar.isHidden = false
            
            return memedImage
        }
    
    //Share Action
    @IBAction func shareMeme(_ sender: Any) {
        let memeImage = generateMemedImage()
            let uiController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
            present(uiController, animated: true, completion: nil)
            
            uiController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
                
                if completed == true {
                    print ("Success")
                    self.save()
                    self.dismiss(animated: true, completion: nil)
                
                // If the user cancells before sharing, the UI Activity View Controller is dismissed without doing anything.
                }else if completed == false{
                    self.dismiss(animated: true, completion: nil)
                }

            }
        }
    
    
    
    
}





