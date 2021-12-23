//The TankLand Class runs the TankLand game. The class is large enough that it is
//factored into three separate files using Swift extension:
//TankLand - holds the grid, all properties, and runs the turns
//TankLandSupport - contains the most important helper methods
//TankLandDisplay contains the code that prints the grid
//TankLandActions contains the code that implements the actions; the most complex code in TankLand

class TankLand {
    var grid: [[GameObject?]]
    var turn : Int
		let numberCols: Int
		let numberRows: Int
    var messageCenter: [String:String]

		var gameOver = false
		var lastLivingTank: GameObject?
	  //Other useful properties go here
   
    init(_ numberRows: Int, _ numberCols: Int){
			self.numberCols = numberCols
			self.numberRows = numberRows	
			self.messageCenter = [:]
			self.lastLivingTank = nil
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
				guard isOnGrid(row: row, col: col) else {return nil}
				return grid[row][col]
			}
  	}
	
    func setWinner(lastTankStanding: Tank){
        gameOver = true
        lastLivingTank = lastTankStanding
    }
    
    func populateTankLand(_ objects: [GameObject]){
			for gameObject in objects {
				let randomRow = Int.random(in: 0..<self.numberRows)
				let randomCol = Int.random(in: 0..<self.numberCols)

				// CONTINUE WORKING ON THIS LATER
			}
        //Sample
        //addGameObject( gameObject: MyTank(row: 2, col: 2, energy: 20000, id: "T1", instructions: ""))
    }
    
    func addGameObject(_ gameObject: GameObject){
			self[gameObject.position.row, gameObject.position.col] = gameObject
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
          } else {
            ()
          }
        }
      }
	  }
		return (tanks, mines, rovers)
  }

  func doTurn() {
    // Charge life support
		let objects = getAllObjects()		// Returns tuple of ([Tanks], [Mine], [Rover])
		for tank in objects.0 {
 			tank.chargeEnergy(Constants.costLifeSupportTank)
		}
		for mine in objects.1 {
			mine.chargeEnergy(Constants.costLifeSupportMine)
		}
		for rover in objects.2 {
			rover.chargeEnergy(Constants.costLifeSupportRover)
		}

		// Move the rovers
    let livingRovers = objects.2
    for r in livingRovers {
			//fakeMoveAction = MoveAction(distance: 2, direction: .North)
			print(r)
			//move(r, fakeMoveAction, rover: true)
			// Move the rover
		}

		// Do Pre-Actions
		for tank in objects.0 {
			for (actionType, preAction) in tank.preActions {
				
			}
		}

		// Do Post-Actions  
    for tank in objects.0 {
			tank.computePostActions()
		}
	}


		// let actionsToFunc [
		// .RadarAction: self.runRader,
		// .DropRover: self.DropRover,
		// .DropMine: self.DropMine,
		// .SendMissile: self.SendMissile,
		//		// .SendMessage
		// .Move: self.move,
		// .ShieldAction: self.doSetShieldAction
		// ]

// enum ActionType {
//   case RadarAction
//   case DropRover
// 	case DropMine
// 	case SendMissile
//   case SendMessage
//   case ReceiveMessage
//   case MissileAction
//   case Move
//   case ShieldAction
// }

}
