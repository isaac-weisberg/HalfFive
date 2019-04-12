import HalfFive

protocol TestViewModel {
    var nextQuestion: Silo<Void, SchedulingMain> { get }
    
    var question: Conveyor<TestCardViewModel, SchedulingMain, HotnessHot> { get }
    
    var nextQuestionLabel: Conveyor<String, SchedulingMain, HotnessHot> { get }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot> { get }
}

class TestViewModelImpl {
    let questionState: Conveyor<(TestCardViewModel, isLast: Bool), SchedulingMain, HotnessHot>
    
    let question: Conveyor<TestCardViewModel, SchedulingMain, HotnessHot>
    
    let nextQuestionLabel: Conveyor<String, SchedulingMain, HotnessHot>
    
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
        
        let questionsConveyorMarked = Conveyors.from(array: questions)
            .assumeFiresOnMain()
        
        self.questionState = Conveyors.zip(questionsConveyorMarked, actionConveyor) { q, _ in q }
        
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
    var isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot> {
        return question
            .flatMapLatest { vm in
                vm.isSelectionValid
            }
    }
}
