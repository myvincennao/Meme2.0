//
//  MemeCollectionViewController.swift
//  MemeProject
//
//  Created by María Yael Vincennao on 30/7/21.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    //Properties
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    //Outlets

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //View States
    override func viewDidLoad() {
           super.viewDidLoad()
           let space:CGFloat = 3.0
           let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
           flowLayout.minimumInteritemSpacing = space
           flowLayout.minimumLineSpacing = space
           flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapToCreate))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapToCreate))
                         
        navigationItem.title = "Sent Memes"
                
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView!.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //Set Collection DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
      }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    //Set Cell View
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewControllerCell", for: indexPath) as! MemeCollectionViewControllerCell
        let myMeme = getMeme(indexPath: indexPath)

        // Set the meme
        //cell.memeTopTextCell.text = myMeme.topText
        //cell.memeBottomTextCell.text = myMeme.bottomText
        cell.memeImageCell?.image = myMeme.memedImage

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {

        let detailVController = self.storyboard!.instantiateViewController(withIdentifier: "detailViewController") as! detailViewController
                //Populate view controller with data from the selected item
        detailVController.meme = getMeme(indexPath: indexPath)
                // Present the view controller using navigation
                navigationController!.pushViewController(detailVController, animated: true)
            }
    
    func getMeme(indexPath: IndexPath) -> Meme {
            return memes[(indexPath as NSIndexPath).row]
        }
    
    //MARK: Utility Funtion
        @objc private func tapToCreate(){
            
            let controller = (storyboard?.instantiateViewController(identifier: "ViewController"))!
                           present(controller, animated: true, completion: nil)
                       }
}
