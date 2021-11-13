let testGOBJ = GameObject(type: .Tank, id: "TANK1", position: Position(2,3), energy: 100)

var test = TankLand(15, 15)
test[1,2] = testGOBJ
test.printGrid()