//
//  ToUserDetailAnimationViewController.swift
//  Git It!
//
//  Created by Eric Mentele on 1/22/15.
//  Copyright (c) 2015 Eric Mentele. All rights reserved.
//

import UIKit

class ToUserDetailAnimation: NSObject, UIViewControllerAnimatedTransitioning {
  
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    
    return 0.40
  }//transitionDuration
  
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    //set up view controllers to animate between.
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UserSearchViewController
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailViewController
    //set up view to animate in
    let containerView = transitionContext.containerView()
    //select the location of what is being sent.
    let selectedIndexPath = fromVC.usersCollection.indexPathsForSelectedItems().first as
    NSIndexPath
    let cell = fromVC.usersCollection.cellForItemAtIndexPath(selectedIndexPath) as UserCell
    //make a copy  of what will be sent including its constraints.
    let snapshotOfCell = cell.userCellImage.snapshotViewAfterScreenUpdates(false)
    cell.userCellImage.hidden = true
    snapshotOfCell.frame = containerView.convertRect(cell.userCellImage.frame, fromView: cell.userCellImage.superview)
    //set up the recieving context of what is being sent.
    toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
    toVC.view.alpha = 0
    toVC.userImage.hidden = true
    //add items to animate, to the container view in which they will be animated in.
    containerView.addSubview(toVC.view)
    containerView.addSubview(snapshotOfCell)
    //set up the recieving view to modify its constraints to what is being recieved.
    toVC.view.setNeedsLayout()
    toVC.view.layoutIfNeeded()
    //set up animation
    let duration = self.transitionDuration(transitionContext)
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      toVC.view.alpha = 1.0
      
      let frame = containerView.convertRect(toVC.userImage.frame, fromView: toVC.view)
      snapshotOfCell.frame = frame
      
      })/*animate with duration*/ { (finished) -> Void in
        
        toVC.userImage.hidden = false
        cell.userCellImage.hidden = false
        snapshotOfCell.removeFromSuperview()
        transitionContext.completeTransition(true)
    }//trailing closure
  }//animateTransition
  
}//To UserDetail
