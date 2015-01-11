//
//  Tweet.swift
//  Tweetacular
//
//  Created by Eric Mentele on 1/7/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import Foundation

import UIKit

class Tweet {
  
  var text: String
  
  var userName: String
  
  var userImage: UIImage?
  
  var userImageURL: String
  
  var tweetId: String
  
  var tweetFavoriteCount: String?
  
  var tweetUserID : String
  
  var tweetUserLocation : String
  
  var userBannerImage: UIImage?
  
  
  init(_ jsonDictionary: [String : AnyObject]) {
    
    
    var nameDictionary = jsonDictionary["user"] as [String : AnyObject]
    
   

    self.text = jsonDictionary["text"] as String
    
    self.tweetId = jsonDictionary ["id_str"] as String
    
    self.userImageURL = nameDictionary["profile_image_url"] as String
    
    self.tweetUserID = nameDictionary["id_str"] as String
    
    self.tweetUserLocation = nameDictionary["location"] as String
    
    self.userName = nameDictionary ["name"] as String
    
  }//init
  
  func getTweetInfo (infoDictionary : [String : AnyObject]) {
    let favoriteNumber = infoDictionary["favorite_count"] as Int
    self.tweetFavoriteCount = "\(favoriteNumber)"
    println("Got the count\(self.tweetFavoriteCount)")
  }
}//Tweet