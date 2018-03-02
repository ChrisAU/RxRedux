import Action

extension Action where Input == Void, Element == Void {
    convenience init(_ action: ActionType) {
        self.init() { .just(fire.onNext(action)) }
    }
}
