//
//  JXSwipeBetweenViewControllers.swift
//  JXSwipeBetweenViewControllers
//
//  Created by Jonathan Xie on 5/18/15.
//  Copyright (c) 2015 Jonathan Xie. All rights reserved.
//

import UIKit


class JXSwipeBetweenViewControllers: UINavigationController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {

    // Constant to determine which swipable screen to show first
    // 0 = Left Screen, 1 = Middle Screen, 2 = Right Screen
    let STARTING_INDEX:Int = 1;
    
    // Set the current screen to the middle one
    var currentPageIndex:Int!
    
    // The page view controller that holds all the scrollable UIViewcontrollers
    var pageController:UIPageViewController!
    
    // Reference to the UIScrollView in the pageController UIPageViewController above
    var pageScrollView:UIScrollView!
    
    // Holds the UIViewControllers to scroll through
    var viewControllerArray:[UIViewController]!
    
    // Prevents scrolling
    var isPageScrollingFlag:Bool!
    
    // Prevents reloading to maintain state
    var hasAppearedFlag:Bool!
    
    // Buttons in the navigation bar
    var leftButton:UIButton!
    var middleButton:UIButton!
    var rightButton:UIButton!
    
    // Holds the nav buttons above and will set it to: pageController.navigationController.navigationBar.topItem.titleView
    var navigationView:UIView!
    
    
    override func viewWillAppear(animated: Bool) {
        setUpPageViewController()
        setupNavigationButtons()
        hasAppearedFlag = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationBar.translucent = false;
        
        viewControllerArray = [UIViewController]()
        currentPageIndex = STARTING_INDEX; // Set it to the middle index of 1 since we're starting off there
        isPageScrollingFlag = false;
        hasAppearedFlag = false;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpPageViewController() {
        pageController = self.topViewController as! UIPageViewController;
        pageController.delegate = self;
        pageController.dataSource = self;
        
        // Set the initial swipable view controller to the first one to match the currentPageIndex instance variable
        pageController.setViewControllers(
            [viewControllerArray[STARTING_INDEX]], // Set the initial swipable view ot the first one
            direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        syncScrollView();
    }
    
    // Allows us to get information back from the UIScrollView via its delegate methods,
    // namely the coordinate information to shift the navigation buttons left or right
    func syncScrollView() {
        for view in pageController.view.subviews {
            if(view.isKindOfClass(UIScrollView)) {
                self.pageScrollView = view as! UIScrollView
                self.pageScrollView.delegate = self;
            }
        }
    }
    
    
    func setupNavigationButtons() {
        
        //println("self.navigationBar.frame.size.width = \(self.navigationBar.frame.size.width)");
        
        // Create a new UIView that has the weight and height of the navigation bar
        // This will be a subview of the navigation bar
        navigationView = UIView(frame: CGRectMake(0, 0, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height))
        
        // Create some empty buttons
        leftButton = UIButton()
        middleButton = UIButton()
        rightButton = UIButton()
        
        // We need to use these tags
        leftButton.tag = 0;
        middleButton.tag = 1;
        rightButton.tag = 2;
        
        // Set the font colors of the buttons to be black
        leftButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        middleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        rightButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        // Add an action to the buttons to mimic view swiping on tap
        leftButton.addTarget(self, action: "touchedNavBarButton:", forControlEvents: UIControlEvents.TouchUpInside)
        middleButton.addTarget(self, action: "touchedNavBarButton:", forControlEvents: UIControlEvents.TouchUpInside)
        rightButton.addTarget(self, action: "touchedNavBarButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set the font of the buttons to use FontAwesome icons
        leftButton.titleLabel!.font = UIFont.fontAwesomeOfSize(30)
        middleButton.titleLabel!.font = UIFont.fontAwesomeOfSize(30)
        rightButton.titleLabel!.font = UIFont.fontAwesomeOfSize(30)
        
        // Set the icons for the buttons
        leftButton.setTitle(String.fontAwesomeIconWithName(FontAwesome.Cog), forState: UIControlState.Normal)
        middleButton.setTitle(String.fontAwesomeIconWithName(FontAwesome.Bullseye), forState: UIControlState.Normal)
        rightButton.setTitle(String.fontAwesomeIconWithName(FontAwesome.Share), forState: UIControlState.Normal)
        
        // Size the buttons accordingly - should be 30x42
        leftButton.sizeToFit()
        middleButton.sizeToFit()
        rightButton.sizeToFit()
        
        // Add the buttons to the navigation view
        navigationView.addSubview(leftButton)
        navigationView.addSubview(middleButton)
        navigationView.addSubview(rightButton)
        
        // Set the left button to be 10px from the left side
        leftButton.frame = CGRectMake(10, 0, leftButton.frame.size.width, leftButton.frame.size.height);
        
        // Set the middle button to be in the middle of the view
        middleButton.frame = CGRectMake(
            self.navigationBar.center.x - (middleButton.frame.size.width/2),
            0,
            middleButton.frame.size.width,
            middleButton.frame.size.height)
        
        // Set the right button to be 10px from the right side
        rightButton.frame = CGRectMake(
            (self.navigationBar.frame.size.width as CGFloat) - rightButton.frame.size.width - 10,
            0,
            rightButton.frame.size.width,
            rightButton.frame.size.height)

        // Set the navigation view to the subview of the navigation bar
        navigationBar.addSubview(navigationView)
        

        /*
        NSLog("leftButton.frame = (%f, %f, %f, %f)", leftButton.frame.origin.x, leftButton.frame.origin.y, leftButton.frame.size.width, leftButton.frame.size.height);
        NSLog("middleButton.frame = (%f, %f, %f, %f)", middleButton.frame.origin.x, middleButton.frame.origin.y, middleButton.frame.size.width, middleButton.frame.size.height);
        NSLog("rightButton.frame = (%f, %f, %f, %f)", rightButton.frame.origin.x, rightButton.frame.origin.y, rightButton.frame.size.width, rightButton.frame.size.height);
        */
        
        
        
    }
    
    // Called when the navigation buttons are touched
    func touchedNavBarButton(button:UIButton) {
        
        if (!self.isPageScrollingFlag) {
        
            print("self.currentPageIndex = \(self.currentPageIndex)")
            
            let tempIndex = self.currentPageIndex

            // Check to see if you're going from left -> right or right -> left
            if (button.tag > tempIndex) {
                
                //println("Going forward since button.tag = \(button.tag)")

                //scroll through all the objects between the two points
                var i:Int = tempIndex;
                for i = tempIndex+1; i <= button.tag; i++ {

                    //println("i in forward for loop = \(i) and button.tag = \(button.tag)")
                    
                    pageController.setViewControllers(
                        [viewControllerArray[i]],
                        direction: UIPageViewControllerNavigationDirection.Forward,
                        animated: true,
                        completion: {[unowned self] (complete:Bool) -> Void in
                            
                            if(complete) {
                                //println("i in complete forward for loop = \(i) and button.tag = \(button.tag)")
                                self.updateCurrentPageIndex(i-1) // I had an off by 1 error here for some reason
                            }
                        }
                    )
                }
            }
            
            else if (button.tag < tempIndex) {
                
                //println("Going reverse since button.tag = \(button.tag)")
                var i:Int = tempIndex;
                for i = tempIndex-1; i >= button.tag; i-- {
                    //println("i in reverse for loop = \(i) and button.tag = \(button.tag)")
                    pageController.setViewControllers([viewControllerArray[i]],
                        direction: UIPageViewControllerNavigationDirection.Reverse,
                        animated: true,
                        completion: {[unowned self] (complete:Bool) -> Void in
                            if(complete) {
                                //println("i in complete reverse for loop = \(i) and button.tag = \(button.tag)")
                                self.updateCurrentPageIndex(i+1) // I had an off by 1 error here for some reason
                            }
                        }
                    )
                }
            }
        }
    }
    
    // Make sure to update the current index after swiping or touching the button is done
    func updateCurrentPageIndex(newIndex:Int) {
        print("updateCurrentPagIndex: Index = \(newIndex)");
        self.currentPageIndex = newIndex;
    }
    
    
    // MARK: UIScrollView Delegate Methods
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Consider views in this order: View 1, View 2, View 3
        // View 1 is on the left
        // View 2 is in the middle
        // View 3 is on the right
        // Starting point here in this case is View 1
        // xFromCenter is positive for swiping your thumb right to left going the View 1 to View 0
        // xFromCenter is negative for swiping your thumb left to right going from View 1 to View 2
        let xFromCenter:CGFloat = self.view.frame.size.width - scrollView.contentOffset.x;
        
        print("xFromCenter = \(xFromCenter)")
        print("scrollView.contentOffset.x = \(scrollView.contentOffset.x)")
        
        if (xFromCenter == 0) {
            return;
        }

        let distanceBetweenButtons:CGFloat = middleButton.frame.origin.x - leftButton.frame.origin.x
        
        let distanceToShift:CGFloat = distanceBetweenButtons/self.view.frame.size.width
        
        //The xCoord for shifting the navigation view based on what
        var xCoor:CGFloat = 0;
        
        if (self.currentPageIndex == 0) {
            xCoor = distanceBetweenButtons;
        } else if (self.currentPageIndex == 1) {
            xCoor = 0;
        } else if (self.currentPageIndex == 2) {
            xCoor = -distanceBetweenButtons;
        }
        
        navigationView.frame = CGRectMake(xCoor + xFromCenter*distanceToShift, navigationView.frame.origin.y, navigationView.frame.size.width, navigationView.frame.size.height);

    }
    

    // MARK: UIPageViewController Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfController(viewController)
        
        if ((index == NSNotFound) || (index == 0)) {
            return nil;
        }
        
        index--;
        
        return viewControllerArray[index];
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfController(viewController)
        
        if (index == NSNotFound) {
            return nil;
        }
        
        index++;
        
        if (index == viewControllerArray.count) {
            return nil;
        }
        
        return viewControllerArray[index];
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if(completed) {
            if let vc = pageViewController.viewControllers!.last {
                currentPageIndex = indexOfController(vc)
            }
        }
    }
    
    
    
    // Checks to see which item we are currently looking at from the array of view controllers.
    func indexOfController(viewController:UIViewController) -> Int {
        for i in 0..<viewControllerArray.count {
            if viewController == viewControllerArray[i] {
                print("indexOfController = \(i)")
                return i;
            }
        }
        return NSNotFound;
    }
    
    // MARK: Scroll View Delegate Functions
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isPageScrollingFlag = false
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        isPageScrollingFlag = false
    }
    
}
