//
//  ViewController.swift
//  BananaSample
//
//  Created by gauravkatoch on 7/8/16.
//  Copyright © 2016 gauravkatoch. All rights reserved.
//

import UIKit
import banana

class ViewController: UIViewController {

    @IBOutlet weak var imageScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Calling loadImages function now, to load images ..
        loadImages()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImages() {
        // imageArray can be a array of UIImages
        var imageArray = [UIImage]()
        
        for i in 1...5 {
            imageArray.append(UIImage(named: "Image-"+String(i))!)
        }
        
        let imageScroll = banana( imageScrollView :self.imageScrollView )
        //Load to load images in memory and display them in User Interface
        imageScroll.load(imageArray)
        
        //Call startScroll for autoScrolling. Default scrolling timer is 8 seconds
        imageScroll.startScroll()
        
        
        //Call this function to stop autoScrolling on touch or swipe.
        imageScroll.assignTouchGesture()
    }


}

