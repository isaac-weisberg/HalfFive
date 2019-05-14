import HalfFive

protocol TestViewModel {
    var nextQuestion: Silo<Void, SchedulingMain> { get }
    
    var question: Conveyor<TestCardViewModel, SchedulingMain, HotnessHot> { get }
    
    var nextQuestionLabel: Conveyor<String, SchedulingMain, HotnessHot> { get }
    
    var isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot> { get }
    
    var isLoading: Conveyor<Bool, SchedulingMain, HotnessHot> { get }
    
    var unitySingular: Conveyor<UnitySingular, SchedulingMain, HotnessCold> { get }
}

class TestViewModelImpl {
    typealias Context = TestRetrievalServiceContext
    
    enum Error: Swift.Error {
        case testRetrieval(TestRetrievalServiceError)
    }
    
    enum State {
        case loading
        case success([TestCardViewModel], index: Int)
        case failed(Error)
        
        var error: Error? {
            if case .failed(let error) = self {
                return error
            }
            return nil
        }
    }
    
    let trashBag = TrashBag()
    
    let question: Conveyor<TestCardViewModel, SchedulingMain, HotnessHot>
    let nextQuestionLabel: Conveyor<String, SchedulingMain, HotnessHot>
    let isSelectionValid: Conveyor<Bool, SchedulingMain, HotnessHot>
    let isLoading: Conveyor<Bool, SchedulingMain, HotnessHot>
    let nextQuestion: Silo<Void, SchedulingMain>
    let unitySingular: Conveyor<UnitySingular, SchedulingMain, HotnessCold>
    
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
                    return .failed(.testRetrieval(error))
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
                case .failed:
                    return TestCardViewModelErrorStub()
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
                case .failed:
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
            .map { state -> State? in
                switch state {
                case .success(let questions, let index):
                    let newIndex = index + 1
                    if questions.count > newIndex {
                        return .success(questions, index: newIndex)
                    }
                    return nil
                case .failed, .loading:
                    return nil
                }
            }
            .filterNil()
            .run(silo: state)
            .disposed(by: trashBag)
        
        unitySingular = state
            .map { state -> UnitySingular? in
                state.error
            }
            .filterNil()
            .assumeIsCold()
    }
}

extension TestViewModelImpl: TestViewModel {
    
}

extension TestViewModelImpl.Error: UnitySingular {
    var unitySingular: EmissionSingular {
        switch self {
        case .testRetrieval(let error):
            return error.unitySingular
        }
    }
}
