import HalfFive

protocol TestCardViewModel {
    var progressLabel: String { get }
    
    var questionTitle: String { get }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain> { get }
    
    var answerVms: [AnswerTextualViewModel] { get }
}

class TestCardViewModelImpl {
    struct Data {
        let title: String
        let questionIndex: Int
        let questionsTotal: Int
        let answers: [(id: String, String)]
    }
    
    let selectionViewModel: TestAnswerSelectionViewModel
    let answerVms: [AnswerTextualViewModel]
    
    let data: Data
    
    init(data: Data) {
        self.data = data
        
        let selectionViewModel: TestAnswerSelectionViewModel = TestAnswerSelectionSingleViewModel()
        self.selectionViewModel = selectionViewModel
        
        answerVms = data.answers
            .map { stuff -> AnswerTextualViewModel in
                let vm: AnswerTextualViewModel = AnswerTextualViewModelImpl(
                    identity: stuff.id,
                    text: stuff.1)
                
                selectionViewModel.isAnswerSelected(vm)
                    .run(silo: vm.isSelected.asSilo())
                    .disposed(by: vm.trashBag)
                
                vm.action
                    .map { _ in vm }
                    .run(silo: selectionViewModel.selectRequest)
                    .disposed(by: vm.trashBag)
                
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
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain> {
        return selectionViewModel.isSelectionValid
    }
}
