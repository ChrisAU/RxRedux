import Foundation

enum CountAction: ActionType {
    case increment
    case decrement
}

struct CountState: StateType, Equatable, Codable {
    static func ==(lhs: CountState, rhs: CountState) -> Bool {
        return lhs.counter == rhs.counter
    }
    
    private(set) var counter: Int = 0
    
    mutating func reduce(_ action: ActionType) {
        switch action {
        case CountAction.decrement: counter -= 1
        case CountAction.increment: counter += 1
        default: break
        }
    }
}
