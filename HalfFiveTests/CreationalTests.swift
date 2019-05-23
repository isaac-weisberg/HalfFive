import XCTest
@testable import HalfFive
import HalfFiveTesting

class CreationalTests: XCTestCase {
    func blockingTest<Conveyor: ConveyorType>(_ blocking: Blocking<Conveyor>, events: [Conveyor.Event], file: StaticString = #file, line: UInt = #line) where Conveyor.Hotness == HotnessHot, Conveyor.Event: Equatable {
        XCTAssertTrue(blocking.isHot(), "Should be hot", file: file, line: line);
        XCTAssertTrue(blocking.proveHotness(), "Should prove it's type hotness", file: file, line: line)
        XCTAssertEqual(blocking.hotEvents(), events, "Should have well defined event sequence", file: file, line: line)
    }
    
    func testFromOperator() {
        let values = [3, 52, 123]
        let conv = Conveyors.from(array: values)
        
        let blocking = conv.toBlocking()
        
        blockingTest(blocking, events: values)
    }
    
    func testJustOperator() {
        let value = 3
        let conv = Conveyors.just(value)
        
        let blocking = conv.toBlocking()
        
        blockingTest(blocking, events: [ value ])
    }
    
    func testEmptyOperator() {
        typealias Event = Int
        
        let conv: Conveyor<Event, SchedulingUnknown, HotnessHot> = Conveyors.empty()
        let blocking = conv.toBlocking()
        let events: [Event] = []
        
        XCTAssertEqual(blocking.hotEvents(), events, "Should have well defined event sequence")
    }
}
