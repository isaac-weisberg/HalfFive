import HalfFive
import UIKit

public class HalfFiveTableDataSource<Event>: NSObject, UITableViewDataSource {
    public typealias Configurer = (UITableView, HalfFiveTableDataSource, IndexPath, Event) -> UITableViewCell
    
    let configurer: Configurer
    
    public let sections = Container<[HalfFiveSection<Event>], SchedulingMain>(value: [])
    
    public private(set) lazy var silo = sections.asSilo()
    
    public init(_ configurer: @escaping Configurer) {
        self.configurer = configurer
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
