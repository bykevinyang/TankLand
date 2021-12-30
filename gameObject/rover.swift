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
	func createRover(tank: Tank, mineAction: MineAction, randomMove: Bool = false) -> Rover {
	  if tank.energy > Constants.costOfReleasingRover {
      tank.chargeEnergy(Constants.costOfReleasingRover)
      let rover = Rover(sender: tank, mineAction: mineAction, randomMove: randomMove)
      print("\(tank.id) created rover \(rover.id) and was charged \(Constants.costOfReleasingRover) energy")
      self.addGameObject(rover)  
    } else {
      print("\(tank) does not have enough energy to create a rover")
    }
    return rover
	}
} 
