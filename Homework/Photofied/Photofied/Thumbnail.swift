//
//  Thumbnail.swift
//  Photofied
//
//  Created by Eric Mentele on 1/13/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class Thumbnail {

  var filterType : String
  var originImage : UIImage?
  var filteredImage : UIImage?
  var gpuContext : CIContext
  var imageQueue : NSOperationQueue

  init (filterType: String, operationQueue : NSOperationQueue, context : CIContext) {
    
    self.filterType = filterType
    self.imageQueue = operationQueue
    self.gpuContext = context
  }//init 
  
  func generateFilteredImage(image: UIImage, filterType: String) {
    
      let startImage = CIImage(image: image)
      let filter = CIFilter(name: self.filterType)
      filter.setDefaults()
      filter.setValue(startImage, forKey: kCIInputImageKey)
      let result = filter.valueForKey(kCIOutputImageKey) as CIImage
      let extent = result.extent()
      let imageRef = self.gpuContext.createCGImage(result, fromRect: extent)
      self.filteredImage = UIImage(CGImage: imageRef)
      
    }//generateFiltered
}//Thumbnail
