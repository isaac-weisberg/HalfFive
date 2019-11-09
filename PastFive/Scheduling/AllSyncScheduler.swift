public struct AllSyncScheduler: SchedulerType, SingleInstanceScheduler, SynchronizedScheduler {
    public static let instance = AllSyncScheduler()

    private init() { }
}
