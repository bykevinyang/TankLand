// //create board
// var test = TankLand(15,15)
// //create tanks
// var testTank = Tank(id: "T1", position: Position(6,0), instructions: "rn")
// // var testTank2 = Tank(id: "T2", position: Position(4,5), instructions: "Hi")
// // var testTank3 = Tank(id: "T3", position: Position(7,8), instructions: "Hi")
// //add tanks to boardtest.addGameObject(testTank)
// //test.addGameObject(testTank)
// //test.addGameObject(testTank2)
// //test.addGameObject(testTank3)
// //create some action structs

// // var mineAction = MineAction(power: 100, dropDirection: .North)
// // var mineAction2 = MineAction(power: 100, dropDirection: .South)
// // var shieldAction = ShieldAction(energy: 400)
// // var moveAction = MoveAction(distance: 2, direction: .East)
// // var moveAction2 = MoveAction(distance: 1, direction: .West)
// // var missileAction = MissileAction(energy: 80000, position: Position(7,7))

// // var roverMineAction = MineAction(power: 100, isRover: true, dropDirection: .NorthEast)

// // //make the tanks do the action structs
// // test.move(gameObject: testTank, action: moveAction)
// // test.printGrid()
// // print("DAD should have moved 2 to the right")
// // test.move(gameObject: testTank3, action: moveAction2)
// // print("Mom should have moved 1 to the left")
// // test.sendMissile(tank: testTank, missileAction: missileAction)
// // print("Hi")
// // let rover = test.dropRover(tank: testTank2, mineAction: roverMineAction)

// let smplTank = SmplTank(id: "TSIMP", position: Position(1,1), instructions: "Hi")
// test.addGameObject(smplTank)
// test.dropRover(tank: smplTank, mineAction: MineAction(power: 100000, isRover: true, dropDirection: .North, moveDirection: .South))
// let smplTank2 = SmplTank(id: "TSIMP2", position: Position(5,4), instructions: "Hi")
// let smplTank3 = SmplTank(id: "TSIMP3", position: Position(7,7), instructions: "Hi")
// let stupidTank = DumbTank(id: "DUMB", position: Position(8, 9), instructions: "BETTER WORK")
// test.addGameObject(smplTank2)
// test.addGameObject(smplTank3)
// test.addGameObject(stupidTank)
// test.printGrid()

// test.move(gameObject: smplTank, action: MoveAction(distance: 2, direction: .North))
// test.doTurn()
// test.printGrid()
// test.doTurn()
// test.printGrid()

// // for i in 0..<3 {
// // 	test.doTurn()
// // 	test.printGrid()
// // }

var game = ViewController()
game.run()