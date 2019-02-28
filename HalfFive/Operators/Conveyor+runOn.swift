import Foundation
import Dispatch

extension Conveyor {
    func run(on queue: DispatchQueue) -> Conveyor {
        let run = self.run(silo:)
        return Conveyor { silo in
            let trash = TrashDeferred()
            queue.async {
                trash.update(with: run(silo))
            }
            return trash
        }
    }
}
