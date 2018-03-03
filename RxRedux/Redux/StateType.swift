import RxSwift

protocol StateType {
    mutating func reduce(_ action: ActionType)
}

extension StateType {
    func reduced(_ action: ActionType) -> Self {
        var newState = self
        newState.reduce(action)
        return newState
    }

    func loop(on actionStream: Observable<ActionType>,
              with sideEffects: [SideEffect<Self>]) -> Observable<Self> {
        return actionStream
            .observeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
            .startWith(Init())
            .scan((state: self, applied: nil), accumulator: { (state, action) in
                (state.state.reduced(action), action)
            })
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .do(onNext: { (state, action) in
                sideEffects.forEach { sideEffect in
                    sideEffect(state, action!)
                }
            })
            .observeOn(MainScheduler.instance)
            .map({ $0.state })
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
    }
}
