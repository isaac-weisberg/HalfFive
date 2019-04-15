enum ResultTing<Value, Error> {
    case success(Value)
    case failure(Error)
}


extension ResultTing {
    func then<NewValue>(_ predicate: (Value) -> NewValue) -> ResultTing<NewValue, Error> {
        switch self {
        case .success(let value):
            return .success(predicate(value))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func then<NewValue>(_ predicate: (Value) -> ResultTing<NewValue, Error>) -> ResultTing<NewValue, Error> {
        switch self {
        case .success(let value):
            return predicate(value)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func `catch`<NewError>(_ predicate: (Error) -> ResultTing<Value, NewError>) -> ResultTing<Value, NewError> {
        switch self {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return predicate(error)
        }
    }
}
