//
//  Tweet.swift
//  CF iOS DevEx Day 1
//
//  Created by Eric Mentele on 1/5/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import Foundation

import UIKit

class Tweet {
  
  var text: String
  
  var userName: String
  
  var userImage: UIImage?//exp
  
  init(_ jsonDictionary: [String : AnyObject]) {
    
    self.text = jsonDictionary["text"] as String
    
    var nameDictionary = jsonDictionary["user"] as [String : AnyObject]
    
    let imageUrlString = nameDictionary["profile_image_url"] as String
    
    let imageURL = NSURL(string: imageUrlString)//exp
    
    let userImageData = NSData(contentsOfURL: imageURL!)//exp
    
    self.userName = nameDictionary ["name"] as String
    
    self.userImage = UIImage(data: userImageData!)
    
  }
}