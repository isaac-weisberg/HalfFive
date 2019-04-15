import HalfFive

protocol AnswerTextualViewModel: class {
    var isSelected: Conveyor<Bool, SchedulingMain, HotnessHot>! { get }
    
    var action: Silo<Void, SchedulingMain> { get }

    var text: String { get }
    
    func setIsSelected(conveyor: Conveyor<Bool, SchedulingMain, HotnessHot>)
    
    var trashBag: TrashBag { get }
}

class AnswerTextualViewModelImpl {
    let actionSilo: Silo<String, SchedulingMain>
    var isSelected: Conveyor<Bool, SchedulingMain, HotnessHot>!
    let identity: String
    let text: String
    
    let trashBag: TrashBag = TrashBag()
    
    init(identity: String, text: String, action: Silo<String, SchedulingMain>) {
        self.text = text
        self.identity = identity
        self.actionSilo = action
    }
}


extension AnswerTextualViewModelImpl: AnswerTextualViewModel {
    var action: Silo<Void, SchedulingMain> {
        return actionSilo.map {
            self.identity
        }
    }
    
    func setIsSelected(conveyor: Conveyor<Bool, SchedulingMain, HotnessHot>) {
         isSelected = conveyor
    }
}
