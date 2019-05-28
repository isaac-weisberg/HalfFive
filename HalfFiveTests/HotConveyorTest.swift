import XCTest
@testable import HalfFive
import HalfFiveTesting

class HotConveyorTest: XCTestCase {
    typealias C = Conveyors
    
    func testConveyorsHotness() {
        let trivialConvs: [(Conveyor<Void, SchedulingUnknown, HotnessHot>, StaticString, UInt)] = [
            (C.from(array: [(), (), ()]), #file, #line),
            (C.sync { C.from(array: [(), ()]) }, #file, #line),
            (C.just(()), #file, #line),
            (C.combineLatest(C.just(12), C.just(235)) { _, _ in () }, #file, #line),
            (C.zip(C.just(31), C.from(array: ["dic", "fuc"])) { _, _ in () }, #file, #line),
            (C.just(3).flatMapLatest { _ in Conveyors.just(()) }, #file, #line)
        ]
        
        trivialConvs.forEach { stuff in
            XCTAssertTrue(stuff.0.toBlocking().isHot(), "Should've been hot", file: stuff.1, line: stuff.2)
        }
    }
}
