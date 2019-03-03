import HalfFive

protocol TestViewModel {
    var question: Conveyor<TestCardViewModel, SchedulingMain> { get }
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
        
        let questionsConveyor = ConveyorFrom(array: questions)
            .assumeRunsOnMain()
        
        self.question = Conveyor.zip(questionsConveyor, action) { q, _ in q }
    }
}

extension TestViewModelImpl: TestViewModel {
    
}
