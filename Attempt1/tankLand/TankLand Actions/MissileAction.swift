struct MissileAction {
  var energy: Int
  // var sendersender: GameObject
	var position: Position
  var damage: Int
	
	init (energy: Int, position: Position) {   
    self.energy = energy
    // self.sender = sender
    self.position = position
		self.damage = energy * Constants.missileStrikeMultiple
	}
}

extension TankLand {
  func sendMissile(tank: Tank, missileAction: MissileAction ) {
      let cost = missileAction.energy
      guard tank.energy > cost else {
            print("SHIELD FAILED...\(tank.id) DOES NOT HAVE ENOUGH ENERGY")
            return
      }
      tank.chargeEnergy(cost) 

			// ADD IN DAMAGING PART FOR SENDMISSILE
      let currentRow = missileAction.position.row
		  let currentCol = missileAction.position.col
      for rowShift in -1...1 {
				for colShift in -1...1 {
					if let object = self[currentRow + rowShift, currentCol + colShift] {
						if object.position == missileAction.position{
							let damage = cost*Constants.missileStrikeMultiple
              var ogEnergy = object.energy
							object.chargeEnergy(damage)
              if object.energy <= 0 {
                self[rowShift, colShift] = nil
                tank.gainEnergy(ogEnergy / 4)
              }
              print("\(tank) sent a missile to \(missileAction.position)")
							print("\(object) was hit with direct \(damage)")	
						}
						else {
							let damage = cost*Constants.missileStrikeMultipleCollateral
              var ogEnergy = object.energy
							object.chargeEnergy(damage)	
              if object.energy <= 0 {
                self[rowShift, colShift] = nil
                tank.gainEnergy(ogEnergy / 4)
              }
              print("\(tank) sent a missile to \(missileAction.position)")
							print("\(object) was hit with collatral \(damage)")	
						}
					}
				}
			}
	}
}