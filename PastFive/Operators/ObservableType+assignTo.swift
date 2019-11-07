public extension ObservableType {
    func assign<Target: AnyObject>(to keyPath: WritableKeyPath<Target, Event>, on target: Target) -> Disposable {
        return subscribe(assignFactory(target, keyPath))
    }
}

public extension ScheduledObservableType {
    func assign<Target: AnyObject>(to keyPath: WritableKeyPath<Target, Event>, on target: Target) -> Disposable {
        return unscheduled.assign(to: keyPath, on: target)
    }
}

private func assignFactory<Target: AnyObject, Event>(
    _ target: Target,
    _ keyPath: WritableKeyPath<Target, Event>
) -> (Event) -> Void {
    return { event in
        var target = target
        target[keyPath: keyPath] = event
    }
}
