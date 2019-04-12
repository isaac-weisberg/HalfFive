import HalfFive

protocol TestAnswerSelectionViewModel: class {
    func isAnswerSelected(_ answer: AnswerTextualViewModel) -> Conveyor<Bool, SchedulingMain, HotnessHot>
    
    var selectRequest: Silo<AnswerTextualViewModel, SchedulingMain> { get }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot> { get }
}
