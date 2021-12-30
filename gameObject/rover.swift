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
	func dropRover(tank: Tank, mineAction: PostAction) -> Bool {
        let dropAction = mineAction as! MineAction
        
        let randomMove: Bool
        if dropAction.moveDirection == nil {
            randomMove = true
        } else {
            randomMove = false
        }

		let rover = Rover(sender: tank, mineAction: dropAction, randomMove: randomMove)
		self.addGameObject(rover)
        return true
	}
}