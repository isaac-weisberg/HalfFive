import XCTest
@testable import HalfFive

class HotConveyorTest: XCTestCase {
    typealias C = Conveyors
    
    func didAllConveyorsEmitSynchronously<C: ConveyorType>(in conveyors: [C]) -> Bool {
        return conveyors
            .map { conveyor in
                var emitted = false
                _ = conveyor.run { _ in
                    emitted = true
                }
                return emitted
            }
            .reduce(true) { $0 && $1 }
    }
    
    let trivialConvs = [
        C.from(array: [(), (), ()]),
        C.sync { C.from(array: [(), ()]) },
        C.just(()),
    ]
    
    func testTrivialConveyors() {
        let result = didAllConveyorsEmitSynchronously(in: trivialConvs)
        
        XCTAssertTrue(result, "All of the trivial conveyors should've emmited synchronously upon subscription")
    }
    
    let combinatorialConvs = [
        C.combineLatest(C.just(12), C.just(235)) { _, _ in () },
        C.zip(C.just(31), C.from(array: ["dic", "fuc"])) { _, _ in () },
        C.just(3).flatMapLatest { _ in Conveyors.just(()) }
    ]
    
    func testCombinatorialConvs() {
        let result = didAllConveyorsEmitSynchronously(in: combinatorialConvs)
        
        XCTAssertTrue(result, "All of the combinatorial conveyors created from trivial conveyors should've emmited synchronously upon subscription")
    }
}
