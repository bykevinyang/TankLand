class Mine: GameObject {
	static var mineCount: Int = 0
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
		let id = "\(sender.id)M\(Mine.mineCount)"
		Mine.mineCount += 1
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
        action = .DropMine
        self.isRover = isRover
        self.dropDirection = dropDirection
        self.moveDirection = moveDirection
        self.power = power
    }
	}
		
extension TankLand {
	func createMine(tank: Tank, mineAction: MineAction) {
		var mine = Mine(sender: tank, mineAction: mineAction)
		self.addGameObject(mine)
	}
}