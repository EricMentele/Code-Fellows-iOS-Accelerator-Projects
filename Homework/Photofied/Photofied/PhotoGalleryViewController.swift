//
//  PhotoGalleryViewController.swift
//  Photofied
//
//  Created by Eric Mentele on 1/12/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

protocol ImageSelectedProtocol {
  
  func controllerDidSelectImage(UIImage) -> Void
  
}//ImageSelectedProtocol


class PhotoGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  var collectionView : UICollectionView!
  var images = [UIImage]()
  var delegate : ImageSelectedProtocol?
  var collectionViewFlowLayout : UICollectionViewFlowLayout!

  
  override func loadView() {
    //MARK: Root view and collection view setup
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    self.collectionViewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: rootView.frame, collectionViewLayout: collectionViewFlowLayout)
    rootView.addSubview(self.collectionView)
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    collectionViewFlowLayout.itemSize = CGSize(width: 100, height: 100)
    self.view = rootView
  }//loadView

  
    override func viewDidLoad() {
      
      super.viewDidLoad()
      self.view.backgroundColor = UIColor.blackColor()
      //MARK: Pinch gesture recognizer
      let pinchGesture = UIPinchGestureRecognizer(target: self, action: "pinched:")
      //MARK:Collection View
      self.collectionView.addGestureRecognizer(pinchGesture)
      self.collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "GalleryCell")
      //MARK: Images
      let image1 = UIImage(named: "Image-1")
      let image2 = UIImage(named: "Image-2")
      let image3 = UIImage(named: "Image-3")
      let image4 = UIImage(named: "Image-4")
      let image5 = UIImage(named: "Image-5")
      let image6 = UIImage(named: "Image-6")
      self.images.append(image1!)
      self.images.append(image2!)
      self.images.append(image3!)
      self.images.append(image4!)
      self.images.append(image5!)
      self.images.append(image6!)
    }//viewDidLoad

  
  //MARK: UI COLLECTION VIEW DATA SOURCE & DELEGATE METHODS
  //MARK: numberOfRowsInSection
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.images.count
  }//collectionView
  
  
  //MARK:cellForItemAtIndexPath
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as GalleryCell
    let image = self.images[indexPath.row]
    cell.imageView.image = image
    return cell
  }//collectionView
  
  
  //MARK: didSelectItemAtIndexPath
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    self.delegate?.controllerDidSelectImage(self.images[indexPath.row])
    self.navigationController?.popToRootViewControllerAnimated(true)
  }//didSelectItem
  
  
  //MARK:GESTURE RECOGNIZERS
  func pinched (sender: UIPinchGestureRecognizer) {
    
    self.collectionView.performBatchUpdates({ () -> Void in
      
      if sender.velocity > 0 {
        
        let grow = CGSize(width: self.collectionViewFlowLayout.itemSize.width * 0.95, height: self.collectionViewFlowLayout.itemSize.height * 0.95)
        self.collectionViewFlowLayout.itemSize = grow
        
      } else if sender.velocity < 0 {
        
        let shrink = CGSize(width: self.collectionViewFlowLayout.itemSize.width / 0.95, height: self.collectionViewFlowLayout.itemSize.height / 0.95)
        self.collectionViewFlowLayout.itemSize = shrink
      }//if else if
      },//colectionViewBatchUpdate
      
      completion: { (finished) -> Void in
    })//completion
  }//pinched
  
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
