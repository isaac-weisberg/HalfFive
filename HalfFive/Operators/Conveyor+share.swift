public extension ConveyorType {
    func share() -> Conveyor<Event, Scheduler, Hotness> {
        let run = self.run(handler:)
        var subscribers = [(Event) -> Void]()
        var trash: Trash?
        return .unsafe { handler in
            subscribers.append(handler)
            if trash == nil {
                trash = run { event in
                    subscribers.forEach { handler in
                        handler(event)
                    }
                }
            }
            return TrashAbstract {
                subscribers = subscribers.filter { predicate in
                    (predicate as AnyObject) !== (handler as AnyObject)
                }
                if subscribers.count == 0 {
                    trash = nil
                }
            }
        }
    }
}
