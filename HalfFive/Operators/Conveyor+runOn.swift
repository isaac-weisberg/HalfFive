import Foundation
import Dispatch

extension Conveyor {
    func run(on queue: DispatchQueue) -> Conveyor {
        let run = self.run(handler:)
        return Conveyor { handler in
            let trash = TrashDeferred()
            queue.async {
                trash.trash = run(handler)
            }
            return trash
        }
    }
}
