//
//  UserDetailViewController.swift
//  Git It!
//
//  Created by Eric Mentele on 1/22/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
  
  @IBOutlet weak var userImage: UIImageView!
  
  var selectedUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()
      self.userImage.image = nil
      self.userImage.image = self.selectedUser.userImage
      assert(self.selectedUser.userImage != nil,"Image not there")

        // Do any additional setup after loading the view.
    }

}
