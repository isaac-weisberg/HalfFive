public struct AllSyncScheduler: SchedulerType, SynchronizedScheduler {
    public static func instantiate() -> AllSyncScheduler {
        return AllSyncScheduler()
    }

    public static func == (lhs: AllSyncScheduler, rhs: AllSyncScheduler) -> Bool {
        return true
    }
}
