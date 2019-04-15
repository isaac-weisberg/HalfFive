import HalfFive

class TestAnswerSelectionSingleViewModel {
    let selectedAnswer = Container<String?, SchedulingMain>(value: nil)
    
    let selectionMultiplexer = Multiplexer<String, SchedulingMain>()
    
    let trashBag = TrashBag()
    
    init() {
        selectionMultiplexer
            .map { $0 }
            .run(silo: selectedAnswer.asSilo())
            .disposed(by: trashBag)
    }
}

extension TestAnswerSelectionSingleViewModel: TestAnswerSelectionViewModel {
    func isAnswerSelected(_ answer: String) -> Conveyor<Bool, SchedulingMain, HotnessHot> {
        return selectedAnswer
            .map { $0 == answer }
    }
    
    var selectRequest: Silo<String, SchedulingMain> {
        return selectionMultiplexer
            .asSilo()
    }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot> {
        return selectedAnswer
            .map { $0 != nil }
    }
}
