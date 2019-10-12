import Dispatch

public extension ObservableType {
    func subscribe(on queue: DispatchQueue) -> Observable<Event> {
        return Observable.unsafe { [subscribe] observer in
            let disposable = DisposableDeferred()
            queue.async { [weak disposable] in
                guard let disposable = disposable else {
                    return
                }
                disposable.disposable = subscribe(observer)
            }
            return disposable
        }
    }
}

private class DisposableDeferred: Disposable {
    var disposable: Disposable?
}
