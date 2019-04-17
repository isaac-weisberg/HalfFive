import HalfFive

protocol TestViewModel {
    var nextQuestion: Silo<Void, SchedulingMain> { get }
    
    var question: Conveyor<TestCardViewModel, SchedulingMain, HotnessCold> { get }
    
    var nextQuestionLabel: Conveyor<String, SchedulingMain, HotnessCold> { get }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot> { get }
}

class TestViewModelImpl {
    typealias Context = TestRetrievalServiceContext
    
    let questionState: Conveyor<(TestCardViewModel, isLast: Bool), SchedulingMain, HotnessCold>
    
    let question: Conveyor<TestCardViewModel, SchedulingMain, HotnessCold>
    
    let nextQuestionLabel: Conveyor<String, SchedulingMain, HotnessCold>
    
    let nextQuestion: Silo<Void, SchedulingMain>
    
    let isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot>
    
    let scheduling = SchedulingSerial.new()
    
    init(context: TestRetrievalServiceContext) {
        let questionsConveyorMarked = context.testRetriever.downloadGithubTest()
            .map { res -> TestModel? in
                let res = res.then { dto in
                    .success(TestModel(github: dto))
                }
                if case .success(let data) = res {
                    return data
                }
                return nil
            }
            .filter { $0 != nil }.map { $0! }
            .map { data -> [(TestCardViewModel, isLast: Bool)] in
                let questionsCount = data.questions.count
                
                let questions = data.questions
                    .enumerated()
                    .map { things -> (TestCardViewModel, isLast: Bool) in
                        let (index, question) = things
                        
                        let data = TestCardViewModelImpl.Data(
                            id: question.id,
                            title: question.title,
                            questionIndex: index,
                            questionsTotal: questionsCount,
                            selection: question.selection,
                            answers: question.answers)
                        
                        let isLast = index == questionsCount - 1
                        
                        return (TestCardViewModelImpl(data: data), isLast: isLast)
                    }
                return questions
            }
            .flatMapLatest { questions in
                Conveyors.from(array: questions)
            }
            .run(on: scheduling)
            .fire(on: SchedulingMain.instance)
        
        let actionMultiplexer = Multiplexer<Void, SchedulingMain>()
        
        nextQuestion = actionMultiplexer
            .asSilo()
        
        
        self.questionState = Conveyors.zip(questionsConveyorMarked, actionMultiplexer) { q, _ in q }
            .share()
        
        self.nextQuestionLabel = questionState
            .map { thigns in
                thigns.isLast ? "Finish Testing" : "Next Question"
            }
        
        self.question = questionState
            .map { things in
                things.0
            }
        
        self.isSelectionValid = question
            .flatMapLatest { vm in
                vm.isSelectionValid
            }
            .startWith(event: false)
    }
}

extension TestViewModelImpl: TestViewModel {
    
}
