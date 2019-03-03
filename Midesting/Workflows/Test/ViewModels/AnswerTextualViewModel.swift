import HalfFive

protocol AnswerTextualViewModel: class {
    var isSelected: Conveyor<Bool, SchedulingMain> { get }
    
    var action: Silo<Void, SchedulingMain> { get }
    
    var text: String { get }
}

class AnswerTextualViewModelImpl {
    let action: Silo<Void, SchedulingMain>
    let isSelected: Conveyor<Bool, SchedulingMain>
    let text: String
    
    init(text: String, isSelected: Conveyor<Bool, SchedulingMain>, action: Silo<Void, SchedulingMain>) {
        self.text = text
        self.isSelected = isSelected
        self.action = action
    }
}


extension AnswerTextualViewModelImpl: AnswerTextualViewModel {
    
}
