struct MissileAction {
  var energy: Int
  var objectHit: GameObject
	var position: Position
  var damage: Int
	
	init (energy: Int, objectHit: GameObject, position: Position) {
    self.energy = energy
    self.objectHit = objectHit
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
	}
}