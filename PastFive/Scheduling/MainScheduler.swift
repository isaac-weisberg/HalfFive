import Dispatch

public struct MainScheduler: KnownSchdulerType, SingleInstanceScheduler {
    public static let instance = MainScheduler()

    public let queue = DispatchQueue.main

    private init() { }
}
