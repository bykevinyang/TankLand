import Foundation

class SmplTank : Tank {
<<<<<<< HEAD
  var turn = 0

  override func computePreActions() {
    if self.energy > 500 {
			if turn == 0 {
        addPreAction(preAction: RadarAction(radius: 2))
				addPostAction(postAction: MoveAction(distance: 1, direction: .North))
        addPostAction(postAction: MineAction(power: 100, isRover: false, dropDirection: .East))
        addPostAction(postAction: MineAction(power: 100, isRover: true, dropDirection: .South,  moveDirection: .East))
				turn += 1
			} else if turn == 1 {
				addPostAction(postAction: MineAction(power: 100, isRover: true, dropDirection: .North,  moveDirection: nil))
				turn += 1
			}
=======
  override func computePreActions() {
    if self.energy > 500 {
        addPreAction(preAction: RadarAction(radius: 2))
        addPostAction(postAction: MineAction(power: 100))
>>>>>>> origin/main
    }
  }
}