let testGOBJ = GameObject(type: .Tank, id: "TANK1", position: Position(2,3), energy: 100)

let test2 = GameObject(type: .Tank, id: "urMOM", position: Position(2,4), energy: 69420)

var test = TankLand(15, 15)
test.printGrid()

test.addGameObject(testGOBJ)
test.addGameObject(test2)
test.printGrid()

test.runRadar(tank: testGOBJ, 1)

