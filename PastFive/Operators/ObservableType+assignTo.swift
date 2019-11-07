public extension ObservableType {
    func assign<Target: AnyObject>(to keyPath: WritableKeyPath<Target, Event>, on target: Target) -> Disposable {
        return subscribe { event in
            var target = target
            target[keyPath: keyPath] = event
        }
    }
}
