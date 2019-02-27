import Foundation
import Dispatch

extension Conveyor {
    func runOn(queue: DispatchQueue) -> Conveyor<Event> {
        let run = self.run
        return Conveyor { silo in
            let trash = TrashDeferred()
            queue.async {
                trash.update(with: run(silo))
            }
            return trash
        }
    }
}
