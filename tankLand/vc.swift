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

    func test() {
       let test1 = TestTank(id: "T1", position: Position(5,5), instructions: "Hi")
       let test2 = TestTank(id: "T2", position: Position(2, 3), instructions: "Hi")
       tankLand.addGameObject(test1)
       tankLand.addGameObject(test2)
    }

	func run() -> Void {
        test() 
        tankLand.printGrid()
		print("Enter Turns to Run: ", terminator: "")
		var input = readLine()
        var turns = 0
		if var command = input {
			while command != "quit" {
				if command == "run" {
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
                        print("TURN \(turns):")
                        tankLand.doTurn()
                        tankLand.printGrid()
                        turns += 1 
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