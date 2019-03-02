protocol TestCardViewModel {
    var progressLabel: String { get }
    
    var questionTitle: String { get }
}

class TestCardViewModelImpl {
    struct Data {
        let title: String
        let questionIndex: Int
        let questionsTotal: Int
    }
    
    let data: Data
    
    init(data: Data) {
        self.data = data
    }
}

extension TestCardViewModelImpl: TestCardViewModel {
    var progressLabel: String {
        return "Question \(data.questionIndex + 1) out of \(data.questionsTotal)"
    }
    
    var questionTitle: String {
        return data.title
    }
}
