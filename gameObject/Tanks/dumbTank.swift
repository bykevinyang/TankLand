import Foundation

class DumbTank : Tank {
  var turn = 0

  override func computePreActions() {
    if self.energy > 500 {
        // addPostAction(postAction: MoveAction(distance: 1, direction: .North))
        addPreAction(preAction: ShieldAction(energy: 500))
        addPreAction(preAction: RadarAction(radius: 3))
        addPostAction(postAction: MissileAction(energy: 10000, position: Position(5,4)))
				addPreAction(preAction: SendMessageAction(id: "joe mama", message: "test for kevin"))
				addPreAction(preAction: ReceiveMessageAction(key: "joe mama"))
				let tank = self as! Tank
				if let message = tank.receivedMessage {
					//print("The message is: \(message)")
				} else { 
						//print("Wrong key or no message")
				}
    }
  }
}