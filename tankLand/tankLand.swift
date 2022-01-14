//The TankLand Class runs the TankLand game. The class is large enough that it is
//factored into three separate files using Swift extension:
//TankLand - holds the grid, all properties, and runs the turns
//TankLandSupport - contains the most important helper methods
//TankLandDisplay contains the code that prints the grid
//TankLandActions contains the code that implements the actions; the most complex code in TankLand

class TankLand {
    var ogROW: Int = 0
    var ogCOL: Int = 0
    var nextROW: Int = 0
    var nextCOL: Int = 0
    var grid: [[GameObject?]]
    var turn : Int
    let numberCols: Int
    let numberRows: Int
    var messageCenter: [String:String]

    var gameOver = false
    var lastLivingTank: GameObject?

    var numberTanksAdded = 0
   
    init(_ numberRows: Int, _ numberCols: Int) {
			self.numberCols = numberCols
			self.numberRows = numberRows	
			self.messageCenter = [:]
			self.lastLivingTank = nil
 
			grid = Array(repeating: Array(repeating: nil, count: numberCols), count: numberRows)
			turn = 0
    }

    func isOnGrid(row: Int, col: Int) -> Bool {
      return (row < self.numberRows) && (row >= 0) && (col < self.numberCols) && (col >= 0)
    }

    subscript(row: Int, col: Int) -> GameObject? {
			set {
				guard isOnGrid(row: row, col: col) else {return}
				grid[row][col] = newValue
    	}
        
			get {
				guard isOnGrid(row: row, col: col) else { return nil }
				return grid[row][col]
			}
  	}
	
    func setWinner(lastTankStanding: Tank) {
        gameOver = true
        lastLivingTank = lastTankStanding
    }

    func checkWinner() -> Bool {
        var remainingTanks = getAllObjects().0
        let alivePlayers = remainingTanks.count
        if alivePlayers <= 1 {
                if let remainingTank = remainingTanks.popFirst() {
                    setWinner(lastTankStanding: remainingTank)
                    print("Winner has been found!: \(remainingTank.id)")
                    // Note: This only works assuming that there were more than two tanks started on the board		
                    return true
                }
        }
        return false
    }

    func populateTankLand(_ objects: [GameObject]) {
			for gameObject in objects {
				let randomRow = Int.random(in: 0..<self.numberRows)
				let randomCol = Int.random(in: 0..<self.numberCols)
                gameObject.setPosition(Position(randomRow, randomCol))
                self.addGameObject(gameObject)
            }
    }
    
    func addGameObject(_ gameObject: GameObject) {
			self[gameObject.position.row, gameObject.position.col] = gameObject
            print("\(gameObject.id) has been added to the grid at position \(gameObject.position)")
	}
    
    func removeGameObject(_ gameObject: GameObject) {
            self[gameObject.position.row, gameObject.position.col] = nil
    }
	
    func getAllObjects() -> (Set<Tank>, Set<Mine>, Set<Rover>) {
		var tanks: Set<Tank> =  Set<Tank>()
		var mines : Set<Mine> =  Set<Mine>() 
		var rovers : Set<Rover> =  Set<Rover>() 
		for r in 0..<self.numberRows {
            for c in 0..<self.numberCols {
                if let object = self[r,c] {
                    if object.type == .Tank {
						let tank = object as! Tank
                        tanks.insert(tank)
                    } else if object.type == .Rover {
						let rover = object as! Rover
						rovers.insert(rover)
                } else if object.type == .Mine {
                    let mine = object as! Mine
                    mines.insert(mine)
                    }
                }
            }
	    }
		return (tanks, mines, rovers)
    }

		func getAllTanks() -> Set<Tank> {
			let objects = getAllObjects()
			return objects.0
		}
		
    func doTurn() -> Bool {
			if !gameOver {
				let objects = getAllObjects()		// Returns tuple of ([Tanks], [Mine], [Rover])
				
				var tanks: [Tank] = objects.0.shuffled()
				var mines: [Mine] = objects.1.shuffled()
				var rovers: [Rover] = objects.2.shuffled()

				var alivePlayers = tanks.count

				// Charge life support
        print("All objects charged life support")
				for tank in tanks { tank.chargeEnergy(Constants.costLifeSupportTank) }
				for mine in mines { mine.chargeEnergy(Constants.costLifeSupportMine) }
				for rover in rovers { rover.chargeEnergy(Constants.costLifeSupportRover) }

				var allObjects: [[GameObject]] = [tanks, mines, rovers]
        var needToFilter = false
				// Remove dead objects
				for (i, objects) in allObjects.enumerated() {
						for (j, object) in objects.enumerated() {
								if !checkLife(gameObject: object) {
                                        print("\(object.id) perished from life support charge")
                                        needToFilter = true
										removeGameObject(object)
                                        if self.checkWinner() {
                                            return true
                                        }
								}
						}
                        if needToFilter == true {
                            allObjects[i] = objects.filter { checkLife(gameObject: $0) }
                            needToFilter = false
                        }
				}
        
				for r in rovers {
					let result = self.move(gameObject: r, action: nil) 
          if type(of: result) == (Bool, Bool).self {
            let boolResult = result as! (Bool, Bool) 
            if boolResult.1 == true {
              if self.checkWinner() {
                return true
              }
            }
          }        
				}

				typealias PreActionFunc = (Tank, PreAction) -> Any
				typealias PostActionFunc = (Tank, PostAction) -> Any

				let preactionsToFunc: [ActionType: PreActionFunc] = [
						ActionType.RadarAction: self.runRadar,
						ActionType.ShieldAction: self.doSetShieldAction,
						ActionType.SendMessage: self.sendMessage,
						ActionType.ReceiveMessage: self.receiveMessage
				]

				let postactionsToFunc: [ActionType: PostActionFunc] = [
						ActionType.DropMine: self.dropMine,
						ActionType.DropRover: self.dropRover,
						ActionType.Move: self.move,
						ActionType.MissileAction: self.sendMissile,
				]

				// To set the order in which to conduct the post actions
				let orderOfPostActions: [ActionType] = [
						ActionType.DropMine,        // 1    
						ActionType.DropRover,       // 2
						ActionType.MissileAction,     // 3
						ActionType.Move,             // 4
				]

				// Compute PreActions
				for tank in tanks {
					tank.computePreActions()
				}

				// Do PreActions
				for tank in tanks {
						print(tank)
						for (actionType, preAction) in tank.preActions {
								if let actionFunc = preactionsToFunc[actionType] {
										print(actionFunc)	
										let result = actionFunc(tank, preAction)
								}
						}
				}

				// Compute PostActions
				for tank in tanks {
						for tank in objects.0 {
								tank.computePostActions()
						}
				}

				// Do PostActions
				for tank in tanks {
						for currentActionToExecute in orderOfPostActions { // To maintain the order in which to execute the post actions
								if let tankAction = tank.postActions[currentActionToExecute] {
										if let postAction = postactionsToFunc[currentActionToExecute] {
												let result = postAction(tank, tankAction) // Actual execution of the post action
												if type(of: result) == (Bool, Bool).self {
														let boolResult = result as! (Bool, Bool)
														if boolResult.1 == true {
															self.checkWinner()
															return false
														}
												}
										}
								}
						}
				}

						// Clear Post and Preactions 
				for tank in objects.0 {
            print("\(tank.id): \(tank.shield)")
					
						tank.preActions.removeAll()
						tank.postActions.removeAll()
				}
        checkWinner()
				return false
		} else {
			print("Game Over. \(lastLivingTank!.id) got that Victory Royale")
			return true
		}
	}
}
