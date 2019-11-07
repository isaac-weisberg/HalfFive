import PastFive

enum MainViewModelInput {
    case buttonTap
}

protocol MainViewModelProtocol {
    var titleText: ScheduledObservable<String, MainScheduler> { get }
}

class MainViewModel: MainViewModelProtocol {
    let titleText: ScheduledObservable<String, MainScheduler>

    init(inputs: ScheduledObservable<MainViewModelInput, MainScheduler>) {
        titleText = inputs
            .map { input in
                [
                    "Toads", "Turds", "Goats"
                ].randomElement()!
            }
    }
}
