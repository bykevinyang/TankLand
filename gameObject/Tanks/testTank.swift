import Foundation

class TestTank : Tank {
    var turn = 0

    override func computePreActions() {
        if self.energy > 500 {
            addPreAction(preAction: ShieldAction(energy: 500))
            addPostAction(postAction: MineAction(power: 500, isRover: true, dropDirection: .East, moveDirection: .West))
        }
    }
}