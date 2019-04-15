class TestGithubRemoteDTO: Decodable {
    struct QuestionDTO: Decodable {
        struct Answer: Decodable {
            let title: String
        }
        
        enum Selection: Decodable {
            case arbitrary
            case single
            case multiple
            
            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                let value = try container.decode(Int.self)
                if value > 1 {
                    self = .multiple
                    return
                } else if value < 1 {
                    self = .arbitrary
                }
                self = .single
            }
        }
        
        let title: String
        let answers: [Answer]
        let selection: Selection
    }
    
    let questions: [QuestionDTO]
}
