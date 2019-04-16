import XCTest
@testable import HalfFive

class ZipTests: XCTestCase {
    let trashBag = TrashBag()
    
    typealias Zip = [Int]
    let countBound = 900
    let rangeBound = 350
    
    lazy var range = 0...Int.random(in: 1..<countBound)
    
    lazy var valuesOne = range.map { _ in Int.random(in: 0...rangeBound) }
    lazy var valuesTwo = range.map { _ in Int.random(in: 0...rangeBound) }
    lazy var one = Conveyors.from(array: valuesOne)
    lazy var another = Conveyors.from(array: valuesTwo)
    
    lazy var expectedResults = { () -> [Zip] in
        var res = [Zip]()
        for (i, valueOne) in valuesOne.enumerated() {
            let valueTwo = valuesTwo[i]
            res.append([valueOne, valueTwo])
        }
        return res
    }()
    
    let timeout: TimeInterval = 2
    
    let schedulingMain = SchedulingMain.instance
    let schedulingSerial = SchedulingSerial.new()
    
    func testZipCreationalOpSync() {
        let trashBag = TrashBag()
        let exp = expectation(description: "Shoulda did all the ting")
        
        checkZip(Conveyors.zip(one, another) { [$0, $1] }, trashBag: trashBag, exp: exp)
        
        wait(for: [ exp ], timeout: timeout)
    }
    
    func testZipCreationalOpAsync() {
        let trashBag = TrashBag()
        let exp = expectation(description: "Shoulda did all the ting")
        
        checkZip(Conveyors.zip(one.fire(on: schedulingMain), another.fire(on: schedulingMain)) { [$0, $1] }, trashBag: trashBag, exp: exp)
        
        wait(for: [ exp ], timeout: timeout)
    }
    
    func testZipCreationalOpAsyncBgFire() {
        let trashBag = TrashBag()
        let exp = expectation(description: "Shoulda did all the ting")
        
        checkZip(Conveyors.zip(one.fire(on: schedulingSerial), another.fire(on: schedulingSerial)) { [$0, $1] }, trashBag: trashBag, exp: exp)
        
        wait(for: [ exp ], timeout: timeout)
    }
    
    func testZipCreationalOpAsyncBgRun() {
        let trashBag = TrashBag()
        let exp = expectation(description: "Shoulda did all the ting")
        
        checkZip(Conveyors.zip(one.run(on: schedulingSerial), another.run(on: schedulingSerial)) { [$0, $1] }, trashBag: trashBag, exp: exp)
        
        wait(for: [ exp ], timeout: timeout)
    }
    
    func testZipCreationalOpAsyncBgRunMainFire() {
        let trashBag = TrashBag()
        let exp = expectation(description: "Shoulda did all the ting")
        
        checkZip(Conveyors.zip(
            one.run(on: schedulingSerial).fire(on: schedulingMain),
            another.run(on: schedulingSerial).fire(on: schedulingMain)
        ) { [$0, $1] }, trashBag: trashBag, exp: exp)
        
        wait(for: [ exp ], timeout: timeout)
    }
    
    func checkZip<Scheduler: SchedulingTrait, Hotness: HotnessTrait>(_ zip: Conveyor<Zip, Scheduler, Hotness>, trashBag: TrashBag, exp: XCTestExpectation) {
        var results = [Zip]()
        zip
            .run { tuple in
                results.append(tuple)
                if results.count == self.expectedResults.count {
                    XCTAssertEqual(results, self.expectedResults, "Should be same")
                    exp.fulfill()
                }
            }
            .disposed(by: trashBag)
    }
}
