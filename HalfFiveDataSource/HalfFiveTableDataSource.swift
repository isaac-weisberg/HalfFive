import HalfFive
import UIKit



public class HalfFiveTableDataSource<Event>: NSObject, UITableViewDataSource {
    public typealias Sections = [HalfFiveSection<Event>]
    
    public typealias Configurer = (UITableView, HalfFiveTableDataSource, IndexPath, Event) -> UITableViewCell
    
    let configurer: Configurer
    
    public let sections = Container<Sections, SchedulingMain>(value: [])
    
    let newSections = Multiplexer<Sections, SchedulingMain>()
    
    public private(set) lazy var silo = sections.asSilo()
    
    let trashBag = TrashBag()
    
    public init(_ configurer: @escaping Configurer) {
        self.configurer = configurer
        
        super.init()
        
        newSections
            .withLatest(from: sections) { (new: $0, old: $1) }
            .do {[unowned self] stuff in
                self.sections.fire(event: stuff.new)
                let diff = PlainDiff(old: stuff.old, new: stuff.new)
                // wait a second, how do I propagate the differentiated index paths...?
            }
            .run { _ in }
            .disposed(by: trashBag)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.value[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configurer(tableView, self, indexPath, sections.value[indexPath.section].items[indexPath.row])
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.value.count
    }
}
