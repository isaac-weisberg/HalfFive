public extension ObservableType {
    func map<NewEvent>(_ transform: @escaping (Event) -> NewEvent) -> Observable<NewEvent, Scheduling> {
        return Observable { [subscribe] handler in
            return subscribe { event in
                handler(transform(event))
            }
        }
    }
}
