public protocol Disposable {

}

struct DiposableVoid: Disposable {

}

class DropInDisposable: Disposable {
    var nested: Disposable?
}
