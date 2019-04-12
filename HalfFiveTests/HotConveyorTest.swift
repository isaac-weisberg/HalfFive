import XCTest
@testable import HalfFive

class HotConveyorTest: XCTestCase {
    typealias C = Conveyors
    
    let convs: [Conveyor<Void, SchedulingUnknown, HotnessHot>] = [
        C.from(array: [(), (), ()]),
        C.sync { C.from(array: [(), ()]) },
        C.just(()),
        C.combineLatest(C.just(12), C.just(235)) { _, _ in () },
        C.zip(C.just(31), C.from(array: ["dic", "fuc"])) { _, _ in () },
    ]

    func testHotConveyors() {
        convs.forEach { conveyor in
            var emitted = false
            _ = conveyor.run {
                emitted = true
            }
            XCTAssertTrue(emitted, "Should've been already executed")
        }
    }
}
