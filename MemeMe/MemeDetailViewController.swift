//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jericho on 5/27/15.
//  Copyright (c) 2015 Jericho. All rights reserved.
//

import UIKit
import Foundation

class MemeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var image: UIImageView!
    
    var memes : Meme!
    
    override func viewDidLoad() {
        navigationController!.hidesBarsOnTap = true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        image.image = memes.memedImage
        
        // Background like the Photos app
        view!.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController!.hidesBarsOnTap = false
    }
}
