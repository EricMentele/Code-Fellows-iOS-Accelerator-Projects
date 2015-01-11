
import UIKit

class Stacktacular {
  //acting stack
  var stack = [String]()
  //push adds something onto the stack
  func push(ball:String) {
    //put it on the stack
    stack.append(ball)
  }//push
  //peek allows you to see the item on top of the stack.
  func peek() -> String? {
    var status: String {
      if !stack.isEmpty {
        return stack.last!
      }
      else {
        return "Empty"
      }
    }
    return status
  }//peek
  //pop takes the last item placed on the stack, off of the stack.
  func pop() {
    if !stack.isEmpty {
      stack.removeLast()
    }//if
  }//pop
  //this is known as LIFO or last in first out.
}//stacktacular

let football = "Football"
let basketball = "Basketball"
let baseball = "Baseball"
let volleyball = "Volley Ball"
let rugbyball = "Rugby Ball"
let golfball = "Golf Ball"
let tennisball = "Tennis Ball"
//Demo

var totallystacktacular = Stacktacular()

totallystacktacular.peek()
totallystacktacular.pop()
totallystacktacular.push(football)
totallystacktacular.push(golfball)
totallystacktacular.peek()
totallystacktacular.push(tennisball)
totallystacktacular.peek()
totallystacktacular.pop()
totallystacktacular.peek()




  
  
  
