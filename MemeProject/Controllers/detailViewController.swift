//
//  detailViewController.swift
//  MemeProject
//
//  Created by María Yael Vincennao on 30/7/21.
//

import UIKit

class detailViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var memeMeImageView: UIImageView!
    
    //MARK: Default properties
    var meme: Meme!
    var memeIndex: Int!
    
    //MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        memeMeImageView.image = meme.memedImage
    }
    
}
