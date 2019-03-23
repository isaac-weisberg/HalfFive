import HalfFive

protocol AnswerTextualViewModel: class {
    var isSelected: Conveyor<Bool, SchedulingMain>! { get }
    
    var action: Silo<Void, SchedulingMain> { get }

    var text: String { get }
    
    func setIsSelected(conveyor: Conveyor<Bool, SchedulingMain>)
    
    var trashBag: TrashBag { get }
}

class AnswerTextualViewModelImpl {
    let actionSilo: Silo<AnswerTextualViewModel, SchedulingMain>
    var isSelected: Conveyor<Bool, SchedulingMain>!
    let identity: String
    let text: String
    
    let trashBag: TrashBag = TrashBag()
    
    init(identity: String, text: String, action: Silo<AnswerTextualViewModel, SchedulingMain>) {
        self.text = text
        self.identity = identity
        self.actionSilo = action
    }
}


extension AnswerTextualViewModelImpl: AnswerTextualViewModel {
    var action: Silo<Void, SchedulingMain> {
        return actionSilo.map {
            self
        }
    }
    
    func setIsSelected(conveyor: Conveyor<Bool, SchedulingMain>) {
         isSelected = conveyor
    }
}
