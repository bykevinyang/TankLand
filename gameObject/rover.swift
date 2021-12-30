class Rover: Mine {
	var mA: MineAction	
	var sender: Tank
	
	var randomDirection: Direction {
		return Direction.allCases.randomElement()!
	}

	init(sender: Tank, mineAction: MineAction, randomMove: Bool = false) {
		self.mA = mineAction
		self.sender = sender
		super.init(sender: self.sender, mineAction: self.mA) 
		if randomMove == true {
			super.mineAction.moveDirection = randomDirection
            //print("HERE")
            //print(super.mineAction.moveDirection)
		}
	}

}

extension TankLand {
	func dropRover(tank: Tank, mineAction: PostAction) -> Bool {
	  if tank.energy > Constants.costOfReleasingRover {
      tank.chargeEnergy(Constants.costOfReleasingRover)
			let dropAction = mineAction as! MineAction
			
			let randomMove: Bool
			if dropAction.moveDirection == nil {
					randomMove = true
			} else {
					randomMove = false
			}

			let rover = Rover(sender: tank, mineAction: dropAction, randomMove: randomMove)
      print("\(tank.id) created rover \(rover.id) and was charged \(Constants.costOfReleasingRover) energy")
			self.addGameObject(rover)
			return true
		} else {
      print("\(tank) does not have enough energy to create a rover")
			return false
		}
	}
} 
