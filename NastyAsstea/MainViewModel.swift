import PastFive

protocol MainViewModelProtocol {
    var titleText: ScheduledObservable<String, MainScheduler> { get }
}

class MainViewModel: MainViewModelProtocol {
    let titleText: ScheduledObservable<String, MainScheduler>

    init(buttonPressed: ScheduledObservable<Void, MainScheduler>) {
        titleText = buttonPressed
            .observeOn(DispatchQueueScheduler(queue: .global()))
            .map { input in
                [
                    "Toads", "Turds", "Goats"
                ].randomElement()!
            }
            .observeOn(MainScheduler.instance)
    }
}
