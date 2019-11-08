public struct AllSyncScheduler: SchedulerType, SingleInstanceScheduler {
    public static let instance = AllSyncScheduler()

    private init() { }
}
