struct SendMessageAction: PreAction {
    let action: ActionType
    let id: String
    let message: String
    var description: String {
        return "\(action) \(id) \(message)"
    }
    init(id: String, message: String){
        action = .SendMessage
        self.id = id
        self.message = message
    }
}

struct ReceiveMessageAction: PreAction{
    let action: ActionType
    let key: String
    var description: String {
        return "\(action) \(key)"
    }
    init(key: String){
        action = .ReceiveMessage
        self.key = key
    }
}

struct MessageCenter {
	static var messages: [String: String] = [:]

	static func add(key: String, message: String) {
    MessageCenter.messages[key] = message
	}
	
	// Fix tank later
	static func clear() {
		MessageCenter.messages = [:]
	}

	static func read(key: String) -> String? {
		//print("key")
		if let secretMessage = MessageCenter.messages[key] {
			return secretMessage
		}
		//print("RETURNING NIL FOR READ")
		return nil
	}
}

extension TankLand {
	func sendMessage(tank: Tank, preAction: PreAction) -> Bool {
		if preAction.action == .SendMessage {
			//print("UNWRAPPING SEND")
			let action = preAction as! SendMessageAction
			//print("UNWRAPPING SUCCESFUL")
			MessageCenter.add(key: action.id, message: action.message)
            addLog(cmd: "\(tank.id) sent a message: '\(action.message)' on channel |\(action.id)|")
			return true
		}
    return false  
	}

	func receiveMessage(tank: Tank, preAction: PreAction) -> Bool {
		if preAction.action == .ReceiveMessage {
			//print("UNWRAPPING RECEIVE")
			let action = preAction as! ReceiveMessageAction
			//print("UNWRAPPING RECEIVE SUCCESS")
			let message = MessageCenter.read(key: action.key)
			print(message)
		  tank.receivedMessage = message
			let printMessage = message ?? "none"
			print("\(tank.id) received a message: \(printMessage) on channel |\(action.key)|")
            // addLog(cmd: "\(tank.id) received a message: '\(message!)' on channel |\(action.key)|")
			return true
  	}
    return false
	}	
}
