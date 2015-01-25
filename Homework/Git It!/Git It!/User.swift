//
//  User.swift
//  Git It!
//
//  Created by Eric Mentele on 1/21/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

struct User {
  
  var userImage: UIImage?
  let userName: String
  let userURL: String
  let totalCount: Int
  
  init(_ jsonDictionary: [String : AnyObject], _ totalCount: Int) {
    
    self.userName = jsonDictionary["login"] as String
    self.userURL = jsonDictionary["avatar_url"] as String
    self.totalCount = totalCount
  }//init
}//User