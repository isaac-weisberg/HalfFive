public extension ConveyorType {
    func share() -> Conveyor<Event, Scheduler, Hotness> {
        let run = self.run(handler:)
        var subscribers = [(Event) -> Void]()
        let trash = run { event in
            subscribers.forEach { handler in
                handler(event)
            }
        }
        return Conveyor { handler in
            subscribers.append(handler)
            return TrashAbstract {
                _ = trash
                subscribers = subscribers.filter { predicate in
                    (predicate as AnyObject) !== (handler as AnyObject)
                }
            }
        }
    }
}
