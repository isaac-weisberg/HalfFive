class TrashCompositeTwo: Trash {
    func dispose() {
        primary?.dispose()
        secondary?.dispose()
    }
    
    var primary: Trash?
    var secondary: Trash?
    
    init(primary: Trash?, secondary: Trash?) {
        self.primary = primary
        self.secondary = secondary
    }
}
