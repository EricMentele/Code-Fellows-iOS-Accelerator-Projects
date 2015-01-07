//
//  TweetCell.swift
//  Tweetacular
//
//  Created by Eric Mentele on 1/7/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
  
  @IBOutlet weak var tweetImage: UIImageView!
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var tweetText: UITextView!
  
  
  override func awakeFromNib() {
    
    super.awakeFromNib()
    
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    
    super.setSelected(selected, animated: animated)
    
  }
  
  
  
}