struct TestModel {
    enum Selection {
        case arbitrary
        case single
        case multiple
        
        init(github: TestGithubRemoteDTO.QuestionDTO.Selection) {
            switch github {
            case .arbitrary:
                self = .arbitrary
            case .single:
                self = .single
            case .multiple:
                self = .multiple
            }
        }
    }
    
    let questions: [(title: String, selection: Selection, answers: [(id: String, String)])]
    
    init(github: TestGithubRemoteDTO) {
        questions = github.questions
            .map { q in
                (title: q.title, selection: Selection(github: q.selection), answers: q.answers.map { a in (id: a.title, a.title )} )
            }
    }
    
    init(literally questions: [(title: String, selection: Selection, answers: [(id: String, String)])]) {
        self.questions = questions
    }
}

extension TestModel {
    static func hardcodedData() -> TestModel {
        return TestModel(
            literally: [
                (title:"How to eat me a burger?", selection: .single, answers: [(id: "a", "With mouth")]),
                (title:"Where to buy MGSV?", selection: .multiple,answers: [(id: "f","GameStop"), (id: "as", "PlayMarket"), (id: "fof","FUck off"), (id: "a", "With mouth"), (id: "load","dfgsny\naebrqebtbt bwrtb wtrb\nqerg qeh trh\n werg 145g\n qbtwbt")]),
                (title:"Can you stop this please?", selection: .single, answers: [(id: "fof","FUck off")]),
                (title:"How to ass?", selection: .single, answers: [(id: "load","dfgsny\naebrqebtbt bwrtb wtrb\nqerg qeh trh\n werg 145g\n qbtwbt")])
            ]
        )
    }
}
