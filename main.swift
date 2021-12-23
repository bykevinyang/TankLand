var testTank = Tank(id: "DAD", position: Position(3,4), instructions: "Hi")
var testTank2 = Tank(id: "BRO", position: Position(7,7), instructions: "Hi")
var testTank3 = Tank(id: "MOM", position: Position(5,7), instructions: "Hi")

var test = TankLand(15, 15)
test.printGrid()

test.addGameObject(testTank)
test.addGameObject(testTank2)
test.addGameObject(testTank3)
test.printGrid()


var testShield = ShieldAction(energy: 400)
test.doSetShieldAction(tank: testTank, shieldAction: testShield)
print(testTank.shield)

var testRadar = RadarAction(radius: 4)
print(test.runRadar(tank: testTank, radarAction: testRadar))

var testMineAction = MineAction(power: 100, dropDirection: .North)
var testMineActionMOM = MineAction(power: 100, dropDirection: .South)

var testRoverAction = MineAction(power: 69, dropDirection: .South)



test.createMine(tank: testTank, mineAction: testMineAction)
test.createMine(tank: testTank3, mineAction: testMineActionMOM)

test.createRover(tank: testTank2, mineAction: testRoverAction)
test.printGrid()

var testMoveAction = MoveAction(distance: 1, direction: .North)
var testMoveACtionMOM = MoveAction(distance: 1, direction: .East)
test.move(gameObject: testTank2, action: testMoveAction)
test.move(gameObject: testTank3, action: testMoveACtionMOM)
test.printGrid()
var testMissileAction = MissileAction(energy: 10000, position: Position(7,7))
test.sendMissile(tank: testTank, missileAction: testMissileAction)
test.printGrid()