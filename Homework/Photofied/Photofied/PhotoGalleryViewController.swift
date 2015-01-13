//
//  PhotoGalleryViewController.swift
//  Photofied
//
//  Created by Eric Mentele on 1/12/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class PhotoGalleryViewController: UIViewController, UICollectionViewDataSource {
  
  var collectionView : UICollectionView!
  var images = [UIImage]()
  
  override func loadView() {
    
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    let collectionViewFlowLayout = UICollectionViewFlowLayout()
    self.collectionView = UICollectionView(frame: rootView.frame, collectionViewLayout: collectionViewFlowLayout)
    rootView.addSubview(self.collectionView)
    self.collectionView.dataSource = self
    self.view = rootView
    collectionViewFlowLayout.itemSize = CGSize(width: 200, height: 200)
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = UIColor.grayColor()
      self.collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "GalleryCell")
      let image1 = UIImage(named: "image1.jpeg")
      let image2 = UIImage(named: "image2.jpeg")
      let image3 = UIImage(named: "image3.JPG")
      let image4 = UIImage(named: "image4.jpeg")
      let image5 = UIImage(named: "image5.jpeg")
      let image6 = UIImage(named: "image6.jpeg")
      self.images.append(image1!)
      self.images.append(image2!)
      self.images.append(image3!)
      self.images.append(image4!)
      self.images.append(image5!)
      self.images.append(image6!)
      
      
      
      
        // Do any additional setup after loading the view.
    }

  //MARK: UICollectionViewDataSource
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.images.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GalleryCell", forIndexPath: indexPath) as GalleryCell
    let image = self.images[indexPath.row]
    cell.imageView.image = image
    return cell
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
