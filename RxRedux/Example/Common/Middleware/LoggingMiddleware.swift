import Foundation

enum LoggingMiddleware<S, T: Store<S>> {
    static func create() -> (T) -> DispatchCreator {
        return { store in
            return { next in
                return { action in
                    //debugPrint("willDispatch \(action)")
                    next(action)
                    debugPrint("didDispatch \(action)")
                }
            }
        }
    }
}
