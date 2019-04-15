import HalfFive

protocol AnswerTextualViewModel: class {
    var isSelected: Conveyor<Bool, SchedulingMain, HotnessHot> { get }
    
    var action: Silo<Void, SchedulingMain> { get }

    var text: String { get }
    
    var trashBag: TrashBag { get }
}

class AnswerTextualViewModelImpl {
    let actionSilo: Silo<String, SchedulingMain>
    let isSelected: Conveyor<Bool, SchedulingMain, HotnessHot>
    let identity: String
    let text: String
    
    let trashBag: TrashBag = TrashBag()
    
    init(identity: String, text: String, action: Silo<String, SchedulingMain>, isSelected: Conveyor<Bool, SchedulingMain, HotnessHot>) {
        self.text = text
        self.identity = identity
        self.actionSilo = action
        self.isSelected = isSelected
    }
}


extension AnswerTextualViewModelImpl: AnswerTextualViewModel {
    var action: Silo<Void, SchedulingMain> {
        return actionSilo.map {
            self.identity
        }
    }
}
