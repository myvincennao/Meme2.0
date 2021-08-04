//
//  MemeTableViewController.swift
//  MemeProject
//
//  Created by María Yael Vincennao on 30/7/21.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    //Properties
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //memes = appDelegate.memes
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
  }
    
    // MARK: View states
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapToCreate))
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(tapToCreate))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapToCreate))
                         
        navigationItem.title = "Sent Memes"
            
        }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tableView.delegate = self
            tableView.dataSource = self
            self.tableView.reloadData()
            self.tabBarController?.tabBar.isHidden = false
        }

    // MARK: Table view data source - Delegate Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return memes.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewControllerCell")!
            let meme = getMeme(indexPath: indexPath)
        
            cell.textLabel?.text = meme.topText + "..." + meme.bottomText
            cell.imageView?.image = meme.memedImage
            
            // Populate detail text label if using subtitle mode.
            if let detailTextLabel = cell.detailTextLabel {
                detailTextLabel.text = "Top: \(meme.topText) | Bottom: \(meme.bottomText)"
            }
            
            return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailVC = storyboard!.instantiateViewController(withIdentifier: "detailViewController") as! detailViewController
            detailVC.meme = getMeme(indexPath: indexPath)
        
            navigationController!.pushViewController(detailVC, animated: true)
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


