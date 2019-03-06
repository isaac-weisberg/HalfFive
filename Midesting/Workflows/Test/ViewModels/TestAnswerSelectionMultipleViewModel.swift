import HalfFive

private extension Array where Element == AnswerTextualViewModel {
    func contains(element: Element) -> Bool {
        return contains { $0 === element }
    }
}

class TestAnswerSelectionMultipleViewModel {
    let selectedAnswers = Container<[AnswerTextualViewModel], SchedulingMain>(value: [])
    
    let selectionMultiplexer = Multiplexer<AnswerTextualViewModel, SchedulingMain>()
    
    let trashBag = TrashBag()
    
    init() {
        selectionMultiplexer
            .withLatest(from: selectedAnswers) { (new: $0, old: $1) }
            .map { stuff -> [AnswerTextualViewModel] in
                if stuff.old.contains(element: stuff.new) {
                    return stuff.old.filter { $0 !== stuff.new }
                }
                var rw = stuff.old
                rw.append(stuff.new)
                return rw
            }
            .run(silo: selectedAnswers)
            .disposed(by: trashBag)
    }
}

extension TestAnswerSelectionMultipleViewModel: TestAnswerSelectionViewModel {
    func isAnswerSelected(_ answer: AnswerTextualViewModel) -> Conveyor<Bool, SchedulingMain> {
        return selectedAnswers
            .map { $0.contains { $0 === answer } }
    }
    
    var selectRequest: Silo<AnswerTextualViewModel, SchedulingMain> {
        return selectionMultiplexer
            .asSilo()
    }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain> {
        return selectedAnswers
            .map { $0.count > 0 }
    }
}
