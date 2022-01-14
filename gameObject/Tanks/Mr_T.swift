// import Foundation

class Mr_T: Tank {
	override func computePreActions() {
		print("Mr. T!!!!")
		
	}
	
	override func computePostActions() {
    addPostAction(postAction: MineAction(power: 1000, isRover: true, dropDirection: nil, moveDirection: nil))
	}
	
}

class Sanic: Tank {
	let taunts = ["..zoOM", "Catch me if you can!", "gotta go fast", "eat my dust!"]
	
	override func computePreActions() {
		if let taunt = taunts.randomElement() {
			print(taunt)
		}
	}

	override func computePostActions() {
		if let randomDirection: Direction =  Direction.allCases.randomElement() {
			let move = MoveAction(distance: 3, direction: randomDirection)
			addPostAction(postAction: move)
		}
	}
}
