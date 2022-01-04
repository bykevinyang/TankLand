struct MoveAction: PostAction {
    //let action: ActionType
    let action: ActionType
    let distance: Int
    let direction: Direction
    var description: String {
        return "\(action) \(distance) \(direction)"
    }
    
    init(distance: Int, direction: Direction){
        action = .Move
        self.distance = distance
        self.direction = direction
    }
}
extension TankLand {
  func checkLife(gameObject: GameObject) -> Bool {
    if gameObject.energy <= 0 {
			return false
    } else {
			return true
		}
  }
}

//ethan's also funky move func
func outOfBounds(row: Int, col: Int) -> Bool {
  if ((row > 0 && row < 14) || row == 0 || row == 14) && ((col > 0 && col < 14) || col == 0 || col == 14) {
    return false
  } else {
    return true
  }
}
extension TankLand {
  func move(gameObject: GameObject, action: PostAction? = nil) -> (Bool, Bool) { // Returns a (Bool, Bool) that represents (Move Success, If Something Blew Up)
    if gameObject.type == .Tank && action != nil {
        let postAction = action
        let moveAction: MoveAction = postAction as! MoveAction

        // Orginal position
        let ogROW = gameObject.position.row // Orginal row
        let ogCOL = gameObject.position.col // Orginal col

        // New desired position
        let nextROW = (DirectionToVectorMove[moveAction.direction]!.0 * moveAction.distance + ogROW)
        let nextCOL = (DirectionToVectorMove[moveAction.direction]!.1 * moveAction.distance + ogCOL)
        //check if tank has enough energy to move
        
        if gameObject.energy <= (Constants.costOfMovingTankPerUnitDistance[moveAction.distance]) 
        { print("\(gameObject.id) does not have enough energy to move"); return (false, false) }

        //check if tank is going to move out of bounds
        if outOfBounds(row: nextROW, col: nextCOL) == true { print("\(gameObject.id) cannot move because it will be out of bounds"); addLog(cmd: "\(gameObject.id) cannot move because it will be out of bounds"); return (false, false) }
          
        // Check if there is something in spot already, different things will happen for tank, rover/mine, or nothing in the new spot
        if let occupyingGO = self[nextROW, nextCOL] {
            //if it's a tank, tank will not move
            if occupyingGO.type == .Tank 
            { print("\(gameObject) cannot move because there is a tank in the new spot"); addLog(cmd: "\(gameObject.id) cannot move because there is a tank in the new spot" ); return (false, false) }
            if occupyingGO.type == .Mine || occupyingGO.type == .Rover {
                //charge cost of moving
                gameObject.chargeEnergy(Constants.costOfMovingTankPerUnitDistance[moveAction.distance])
            
                // Fix this:
                // Remove whatever was in the desiered destination
                self[nextROW, nextCOL] = nil
                // Remove the old spot
                self[ogROW, ogCOL] = nil
                
                // Check if tank is still alive after mine/rover blows up
                let damage = occupyingGO.energy * Constants.mineStrikeMultiple
                gameObject.chargeEnergy(damage)
                if checkLife(gameObject: gameObject) == false 
                { print("Mine/Rover \(occupyingGO.id) blew up \(gameObject.id)"); addLog(cmd: "Mine/Rover \(occupyingGO.id) blew up \(gameObject.id)"); return (false, true) }
                print("\(gameObject.id) tanked the damage from mine/rover \(occupyingGO.id)")
                self[nextROW, nextCOL] = gameObject
                return (true, false)
            }
        }   
        //just move to spot if there is nothing there
        gameObject.chargeEnergy(Constants.costOfMovingTankPerUnitDistance[moveAction.distance])
        gameObject.setPosition(Position(nextROW, nextCOL))
        self[nextROW, nextCOL] = gameObject
        self[ogROW, ogCOL] = nil
        //print("\(gameObject.id) moved to \(nextROW),\(nextCOL)")
        addLog(cmd: "\(gameObject.id) moved to \(nextROW),\(nextCOL)")
    }
        else if gameObject.type == .Rover {
            //print("TRYING TO MOVE A ROVER")
            let mine: Mine = gameObject as! Mine
            let mineAction = mine.mineAction

            let rover: Rover = gameObject as! Rover

            // Orginal position
            let ogROW = gameObject.position.row // Orginal row
            let ogCOL = gameObject.position.col // Orginal col

            let direction = mineAction.moveDirection
            // New desired position
            let nextROW = (DirectionToVectorMove[direction ?? .North]!.0 + ogROW) // If no direction is specified, default to north
            let nextCOL = (DirectionToVectorMove[direction ?? .North]!.1 + ogCOL)

            // Check if tank has enough energy to move
            if gameObject.energy <= (Constants.costOfMovingRover) 
            { print("\(gameObject.id) does not have enough energy to move"); addLog(cmd: "\(gameObject.id) does not have enough energy to move"); return (false, false) }
            
            // Check if there is something in spot already, different things will happen for tank, rover/mine, or nothing in the new spot
            if outOfBounds(row: nextROW, col: nextCOL) == true { print("\(gameObject.id) cannot move because it will be out of bounds"); return (false, false) }

            if let occupyingGO = self[nextROW, nextCOL] {
                //print("THERE IS AN OBJECT IN THE SPOT")
            
                gameObject.chargeEnergy(Constants.costOfMovingRover)
                //if it's a tank, rover moves into tank and explodes
                let damage = rover.energy * Constants.mineStrikeMultiple
                occupyingGO.chargeEnergy(damage) // Damage whatever was there
                print("\(gameObject.id) blew up and damaged \(occupyingGO.id) with \(damage)")
                addLog(cmd: "\(gameObject.id) blew up and damaged \(occupyingGO.id) with \(damage)")
                if checkLife(gameObject: occupyingGO) == false {
                    print("Mine/Rover \(occupyingGO.id) blew up \(gameObject.id)")
                    addLog(cmd: "Mine/Rover \(occupyingGO.id) blew up \(gameObject.id)")
                    self.removeGameObject(occupyingGO)
                    addLog(cmd: "\(occupyingGO.id) had 0 energy and died")
                    self.removeGameObject(gameObject) // Delete rover from board since it blew up
                    return (true, true) 
                }
                self.removeGameObject(gameObject) // Delete rover from board since it blew up
                return (true, false)
            }
            //just move to spot if there is nothing there
            gameObject.chargeEnergy(Constants.costOfMovingRover)
            gameObject.setPosition(Position(nextROW, nextCOL))
            self[nextROW, nextCOL] = gameObject
            self[ogROW, ogCOL] = nil
            print("\(gameObject.id) moved to \(nextROW),\(nextCOL)")
            addLog(cmd: "\(gameObject.id) moved to \(nextROW),\(nextCOL)")
            return (true, false)
        }
    return (false, false)
    }
}





// extension TankLand {
//     // Move function for all gameobjects.
//     // Takes in an action, will return a bool on the success of that move
//   func move(gameObject: GameObject, action : PostAction? = nil) -> Bool {

//     var ogGameObject: GameObject = gameObject
//     if gameObject.type == .Tank && action != nil {
// 			let postAction = action
//       let moveAction: MoveAction = postAction as! MoveAction

//       ogROW = gameObject.position.row // Orginal row
//       ogCOL = gameObject.position.col // Orginal col
  
//       nextROW += (DirectionToVectorMove[moveAction.direction]!.0 * moveAction.distance + ogROW)
//       nextCOL += (DirectionToVectorMove[moveAction.direction]!.1 * moveAction.distance + ogCOL)

//       //checks if new coor is out of bounds
//         if outOfBounds(row: nextROW, col: nextCOL) == true {
//           print("\(gameObject.id): Cannot move because it's out of bounds")
//         } else {
//           //checks if there's already a GO in the new coor
//           if let occupyingGO = self[nextROW, nextCOL] {
//             //if it's a tank, tank will not move
//             if occupyingGO.type == .Tank {
//               print("Cannot move becase there is a tank in the spot")
//             //if it's a mine, tank will move and take dmg  
//             } else if occupyingGO.type == .Mine {
//               self[nextROW, nextCOL] = gameObject
//               self[ogROW, ogCOL] = nil
//               gameObject.setPosition(Position(nextROW, nextCOL))
//               let damageTaken = occupyingGO.energy * Constants.mineStrikeMultiple + Constants.costOfMovingTankPerUnitDistance[moveAction.distance]
//               gameObject.chargeEnergy(damageTaken)
//               print("\(gameObject.id) moved to \(nextROW),\(nextCOL) and took \(damageTaken) damage")
              
//               if checkLife(gameObject: gameObject) == false {
//                 self[gameObject.position.row, gameObject.position.col] = nil
//               }
//             } else {
//               ()
//             }
//           } else { 
//             self[ogROW, ogCOL] = nil
//             self[nextROW, nextCOL] = gameObject
//             gameObject.setPosition(Position(nextROW, nextCOL))
//             print("\(gameObject.id) moved to \(nextROW),\(nextCOL)")
//             if checkLife(gameObject: gameObject) == false {
//               self[gameObject.position.row, gameObject.position.col] = nil
//             }
//           }
//         }
//       ogCOL = 0
//       ogROW = 0
//       nextCOL = 0
//       nextROW = 0
//     } else if gameObject.type == .Rover {
//         ogROW = gameObject.position.row // Orginal row
//         ogCOL = gameObject.position.col // Orginal col

//         let rover = gameObject as! Rover

//         nextROW += (DirectionToVectorMove[rover.mineAction.moveDirection ?? .North]!.0 + ogROW)
//         nextCOL += (DirectionToVectorMove[rover.mineAction.moveDirection ?? .North]!.1 + ogCOL)

//         //checks if new coor is out of bounds
//         if outOfBounds(row: nextROW, col: nextCOL) == true {
//             print("Cannot move because it's out of bounds")
//         } else {
//             //checks if there's already a GO in the new coor
//             if let occupyingGO = self[nextROW, nextCOL] {
//                 //if it's a tank
//                 if occupyingGO.type == .Tank {
//                     occupyingGO.chargeEnergy(gameObject.energy * Constants.mineStrikeMultiple)
//                     self[ogROW, ogCOL] = nil
//                     print("\(gameObject.id) hit a tank and died")
//                     if !checkLife(gameObject: occupyingGO) {
// 											self[nextROW, nextCOL] = nil
// 										}
//                     if self[nextROW, nextCOL] == nil {
//                       print("\(occupyingGO.id) died")
//                     }
//                 //if it's a mine/rover
//                     } else if occupyingGO.type == .Mine || occupyingGO.type == .Rover { // Ask Mr.P if we rovers can explode other rovers
//                     occupyingGO.chargeEnergy(gameObject.energy * Constants.mineStrikeMultiple)
//                     self[ogROW, ogCOL] = nil
//                     print("\(gameObject.id) hit a mine/rover and died")
//                     checkLife(gameObject: occupyingGO)
//                     if self[nextROW, nextCOL] == nil {
//                       print("\(occupyingGO.id) died")
//                     }
//                 }
//             } else { 
//                 self[ogROW, ogCOL] = nil
//                 self[nextROW, nextCOL] = gameObject
//                 gameObject.setPosition(Position(nextROW, nextCOL))
//                 print("\(gameObject.id) moved to \(nextROW),\(nextCOL)")
//                 checkLife(gameObject: gameObject)
//             }
//         }
//         ogCOL = 0
//         ogROW = 0
//         nextCOL = 0
//         nextROW = 0
//         }
//     return false
//   }
// }


//kevin's funky move func

// extension TankLand {
// 	func move(gameObject: GameObject, moveAction: MoveAction, isRover: Bool = false) {
// 		if isRover == false {
// 			var position = gameObject.position
// 			let row = position.row
// 			let col = position.col

// 			var direction = moveAction.direction
// 			let distance = moveAction.distance
			
// 			if let moveAmount = DirectionToVectorMove[direction] * (distance, distance) {
// 				// do adding here
// 			} 

// 		}
// 		else{
// 			// Then it is a rover
// 			let rover = gameObject as! Rover
// 			if isRover != nil {
// 				let position = gameObject.position
// 				let row = position.row
// 				let col = position.col

// 				if let direction = rover.mineAction.moveDirection {
// 					if let moveAmount = DirectionToVectorMove[direction] {
// 						let addRow = moveAmount.0
// 						let addCol = moveAmount.1
// 						let newRow = row + addRow
// 						let newCol = col + addCol
// 						print(newRow, newCol) 
// 					}
// 				}
// 				// Fix here
						
// 			} else {
// 				// Raise an error
// 				print("Not a rover")
// 			}
// 		}
// 	}
// }
