class Mine: GameObject {
	static var mineCount: Int = 0
	static var roverCount: Int = 0

	var mineAction: MineAction

	var damage: Int {
		return super.energy * Constants.mineStrikeMultiple
	}

	init(sender: Tank, mineAction: MineAction){
		self.mineAction = mineAction
		var type = GameObjectType.Rover
		if mineAction.isRover {
			type = GameObjectType.Rover	
		} else {
			type = GameObjectType.Mine
		}

		let id: String
		if mineAction.isRover {
			id = "\(sender.id)R\(Mine.roverCount)"
			Mine.roverCount += 1
		} else {
			id = "\(sender.id)M\(Mine.mineCount)"
			Mine.mineCount += 1
		}

		let initialPosition = Mine.calcInitPosition(sender: sender, dropDirection: mineAction.dropDirection)
		super.init(type: type, id: id, position: initialPosition, energy: mineAction.power)
	}
  
	static func calcInitPosition (sender: Tank, dropDirection: Direction?) -> Position {
		var tankPos = sender.position
		if let direction = dropDirection {
			switch direction {
				case .North:
					tankPos.row -= 1    // col stays the same
				case .South:
					tankPos.row += 1
				case .East:
					tankPos.col += 1
				case .West:
					tankPos.col -= 1
				case .NorthEast:
					tankPos.row -= 1
					tankPos.col += 1
				case .NorthWest:
					tankPos.row -= 1
					tankPos.col -= 1
				case .SouthEast:
					tankPos.row += 1
					tankPos.col += 1
				case .SouthWest:
					tankPos.row += 1
					tankPos.col -= 1
				default:
					()
			}
		} else {
			tankPos.row -= 1
		}
		return tankPos
  }
}

struct MineAction: PostAction {
    let action: ActionType
    let isRover: Bool
    let power: Int
    let dropDirection: Direction?
    var moveDirection: Direction?
    
    var description: String {
        let dropDirectionMessage = (dropDirection == nil) ? "drop direction is random" : "\(dropDirection!)"
        let moveDirectionMessage = (moveDirection == nil) ? "move direction is random" : "\(moveDirection!)"
        return "\(action) \(power) \(dropDirectionMessage) \(isRover) \(moveDirectionMessage)"
    }
    init(power: Int, isRover: Bool = false, dropDirection: Direction? = nil,  moveDirection: Direction? = nil){
        if isRover == true {
            self.action = .DropRover
        } else {
            self.action = .DropMine
        }
        self.isRover = isRover
        self.dropDirection = dropDirection
        self.moveDirection = moveDirection
        self.power = power
    }
	}
		
extension TankLand {
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
	func dropMine(tank: Tank, mineAction: PostAction) -> Bool {
		if tank.energy > Constants.costOfReleasingMine {
		let mineAct = mineAction as! MineAction
=======
	func createMine(tank: Tank, mineAction: PostAction) -> Bool {
        let mineAct = mineAction as! MineAction
>>>>>>> origin/main
=======
	func createMine(tank: Tank, mineAction: PostAction) -> Bool {
        let mineAct = mineAction as! MineAction
>>>>>>> origin/main
=======
	func createMine(tank: Tank, mineAction: PostAction) -> Bool {
        let mineAct = mineAction as! MineAction
>>>>>>> origin/main
        
		let mine = Mine(sender: tank, mineAction: mineAct)
		self.addGameObject(mine)
        tank.chargeEnergy(Constants.costOfReleasingMine)
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
        print("\(tank.id) dropped mine \(mine.id) and was charged \(Constants.costOfReleasingMine) energy")
		return true
		} else {
			print("\(tank.id) unable to drop mine b/c it does not have enough energy")	
			return false
		}
=======
        print("\(tank) dropped a mine abd was charged \(Constants.costOfReleasingMine) energy")
        return true
>>>>>>> origin/main
=======
        print("\(tank) dropped a mine abd was charged \(Constants.costOfReleasingMine) energy")
        return true
>>>>>>> origin/main
=======
        print("\(tank) dropped a mine abd was charged \(Constants.costOfReleasingMine) energy")
        return true
>>>>>>> origin/main
	}
}
