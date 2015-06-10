//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Jericho on 5/26/15.
//  Copyright (c) 2015 Jericho. All rights reserved.
//


import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    var memeObj = [Meme]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memeObj = appDelegate.memeObj
        
       collectionView!.backgroundColor = UIColor.whiteColor()
        
        // Reload collection data
        collectionView!.reloadData()
        
    }
    
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addNewMeme", sender: sender)
    }
    
    
    //find the number of rows
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.memeObj.count
        
    }
    
    
    //dequeue cell at index path and access model object for a given row
    //reuse-identifier is "MemeCollectionCell"
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! CustomMemeCell
        let MemeForRow = self.memeObj[indexPath.row]
        
        cell.memedImage.image = MemeForRow.memedImage
                return cell

    }

    //present a detail view of the selected meme
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        detailController.memes = memeObj[indexPath.row]
        
        hidesBottomBarWhenPushed = true
        navigationController!.pushViewController(detailController, animated: true)
        hidesBottomBarWhenPushed = false
    }

    
}
