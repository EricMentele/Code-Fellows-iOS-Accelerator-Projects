//
//  Tweet.swift
//  CF iOS DevEx Day 1
//
//  Created by Eric Mentele on 1/5/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import Foundation

class Tweet {
  
  var text: String
  
  var userName: String
  
  init(_ jsonDictionary: [String : AnyObject]) {
    
    self.text = jsonDictionary["text"] as String
    
    var nameDictionary = jsonDictionary["user"] as [String : AnyObject]
    
    self.userName = nameDictionary ["name"] as String
    
  }
}