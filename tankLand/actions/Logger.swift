// CHECK WITH PAL. IF THIS IS CORRECT

// struct Logger: CustomStringConvertible{
// 	var log: [String]

// 	var description: String {
// 		for thing in log {
//       return thing
//     }
// 	}

// 	init(actor: GameObject, receiver: GameObject, action: ActionType) {
// 		self. = id
// 		self.message = message
// 	}

//   func addLog(cmd: String) {

//   }
// }

  var log: [String] = []

  func addLog(cmd: String) {
    log.append(cmd)
  }

  func printLog(log: [String]) {
    for thing in log {
      print(thing)
    }
  }

