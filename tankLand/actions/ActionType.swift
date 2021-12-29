enum ActionType {
  case RadarAction
  case DropRover
  case DropMine
  case SendMissile
  case SendMessage
  case ReceiveMessage
  case MissileAction
  case Move
  case ShieldAction
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
