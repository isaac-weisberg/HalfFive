import HalfFive

protocol AnswerTextualViewModel: class {
    var isSelected: Multiplexer<Bool, SchedulingMain> { get }
    
    var action: Multiplexer<Void, SchedulingMain> { get }
    
    var text: String { get }
    
    var trashBag: TrashBag { get }
}

class AnswerTextualViewModelImpl {
    let action = Multiplexer<Void, SchedulingMain>()
    let isSelected = Multiplexer<Bool, SchedulingMain>()
    let identity: String
    let text: String
    
    let trashBag = TrashBag()
    
    init(identity: String, text: String) {
        self.text = text
        self.identity = identity
    }
}


extension AnswerTextualViewModelImpl: AnswerTextualViewModel {
    
}
