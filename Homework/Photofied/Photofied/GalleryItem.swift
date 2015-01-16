//
//  GalleryItem.swift
//  Photofied
//
//  Created by Eric Mentele on 1/12/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
  
  let imageView = UIImageView()
  
  override init (frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(self.imageView)
    self.backgroundColor = UIColor.blackColor()
    imageView.frame = self.bounds
    imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    imageView.layer.masksToBounds = true
    imageView.contentMode = UIViewContentMode.ScaleToFill
    let views = ["imageView" : imageView]
    let imageViewConstraintH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[imageView]|", options: nil, metrics: nil, views: views)
    let imageViewConstraintV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: nil, metrics: nil, views: views)
    self.addConstraints(imageViewConstraintH)
    self.addConstraints(imageViewConstraintV)
    
  }//override
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }//required init
}//GalleryCell
