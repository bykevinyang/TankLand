//The TankLand Class runs the TankLand game. The class is large enough that it is
//factored into three separate files using Swift extension:
//TankLand - holds the grid, all properties, and runs the turns
//TankLandSupport - contains the most important helper methods
//TankLandDisplay contains the code that prints the grid
//TankLandActions contains the code that implements the actions; the most complex code in TankLand

class TankLand {
    //var log: [String] = []
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
    //Other useful properties go here
   
    init(_ numberRows: Int, _ numberCols: Int) {
			self.numberCols = numberCols
			self.numberRows = numberRows	
			self.messageCenter = [:]
			self.lastLivingTank = nil
      //self.log = log
 
			grid = Array(repeating: Array(repeating: nil, count: numberCols), count: numberRows)
			turn = 0
 	//other init stuff
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
    
    func populateTankLand(_ objects: [GameObject]) {
			for gameObject in objects {
				let randomRow = Int.random(in: 0..<self.numberRows)
				let randomCol = Int.random(in: 0..<self.numberCols)

				// CONTINUE WORKING ON THIS LATER
			}
        //Sample
        //addGameObject( gameObject: MyTank(row: 2, col: 2, energy: 20000, id: "T1", instructions: ""))
    }
    
    func addGameObject(_ gameObject: GameObject) {
			self[gameObject.position.row, gameObject.position.col] = gameObject
			// Add logger message here!
	}
    
    func removeGameObject(_ gameObject: GameObject) {
            self[gameObject.position.row, gameObject.position.col] = nil
            // Add logger message here!
    }

//     func runGame(){
//         populateTankLand()
//         printGrid()
//         while !gameOver {
//          //This while loop is the driver for TankLand      
// }
//         print("****Winner is...\(lastLivingTank!)")
//     }
	func getAllObjects() -> ([Tank], [Mine], [Rover]) {
		var tanks : [Tank] = []
		var mines : [Mine] = []
		var rovers : [Rover] = []
		for r in 0..<self.numberRows {
            for c in 0..<self.numberCols {
                if let object = self[r,c] {
                    if object.type == .Tank {
						let tank = object as! Tank
                        tanks.append(tank)
                    } else if object.type == .Rover {
						let rover = object as! Rover
						rovers.append(rover)
                } else if object.type == .Mine {
                    let mine = object as! Mine
                    mines.append(mine)
                    }
                }
            }
	    }
		return (tanks, mines, rovers)
    }

    func doTurn() {
        let objects = getAllObjects()		// Returns tuple of ([Tanks], [Mine], [Rover])

        var tanks = objects.0
        var mines = objects.1
        var rovers = objects.2

        // Charge life support
        for tank in tanks { tank.chargeEnergy(Constants.costLifeSupportTank) }
        for mine in mines { mine.chargeEnergy(Constants.costLifeSupportMine) }
        for rover in rovers { rover.chargeEnergy(Constants.costLifeSupportRover) }

        var allObjects: [[GameObject]] = [tanks, mines, rovers]

        // Remove dead objects
        for (i, objects) in allObjects.enumerated() {
            for (j, object) in objects.enumerated() {
                if !checkLife(gameObject: object) {
                    removeGameObject(object)
                    allObjects[i].remove(at: j)
                }
            }
        }

        for r in rovers {
            print(r)
            self.move(gameObject: r, action: nil)
            self.printGrid()
        }

        typealias PreActionFunc = (Tank, PreAction) -> Any
        typealias PostActionFunc = (Tank, PostAction) -> Any

        let preactionsToFunc: [ActionType: PreActionFunc] = [
            ActionType.RadarAction: self.runRadar,
            ActionType.ShieldAction: self.doSetShieldAction
        ]

        let postactionsToFunc: [ActionType: PostActionFunc] = [
            ActionType.DropMine: self.dropMine,
            ActionType.DropRover: self.dropRover,
            ActionType.SendMissile: self.sendMissile,
            ActionType.Move: self.move
        ]

        // To set the order in which to conduct the post actions
        let orderOfPostActions: [ActionType] = [
            ActionType.DropMine,        // 1    
            ActionType.DropRover,       // 2
            ActionType.SendMissile,     // 3
            ActionType.Move,             // 4
        ]

            // Compute PreActions
        for tank in tanks {
            for tank in objects.0 {
                tank.computePreActions()
            }
        }

        // Do PreActions
        for tank in tanks {
            for (actionType, preAction) in tank.preActions {
                if let actionFunc = preactionsToFunc[actionType] {
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
                        print(result)
                    }
                }
            }
        }

            // Clear Post and Preactions 
        for tank in objects.0 {
            //print("Before Clear")	
            //print(tank.preActions)
            //print(tank.postActions)
            //print("After Clear")
            tank.preActions.removeAll()
            tank.postActions.removeAll()
            //print(tank.preActions)
            //print(tank.postActions)
        }
        printLog(log: log)
        log.removeAll()
        
    }
}
