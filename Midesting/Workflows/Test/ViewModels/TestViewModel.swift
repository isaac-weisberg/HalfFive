import HalfFive

protocol TestViewModel {
    var nextQuestion: Silo<Void, SchedulingMain> { get }
    
    var question: Conveyor<TestCardViewModel, SchedulingMain> { get }
    
    var nextQuestionLabel: Conveyor<String, SchedulingMain> { get }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain> { get }
}

class TestViewModelImpl {
    let questionState: Conveyor<(TestCardViewModel, isLast: Bool), SchedulingMain>
    
    let question: Conveyor<TestCardViewModel, SchedulingMain>
    
    let nextQuestionLabel: Conveyor<String, SchedulingMain>
    
    let nextQuestion: Silo<Void, SchedulingMain>
    
    init(data: TestModel) {
        let questionsCount = data.questions.count
        
        let questions = data.questions
            .enumerated()
            .map { things -> (TestCardViewModel, isLast: Bool) in
                let (index, question) = things
                
                let data = TestCardViewModelImpl.Data(
                    title: question.title,
                    questionIndex: index,
                    questionsTotal: questionsCount,
                    selection: question.selection,
                    answers: question.answers)
                
                let isLast = index == questionsCount - 1
                
                return (TestCardViewModelImpl(data: data), isLast: isLast)
            }
        
        let actionMultiplexer = Multiplexer<Void, SchedulingMain>()
        
        nextQuestion = actionMultiplexer
            .asSilo()
        
        let actionConveyor = actionMultiplexer
            .startWith(event: ())
            .assumeFiresOnMain()
        
        let questionsConveyorMarked = Conveyors.from(array: questions)
            .assumeFiresOnMain()
        
        self.questionState = Conveyor.zip(questionsConveyorMarked, actionConveyor) { q, _ in q }
        
        self.nextQuestionLabel = questionState
            .map { thigns in
                thigns.isLast ? "Finish Testing" : "Next Question"
            }
        
        self.question = questionState
            .map { things in
                things.0
            }
    }
}

extension TestViewModelImpl: TestViewModel {
    var isSelectionValid: Conveyor<Bool, SchedulingMain> {
        return question
            .flatMapLatest { vm in
                vm.isSelectionValid
            }
    }
}
