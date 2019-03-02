public class Container<Event, Scheduler: Scheduling>: Multiplexer<Event, Scheduler> {
    private(set) var value: Event
    
    public init(value: Event) {
        self.value = value
        super.init()
    }
    
    override func fire(event: Event) {
        super.fire(event: event)
        value = event
    }
    
    override public func run(silo: Silo<Event, Scheduler>) -> Trash {
        let trash = super.run(silo: silo)
        silo.fire(event: value)
        return trash
    }
}
