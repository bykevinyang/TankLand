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
    
   
    // func doTurn(){
    //     var allObjects = findAllGameObjects()
    //     allObjects = randomizeGameObjects(gameObjects: allObjects)
        
 	//all the code needed to run a single turn goes here
//many for loops as we will discuss in class
    //     turn += 1
    // }
    
   
//     func runGame(){
//         populateTankLand()
//         printGrid()
//         while !gameOver {
//          //This while loop is the driver for TankLand      
// }
//         print("****Winner is...\(lastLivingTank!)")
//     }
}
