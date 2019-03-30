class TrashCompositeTwo: Trash {
    var primary: Trash?
    var secondary: Trash?
    
    init(primary: Trash?, secondary: Trash?) {
        self.primary = primary
        self.secondary = secondary
    }
}
