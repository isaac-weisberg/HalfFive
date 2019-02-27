import Dispatch

extension Conveyor {
    func fireOn(queue: DispatchQueue) -> Conveyor {
        let run = self.run
        return Conveyor { silo in
            run(Silo { event in
                queue.async {
                    silo.fire(event: event)
                }
            })
        }
    }
}
