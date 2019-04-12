import HalfFive

protocol TestCardViewModel {
    var progressLabel: String { get }
    
    var questionTitle: String { get }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot> { get }
    
    var answerVms: [AnswerTextualViewModel] { get }
}

class TestCardViewModelImpl {
    struct Data {
        let title: String
        let questionIndex: Int
        let questionsTotal: Int
        let selection: TestModel.Selection
        let answers: [(id: String, String)]
    }
    
    let selectionViewModel: TestAnswerSelectionViewModel
    let answerVms: [AnswerTextualViewModel]
    
    let data: Data
    
    init(data: Data) {
        self.data = data
        
        let selectionViewModel: TestAnswerSelectionViewModel
        switch data.selection {
        case .single:
            selectionViewModel = TestAnswerSelectionSingleViewModel()
        case .multiple:
            selectionViewModel = TestAnswerSelectionMultipleViewModel()
        }
        self.selectionViewModel = selectionViewModel
        
        answerVms = data.answers
            .map { stuff -> AnswerTextualViewModel in
                let vm: AnswerTextualViewModel = AnswerTextualViewModelImpl(
                    identity: stuff.id,
                    text: stuff.1,
                    action: selectionViewModel.selectRequest)
                
                vm.setIsSelected(conveyor: selectionViewModel.isAnswerSelected(vm))
                
                return vm
            }
    }
}

extension TestCardViewModelImpl: TestCardViewModel {
    var progressLabel: String {
        return "Question \(data.questionIndex + 1) out of \(data.questionsTotal)"
    }
    
    var questionTitle: String {
        return data.title
    }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot> {
        return selectionViewModel.isSelectionValid
    }
}
