import Foundation

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
    func sendMissile(tank: Tank, missileAction: PostAction ) -> Bool {
        if missileAction.action != .SendMissile { return false }
        let missileAction = missileAction as! MissileAction
        //calculating distance
        var distance: Int = 0
        distance += (missileAction.position.row - tank.position.row) * (missileAction.position.row - tank.position.row)
        distance += (missileAction.position.col - tank.position.col) * (missileAction.position.col - tank.position.col)
        var distanceAsDouble: Double = 0
        distanceAsDouble = sqrt(distanceAsDouble)
        distance = Int(distanceAsDouble)
        //calculating cost
        let cost = Constants.costOfLaunchingMissile + distance * 200
        guard tank.energy > cost else {
            print("SHIELD FAILED...\(tank.id) DOES NOT HAVE ENOUGH ENERGY")
            return false
        }
        tank.chargeEnergy(cost) 

            // ADD IN DAMAGING PART FOR SENDMISSILE
        let currentRow = missileAction.position.row
            let currentCol = missileAction.position.col
        print("\(tank) sent a missile to \(missileAction.position) and used \(cost) energy")
        for rowShift in -1...1 {
            for colShift in -1...1 {
                if let object = self[currentRow + rowShift, currentCol + colShift] {
                    if object.position == missileAction.position {
                        let ogEnergy = object.energy
                        let damage = missileAction.energy * Constants.missileStrikeMultiple
                        object.chargeEnergy(damage)
                        //removes GO from grid is it has <=0 energy
                        if object.energy <= 0 {
                        self[missileAction.position.row, missileAction.position.col] = nil
                        tank.gainEnergy(ogEnergy / 4)
                                        print("\(object) was hit with direct \(damage) and died")	
                        }
                    } else {
                        let damage = cost*Constants.missileStrikeMultipleCollateral
                        let ogEnergy = object.energy
                                    object.chargeEnergy(damage)	
                        if object.energy <= 0 {
                        self[currentRow + rowShift, currentCol + colShift] = nil
                        tank.gainEnergy(ogEnergy / 4)
                                        print("\(object) was hit with collatral \(damage) and died")	
                        }
                    }
                }
            }
        }
        return true
    }
}  