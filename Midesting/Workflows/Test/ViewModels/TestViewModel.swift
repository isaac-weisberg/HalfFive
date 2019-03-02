import HalfFive

protocol TestViewModel {
    var question: Conveyor<TestCardViewModel, SchedulingMain> { get }
}

class TestViewModelImpl {
    let questionContainer: Container<TestCardViewModel, SchedulingMain>
    
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
        
        assert(questionsCount > 0, "Should be at least one question")
        let firstQuestion = questions.first!
        self.questionContainer = Container(value: firstQuestion)
    }
}

extension TestViewModelImpl: TestViewModel {
    var question: Conveyor<TestCardViewModel, SchedulingMain> {
        return questionContainer
            .asConveyor()
    }
}
