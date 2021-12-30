//create board
var test = TankLand(15,15)
//create tanks
var testTank = Tank(id: "T1", position: Position(1,2), instructions: "Hi")
var testTank2 = Tank(id: "T2", position: Position(4,5), instructions: "Hi")
var testTank3 = Tank(id: "T3", position: Position(7,8), instructions: "Hi")
//add tanks to boardtest.addGameObject(testTank)
test.addGameObject(testTank)
test.addGameObject(testTank2)
test.addGameObject(testTank3)
test.printGrid()

//some pre actions
var shieldAction = ShieldAction(energy: 400)
var radarAction = RadarAction(radius: 3)
// do those pre actions
test.doSetShieldAction(tank: testTank, shieldAction: shieldAction)
test.doSetShieldAction(tank: testTank2, shieldAction: shieldAction)
test.doSetShieldAction(tank: testTank3, shieldAction: shieldAction)


//some post actions
var mineAction = MineAction(power: 100, dropDirection: .North)
var mineAction2 = MineAction(power: 100, dropDirection: .South)
var moveAction = MoveAction(distance: 2, direction: .East)
var moveAction2 = MoveAction(distance: 1, direction: .West)
var missileAction = MissileAction(energy: 80000, position: Position(7,7))
var roverAction = MineAction(power: 100, isRover: true, dropDirection: .NorthEast)
var roverAction2 = MineAction(power: 100, isRover: true, dropDirection: .SouthEast,  moveDirection: .South)
var roverAction3 = MineAction(power: 100, isRover: true, dropDirection: .West,  moveDirection: .West)

//
let rover = test.createRover(tank: testTank2, mineAction: roverAction, randomMove: true)
let rover2 = test.createRover(tank: testTank, mineAction: roverAction2, randomMove: false)
let rover3 = test.createRover(tank: testTank2, mineAction: roverAction3, randomMove: false)
test.printGrid()

we have some unwrapping or index out of bounds, at least i think
let me merge my code - should take like 5 mins i hope

indeed

print("here")
test.move(gameObject: rover2, action: nil)
//test.move(gameObject: rover, action: nil)
// test.move(gameObject: rover3, action: moveAction2)
// test.printGrid()
// test.move(gameObject: rover2, action: moveAction)
// test.printGrid()
// print("Rover should have been created")
// test.printGrid()
// print(rover)