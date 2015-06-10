//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Jericho on 5/27/15.
//  Copyright (c) 2015 Jericho. All rights reserved.
//


import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate {
    
 var memeObj = [Meme]()
    
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memeObj = appDelegate.memeObj
        
        
        // Reload table data
        tableView?.reloadData()
        tableView?.rowHeight = 100

    }
    
    
    

    // go to the MemeEditorViewController if no memes are saved...
    override func viewDidAppear(animated: Bool) {
                
        if memeObj.count == 0 {
            let memeEditorNavigationController = storyboard!.instantiateViewControllerWithIdentifier("memeEditorNavController") as! UINavigationController
            presentViewController(memeEditorNavigationController, animated: true, completion: nil)
        }
    }

    
    
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addNewMeme", sender: sender)
    }
    
    
    
    
    
    
    //find the number of rows 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memeObj.count
  
    }
    
    //dequeue cell at index path and access model object for a given row
    //reuse-identifier is "MemeCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        var MemeForRow = self.memeObj[indexPath.row]
        cell.imageView?.image = MemeForRow.memedImage
        cell.textLabel?.text = MemeForRow.topText + " ... " + MemeForRow.bottomText
      //  cell.detailTextLabel?.text = "..." + MemeForRow.bottomText
        
        return cell
        
    }
    
   //present a detail view of the selected meme
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.memes = memeObj[indexPath.row]
        
        hidesBottomBarWhenPushed = true
        navigationController!.pushViewController(detailController, animated: true)
        hidesBottomBarWhenPushed = false

        
    }
    
    
}
