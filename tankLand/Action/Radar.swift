  struct RadarResult: CustomStringConvertible {
  let position: Position
	let id: String
	let energy: Int
	let objectType: GameObjectType

	init(position:Position, id:String, energy:Int, objectType:GameObjectType) {
		self.position = position
		self.id = id
		self.energy = energy
		self.objectType = objectType
	}

	var description: String {
		return "\(objectType): \(id) @ \(position) w/ \(energy)e"
	}
}

extension TankLand {
	func runRadar (tank: GameObject, _ radius: Int) -> [RadarResult]? {
		let currentRow = tank.position.row
		let currentCol = tank.position.col

		var results: [RadarResult]? = []

		var cost: Int?
		// Do check on radius
		if radius <= 8 && radius >= 0 {
			cost = Constants.costOfRadarByUnitsDistance[radius]
		} else {
      print("Radar radius is invalid")
			return nil
    }

		for rowShift in -radius...radius {
			for colShift in -radius...radius {
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