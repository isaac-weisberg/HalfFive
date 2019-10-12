private class DisposableVoid: Disposable {
    init() {

    }
}


public extension Disposables {
    static func create() -> Disposable {
        return DisposableVoid()
    }
}
