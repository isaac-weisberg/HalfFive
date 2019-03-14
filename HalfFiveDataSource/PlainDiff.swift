import Foundation

internal func PlainDiff<Event: Diffable>(old: [HalfFiveSection<Event>], new: [HalfFiveSection<Event>]) -> [IndexPath] {
    return new
        .enumerated()
        .map { stuff -> [IndexPath] in
            let (sectionIndex, section) = stuff
            guard case .value(let oldSection) = old.at(index: sectionIndex) else {
                return (0..<section.items.count).map { IndexPath(row: $0, section: sectionIndex) }
            }
            
            return section.items
                .enumerated()
                .compactMap { stuff in
                    let (itemIndex, event) = stuff
                    let indexPath = { IndexPath(row: itemIndex, section: sectionIndex) }
                    guard case .value(let oldEvent) = oldSection.items.at(index: itemIndex) else {
                        return indexPath()
                    }
                    guard event.isIdentical(to: oldEvent) else {
                        return indexPath()
                    }
                    return nil
                }
        }
        .flatMap { $0 }
}

private extension Array {
    enum AtResult {
        case nothing
        case value(Element)
    }
    
    func at(index: Int) -> AtResult {
        guard index < count else {
            return .nothing
        }
        return .value(self[index])
    }
}
