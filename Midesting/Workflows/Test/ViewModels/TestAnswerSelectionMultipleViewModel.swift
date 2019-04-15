import HalfFive

class TestAnswerSelectionMultipleViewModel {
    let selectedAnswers = Container<[String], SchedulingMain>(value: [])
    
    let selectionMultiplexer = Multiplexer<String, SchedulingMain>()
    
    let trashBag = TrashBag()
    
    init() {
        selectionMultiplexer
            .withLatest(from: selectedAnswers) { (new: $0, old: $1) }
            .map { stuff -> [String] in
                if stuff.old.contains(stuff.new) {
                    return stuff.old.filter { $0 != stuff.new }
                }
                var rw = stuff.old
                rw.append(stuff.new)
                return rw
            }
            .run(silo: selectedAnswers.asSilo())
            .disposed(by: trashBag)
    }
}

extension TestAnswerSelectionMultipleViewModel: TestAnswerSelectionViewModel {
    func isAnswerSelected(_ answer: String) -> Conveyor<Bool, SchedulingMain, HotnessHot> {
        return selectedAnswers
            .map { $0.contains { $0 == answer } }
    }
    
    var selectRequest: Silo<String, SchedulingMain> {
        return selectionMultiplexer
            .asSilo()
    }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot> {
        return selectedAnswers
            .map { $0.count > 0 }
    }
}
