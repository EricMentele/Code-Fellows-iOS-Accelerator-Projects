//
//  ViewController.swift
//  Photofied
//
//  Created by Eric Mentele on 1/12/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
 
  let alertController = UIAlertController(title: "Photo Library", message: "Take a look!", preferredStyle: UIAlertControllerStyle.ActionSheet)
  
  
  
  //manually load view  with root view
  override func loadView() {
    
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    rootView.backgroundColor = UIColor.grayColor()
    self.view = rootView
    
    /////////////PHOTO BUTTON///////////////
    let photoButton = UIButton()
    //Turn off auto resizing masks
    photoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    //add buton to root view
    rootView.addSubview(photoButton)
    //set up attributes and behavior
    photoButton.setTitle("Photos", forState: .Normal)
    photoButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    photoButton.addTarget(self, action: "photoButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    
    ////////////////IMAGE VIEW//////////////////
    let viewImage = UIImage(named: "image1.jpeg")
    let imageView = UIImageView()
    rootView.addSubview(imageView)
    imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    imageView.image = viewImage
    
    ///////////////Views////////////////////////
    let views = ["photoButton" : photoButton, "imageView" : imageView]
    self.rootViewConstraints(rootView, forViews: views)
    rootView.insertSubview(photoButton, aboveSubview: imageView)
    
  }//loadView

  override func viewDidLoad() {
    super.viewDidLoad()
    //set up alert controller actions
    let gallery = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
      println("gallery button pressed")
      let galleryVC = PhotoGalleryViewController()
      self.navigationController?.pushViewController(galleryVC, animated: true)
      
    
    }//gallery
    
    self.alertController.addAction(gallery)
    // Do any additional setup after loading the view, typically from a nib.
  }//viewDidLoad
  
  //MARK: Button Selectors
  func photoButtonPressed(sender: UIButton) {
    
    self.presentViewController(self.alertController, animated: true, completion: nil)
    
  }//photoButtonPressed
  
  //MARK: Auto Layout constraints
  func rootViewConstraints (rootView : UIView, forViews views : [String : AnyObject]) {
    
    ///////////////PHOTO BUTTON//////////////
    let photoButton = views["photoButton"] as UIView!
    let photoButtonVertConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[photoButton]-20-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(photoButtonVertConstraint)
    //When adding a constraint with this method remember that it is one constraint.
    let photoButtonHorizConstraint = NSLayoutConstraint(item: photoButton, attribute: .CenterX, relatedBy: NSLayoutRelation.Equal, toItem: rootView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
    //So it needs to be called with this constraint method.
    rootView.addConstraint(photoButtonHorizConstraint)
    
    //////////////////IMAGE VIEW////////////
    let imageView = views["imagView"] as UIView!
    let imageViewConstraintH = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[imageView]-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(imageViewConstraintH)
    let imageViewConstraintV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[imageView]-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(imageViewConstraintV)
    
    
  }//rootViewConstraints


}//ViewController

