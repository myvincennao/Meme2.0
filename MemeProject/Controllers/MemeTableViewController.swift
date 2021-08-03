//
//  MemeTableViewController.swift
//  MemeProject
//
//  Created by María Yael Vincennao on 30/7/21.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //memes = appDelegate.memes
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
  }
}
