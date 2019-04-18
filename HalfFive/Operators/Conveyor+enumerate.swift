public extension ConveyorType {
    func enumerate() -> Conveyor<(Int, Event), Scheduler, Hotness> {
        var next: Int = 0
        return map { event in
            let index = next
            next += 1
            return (index, event)
        }
        
    }
}
