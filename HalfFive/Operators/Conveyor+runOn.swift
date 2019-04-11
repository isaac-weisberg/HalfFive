import Foundation
import Dispatch

extension Conveyor where Scheduler == SchedulingUnknown {
    func run(on queue: DispatchQueue) -> Conveyor<Event, SchedulingUnknown> {
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
