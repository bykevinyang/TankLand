struct MoveAction: PostAction{
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
  func move(gameObject: GameObject, action: PostAction? = nil) {
    if gameObject.type == .Tank && action != nil {
      let postAction = action
      let moveAction: MoveAction = postAction as! MoveAction
      ogROW = gameObject.position.row // Orginal row
      ogCOL = gameObject.position.col // Orginal col
      nextROW += (DirectionToVectorMove[moveAction.direction]!.0 * moveAction.distance + ogROW) //posiiton that tank is going to move to
      nextCOL += (DirectionToVectorMove[moveAction.direction]!.1 * moveAction.distance + ogCOL) //posiiton that tank is going to move to
      //check if tank has enough energy to move
      if gameObject.energy <= (Constants.costOfMovingTankPerUnitDistance[moveAction.distance]) {
        print("\(gameObject.id) does not have enough energy to move")
      } else {
        //check if tank is going to move out of bounds
        if outOfBounds(row: nextROW, col: nextCOL) == true {
          print("\(gameObject.id) cannot move because it will be out of bounds")
        } else {
          //now the move
          //check if there is something in spot already, different things will happen for tank, rover/mine, or nothing in the new spot
          if let occupyingGO = self[nextROW, nextCOL] {
            //if it's a tank, tank will not move
            if occupyingGO.type == .Tank {
              print("\(gameObject) cannot move because there is a tank in the new spot")
            } else if occupyingGO.type == .Mine || occupyingGO.type == .Rover {
              //charge cost of moving
              gameObject.chargeEnergy(Constants.costOfMovingTankPerUnitDistance[moveAction.distance])
              self[nextROW, nextCOL] = nil
              self[ogROW, ogCOL] = nil
              //check if tank is still alive after mine/rover blows up
              let damage = occupyingGO.energy * Constants.mineStrikeMultiple
              gameObject.chargeEnergy(damage)
              if checkLife(gameObject: gameObject) == false {
                print("Mine/Rover \(occupyingGO.id) blew up \(gameObject.id)")
              } else {
                print("\(gameObject.id) tanked the damage from mine/rover \(occupyingGO.id)")
                self[nextROW, nextCOL] = gameObject
              }
            } else {
              //just move to spot if there is nothing there
              gameObject.chargeEnergy(Constants.costOfMovingTankPerUnitDistance[moveAction.distance])
              self[nextROW, nextCOL] = gameObject
              print("\(gameObject.id) moved to \(nextROW),\(nextCOL)")
            }
          }
        }
      }
    } else if gameObject.type == .Rover && action != nil {
      let postAction = action
      print("HERE")
      print(type(of: postAction))
      let moveAction = postAction as! MoveAction
      
      let rover = gameObject as! Rover
      //check if rover has enough energy to move
      if gameObject.energy <= Constants.costOfMovingRover {
            print("\(gameObject.id) does not have enough energy to move")
      } else {
            ogROW = gameObject.position.row // Orginal row
            ogCOL = gameObject.position.col // Orginal col
            nextROW += (DirectionToVectorMove[rover.mineAction.moveDirection ?? .North]!.0 + ogROW) //posiiton that tank is going to move to
            nextCOL += (DirectionToVectorMove[rover.mineAction.moveDirection ?? .North]!.1 + ogCOL) //
            //check if rover is going to move out of bounds
            if gameObject.energy <= (Constants.costOfMovingTankPerUnitDistance[moveAction.distance]) {
                print("\(gameObject.id) does not have enough energy to move")
            } else {
                //check if tank is going to move out of bounds
                if outOfBounds(row: nextROW, col: nextCOL) == true {
                    print("\(gameObject.id) cannot move because it will be out of bounds")
                } else {
                    //now the move
                    //check if there is something in spot already, different things will happen for tank, rover/mine, or nothing in the new spot
                    if let occupyingGO = self[nextROW, nextCOL] {
                        //if it's a tank, tank will not move
                        if occupyingGO.type == .Tank {
                            occupyingGO.chargeEnergy(Constants.mineStrikeMultiple * rover.energy)
                            print("\(gameObject) hit a tank, exploded with \(Constants.mineStrikeMultiple * rover.energy) damage")
                        } else if occupyingGO.type == .Mine || occupyingGO.type == .Rover {
                            print("SHOULD ROVER EXPLODE WHEN IT HITS A MINE?")
                        // does rover explode when it hits a mine or another rover?
                        }
                    } else {
                        //just move to spot if there is nothing there
                        gameObject.chargeEnergy(Constants.costOfMovingRover)
                        self[nextROW, nextCOL] = gameObject
                        print("\(gameObject.id) moved to \(nextROW),\(nextCOL)")
                        }   
                    }
                }
            }
        }
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
