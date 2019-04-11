import HalfFive

class TestAnswerSelectionSingleViewModel {
    let selectedAnswer = Container<AnswerTextualViewModel?, SchedulingMainOrHot>(value: nil)
    
    let selectionMultiplexer = Multiplexer<AnswerTextualViewModel, SchedulingMain>()
    
    let trashBag = TrashBag()
    
    init() {
        selectionMultiplexer
            .map { $0 }
            .run(silo: selectedAnswer.asSilo())
            .disposed(by: trashBag)
    }
}

extension TestAnswerSelectionSingleViewModel: TestAnswerSelectionViewModel {
    func isAnswerSelected(_ answer: AnswerTextualViewModel) -> Conveyor<Bool, SchedulingMain> {
        return selectedAnswer
            .assumeFiresOnMain()
            .map { $0 === answer }
    }
    
    var selectRequest: Silo<AnswerTextualViewModel, SchedulingMain> {
        return selectionMultiplexer
            .asSilo()
    }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain> {
        return selectedAnswer
            .assumeFiresOnMain()
            .map { $0 != nil }
    }
}
