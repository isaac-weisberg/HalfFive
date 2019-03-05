import HalfFive

protocol AnswerTextualViewModel: class {
    var isSelected: Multiplexer<Bool, SchedulingMain> { get }
    
    var action: Multiplexer<Void, SchedulingMain> { get }
    
    var text: String { get }
    
    var trashBag: TrashBag { get }
}

class AnswerTextualViewModelImpl {
    let action = Multiplexer<Void, SchedulingMain>()
    let isSelectedContainer: Container<Bool, SchedulingMain>
    let identity: String
    let text: String
    
    let trashBag = TrashBag()
    
    init(identity: String, text: String, isSelectedByDefault: Bool = false) {
        self.text = text
        self.identity = identity
        self.isSelectedContainer = Container<Bool, SchedulingMain>(value: isSelectedByDefault)
    }
}


extension AnswerTextualViewModelImpl: AnswerTextualViewModel {
    var isSelected: Multiplexer<Bool, SchedulingMain> {
        return isSelectedContainer
    }
}
