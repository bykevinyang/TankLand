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
	
	static func clear() {
		MessageCenter.messages = [:]
	}

	static func read(key: String) -> String? {
		if let secretMessage = MessageCenter.messages[key] {
			return secretMessage
		}
		return nil
	}
}

extension TankLand {
	func sendMessage(tank: Tank, preAction: PreAction) -> Bool {
		if preAction.action == .SendMessage {
			let action = preAction as! SendMessageAction
			MessageCenter.add(key: action.id, message: action.message)
            addLog(cmd: "\(tank.id) sent a message: '\(action.message)' on channel |\(action.id)|")
			return true
		}
    return false  
	}

	func receiveMessage(tank: Tank, preAction: PreAction) -> Bool {
		if preAction.action == .ReceiveMessage {
			let action = preAction as! ReceiveMessageAction
			let message = MessageCenter.read(key: action.key)
			print(message)
		  tank.receivedMessage = message
			let printMessage = message ?? "none"
			print("\(tank.id) received a message: \(printMessage) on channel |\(action.key)|")
			return true
  	}
    return false
	}	
}
