public class Container<Event, Scheduler: SchedulingHot & Scheduling & SchedulingConst>: Multiplexer<Event, Scheduler> {
    public private(set) var value: Event
    
    public init(value: Event) {
        self.value = value
        super.init()
    }
    
    override public func fire(event: Event) {
        super.fire(event: event)
        value = event
    }
    
    public override func run(handler: @escaping (Event) -> Void) -> Trash {
        let trash = super.run(handler: handler)
        handler(value)
        return trash
    }
}
