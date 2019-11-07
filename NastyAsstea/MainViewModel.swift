import PastFive

enum MainViewModelInput {
    case buttonTap
}

protocol MainViewModelProtocol {
    var titleText: Observable<String, MainScheduler> { get }
}

class MainViewModel: MainViewModelProtocol {
    let titleText: Observable<String, MainScheduler>

    init(inputs: Observable<MainViewModelInput, MainScheduler>) {
        titleText = inputs
            .map { input in
                [
                    "Toads", "Turds", "Goats"
                ].randomElement()!
            }
    }
}
