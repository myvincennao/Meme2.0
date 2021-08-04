//
//  detailViewController.swift
//  MemeProject
//
//  Created by María Yael Vincennao on 30/7/21.
//

import UIKit

class detailViewController: UIViewController {
    
    /*var meme: Meme
    
    @IBOutlet weak var m: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.m!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    } */
    
    
    //MARK: Outlets
    @IBOutlet weak var memeMeImageView: UIImageView!
    
    //MARK: Default properties
    var meme: Meme!
    var memeIndex: Int!
    
    //MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        memeMeImageView.image = meme.memedImage
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tabToEdit))
    }
    
    //MARK: Utility Funnctions
    /*@objc private func tabToEdit(){
        
        let memeMeViewController = storyboard?.instantiateViewController(identifier: "ViewControler") as! ViewController
        
        ViewController.isEdit =  true
        ViewController.oldMeme = meme
        ViewController.completionHandler = {(isUpdated) in
            if isUpdated {
                
                let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                
                //update old meme with edited meme
                self.meme = appDelegate.memes[appDelegate.memes.count - 1]
                
                //remove old meme from array
                appDelegate.memes.remove(at: self.memeIndex)
                
                //update index
                self.memeIndex = appDelegate.memes.count - 1
                
                self.updateView()
                
            }
        }
        let navigation = UINavigationController(rootViewController: ViewController)
        
        present(navigation, animated: true, completion: nil)
    }
    
    private func updateView(){
        if let meme = self.meme {
            memeMeImageView.image = meme.memedImage
        }
    }*/
    
}
