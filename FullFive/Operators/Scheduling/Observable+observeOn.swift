import Dispatch

public extension ObservableType {
    func observe(on queue: DispatchQueue) -> Observable<Event> {
        return Observable.unsafe { [subscribe] observer in
            return subscribe { event in
                queue.async {
                    observer(event)
                }
            }
        }
    }
}
