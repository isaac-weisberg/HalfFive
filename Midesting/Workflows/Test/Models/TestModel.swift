struct TestModel {
    enum Selection {
        case single
        case multiple
    }
    
    let questions: [(title: String, selection: Selection, answers: [(id: String, String)])]
}
