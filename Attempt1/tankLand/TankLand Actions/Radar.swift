struct RadarResult: CustomStringConvertible {
  let position: Position
	let id: String
	let energy: Int
	
	// CHANGE ObjectType to type Tank and not GameObjectType
	let objectType: GameObjectType

	init(position:Position, id:String, energy:Int, objectType: GameObjectType) {
		self.position = position
		self.id = id
		self.energy = energy
		self.objectType = objectType
	}

	var description: String {
		return "\(objectType): \(id) @ \(position) w/ \(energy)e"
	}
}

struct RadarAction: PreAction {
    let action: ActionType
    let radius: Int
    var description: String {return "\(action) \(radius)"}
    init(radius: Int) {
        action = .RadarAction
        self.radius = radius
    }
}


extension TankLand {
	func runRadar (tank: Tank, radarAction: RadarAction) -> [RadarResult]? {
		let currentRow = tank.position.row
		let currentCol = tank.position.col

		var results: [RadarResult]? = []

		var cost: Int?
		// Do check on radius
		if radarAction.radius <= 8 && radarAction.radius >= 0 {
			cost = Constants.costOfRadarByUnitsDistance[radarAction.radius]
		} else {
      print("Radar radius is invalid")
			return nil
    }

		for rowShift in -radarAction.radius...radarAction.radius {
			for colShift in -radarAction.radius...radarAction.radius {
				if let object = self[currentRow + rowShift, currentCol + colShift] {
					// To prevent from counting itself
					if object.position != tank.position {
						let result = RadarResult(position: object.position, id: object.id, energy: object.energy, objectType: object.type)
            
            if results != nil {
                results?.append(result)
						} else {
                results = [result]
						}
					}
				} 
			}
		}
		return results 
	}
}