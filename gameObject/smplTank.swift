import Foundation

class SmplTank : Tank {
  override func computePreActions() {
    if self.energy > 500 {
        addPreAction(preAction: RadarAction(radius: 2))
        addPostAction(postAction: MineAction(power: 100))
    }
  }
}