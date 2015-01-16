//
//  ViewController.swift
//  Photofied
//
//  Created by Eric Mentele on 1/12/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, ImageSelectedProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
 
  let alertController = UIAlertController(title: "Photo Library", message: "Take a look!", preferredStyle: UIAlertControllerStyle.ActionSheet)
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
  
  var navDone : UIBarButtonItem!
  var navShare : UIBarButtonItem!
  
  
  //manually load view  with root view
  override func loadView() {
    
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    rootView.backgroundColor = UIColor.blackColor()
    self.view = rootView
    
    /////////////BUTTONS///////////////
    let photoButton = UIButton()
    //Turn off auto resizing masks
    photoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    //add buton to root view
    rootView.addSubview(photoButton)
    //set up attributes and behavior
    photoButton.setTitle("Photos", forState: .Normal)
    photoButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    photoButton.backgroundColor = UIColor.blackColor()
    photoButton.addTarget(self, action: "photoButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    
    
    ////////////////VIEWS//////////////////
    //nav spacer
    var navSpacer = UIImageView()
    navSpacer.setTranslatesAutoresizingMaskIntoConstraints(false)
    rootView.addSubview(navSpacer)
    //main view image
    var viewImage = UIImage(named: "image1.jpeg")
    rootView.addSubview(self.mainImageView)
    self.mainImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.mainImageView.image = viewImage!
    //self.mainImageView.userInteractionEnabled = true
    //let singleTap = UITapGestureRecognizer(target: self.mainImageView, action: "tapped")
    //singleTap.numberOfTapsRequired = 1
    //self.mainImageView.addGestureRecognizer(singleTap)
    //collection view
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout)
    collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
    collectionViewFlowLayout.scrollDirection = .Horizontal
    self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
    rootView.addSubview(self.collectionView)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "FilterCell")
    //view s and constraints
    let views = ["photoButton" : photoButton, "imageView" : self.mainImageView, "collectionView" : collectionView, "navSpacer" : navSpacer]
    self.rootViewConstraints(rootView, forViews: views)
    rootView.insertSubview(photoButton, aboveSubview: self.mainImageView)
    //self.tapped(rootView, button: photoButton)
    
  }//loadView

  override func viewDidLoad() {
    super.viewDidLoad()
    //MARK: Controller Actions
    
    //main view action
    
    
    //gallery action
    let gallery = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
      println("gallery button pressed")
      let galleryVC = PhotoGalleryViewController()
      galleryVC.delegate = self
      self.navigationController?.pushViewController(galleryVC, animated: true)
    }//gallery action
    self.alertController.addAction(gallery)
    
    //MARK: filter action
    let filter = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default) { (action) -> Void in
      println("filter button pressed")
      //animate image view size
      self.resizer(vCArray: self.mainImageViewSizeAnimateConstraintV, hCArray: self.mainImageViewSizeAnimateConstraintH, vcs: 120, hcs: 20, vAnim: 20)
      //self.mainImageViewPosAnimationConstraintV.constant = 10
      
      //animate collection view when filter button is pressed.
      self.collectionViewVAnimateConstraint.constant = 5
      UIView.animateWithDuration(0.4, animations: { () -> Void in
        self.view.layoutIfNeeded()
      })
      //filter nav done button
      let navDone = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePressed")
      self.navigationItem.rightBarButtonItem = navDone
    }//filter action
    self.alertController.addAction(filter)
    
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      let cameraOption = UIAlertAction(title: "Camera", style: .Default, handler: { (action) -> Void in
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
      })
      self.alertController.addAction(cameraOption)
    }
    
    let photo = UIAlertAction(title: "Photo", style: .Default) { (action) -> Void in
      let photosVC = PhotosViewController()
      photosVC.destinationImageSize = self.mainImageView.frame.size
      photosVC.delegate = self
      self.navigationController?.pushViewController(photosVC, animated: true)
    }
    self.alertController.addAction(photo)
    
    self.navShare = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "sharePressed")
    self.navigationItem.rightBarButtonItem = self.navShare

    let options = [kCIContextWorkingColorSpace : NSNull()]
    let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
    self.gpuContext = CIContext(EAGLContext: eaglContext, options: options)
    self.setupThumbnails()

    // Do any additional setup after loading the view, typically from a nib.
  }//viewDidLoad
  
  //func tapped(view: UIView!, button: UIButton) {
    
    //view.bringSubviewToFront(button)
    
  //}
  
  func setupThumbnails() {
    
    self.filterTypes = ["CIColorInvert","CIPhotoEffectInstant","CISepiaTone","CIPhotoEffectChrome","CIPhotoEffectNoir"]
    for type in self.filterTypes {
      let thumbnail = Thumbnail(filterType: type, operationQueue: self.imageQueue, context: self.gpuContext)
      self.thumbnails.append(thumbnail)
    }//for in
  }//setupThumbnails
  
  //MARK: Image selected delegate
  func controllerDidSelectImage(image : UIImage) {
    println("Image selected")
    self.mainImageView.image = image
    generateThumbnail(image)
    
    for thumbnail in self.thumbnails {
      thumbnail.originImage = self.originalThumbnail
      thumbnail.filteredImage = nil
    }
    self.collectionView.reloadData()
  }

  //MARK: UIImagePickerController
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image = info[UIImagePickerControllerEditedImage] as? UIImage
    self.controllerDidSelectImage(image!)
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK: Button Selectors
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
    println("done pressed")
    self.collectionViewVAnimateConstraint.constant = -120
    self.resizer(vCArray:self.mainImageViewSizeAnimateConstraintH,hCArray: self.mainImageViewSizeAnimateConstraintV,vcs: 0,hcs: 0, vAnim: 0)

    UIView.animateWithDuration(0.4, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    self.navigationItem.rightBarButtonItem = self.navShare
  }
  func sharePressed() {
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
      let compViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
      compViewController.addImage(self.mainImageView.image)
      self.presentViewController(compViewController, animated: true, completion: nil)
    } else {
      //must sign in to twitter to use this feature
    }
  }
  
  //MARK: UICollectionViewDataSource
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterCell", forIndexPath: indexPath) as GalleryCell
    let thumbnail = self.thumbnails[indexPath.row]
    if thumbnail.originImage != nil {
      println("got origin!")
      if thumbnail.filteredImage == nil {
        println("filtered image commence!")
        thumbnail.generateFilteredImage(thumbnail.originImage!, filterType: thumbnail.filterType)
        cell.imageView.image = thumbnail.filteredImage!
      }//if thumbnail
    }//if thumbnail
    return cell
  }//collectionViewCell
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return self.thumbnails.count
  }
  
  
  //MARK: Did Select Item VC CollectionView
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let filterCarrier = thumbnails[indexPath.row] as Thumbnail
    filterCarrier.generateFilteredImage(mainImageView.image!, filterType: filterCarrier.filterType)
    self.mainImageView.image = filterCarrier.filteredImage
    //Thumbnail.generateFilteredImage(self.mainImageView.image, filterCarrier.filterType)
    
      }
  
  
  func resizer(#vCArray: [NSLayoutConstraint], hCArray: [NSLayoutConstraint], vcs: CGFloat, hcs: CGFloat, vAnim: CGFloat) {
    //if cs
    for cs in vCArray {
      cs.constant = vcs
      if cs.firstItem.isEqual(self.mainImageView) {
        println(cs.constant)
        if cs.firstAttribute == NSLayoutAttribute.Top {
          cs.constant = vAnim
          println(cs.constant)
        }
      }
    }
    for cs in hCArray {
      cs.constant = hcs
    }
    
  }
  
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
    let imageView = views["imageView"] as UIView!
    let imageViewConstraintH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[imageView]-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(imageViewConstraintH)
    let imageViewConstraintV = NSLayoutConstraint.constraintsWithVisualFormat("V:[navSpacer]-[imageView]-8-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(imageViewConstraintV)
    
    self.mainImageViewSizeAnimateConstraintH = imageViewConstraintH as [NSLayoutConstraint]
    self.mainImageViewSizeAnimateConstraintV = imageViewConstraintV as [NSLayoutConstraint]
    //self.mainImageViewPosAnimationConstraintV = imageViewConstraintV.first as NSLayoutConstraint
    
    //////////////NAV SPACER/////////////////////
    let navSpacer = views["navSpacer"] as UIImageView!
    let navSpacerConstraintV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[navSpacer]", options: nil, metrics: nil, views: views)
    let navSpacerConstraintHeight = NSLayoutConstraint.constraintsWithVisualFormat("V:[navSpacer(72)]", options: nil, metrics: nil, views: views)
    rootView.addConstraints(navSpacerConstraintHeight)
    rootView.addConstraints(navSpacerConstraintV)
    
    /////////////COLLECTION VIEW////////////////
    var collectionView = views["collectionView"] as UICollectionView!
    let collectionViewConstraintH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[collectionView]-|", options: nil, metrics: nil, views: views)
    rootView.addConstraints(collectionViewConstraintH)
    let collectionViewConstraintV = NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView]-(-120)-|", options: nil , metrics: nil, views: views)
    rootView.addConstraints(collectionViewConstraintV)
    let collectionViewConstraintHeight = NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView(100)]", options: nil, metrics: nil, views: views)
    rootView.addConstraints(collectionViewConstraintHeight)
    self.collectionViewVAnimateConstraint = collectionViewConstraintV.first as NSLayoutConstraint
  }//rootViewConstraints

}//ViewController

