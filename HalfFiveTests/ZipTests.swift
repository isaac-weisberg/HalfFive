import XCTest
@testable import HalfFive

class ZipTests: XCTestCase {
    let trashBag = TrashBag()
    
    func testZipCreationalOp() {
        typealias Zip = [Int]
        let exp = expectation(description: "Should gather all the results and produce consistent stuff")
        
        let countBound = 25
        let rangeBound = 26
        
        let range = 0...Int.random(in: 1..<countBound)
        
        let valuesOne = range.map { _ in Int.random(in: 0...rangeBound) }
        let valuesTwo = range.map { _ in Int.random(in: 0...rangeBound) }
        
        assert(valuesOne.count == valuesTwo.count, "Fuck off")
        
        let expectedResults = { () -> [Zip] in
            var res = [Zip]()
            for (i, valueOne) in valuesOne.enumerated() {
                let valueTwo = valuesTwo[i]
                res.append([valueOne, valueTwo])
            }
            return res
        }()
        
        
        let one = Conveyors.from(array: valuesOne)
            .fire(on: SchedulingMain())
        
        let another = Conveyors.from(array: valuesTwo)
            .fire(on: SchedulingMain())
        
        var results = [Zip]()
        
        Conveyors
            .zip(one, another) { [$0, $1] }
            .run { tuple in
                results.append(tuple)
                if results.count == expectedResults.count {
                    XCTAssertEqual(results, expectedResults, "Should be same")
                    exp.fulfill()
                }
            }
            .disposed(by: trashBag)
        
        wait(for: [exp], timeout: 20)
    }
}
