//create board
var test = TankLand(15,15)
//create tanks
var testTank = Tank(id: "T1", position: Position(6,0), instructions: "rn")
// var testTank2 = Tank(id: "T2", position: Position(4,5), instructions: "Hi")
// var testTank3 = Tank(id: "T3", position: Position(7,8), instructions: "Hi")
//add tanks to boardtest.addGameObject(testTank)
//test.addGameObject(testTank)
//test.addGameObject(testTank2)
//test.addGameObject(testTank3)
//create some action structs

// var mineAction = MineAction(power: 100, dropDirection: .North)
// var mineAction2 = MineAction(power: 100, dropDirection: .South)
// var shieldAction = ShieldAction(energy: 400)
// var moveAction = MoveAction(distance: 2, direction: .East)
// var moveAction2 = MoveAction(distance: 1, direction: .West)
// var missileAction = MissileAction(energy: 80000, position: Position(7,7))

// var roverMineAction = MineAction(power: 100, isRover: true, dropDirection: .NorthEast)

let smplTank = SmplTank(id: "TSIMP", position: Position(6,2), instructions: "Hi")
test.addGameObject(testTank)
test.addGameObject(smplTank)
test.printGrid()
test.doTurn()
test.printGrid()
test.doTurn()
test.printGrid()

for i in 0..<3 {
	test.doTurn()
	test.printGrid()
}