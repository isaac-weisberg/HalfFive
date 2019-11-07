public extension ObservableType {
    func eraseType() -> Observable<Event, Scheduler> {
        return Observable.unchecked(scheduler: scheduler, self.subscribe)
    }
}
