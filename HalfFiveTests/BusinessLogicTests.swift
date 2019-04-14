import Foundation
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
    
    func testAsyncFlatmap() {
        let exp = expectation(description: "Should've successfully finished producing all the elements")
        
        let multiplyAgainst = self.multiplyAgainst
        let expectedResults = self.expectedResults
        
        let lock = NSLock()
        
        let initial = Conveyors
            .from(array: initialSequence)
            .run(on: SchedulingMain())
        
        let appliedFlatMap = initial
            .flatMapLatest { val in
                Conveyors.sync {
                    Conveyors.from(array: multiplyAgainst.map { val * $0 })
                }
                .run(on: SchedulingSerial())
            }
            .fire(on: SchedulingSerial())
        
        var syncResults: [Int] = []
        
        appliedFlatMap
            .run { res in
                /* I tried without using the lock
                 but evidently, Array objects mutations
                 are not atomic, and when you get array's `count`
                 in the midst of the `append` happening, you get
                 EXC_BAD_ACCESS which is sorta-- logical...
                 However, at the same time-- wasn't it supposed to be on a serial query?
                 hence.. you know what i mean
                 hence thread safe
                 */
                lock.lock()
                defer { lock.unlock() }
                
                syncResults.append(res)
                if syncResults.count == expectedResults.count {
                    XCTAssertEqual(syncResults.sorted(), expectedResults.sorted(), "All the results should've been populated and be equal")
                    exp.fulfill()
                }
            }
            .disposed(by: trashBag)
        
        wait(for: [exp], timeout: 15.0)
    }
}
