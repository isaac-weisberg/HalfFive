import Dispatch

public struct MainScheduler: KnownSchedulerType, SingleInstanceScheduler, SynchronizedScheduler {
    public static let instance = MainScheduler()

    public let queue = DispatchQueue.main

    private init() { }
}
