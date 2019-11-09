import Dispatch

public struct MainScheduler: KnownSchedulerType, SingleInstanceScheduler {
    public static let instance = MainScheduler()

    public let queue = DispatchQueue.main

    private init() { }
}
