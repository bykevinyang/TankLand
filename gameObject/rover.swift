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
            print("HERE")
            print(super.mineAction.moveDirection)
		}
	}

}

extension TankLand {
	func createRover(tank: Tank, mineAction: MineAction, randomMove: Bool = false) -> Rover{
		let rover = Rover(sender: tank, mineAction: mineAction, randomMove: randomMove)
		self.addGameObject(rover)
        return rover
	}
}