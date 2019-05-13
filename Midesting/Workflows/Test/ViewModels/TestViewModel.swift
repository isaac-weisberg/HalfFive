import HalfFive

protocol TestViewModel {
    var nextQuestion: Silo<Void, SchedulingMain> { get }
    
    var question: Conveyor<TestCardViewModel, SchedulingMain, HotnessHot> { get }
    
    var nextQuestionLabel: Conveyor<String, SchedulingMain, HotnessHot> { get }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot> { get }
    
    var isLoading: Conveyor<Bool, SchedulingMain, HotnessHot> { get }
}

class TestViewModelImpl {
    typealias Context = TestRetrievalServiceContext
    
    enum State {
        case loading
        case success([TestCardViewModel], index: Int)
        case failed(TestRetrievalServiceError)
    }
    
    let trashBag = TrashBag()
    
    let question: Conveyor<TestCardViewModel, SchedulingMain, HotnessHot>
    let nextQuestionLabel: Conveyor<String, SchedulingMain, HotnessHot>
    let isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot>
    let isLoading: Conveyor<Bool, SchedulingMain, HotnessHot>
    let nextQuestion: Silo<Void, SchedulingMain>
    
    init(context: TestRetrievalServiceContext) {
        let actionMultiplexer = Multiplexer<Void, SchedulingMain>()
        
        nextQuestion = actionMultiplexer
            .asSilo()
        
        let state = Container<State, SchedulingMain>(value: State.loading)
        let scheduling = SchedulingSerial.new()
        
        context.testRetriever.downloadGithubTest()
            .map { res in
                res
                    .then { test -> [TestCardViewModel] in
                        let questionsCount = test.questions.count
                        
                        let questions = test.questions
                            .enumerated()
                            .map { things -> TestCardViewModel in
                                let (index, question) = things
                                
                                let data = TestCardViewModelImpl.Data(
                                    id: question.id,
                                    title: question.title,
                                    questionIndex: index,
                                    questionsTotal: questionsCount,
                                    selection: question.selection,
                                    answers: question.answers)
                                
                                return TestCardViewModelImpl(data: data)
                            }
                        return questions
                    }
            }
            .map { res -> State in
                switch res {
                case .success(let test):
                    return .success(test, index: 0)
                case .failure(let error):
                    return .failed(error)
                }
            }
            .run(on: scheduling)
            .fire(on: SchedulingMain.instance)
            .run(silo: state)
            .disposed(by: trashBag)
        
        question = state
            .map { state -> TestCardViewModel in
                switch state {
                case .success(let questions, let index):
                    return questions[index]
                case .loading:
                    return TestCardViewModelLoadingStub()
                case .failed(let error):
                    return TestCardViewModelLoadingStub()
                }
            }
        
        isLoading = state
            .map { state in
                if case .loading = state {
                    return true
                }
                return false
            }
        
        nextQuestionLabel = state
            .map { state in
                switch state {
                case .success(let questions, let index):
                    let isLast = questions.count - 1 == index
                    return isLast
                        ? "Finish Testing"
                        : "Next Question"
                case .failed(let error):
                    return "Error :("
                case .loading:
                    return "Loading"
                }
            }
        
        isSelectionValid = question
            .flatMapLatest { vm in
                vm.isSelectionValid
            }
            .startWith(event: false)
        
        
        actionMultiplexer
            .withLatest(from: state) { $1 }
            .map { state -> State in
                switch state {
                case .success(let questions, let index):
                    let newIndex = index + 1
                    if questions.count > newIndex {
                        return .success(questions, index: newIndex)
                    }
                    return .success(questions, index: index)
                case .failed, .loading:
                    return state
                }
            }
            .run(silo: state)
            .disposed(by: trashBag)
    }
}

extension TestViewModelImpl: TestViewModel {
    
}
