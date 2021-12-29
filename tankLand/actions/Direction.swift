enum Direction : CaseIterable {
  case North
  case East
  case South
  case West
  case NorthEast
  case NorthWest
  case SouthEast
  case SouthWest
}

let DirectionToVectorMove: [Direction: (Int, Int)] = [
	// .Direction: (x move, y move)
	.North: (-1, 0),
	.South: (1, 0),
	.West: (0, -1),
	.East: (0, 1),
	.NorthEast: (-1, 1),
	.NorthWest: (-1, -1),
	.SouthEast: (1, 1),
	.SouthWest: (1, -1)
]
