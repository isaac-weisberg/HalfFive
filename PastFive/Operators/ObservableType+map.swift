public extension ObservableType {
    func map<NewEvent>(_ transform: @escaping (Event) -> NewEvent) -> Observable<NewEvent, Scheduler> {
        return Observable.unchecked(scheduler: scheduler) { [subscribe] handler in
            return subscribe { event in
                handler(transform(event))
            }
        }
    }
}
