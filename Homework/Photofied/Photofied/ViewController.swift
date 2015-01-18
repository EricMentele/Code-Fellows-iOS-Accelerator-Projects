//
//  ViewController.swift
//  Photofied
//
//  Created by Eric Mentele on 1/12/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//Inspect image meta data and change the orientation of the image.

import UIKit
import Social

class ViewController: UIViewController, ImageSelectedProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  let alertController = UIAlertController(title: NSLocalizedString("Image Options", comment:"This is the title of the alert controller for images."), message: NSLocalizedString("Choose an image option.", comment:"This is the comment section for the image options alert controller."), preferredStyle: UIAlertControllerStyle.ActionSheet)
  let mainImageView = UIImageView()
  var collectionView: UICollectionView!
  var collectionViewVAnimateConstraint: NSLayoutConstraint!
  var mainImageViewSizeAnimateConstraintH: [NSLayoutConstraint]!
  var mainImageViewSizeAnimateConstraintV: [NSLayoutConstraint]!
  var mainImageViewPosAnimationConstraintV: NSLayoutConstraint!
  var originalThumbnail : UIImage!
  var filterTypes = [String]()
  var imageQueue = NSOperationQueue()
  var gpuContext : CIContext!
  var thumbnails = [Thumbnail]()
  var originImage: UIImage?//Jeff Chavez code contribution
  var toggleHelper = 0
  let photoButton = UIButton()
  var navDone : UIBarButtonItem!
  var navShare : UIBarButtonItem!
  
  
  //load view  with root view
  override func loadView() {
    
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    rootView.backgroundColor = UIColor.blackColor()
    self.view = rootView
    
    //MARK: BUTTONS
    //MARK: Photo button
    //Turn off auto resizing masks
    self.photoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    //add buton to root view
    mainImageView.addSubview(photoButton)
    //set up attributes and behavior
    self.photoButton.setTitle(NSLocalizedString("Images", comment:"This is the title of the images button for presenting image options."), forState: .Normal)
    self.photoButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    self.photoButton.backgroundColor = UIColor.blackColor()
    self.photoButton.addTarget(self, action: "photoButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    //MARK: VIEWS
    //MARK:Nav spacer
    //settings
    var navSpacer = UIImageView()
    navSpacer.setTranslatesAutoresizingMaskIntoConstraints(false)
    rootView.addSubview(navSpacer)
    //MARK:Main Image View
    //gesture recognizers
    let doubleTap = UITapGestureRecognizer(target: self, action: "tapped:")
    let singleTap = UITapGestureRecognizer(target: self, action: "tap:")
    singleTap.numberOfTapsRequired = 1
    doubleTap.numberOfTapsRequired = 2
    self.mainImageView.userInteractionEnabled = true
    self.mainImageView.addGestureRecognizer(doubleTap)
    self.mainImageView.addGestureRecognizer(singleTap)
    //place holder image
    var viewImage = UIImage(named: "Image-1")
    self.mainImageView.image = viewImage!
    //settings
    rootView.addSubview(self.mainImageView)
    rootView.insertSubview(photoButton, aboveSubview: self.mainImageView)
    self.mainImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    //MARK:Collection view
    //settings
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout)
    collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
    collectionViewFlowLayout.scrollDirection = .Horizontal
    self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
    rootView.addSubview(self.collectionView)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "FilterCell")
    //MARK:Views for constraints
    let views = ["photoButton" : photoButton, "imageView" : self.mainImageView, "collectionView" : collectionView, "navSpacer" : navSpacer]
    self.rootViewConstraints(rootView, forViews: views)
  }//loadView
  

  override func viewDidLoad() {
    
    super.viewDidLoad()
    //MARK: CONTROLLER ACTIONS

    //MARK:Gallery Action
    let gallery = UIAlertAction(title: NSLocalizedString("Gallery", comment:"This is the title of the alert controller images gallery option."), style: UIAlertActionStyle.Default) { (action) -> Void in
      
      println("gallery button pressed")
      let galleryVC = PhotoGalleryViewController()
      galleryVC.delegate = self
      self.navigationController?.pushViewController(galleryVC, animated: true)
    }//gallery action
    self.alertController.addAction(gallery)
    
    //MARK:Filter action
    let filter = UIAlertAction(title: NSLocalizedString("Filter Image", comment:"This is the title of the alert controller filter image option."), style: UIAlertActionStyle.Default) { (action) -> Void in
      
      //animate image view size
      self.resizer(vCArray: self.mainImageViewSizeAnimateConstraintV, hCArray: self.mainImageViewSizeAnimateConstraintH, vcs: 120, hcs: 20, vAnim: 20)
      
      //animate collection view when filter button is pressed.
      self.collectionViewVAnimateConstraint.constant = 5
      UIView.animateWithDuration(0.4, animations: { () -> Void in
        
        self.view.layoutIfNeeded()
      })//animation
      
      //filter nav done button
      let navDone = UIBarButtonItem(title: NSLocalizedString("Done", comment:"This is the title of the navigation bar done button."), style: UIBarButtonItemStyle.Done, target: self, action: "donePressed")
      self.navigationItem.rightBarButtonItem = navDone
    }//filter action
    self.alertController.addAction(filter)
    
    //MARK:Camera action
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      
      let cameraOption = UIAlertAction(title: NSLocalizedString("Camera", comment:"This is the title of the alert controller camera option."), style: .Default, handler: { (action) -> Void in
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
      })//cameraOption
      self.alertController.addAction(cameraOption)
    }//UIImagePickerController
    
    //MARK:Photo library action
    let photo = UIAlertAction(title: NSLocalizedString("Photo Library", comment:"This is the title of the alert controller photo library option."), style: .Default) { (action) -> Void in
      
      let photosVC = PhotosViewController()
      photosVC.destinationImageSize = self.mainImageView.frame.size
      photosVC.delegate = self
      self.navigationController?.pushViewController(photosVC, animated: true)
    }
    self.alertController.addAction(photo)
    //add nav bar share button
    self.navShare = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "sharePressed")
    self.navigationItem.rightBarButtonItem = self.navShare
    //core image processing
    let options = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    self.gpuContext = CIContext(EAGLContext: eaglContext, options: options)
    self.setupThumbnails()
  }//viewDidLoad
  
  
  override func viewDidAppear(animated: Bool) {
    
    self.originImage = self.mainImageView.image
  }//Jeff Chavez code contribution
  
  
  //MARK: Set up filter thumbnails
  func setupThumbnails() {
    
    self.filterTypes = ["CIColorInvert","CIPhotoEffectInstant","CISepiaTone","CIPhotoEffectChrome","CIPhotoEffectNoir","CIDotScreen","CIHatchedScreen"]
    for type in self.filterTypes {
      
      let thumbnail = Thumbnail(filterType: type, operationQueue: self.imageQueue, context: self.gpuContext)
      self.thumbnails.append(thumbnail)
    }//for in
  }//setupThumbnails
  
  
  //MARK: Image Selected Delegate
  func controllerDidSelectImage(image : UIImage) {
    
    self.mainImageView.image = image
    generateThumbnail(image)
    
    for thumbnail in self.thumbnails {
      
      thumbnail.originImage = self.originalThumbnail
      thumbnail.filteredImage = nil
    }//for thumbnail in thumbnails
    self.collectionView.reloadData()
  }//controllerDidSelectImage
  

  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    
    let image = info[UIImagePickerControllerEditedImage] as? UIImage
    self.controllerDidSelectImage(image!)
    picker.dismissViewControllerAnimated(true, completion: nil)
  }//imagePickerController
  
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    
    picker.dismissViewControllerAnimated(true, completion: nil)
  }//imagePickerControllerDidCancel
  
  
  //MARK: BUTTON SELECTORS
  func photoButtonPressed(sender: UIButton) {
    
    self.presentViewController(self.alertController, animated: true, completion: nil)
    
  }//photoButtonPressed
  
  
  func generateThumbnail(originImage: UIImage) {
    
    let size = CGSize(width: 100, height: 100)
    UIGraphicsBeginImageContext(size)
    originImage.drawInRect(CGRect(x: 0, y: 0, width: 100, height: 100))
    self.originalThumbnail = UIGraphicsGetImageFromCurrentImageContext()
  }//genreateThumbnail
  
  
  func donePressed() {
    
    self.collectionViewVAnimateConstraint.constant = -120
    self.resizer(vCArray:self.mainImageViewSizeAnimateConstraintH,hCArray: self.mainImageViewSizeAnimateConstraintV,vcs: 0,hcs: 0, vAnim: 0)

    UIView.animateWithDuration(0.4, animations: { () -> Void in
      
      self.view.layoutIfNeeded()
    })//animatedWithDuration
    self.navigationItem.rightBarButtonItem = self.navShare
  }//donePressed
  
  
  func sharePressed() {
    
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
      
      let compViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
      compViewController.addImage(self.mainImageView.image)
      self.presentViewController(compViewController, animated: true, completion: nil)
      
    } else {
      
      let twitterErrorController = UIAlertController(title: "Error", message: "Twitter unavailable. Try again later.", preferredStyle: .Alert)
      let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
      twitterErrorController.addAction(okButton)
      self.presentViewController(twitterErrorController, animated: true, completion: nil)
    }//if else
  }//sharePressed
  
  
  //MARK: UICOLLECTION VIEW DATA SOURCE & DELEGATE METHODS
  //MARK: Cell for Item
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterCell", forIndexPath: indexPath) as GalleryCell
    let thumbnail = self.thumbnails[indexPath.row]
    
    if thumbnail.originImage != nil {
      
      if thumbnail.filteredImage == nil {
        
        thumbnail.generateFilteredImage(thumbnail.originImage!, filterType: thumbnail.filterType)
        cell.imageView.image = thumbnail.filteredImage!
      }//if thumbnail origin
    }//if thumbnail filtered
    return cell
  }//collectionViewCell
  
  
  //MARK: Number of items in section
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return self.thumbnails.count
  }//number OfItems
  
  
  //MARK: Did Select Item
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    let filterCarrier = thumbnails[indexPath.row] as Thumbnail
        filterCarrier.generateFilteredImage(self.originImage!, filterType: filterCarrier.filterType)

    self.mainImageView.image = filterCarrier.filteredImage
  }//didSelectItem
  
  
  //MARK: GESTURE RECOGNIZER FUNCS
  //MARK:Double tap
  func tapped(sender: UITapGestureRecognizer) {
    
    self.resizer(vCArray: self.mainImageViewSizeAnimateConstraintV, hCArray: self.mainImageViewSizeAnimateConstraintH, vcs: 120, hcs: 20, vAnim: 20)
    self.collectionViewVAnimateConstraint.constant = 5
    
    //animate collection view when mainImageView is double tapped.
    UIView.animateWithDuration(0.4, animations: { () -> Void in
      
      self.view.layoutIfNeeded()
    })//animateWithDuration
    let navDone = UIBarButtonItem(title: NSLocalizedString("Done", comment:"This is the title of the navigation bar done button."), style: UIBarButtonItemStyle.Done, target: self, action: "donePressed")
    self.navigationItem.rightBarButtonItem = navDone
  }//tapped
  
  
  //MARK: Single tap toggle
  func tap(sender: UITapGestureRecognizer) {
    
    toggleHelper++
    if self.toggleHelper % 2 == 0 {
      
      self.photoButton.hidden = true
      println("TAP!")
      
    } else {
      
      self.photoButton.hidden = false
    }//if else
  }//tap :Duncan Marsh helped me figure this out
  
  
  //MARK: Constraints modifier
  func resizer(#vCArray: [NSLayoutConstraint], hCArray: [NSLayoutConstraint], vcs: CGFloat, hcs: CGFloat, vAnim: CGFloat) {
    
    for cs in vCArray {
      
      cs.constant = vcs
      
      if cs.firstItem.isEqual(self.mainImageView) {
        
        if cs.firstAttribute == NSLayoutAttribute.Top {
  
          cs.constant = vAnim
        }//if
      }//if
    }//for in
    
    for cs in hCArray {
      
      cs.constant = hcs
    }//for in
  }//Adam and Brad helped me figure out how to do this.
  
  
  //MARK: AUTO LAYOUT CONSTRAINTS
  func rootViewConstraints (rootView : UIView, forViews views : [String : AnyObject]) {
    
    //MARK:Photo Button
    let photoButton = views["photoButton"] as UIView!
    let photoButtonVertConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[photoButton]-20-|", options: nil, metrics: nil, views: views)
    //When adding a constraint with this method remember that it is one constraint.
    let photoButtonHorizConstraint = NSLayoutConstraint(item: photoButton, attribute: .CenterX, relatedBy: NSLayoutRelation.Equal, toItem: rootView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
    //So it needs to be called with this constraint method.
    rootView.addConstraint(photoButtonHorizConstraint)
    rootView.addConstraints(photoButtonVertConstraint)
    //MARK:Image View
    let imageView = views["imageView"] as UIView!
    let imageViewConstraintH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[imageView]-|", options: nil, metrics: nil, views: views)
    let imageViewConstraintV = NSLayoutConstraint.constraintsWithVisualFormat("V:[navSpacer]-[imageView]-8-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(imageViewConstraintH)
    rootView.addConstraints(imageViewConstraintV)
    self.mainImageViewSizeAnimateConstraintH = imageViewConstraintH as [NSLayoutConstraint]
    self.mainImageViewSizeAnimateConstraintV = imageViewConstraintV as [NSLayoutConstraint]
    //MARK: Nav Spacer
    let navSpacer = views["navSpacer"] as UIImageView!
    let navSpacerConstraintV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[navSpacer]", options: nil, metrics: nil, views: views)
    let navSpacerConstraintHeight = NSLayoutConstraint.constraintsWithVisualFormat("V:[navSpacer(72)]", options: nil, metrics: nil, views: views)
    rootView.addConstraints(navSpacerConstraintHeight)
    rootView.addConstraints(navSpacerConstraintV)
    //MARK:Collection VIew
    var collectionView = views["collectionView"] as UICollectionView!
    let collectionViewConstraintH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[collectionView]-|", options: nil, metrics: nil, views: views)
    let collectionViewConstraintV = NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView]-(-120)-|", options: nil , metrics: nil, views: views)
    let collectionViewConstraintHeight = NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView(100)]", options: nil, metrics: nil, views: views)
    rootView.addConstraints(collectionViewConstraintH)
    rootView.addConstraints(collectionViewConstraintV)
    rootView.addConstraints(collectionViewConstraintHeight)
    self.collectionViewVAnimateConstraint = collectionViewConstraintV.first as NSLayoutConstraint
  }//rootViewConstraints
}//ViewController

