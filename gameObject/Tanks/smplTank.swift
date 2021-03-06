import Foundation

class SmplTank : Tank {
  var turn = 0

  override func computePreActions() {
    if self.energy > 500 {
        // addPostAction(postAction: MoveAction(distance: 1, direction: .North))
        addPreAction(preAction: ShieldAction(energy: 500))
        addPreAction(preAction: RadarAction(radius: 3))
        addPostAction(postAction: MissileAction(energy: 10000, position: Position(5,4)))
          if turn == 0 {
            addPreAction(preAction: RadarAction(radius: 2))
            addPostAction(postAction: MoveAction(distance: 1, direction: .North))
            addPostAction(postAction: MineAction(power: 100, isRover: false, dropDirection: .East))
            addPostAction(postAction: MineAction(power: 100, isRover: true, dropDirection: .South,  moveDirection: .East))
            addPostAction(postAction: MoveAction(distance: 1, direction: .East))
						addPreAction(preAction: SendMessageAction(id: "joe mama", message: "this better work"))
            turn += 1
          } else if turn == 1 {
              addPostAction(postAction: MineAction(power: 100, isRover: true, dropDirection: .North,  moveDirection: nil))
              addPreAction(preAction: ReceiveMessageAction(key: "joe mama"))
              let tank = self as! Tank
              if let message = tank.receivedMessage {
                //print("The message is: \(message)")
              } else { 
                  //print("Wrong key or no message")
              }
          }    
          turn += 1
				}
			}  
    }
  

