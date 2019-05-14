protocol Unity {
    
}

protocol UnitySingular: Unity {
    var unitySingular: EmissionSingular { get }
}

protocol EmissionSingular {
    var description: String { get }
}

struct EmissionSingularCommon: EmissionSingular {
    let description: String
}
