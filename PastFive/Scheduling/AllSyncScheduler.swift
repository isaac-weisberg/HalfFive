public struct AllSyncScheduler: SchedulerType, SynchronizedScheduler {
    public static func == (lhs: AllSyncScheduler, rhs: AllSyncScheduler) -> Bool {
        return true
    }
}
