public protocol Disposable {

}

public struct DisposableVoid: Disposable {

}

public class DisposableAnon: Disposable {
    public let dispose: () -> Void

    public init(_ dispose: @escaping () -> Void) {
        self.dispose = dispose
    }

    deinit {
        dispose()
    }
}

class DropInDisposable: Disposable {
    var nested: Disposable?
}

public class DisposeBag: Disposable {
    var nested: [Disposable]

    public init() {
        nested = []
    }
}

public extension Disposable {
    func disposed(by disposeBag: DisposeBag) {
        disposeBag.nested.append(self)
    }
}
