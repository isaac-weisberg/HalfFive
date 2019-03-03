import HalfFive

protocol TestViewModel {
    var nextQuestion: Silo<Void, SchedulingMain> { get }
    
    var question: Conveyor<TestCardViewModel, SchedulingMain> { get }
    
    var nextQuestionLabel: Conveyor<String, SchedulingMain> { get }
}

class TestViewModelImpl {
    let action = Multiplexer<Void, SchedulingMain>()
    
    let question: Conveyor<TestCardViewModel, SchedulingMain>
    
    init(data: TestModel) {
        let questionsCount = data.questions.count
        
        let questions = data.questions
            .enumerated()
            .map { things -> TestCardViewModel in
                let (index, question) = things
                
                return TestCardViewModelImpl(data: .init(
                    title: question.title, questionIndex: index, questionsTotal: questionsCount)
                )
            }
        
        let actionConveyor = action
            .startWith(event: ())
        
        let questionsConveyor = ConveyorFrom(array: questions)
            .assumeRunsOnMain()
        
        self.question = Conveyor.zip(questionsConveyor, actionConveyor) { q, _ in q }
    }
}

extension TestViewModelImpl: TestViewModel {
    var nextQuestion: Silo<Void, SchedulingMain> {
        return action
            .asSilo()
    }
    
    var nextQuestionLabel: Conveyor<String, SchedulingMain> {
        return ConveyorFrom(array: ["Next Question"])
            .assumeRunsOnMain()
    }
}
