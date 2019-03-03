import HalfFive

protocol TestViewModel {
    var nextQuestion: Silo<Void, SchedulingMain> { get }
    
    var question: Conveyor<TestCardViewModel, SchedulingMain> { get }
    
    var nextQuestionLabel: Conveyor<String, SchedulingMain> { get }
}

class TestViewModelImpl {
    let action = Multiplexer<Void, SchedulingMain>()
    
    let questionState: Conveyor<(TestCardViewModel, isLast: Bool), SchedulingMain>
    
    let question: Conveyor<TestCardViewModel, SchedulingMain>
    
    let nextQuestionLabel: Conveyor<String, SchedulingMain>
    
    init(data: TestModel) {
        let questionsCount = data.questions.count
        
        let questions = data.questions
            .enumerated()
            .map { things -> (TestCardViewModel, isLast: Bool) in
                let (index, question) = things
                
                let data = TestCardViewModelImpl.Data(
                    title: question.title,
                    questionIndex: index,
                    questionsTotal: questionsCount)
                
                let isLast = index == questionsCount - 1
                
                return (TestCardViewModelImpl(data: data), isLast: isLast)
            }
        
        let actionConveyor = action
            .startWith(event: ())
        
        let questionsConveyorMarked = ConveyorFrom(array: questions)
            .assumeRunsOnMain()
        
        
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
    var nextQuestion: Silo<Void, SchedulingMain> {
        return action
            .asSilo()
    }
}
