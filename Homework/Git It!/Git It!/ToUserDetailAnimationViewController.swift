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
    
    return 0.25
  }//transitionDuration
  
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UserSearchViewController
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailViewController
    let containerView = transitionContext.containerView()
    let selectedIndexPath = fromVC.usersCollection.indexPathsForSelectedItems().first as
    NSIndexPath
    let cell = fromVC.usersCollection.cellForItemAtIndexPath(selectedIndexPath) as UserCell
    let snapshotOfCell = cell.userCellImage.snapshotViewAfterScreenUpdates(false)
    cell.userCellImage.hidden = true
    snapshotOfCell.frame = containerView.convertRect(cell.userCellImage.frame, fromView: cell.userCellImage.superview)
    toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
    toVC.view.alpha = 0
    toVC.userImage.hidden = true
    containerView.addSubview(toVC.view)
    containerView.addSubview(snapshotOfCell)
    toVC.view.setNeedsLayout()
    toVC.view.layoutIfNeeded()
    
    let duration = self.transitionDuration(transitionContext)
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      toVC.view.alpha = 1.0
      
      let frame = containerView.convertRect(toVC.userImage.frame, fromView: toVC.view)
      snapshotOfCell.frame = frame
      
      }) { (finished) -> Void in
        
        
        toVC.userImage.hidden = false
        cell.userCellImage.hidden = false
        snapshotOfCell.removeFromSuperview()
        transitionContext.completeTransition(true)
    }
  }//animatTransition
  
}//To UserDetail
