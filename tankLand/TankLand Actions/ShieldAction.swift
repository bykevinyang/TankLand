struct ShieldAction {
	var power: Int	
	var energy: Int

  init (energy: Int) {
		self.energy = energy
    self.power = energy * Constants.shieldPowerMultiple
  }
}

extension TankLand {
  func doSetShieldAction(tank: Tank, shieldAction: ShieldAction) {
        let cost = shieldAction.energy
        guard tank.energy > cost else {
            print("SHIELD FAILED...\(tank.id) DOES NOT HAVE ENOUGH ENERGY")
            return
        }
        tank.chargeEnergy(cost)
        tank.setShield(cost * Constants.shieldPowerMultiple)
		
	        //PRINT STATEMENT FOR DEBUGGING PURPOSES WHILE LOGGER IS DEVELOPED
      print("SHIELD ADDED...\(tank.id) SET SHIELD TO \(cost * Constants.shieldPowerMultiple)")
          //UPDATE LOGGER HERE
  }
}