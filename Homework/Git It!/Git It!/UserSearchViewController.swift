//
//  UserSearchViewController.swift
//  Git It!
//
//  Created by Eric Mentele on 1/21/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate {

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
  //MARK: number of rows
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return self.users.count
  }
  
  
  //MARK: Collection view cell
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userCell", forIndexPath: indexPath) as UserCell
    
    //if cell.userCellImage != nil {
      
    cell.userCellImage.image = nil
    //}
    
    var user = self.users[indexPath.row]
    
    if user.userImage == nil {
      
      GitCom.sharedGitCom.fetchUserImage(user.userURL, completionHandler: { (image) -> () in
        
        cell.userCellImage.image = image
        user.userImage = image
        self.users[indexPath.row] = user
      })
    } else {
      cell.userCellImage.image = user.userImage
    }
   
    return cell
  }
  
  
  //MARK: SEGUE AND NAV
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "userDetail" {
      
      let destination = segue.destinationViewController as UserDetailViewController
      let selectedCell = self.usersCollection.indexPathsForSelectedItems().first as NSIndexPath
      destination.selectedUser = self.users[selectedCell.row]
    }
  }
  
  
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if toVC is UserDetailViewController {
      //return the animation controller
      return ToUserDetailAnimation()
    }
    
    //    if fromVC is SearchUsersViewController  {
    //      return ToUserDetailAnimationController()
    //    }
    return nil
  }
  
  
  //Mark: SEARCH BAR
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    GitCom.sharedGitCom.fetchUsersForSearchTerm(searchBar.text, callback: { (items, errorDescription) -> () in
      
      if errorDescription == nil {
        
        self.users = items!
        assert(self.users.count > 0, "Users are not populating")
        
      }
      self.usersCollection.reloadData()
    })
    
    searchBar.resignFirstResponder()
    
  }


  
}//UserSearchViewController
