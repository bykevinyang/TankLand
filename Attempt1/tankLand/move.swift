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

//ethan's also funky move func
extension TankLand{
  func move(gameObject: GameObject, action: MoveAction) {

        //if let unwrappedGO = gameObject {
          //changes position of tank
          if gameObject.type == .Tank {
            //checck the different directions it can move
            if action.direction == .North {
              var ogROW = gameObject.position.row
              var ogCOL = gameObject.position.col
              var ugoROW = gameObject.position.row
              var ugoCOL = gameObject.position.col
              ugoROW -= action.distance
              
              //first checks if row is possible
              if ((ugoROW > 0 && ugoROW < 14) || ugoROW == 0 || ugoROW == 14) {
                //then checks if col is possible
                if ((ugoCOL > 0 && ugoCOL < 14) || ugoCOL == 0 || ugoCOL == 14) {
                  //then checks if there is something already in the spot the tank is about to move into
                  if let something = self[ugoROW, ugoCOL] {
                    //if yes, tank does not move
                    if something.type == .Mine {
                      var somethingAsMine = something as! Mine
                      gameObject.chargeEnergy(somethingAsMine.energy * Constants.mineStrikeMultiple)
                      print("\(gameObject) took \(somethingAsMine.energy * Constants.mineStrikeMultiple) damage")
                      self[ugoROW, ugoCOL] = nil
                      self[ogROW, ogCOL] = nil
                      self[ugoROW, ugoCOL] = gameObject
                      gameObject.chargeEnergy(Constants.costOfMovingTankPerUnitDistance[action.distance])
                    } else if something.type == .Tank {
                      ()
                    }
                    print("Cannot move to row:\(ugoROW), col:\(ugoCOL)")
                  } else {
                    //if no, tank moves
                    self[ogROW, ogCOL] = nil
                    self[ugoROW, ugoCOL] = gameObject
                    gameObject.chargeEnergy(Constants.costOfMovingTankPerUnitDistance[action.distance])
                    gameObject.setPosition(Position(ugoROW, ugoCOL))
                  }
                }
              }
            } else if action.direction == .East {
              // so on and so forth
              var ogROW = gameObject.position.row
              var ogCOL = gameObject.position.col
              var ugoROW = gameObject.position.row
              var ugoCOL = gameObject.position.col
              ugoCOL += action.distance
              
              //first checks if row is possible
              if ((ugoROW > 0 && ugoROW < 14) || ugoROW == 0 || ugoROW == 14) {
                //then checks if col is possible
                if ((ugoCOL > 0 && ugoCOL < 14) || ugoCOL == 0 || ugoCOL == 14) {
                  //then checks if there is something already in the spot the tank is about to move into
                  if let something = self[ugoROW, ugoCOL] {
                    //if yes, tank does not move
                    if something.type == .Mine {
                      var somethingAsMine = something as! Mine
                      gameObject.chargeEnergy(somethingAsMine.energy * Constants.mineStrikeMultiple)
                      print("\(gameObject) took \(somethingAsMine.energy * Constants.mineStrikeMultiple) damage")
                      self[ugoROW, ugoCOL] = nil
                      self[ogROW, ogCOL] = nil
                      self[ugoROW, ugoCOL] = gameObject
                      gameObject.chargeEnergy(Constants.costOfMovingTankPerUnitDistance[action.distance])
                    } else if something.type == .Tank {
                      ()
                    }
                    print("Cannot move to row:\(ugoROW), col:\(ugoCOL)")
                  } else {
                    self[ogROW, ogCOL] = nil
                    self[ugoROW, ugoCOL] = gameObject
                    gameObject.chargeEnergy(Constants.costOfMovingTankPerUnitDistance[action.distance])
                    gameObject.setPosition(Position(ugoROW, ugoCOL))
                  }
                }
              }
            } else {
							
						}

  	//} else if gameObject.type = .Rover {

    //}
	}
  }
	func roverMove(gameObject: GameObject) {
		if gameObject.type == .Rover {
			let rover = gameObject as! Rover
			if let roverDirection = rover.mineAction.moveDirection {
				let moveAction = MoveAction(distance: 1, direction: roverDirection)
				move(gameObject: gameObject, action: moveAction)
        // if ((ugoROW > 0 && ugoROW < 14) || ugoROW == 0 || ugoROW == 14) {
        //   //then checks if col is possible
        //   if ((ugoCOL > 0 && ugoCOL < 14) || ugoCOL == 0 || ugoCOL == 14) {
            
        //   }
        // }  
			}
		}
	}
	
}
