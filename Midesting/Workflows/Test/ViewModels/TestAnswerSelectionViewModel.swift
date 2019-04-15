import HalfFive

protocol TestAnswerSelectionViewModel: class {
    func isAnswerSelected(_ answer: String) -> Conveyor<Bool, SchedulingMain, HotnessHot>
    
    var selectRequest: Silo<String, SchedulingMain> { get }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot> { get }
}
