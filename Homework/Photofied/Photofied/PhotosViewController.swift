//
//  PhotosViewController.swift
//  Photofied
//
//  Created by Eric Mentele on 1/14/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  var assetsFetchResults : PHFetchResult!
  var assetCollection : PHAssetCollection!
  var imageManager = PHCachingImageManager()
  
  var collectionView : UICollectionView!
  
  var destinationImageSize : CGSize!
  
  var delegate : ImageSelectedProtocol?
  
  override func loadView() {
    let rootView = UIView(frame: UIScreen.mainScreen().bounds)
    //flowlayout?
    self.collectionView = UICollectionView(frame: rootView.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    let flowLayout = collectionView.collectionViewLayout as UICollectionViewFlowLayout 
    flowLayout.itemSize = CGSize(width: 100, height: 100)
    
    rootView.addSubview(collectionView)
    collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.view = rootView
  }//loadView
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.imageManager = PHCachingImageManager()
    self.assetsFetchResults = PHAsset.fetchAssetsWithOptions(nil)
    
    self.collectionView.delegate = self
    self.collectionView.dataSource = self
    self.collectionView.registerClass(GalleryCell.self, forCellWithReuseIdentifier: "PhotoCell")
    
    // Do any additional setup after loading the view.
  }//viewDidLoad
  
  //MARK: UICollectionViewDataSource
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.assetsFetchResults.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as GalleryCell
    let asset = self.assetsFetchResults[indexPath.row] as PHAsset
    self.imageManager.requestImageForAsset(asset, targetSize: CGSize(width: 100, height: 100), contentMode: PHImageContentMode.AspectFill, options: nil) { (requestedImage, info) -> Void in
    cell.imageView.image = requestedImage
    }
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let selectedAsset = self.assetsFetchResults[indexPath.row] as PHAsset
    self.imageManager.requestImageForAsset(selectedAsset, targetSize: self.destinationImageSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (requestedImage, info) -> Void in
      println("I am a bug fix")
      self.delegate?.controllerDidSelectImage(requestedImage)
      self.navigationController?.popToRootViewControllerAnimated(true)
    }
  }
}//PhotosViewController
