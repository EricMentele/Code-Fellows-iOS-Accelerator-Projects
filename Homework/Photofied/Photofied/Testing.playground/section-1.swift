// Playground - noun: a place where people can play

import UIKit


import Foundation

class Queue {
  
  var myQueue = [Int]()
  
  init(){}
  
  func enQueue (item: Int) {
    
    myQueue.append(item)
  }
  
  func deQueue () {
    
    if !myQueue.isEmpty{
      self.myQueue.removeAtIndex(0)
    }
  }
  
  
}


let queue: Queue = Queue()
queue.enQueue(1)
queue.enQueue(7)
queue.enQueue(9)
queue.deQueue()
queue.enQueue(10)
queue.enQueue(23)
queue.deQueue()
