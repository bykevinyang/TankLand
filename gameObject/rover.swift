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
		//let type = GameObjectType.Rover
		self.mineAction = mineAction
		if randomMove == true {
			super.mineAction.moveDirection = randomDirection
		} 
	}

}

extension TankLand {
	func createRover(tank: Tank, mineAction: MineAction) {
		let rover = Rover(sender: tank, mineAction: mineAction)
		self.addGameObject(rover)
	}
}