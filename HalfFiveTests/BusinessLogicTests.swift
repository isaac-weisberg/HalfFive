import XCTest
@testable import HalfFive

class BusinessLogicTests: XCTestCase {
    let trashBag = TrashBag()
    
    let initialSequence =  [1, 2, 34, 5]
    let multiplyAgainst = [ 002, 18, 33 ]
    
    lazy var expectedResults = initialSequence
        .map { val in
            multiplyAgainst.map { val * $0 }
        }
        .reduce([]) { $0 + $1 }
    
    func testSyncFlatmap() {
        let multiplyAgainst = self.multiplyAgainst
        
        let initial = Conveyors
            .from(array: initialSequence)
            .assumeFiresOnMain()
        
        let appliedFlatMap = initial
            .flatMapLatest { val in
                Conveyors.sync {
                    Conveyors.from(array: multiplyAgainst.map { val * $0 })
                }
            }
        
        var syncResults: [Int] = []
        
        appliedFlatMap
            .run { res in
                syncResults.append(res)
            }
            .disposed(by: trashBag)
        
        XCTAssertEqual(syncResults, expectedResults, "Should've already by now emitted all of the events since it's all sync")
    }
}
