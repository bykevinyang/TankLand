enum GameObjectType {
  case Tank, Mine, Rover
}

class GameObject: CustomStringConvertible, Hashable, Equatable {
    let type: GameObjectType
    let id: String
    private (set) var position: Position
    private (set) var energy: Int
    var description: String {return "ID: \(id), Type: \(type), Energy: \(energy), Position: \(position)"}
    
    init(type: GameObjectType, id: String, position: Position, energy: Int) {
        self.type = type
        self.id = id
        self.position = position
        self.energy = energy
    }
    final func chargeEnergy(_ amount: Int) {
        self.energy -= amount
    }
    
    final func gainEnergy(_ amount: Int) {
        self.energy += amount
    }
    
    final func setPosition(_ newPosition: Position) {
        self.position = newPosition
    }

    static func == (lhs: GameObject, rhs: GameObject) -> Bool {
        return
            ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    static func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }
}

// Some black magic to make the compiler happy
// Basically extends Hashable and Equatable to classes and not just structs
extension Hashable where Self: AnyObject {

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
    
extension Equatable where Self: AnyObject {

    static func == (lhs:Self, rhs:Self) -> Bool {
        return lhs === rhs
    }
}