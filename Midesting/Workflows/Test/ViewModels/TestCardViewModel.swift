import HalfFive

protocol TestCardViewModel {
    var progressLabel: String { get }
    
    var questionTitle: String { get }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot> { get }
    
    var answerVms: [AnswerTextualViewModel] { get }
}

class TestCardViewModelLoadingStub: TestCardViewModel {
    let progressLabel: String = ""
    
    let questionTitle: String = "Loading..."
    
    let isSelectionValid = Conveyors.just(false).assumeFiresOnMain()
    
    let answerVms: [AnswerTextualViewModel] = []
}

class TestCardViewModelErrorStub: TestCardViewModel {
    let progressLabel: String = ""
    
    let questionTitle: String = "Error"
    
    let isSelectionValid = Conveyors.just(false).assumeFiresOnMain()
    
    let answerVms: [AnswerTextualViewModel] = []
}

class TestCardViewModelImpl {
    struct Data {
        let id: String
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
        case .arbitrary:
            selectionViewModel =  TestAnswerSelectionArbitraryViewModel()
        case .single:
            selectionViewModel = TestAnswerSelectionSingleViewModel()
        case .multiple:
            selectionViewModel = TestAnswerSelectionMultipleViewModel()
        }
        self.selectionViewModel = selectionViewModel
        
        answerVms = data.answers
            .map { stuff -> AnswerTextualViewModel in
                AnswerTextualViewModelImpl(
                    identity: stuff.id,
                    text: stuff.1,
                    action: selectionViewModel.selectRequest,
                    isSelected: selectionViewModel.isAnswerSelected(stuff.id))
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
