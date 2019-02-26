class Container<Event>: Multiplexer<Event> {
    private(set) var value: Event
    
    init(value: Event) {
        self.value = value
        super.init()
    }
    
    override func fire(event: Event) {
        super.fire(event: event)
        value = event
    }
    
    override func run(silo: Silo<Event>) -> Trash {
        let trash = super.run(silo: silo)
        silo.fire(event: value)
        return trash
    }
}
