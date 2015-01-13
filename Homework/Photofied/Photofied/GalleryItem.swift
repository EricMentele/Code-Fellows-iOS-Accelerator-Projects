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
    self.backgroundColor = UIColor.grayColor()
    imageView.frame = self.bounds
  }//override
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }//required init
}//GalleryCell
