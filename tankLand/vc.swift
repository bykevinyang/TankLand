class ViewController {
	var tankLand = TankLand(15,15)

	func run() {
    let smplTank2 = SmplTank(id: "TSIMP2", position: Position(5,4), instructions: "Hi")
    let smplTank3 = SmplTank(id: "TSIMP3", position: Position(7,7), instructions: "Hi")
    let stupidTank = DumbTank(id: "DUMB", position: Position(8, 9), instructions: "BETTER WORK")
    tankLand.addGameObject(smplTank2)
    tankLand.addGameObject(smplTank3)
		tankLand.printGrid()
    // tankLand.addGameObject(stupidTank)
		print("Enter Turns to Run: ", terminator: "")
		var input = readLine()
		if var command = input {
			while command != "quit" {
				if command == "run" {
					while !tankLand.gameOver {
						tankLand.doTurn()
						tankLand.printGrid()
					}
				}
				var cycles = Int(command)!
				for i in 0..<cycles {

					print(tankLand.getAllTanks())
					tankLand.doTurn()
					tankLand.printGrid()
				}
				print("Enter Turns to Run: ", terminator: "")
				command = readLine()!
			}
		}
	}

}