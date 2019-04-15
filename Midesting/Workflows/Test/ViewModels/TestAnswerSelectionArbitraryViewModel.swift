import HalfFive

class TestAnswerSelectionArbitraryViewModel {
    let answers = Container<[String], SchedulingMain>(value: [])
    
    let selectRequest: Silo<String, SchedulingMain>
    let isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot>
    
    let trashBag = TrashBag()
    
    init() {
        let selectionMultiplex = Multiplexer<String, SchedulingMain>()
        
        selectRequest = selectionMultiplex
            .asSilo()
        
        isSelectionValid = Conveyors
            .just(true)
            .assumeFiresOnMain()
        
        selectionMultiplex
            .withLatest(from: answers) { (new: $0, old: $1) }
            .map { stuff -> [String] in
                if stuff.old.contains(stuff.new) {
                    return stuff.old.filter { $0 != stuff.new }
                }
                var rw = stuff.old
                rw.append(stuff.new)
                return rw
            }
            .run(silo: answers.asSilo())
            .disposed(by: trashBag)
    }
}

extension TestAnswerSelectionArbitraryViewModel: TestAnswerSelectionViewModel {
    func isAnswerSelected(_ answer: String) -> Conveyor<Bool, SchedulingMain, HotnessHot> {
        return answers
            .map { $0.contains(answer) }
    }
}
