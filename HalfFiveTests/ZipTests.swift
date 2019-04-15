import XCTest
@testable import HalfFive

class ZipTests: XCTestCase {
    func testZipCreationalOp() {
        let countBound = 25
        let rangeBound = 25
        
        let range = 0...Int.random(in: 1..<countBound)
        
        let one = Conveyors.from(array: range.map { _ in Int.random(in: 0...rangeBound) })
        let another = Conveyors.from(array: range.map { _ in Int.random(in: 0...rangeBound) })
            .run(on: SchedulingMain())
            .run(on: SchedulingSerial())
            .run(on: SchedulingMain())
            .run(on: SchedulingSerial())
            .run(on: SchedulingMain())
            .run(on: SchedulingSerial())
        
        Conveyors
            .zip(one, another) { ($0, $1) }
            
    }
}
