struct ShieldAction : PreAction {
  var action: ActionType
	var power: Int	
	var energy: Int
  var description: String {
    return("Shield: \(power) power")
  }
  init (energy: Int) {
    self.action = .ShieldAction
		self.energy = energy
    self.power = energy * Constants.shieldPowerMultiple
  }
}

extension TankLand {
  func doSetShieldAction(tank: Tank, shieldAction: PreAction) -> Bool {  
        if shieldAction.action != .ShieldAction { return false }
        let shieldAction = shieldAction as! ShieldAction
        let cost = shieldAction.energy
        guard tank.energy > cost else {
            print("SHIELD FAILED...\(tank.id) DOES NOT HAVE ENOUGH ENERGY")
            addLog(cmd: "\(tank.id) cannot set shields because it does not have enough energy")
            return false
        }
        print("\(tank.id) set shields to \(shieldAction.power). Cost: \(cost)")
        tank.chargeEnergy(cost)
        tank.setShield(cost * Constants.shieldPowerMultiple)
		
        print("\(tank.id) SET SHIELD TO \(cost * Constants.shieldPowerMultiple)")
        addLog(cmd: "\(tank.id) SET SHIELD TO \(cost * Constants.shieldPowerMultiple)")
        return true
  }
}