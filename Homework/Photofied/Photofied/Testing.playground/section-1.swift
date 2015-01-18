// Playground - noun: a place where people can play

import UIKit


import Foundation

class Queue {
  
  var myQueue = [Int]()
  
  
  init() {
  
  }
  
  
  func enQueue (item: Int) {
    
    myQueue.append(item)
  }
  
  
  func deQueue () {
    
    if !myQueue.isEmpty{
      self.myQueue.removeAtIndex(0)
    }
  }
  
  
}
//FIFO

let queue: Queue = Queue()
queue.enQueue(1)//First in
queue.enQueue(7)
queue.enQueue(9)
queue.deQueue()//First out
queue.enQueue(10)
queue.enQueue(23)
queue.deQueue()
