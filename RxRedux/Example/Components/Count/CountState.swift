import Foundation

enum CountAction: ActionType {
    case increment
    case decrement
}

struct CountState: StateType {
    private(set) var counter: Int
    
    mutating func reduce(_ action: ActionType) {
        switch action {
        case CountAction.decrement: counter -= 1
        case CountAction.increment: counter += 1
        default: break
        }
    }
}