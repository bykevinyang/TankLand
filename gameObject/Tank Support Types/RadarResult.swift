struct RadarResult {
  let position:Position
	let id:String
	let energy:Int
	let objectType:GameObjectType

	init(position:Position, id:String, energy:Int, objectType:GameObjectType) {
		self.position = position
		self.id = id
		self.energy = energy
		self.objectType = objectType
	}
}