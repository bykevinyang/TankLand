enum ActionType {
  case RunRadar
  case DropRover
	case DropMine
	case SendMissile
  case SendMessage
  case ReceiveMessage
  case MissileAction
  case Move
}

//where you write the methods   extends tankland
protocol Action: CustomStringConvertible {
    var  action: ActionType {get}
    var description: String {get}
}
 
protocol PreAction: Action{
}
 
protocol PostAction: Action{
}
 
struct MoveAction: PostAction{
    let action: ActionType
    let distance: Int
    let direction: Direction
    var description: String {
        return "\(action) \(distance) \(direction)"
    }
    
    init(distance: Int, direction: Direction){
        action = .Move
        self.distance = distance
        self.direction = direction
    }
}