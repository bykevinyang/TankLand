struct MoveAction: PostAction {
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

func outOfBounds(row: Int, col: Int) -> Bool {
  if ((row > 0 && row < 14) || (row == 0 || row == 14)) && ((col > 0 && col < 14) || col == 0 || col == 14) {
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
        
				let vector = DirectionToVectorMove[moveAction.direction ?? .North]!
        let nextROW = vector.0 * moveAction.distance + ogROW
        let nextCOL = vector.1 * moveAction.distance + ogCOL
       
          //check if tank has enough energy to move
          
					if !(moveAction.distance - 1 >= 0 && moveAction.distance - 1 <= 2) {
						print("Invalid move amount: \(moveAction.distance)")
						return (false, false)
					}

          if gameObject.energy <= (Constants.costOfMovingTankPerUnitDistance[moveAction.distance - 1]) { 
            print("\(gameObject.id) does not have enough energy to move"); return (false, false) 
          }
					
          //check if tank is going to move out of bounds
          if outOfBounds(row: nextROW, col: nextCOL) == true { 
            print("\(gameObject.id) cannot move because it will be out of bounds"); addLog(cmd: "\(gameObject.id) cannot move because it will be out of bounds"); return (false, false) 
          }
          
          // Check if there is something in spot already, different things will happen for tank, rover/mine, or nothing in the new spot
   
          if let occupyingGO = self[nextROW, nextCOL] {
              //if it's a tank, tank will not move
              if occupyingGO.type == .Tank 
              { print("\(gameObject) cannot move because there is a tank in the new spot"); addLog(cmd: "\(gameObject.id) cannot move because there is a tank in the new spot" ); return (false, false) }
              if occupyingGO.type == .Mine || occupyingGO.type == .Rover {
                  //charge cost of moving
                  gameObject.chargeEnergy(Constants.costOfMovingTankPerUnitDistance[moveAction.distance - 1])
              
                  // Remove whatever was in the desiered destination
                  self[nextROW, nextCOL] = nil
                  // Remove the old spot
                  self[ogROW, ogCOL] = nil
                  
                  // Check if tank is still alive after mine/rover blows up
                  let damage = gameObject.chargeDamage(damage: occupyingGO.energy * Constants.mineStrikeMultiple)

                  if checkLife(gameObject: gameObject) == false 
                  { print("Mine/Rover \(occupyingGO.id) blew up \(gameObject.id)"); addLog(cmd: "Mine/Rover \(occupyingGO.id) blew up \(gameObject.id)"); return (false, true) }
                  print("\(gameObject.id) tanked the damage from mine/rover \(occupyingGO.id)")
                  self[nextROW, nextCOL] = gameObject
                  gameObject.setPosition(Position(nextROW, nextCOL))
                  return (true, false)
              }
          }
      
        //just move to spot if there is nothing there
        gameObject.chargeEnergy(Constants.costOfMovingTankPerUnitDistance[moveAction.distance - 1])

        gameObject.setPosition(Position(nextROW, nextCOL))
        self[nextROW, nextCOL] = gameObject
        self[ogROW, ogCOL] = nil
        print("\(gameObject.id) moved to \(nextROW),\(nextCOL)")
        addLog(cmd: "\(gameObject.id) moved to \(nextROW),\(nextCOL)")
    } else if gameObject.type == .Rover {
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

                gameObject.chargeEnergy(Constants.costOfMovingRover)
                
                // Cost of blowing up
                let damage = occupyingGO.chargeDamage(damage: rover.energy * Constants.mineStrikeMultiple)

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
            print("\(gameObject.id) moved to (\(nextROW),\(nextCOL))")
            addLog(cmd: "\(gameObject.id) moved to (\(nextROW),\(nextCOL))")
            return (true, false)
    }
    return (false, false)
    }
}



// extension TankLand {
//   func move (gameObject: GameObject, action: PostAction? = nil) -> (Bool, Bool) { // Returns a (Bool, Bool) that represents (Move Success, If Something Blew Up)
//     let postAction = action
//     let moveAction: MoveAction = postAction as! MoveAction
//         // Orginal position
//         let ogROW = gameObject.position.row
//         let ogCOL = gameObject.position.col
//         // New desired position
//         let vector = DirectionToVectorMove[moveAction.direction ?? .North]!
//         let nextROW = vector.0 * moveAction.distance + ogROW
//         let nextCOL = vector.1 * moveAction.distance + ogCOL
//     //checks if you can even move to the next spot
//     if outOfBounds(row: nextROW, col: nextCOL) == true {
//       print("Can't more to that spot because it will be out of bounds")
//       return (false, false)
//     } else {
//       if gameObject.type == .Tank && action != nil {
//         if gameObject.energy <= (Constants.costOfMovingTankPerUnitDistance[moveAction.distance - 1]) { 
//           print("\(gameObject.id) does not have enough energy to move"); return (false, false) 
//         } else {
//           print("DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG")
//           if let occupyingGO = self[nextROW, nextCOL] {
//             print("DEBUG 2 DEBUG 2 DEBUG 2 DEBUG 2 DEBU 2G DEBUG 2")
//             if occupyingGO.type == .Tank {
//               print("\(gameObject) cannot move because there is a tank in the new spot"); addLog(cmd: "\(gameObject.id) cannot move because there is a tank in the new spot" ); return (false, false) 
//             } else if occupyingGO.type == .Mine || occupyingGO.type == .Rover {
//               gameObject.chargeEnergy(Constants.costOfMovingTankPerUnitDistance[moveAction.distance])
//               self[nextROW, nextCOL] = nil
//               self[ogROW, ogCOL] = nil
//               let damage = gameObject.chargeDamage(damage: occupyingGO.energy * Constants.mineStrikeMultiple)
//               if checkLife(gameObject: gameObject) == false {
//                 print("Mine/Rover \(occupyingGO.id) blew up \(gameObject.id)"); addLog(cmd: "Mine/Rover \(occupyingGO.id) blew up \(gameObject.id)"); return (false, true) 
//               } else {
//                 print("\(gameObject.id) tanked the damage from mine/rover \(occupyingGO.id)")
//                 self[nextROW, nextCOL] = gameObject
//                 gameObject.setPosition(Position(nextROW, nextCOL))
//                 return (true, false)
//               }
//             } else {
//               ()
//             }
//           } else {
//             gameObject.chargeEnergy(Constants.costOfMovingTankPerUnitDistance[moveAction.distance])
//             gameObject.setPosition(Position(nextROW, nextCOL))
//             self[nextROW, nextCOL] = gameObject
//             self[ogROW, ogCOL] = nil
//             addLog(cmd: "\(gameObject.id) moved to \(nextROW),\(nextCOL)")
//           }
//         }
//       } else if gameObject.type == .Rover {
//         let mine: Mine = gameObject as! Mine
//         let mineAction = mine.mineAction
//         let rover: Rover = gameObject as! Rover

//         if gameObject.energy <= (Constants.costOfMovingRover) {
//           print("\(gameObject.id) does not have enough energy to move"); addLog(cmd: "\(gameObject.id) does not have enough energy to move"); return (false, false)
//         } else {
//           if let occupyingGO = self[nextROW, nextCOL] {
//             self[ogROW, ogCOL] = nil
//             let damage = occupyingGO.chargeDamage(damage: rover.energy * Constants.mineStrikeMultiple)
//             print("\(gameObject.id) blew up and damaged \(occupyingGO.id) with \(damage)")
//             addLog(cmd: "\(gameObject.id) blew up and damaged \(occupyingGO.id) with \(damage)")
//             if checkLife(gameObject: occupyingGO) == false {
//               print("Mine/Rover \(gameObject.id) blew up \(occupyingGO.id)")
//               addLog(cmd: "Mine/Rover \(occupyingGO.id) blew up \(gameObject.id)")
//               self[nextROW, nextCOL] = nil
//               addLog(cmd: "\(occupyingGO.id) had 0 energy and died")
//               return (true, true) 
//             }
//           } else {
//             gameObject.chargeEnergy(Constants.costOfMovingRover)
//             gameObject.setPosition(Position(nextROW, nextCOL))
//             self[nextROW, nextCOL] = gameObject
//             self[ogROW, ogCOL] = nil
//             print("\(gameObject.id) moved to (\(nextROW),\(nextCOL))")
//             addLog(cmd: "\(gameObject.id) moved to (\(nextROW),\(nextCOL))")
//             return (true, false)
//             }
//           }
//         }
//       }
//       return(false, false)
//     }
//   }
