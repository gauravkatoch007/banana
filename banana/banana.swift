//
//  banana.swift
//  banana
//
//  Created by cdp  on 11/9/15.
//  Copyright © 2015 Katoch. All rights reserved.
//

import Foundation
import UIKit

public class banana : UIViewController, UIScrollViewDelegate {
    
    var imagePageControl: UIPageControl?
    var imageScrollView: UIScrollView!
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    var timer : Timer = Timer()
    var imagesLoaded = false
    public var autoScrollTime : Double = 8
    public var imagesToLoadInMemory = 4
    
    public convenience init ( imageScrollView : UIScrollView, imagePageControl : UIPageControl? = nil){
        self.init()
        self.imageScrollView = imageScrollView
        self.imageScrollView.delegate = self
        self.imagePageControl = imagePageControl
        
    }

//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    @nonobjc public func load(imagesArrayInput : [String]){
        let priority = DispatchQueue.GlobalQueuePriority.default
        DispatchQueue.global(priority: priority).async() {
            // do some task
            self.getScrollViewImages(imagesArray: imagesArrayInput)
            DispatchQueue.main.async {
                self.loadScrollViewImages()
            }
        }
    }
    
    @nonobjc public func load(imagesArrayInput : [UIImage]){
        let priority = DispatchQueue.GlobalQueuePriority.default
        DispatchQueue.global(priority: priority).async() {
            // do some task
            self.getScrollViewImages(imagesArray: imagesArrayInput)
            DispatchQueue.main.async {
                // update some UI
                self.loadScrollViewImages()
            }
        }
    }
    
    public func startScroll(){
        timer = Timer.scheduledTimer(timeInterval: autoScrollTime, target: self, selector: "autoScrollImage", userInfo: nil, repeats: true)
    }
    
    public func stopScroll(){
        timer.invalidate()
    }
    
    
    
    @nonobjc func getScrollViewImages(imagesArray : [String]){
        for image in imagesArray {
            if let url = NSURL(string: image) {
                if let data = NSData(contentsOf: url as URL){
                    pageImages.append(UIImage(data: data as Data)!)
                }
            }
        }
    }
    
    @nonobjc func getScrollViewImages(imagesArray : [UIImage]){
        for image in imagesArray {
            pageImages.append(image)
        }
    }
    
    func loadScrollViewImages(){
        let pageCount = pageImages.count
        
        // 2
        if imagePageControl != nil {
            imagePageControl!.currentPage = 1
            imagePageControl!.numberOfPages = pageCount
        }
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 4
        let pagesScrollViewSize = imageScrollView.frame.size
        imageScrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        // 5
        self.imagesLoaded = true
        loadVisiblePages()
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // 1
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            // 2
            var frame = imageScrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            //            frame = CGRectInset(frame, 10.0, 0.0)
            
            // 3
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .scaleAspectFit
            newPageView.frame = frame
            imageScrollView.addSubview(newPageView)
            
            // 4
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    public func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = imageScrollView.frame.size.width
        var page = Int(floor((imageScrollView.contentOffset.x * 1.0 + pageWidth) / (pageWidth * 1.0))) - 1
        if page >= pageImages.count {
            page = 0
        }
        // Update the page control
        if imagePageControl != nil {
            imagePageControl!.currentPage = page
        }
        
        // Work out which pages you want to load
        let firstPage = page - ( imagesToLoadInMemory / 2 )
        let lastPage = page + ( imagesToLoadInMemory / 2 )
        
        print("First Page ="+String(firstPage))
        print("Last Page ="+String(lastPage))
        
        // Purge anything before the first page
        for var index in 0 ..< firstPage {
            purgePage(page: index)
            index += 1
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(page: index)
        }
        
        // Purge anything after the last page
        for var index in lastPage+1 ..< pageImages.count {
            purgePage(page: index)
            index += 1
        }
    }
    
    
    @objc public func autoScrollImage (){
        
        let pageWidth:CGFloat = self.imageScrollView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(pageImages.count)
        let contentOffset:CGFloat = self.imageScrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth{
            slideToX = 0
        }
        
        self.imageScrollView.scrollRectToVisible(CGRect(x: slideToX, y: 0, width: pageWidth, height: self.imageScrollView.frame.height), animated: true)
    }
    
    public func assignTouchGesture(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewTapped:")
        
        tapRecognizer.numberOfTapsRequired = 1
        //        tapRecognizer.numberOfTouchesRequired = 1
        self.imageScrollView.addGestureRecognizer(tapRecognizer)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.imageScrollView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.imageScrollView.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.imageScrollView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.imageScrollView.addGestureRecognizer(swipeDown)
    }
    @objc public func scrollViewTapped(recognizer: UITapGestureRecognizer){
        timer.invalidate()
        if self.imagesLoaded == true {
            loadVisiblePages()
        }
    }
    
    @objc public func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        timer.invalidate()
        if self.imagesLoaded == true {
            loadVisiblePages()
        }
    }
    
    @objc public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if self.imagesLoaded == true {
            loadVisiblePages()
        }
    }
    
    @objc public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if self.imagesLoaded == true {
            loadVisiblePages()
        }
    }

}
