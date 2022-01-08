class ViewController {
	var tankLand = TankLand(15,15)

    func debugPopulation() {
        let smplTank2 = SmplTank(id: "TSIMP2", position: Position(5,4), instructions: "Hi")
        let smplTank3 = SmplTank(id: "TSIMP3", position: Position(7,7), instructions: "Hi")
        let stupidTank = DumbTank(id: "DUMB", position: Position(8, 9), instructions: "BETTER WORK")
        tankLand.addGameObject(smplTank2)
        tankLand.addGameObject(smplTank3)
        tankLand.addGameObject(stupidTank)
    }

	func run() -> Void {
        debugPopulation()
        tankLand.printGrid()
		print("Enter Turns to Run: ", terminator: "")
		var input = readLine()
		if var command = input {
			while command != "quit" {
				if command == "run" {
                    var turns = 0
					while !tankLand.gameOver {
                        print("TURN \(turns):")
						tankLand.doTurn()
						tankLand.printGrid()
                        turns += 1
					}
                    print("Game Over at turn \(turns)")
                    return
				}
				if let cycles = Int(command){
                    for i in 0..<cycles {

                        print(tankLand.getAllTanks())
                        tankLand.doTurn()
                        tankLand.printGrid()
                    }
                } else {
                    print("Enter a number of turns to run OR 'run' to fast forward")
                }
				print("Enter Turns to Run: ", terminator: "")
				command = readLine()!
			}
		}
	}

}