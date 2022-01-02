import Foundation

class SmplTank : Tank {
  var turn = 0

  override func computePreActions() {
    if self.energy > 500 {
        addPostAction(postAction: MoveAction(distance: 1, direction: .North))
        // if turn == 0 {
        //     addPreAction(preAction: RadarAction(radius: 2))
        //     addPostAction(postAction: MoveAction(distance: 1, direction: .North))
        //     addPostAction(postAction: MineAction(power: 100, isRover: false, dropDirection: .East))
        //     addPostAction(postAction: MineAction(power: 100, isRover: true, dropDirection: .South,  moveDirection: .East))
        //     addPostAction(postAction: MoveAction(distance: 1, direction: .East))
        //     turn += 1
        // } else if turn == 1 {
        //     addPostAction(postAction: MineAction(power: 100, isRover: true, dropDirection: .North,  moveDirection: nil))
        //     turn += 1
        //     } 
        }
    }
}