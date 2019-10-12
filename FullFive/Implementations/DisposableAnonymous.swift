private class DisposableAnonymous: Disposable {
    let closure: () -> Void

    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }
}

public extension Disposables {
    static func create(_ onDisposed: @escaping () -> Void) -> Disposable {
        return DisposableAnonymous(onDisposed)
    }
}
