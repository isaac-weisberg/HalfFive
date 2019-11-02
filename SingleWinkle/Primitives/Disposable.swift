public protocol Disposable: class {

}

class DisposableDropIn: Disposable {
    var nested: Disposable?
}

class DisposableVoid: Disposable {
    
}
