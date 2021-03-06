//
//  UserSearchViewController.swift
//  Git It!
//
//  Created by Eric Mentele on 1/21/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var results: UILabel!
  @IBOutlet weak var userSearch: UISearchBar!
  @IBOutlet weak var usersCollection: UICollectionView!
  
  var users = [User]()
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    self.usersCollection.dataSource = self
    self.userSearch.delegate = self
    self.navigationController?.delegate = self
    // Do any additional setup after loading the view.
  }//viewDidLoad
  
  
  //MARK: COLLECTION VIEW DATA SOURCE
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return self.users.count
  }//collection view
  
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userCell", forIndexPath: indexPath) as UserCell
    
    cell.userCellImage.image = nil
    var user = self.users[indexPath.row]
    let userCount = String(user.totalCount)
    self.results.text = ("Results: \(userCount)")
    cell.userName.text = user.userName
    
    if user.userImage == nil {
      
      GitCom.sharedGitCom.fetchUserImage(user.userURL, completionHandler: { (image) -> () in
        
        cell.userCellImage.image = image
        user.userImage = image
        self.users[indexPath.row] = user
      })//fetch user image
    } else {
      
      cell.userCellImage.image = user.userImage
    }//if else
    
    return cell
  }//cell for item
  
  
  //MARK: SEGUE AND NAV
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "userDetail" {
      
      let destination = segue.destinationViewController as UserDetailViewController
      let selectedCell = self.usersCollection.indexPathsForSelectedItems().first as NSIndexPath
      destination.selectedUser = self.users[selectedCell.row]
    }//if
  }//prepare for segue
  
  
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    if toVC is UserDetailViewController {
      
      return ToUserDetailAnimation()
    }//if
    return nil
  }//nav animation control
  
  
  //MARK: SEARCH BAR
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    
    GitCom.sharedGitCom.fetchUsersForSearchTerm(searchBar.text, callback: { (items, errorDescription) -> () in
      
      if errorDescription == nil {
        
        self.users = items!
        assert(self.users.count > 0, "Users are not populating")
      }
      self.usersCollection.reloadData()
    })//fetch users for search
    
    searchBar.resignFirstResponder()
  }//search bar clicked
  
  
  //MARK: Search text restriction
  func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
    return text.validate()
  }//search bare text validate
}//UserSearchViewController
