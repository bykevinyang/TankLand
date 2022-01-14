import Foundation

class TestTank : Tank {
    var turn = 0

    override func computePreActions() {
        if self.energy > 500 {
            addPreAction(preAction: ShieldAction(energy: 500))
            addPostAction(postAction: MineAction(power: 4000, isRover: true, dropDirection: .East, moveDirection: nil))
            addPostAction(postAction: MissileAction(energy: 1000, position: Position(2,3)))
            addPostAction(postAction: MoveAction(distance: 2, direction: .East))
        }
    }
}