//
//  Repo.swift
//  Git It!
//
//  Created by Eric Mentele on 1/19/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import Foundation

struct Repo {
  
  var name: String
  var author: String
  
  init(_ jsonDictionary: [String : AnyObject]) {
    
    self.name = jsonDictionary["name"] as String
    self.author = jsonDictionary["full_name"] as String
    println(self.name)
  }//init
}//