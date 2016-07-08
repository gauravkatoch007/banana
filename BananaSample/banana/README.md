Banana - ImageSlider for Swift
=========================

![Swift 2.0](https://img.shields.io/badge/Swift-2.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/JLToast.svg?style=flat)](http://cocoapods.org/?q=name%3AJLToast%20author%3Adevxoul)

Image slider with very simple interface.


At a Glance
-----------

```swift
@IBOutlet weak var imageScrollView: UIScrollView!
// Here imageArray can be a string array of Image URLs 
var imageArray = [String]()

//or imageArray can be a array of UIImages
var imageArray = [UIImage]()

var imageScroll = banana( imageScrollView :self.imageScrollView )
//Load to load images in memory and display them in User Interface
imageScroll!.load(imageArray)

//Call startScroll for autoScrolling. Default scrolling timer is 8 seconds
imageScroll!.startScroll()

//Call this function to stop autoScrolling on touch or swipe.
imageScroll!.assignTouchGesture()
```


Features
--------

- **Objective-C Compatible**: import `banana.h` to use Banana in Objective-C.
- **Customizable**: see [Advanced] section.


Installation
------------

    
- **For iOS 8+ projects with [Carthage](https://github.com/Carthage/Carthage):**

    ```
    github "gauravkatoch007/banana" ~> 1.0
    ```
    
- **For iOS 7 projects:** I recommend you to try [CocoaSeeds](https://github.com/devxoul/CocoaSeeds), which uses source code instead of dynamic frameworks. Sample Seedfile:

    ```ruby
    github 'gauravkatoch007/banana', '1', :files => 'banana/*.{swift,h}'
    ```


Objective-C
-----------

banana is compatible with Objective-C. What you need to do is to import a auto-generated header file:

```objc
#import <banana/banana.h>
```


Setting AutoScroll Delay and Caching threshold
--------------------------

```swift
var imageScroll = banana( imageScrollView :self.imageScrollView )
imageScroll.autoScrollTime = 2 // < Any integer value in seconds >

//banana library doesn't load all images at once in memory, but only some images (one in display and one or two before and after are loaded). Images are loaded and unloaded dynamically. Default is 4
imageScoll.imagesToLoadInMemory = 10
```



#### Advanced

```swift
//You can also assign a UIPageControl.
@IBOutlet weak var imageScrollView: UIScrollView!
@IBOutlet weak var imagePageControl: UIPageControl!

var imageScroll = banana( imageScrollView :self.imageScrollView, imagePageControl : self.imagePageControl )
self.imageScroll!.load(imageArray)
self.imageScroll!.startScroll()
self.imageScroll!.assignTouchGesture()
```

Screenshots
-----------

<ToDo>


License
-------

banana is released under the MIT license. See [LICENSE](LICENSE) file for more info.
