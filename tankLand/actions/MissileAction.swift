import Foundation

struct MissileAction: PostAction {
    var action: ActionType
    var energy: Int
    // var sendersender: GameObject
    var position: Position
    var damage: Int
        
    init (energy: Int, position: Position) {   
    self.action = .MissileAction
    self.energy = energy
    // self.sender = sender
    self.position = position
        self.damage = energy * Constants.missileStrikeMultiple
    }

    var description: String {
        return "\(self.action) \(self.energy) \(self.position)"
    }
}

extension TankLand {
    // FIX BRAKCET PROBLEM
    func sendMissile(tank: Tank, missileAction: PostAction ) -> (Bool, Bool) { // Returns (Succes o f missle launch, whether or not something died b/c of it)
        print("HERE BEFOE SEND MISSILE UNWRAP")
        if missileAction.action != .MissileAction { return (false, false) }
        print("HERE IN MISSILE ACTION")
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
            print("MISSLE FAILED...\(tank.id) DOES NOT HAVE ENOUGH ENERGY")
            return (false, false)
        }
        tank.chargeEnergy(cost)

            // ADD IN DAMAGING PART FOR SENDMISSILE
        let currentRow = missileAction.position.row
        let currentCol = missileAction.position.col
        print("\(tank) sent a missile to \(missileAction.position) and used \(cost) energy")
        for rowShift in -1...1 {
            for colShift in -1...1 {
                if let object = self[currentRow + rowShift, currentCol + colShift] {
                    if object.position == missileAction.position { // Direct Hit
                        let ogEnergy = object.energy
                        let damage = missileAction.energy * Constants.missileStrikeMultiple
                        object.chargeEnergy(damage)
                        //removes GO from grid is it has <=0 energy
                        if !checkLife(gameObject: object) {
                            self.removeGameObject(object)
                            tank.gainEnergy(ogEnergy / 4)
                            print("\(object) was hit with direct \(damage) and died")
                            return (true, true)
                            print("\(object) was hit with direct \(damage) and died")
                        }
                    } else { // Collat Hit
                        let damage = cost*Constants.missileStrikeMultipleCollateral
                        let ogEnergy = object.energy
                        object.chargeEnergy(damage)	
                        if !checkLife(gameObject: object) {
                            print("\(object) was hit with collateral \(damage) and died")
                            return (true, true)
                        } else {
                            print("\(object) was hit with collateral \(damage) and survived")
                            return (true, false)
                        }
                    }
                }
            }
        }
        return (true, false)
    }
}  