import Dispatch

func usage() {
    let foo = Observables.just(())
    let bar = Observables.just(())
        .observeOn(DispatchQueueScheduler(queue: .global()))
    let baz = Observables.just(())
        .observeOn(MainScheduler.instance)


    print(foo, bar, baz)
}


func a() {
    let first = Observables.just(())
    let second = Observables.just(())

    // will use the super-prime implementation
    // because both are sync and all sync
    // schedulers are always equal to each other
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func b() {
    let first = Observables.just(())
        .observeOn(MainScheduler.instance)
    let second = Observables.just(())
        .observeOn(MainScheduler.instance)

    // will use the super-prime implementation
    // because both schedulers are equal
    // because their dispatch queues are referrentially equal
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func c() {
    let first = Observables.just(())
        .observeOn(SerialDispatchQScheduler())
    let second = Observables.just(())
        .observeOn(SerialDispatchQScheduler())

    // won't use the super-prime implementation
    // because although schedulers are
    // type equivalent, on runtime their queues
    // are will be different and synchronization
    // will be required
    _ = Observables.combineLatest(first, second) { _, _ in () }
}


func d() {
    let queue = DispatchQueue(label: "", attributes: .concurrent)

    let first = Observables.just(())
        .observeOn(DispatchQueueScheduler(queue: queue))
    let second = Observables.just(())
        .observeOn(DispatchQueueScheduler(queue: queue))

    // won't use the super-prime implementation.
    // Although they are type equivalent
    // and they will be equal dynamically,
    // the dispatch queue that they use
    // doesn't synchronize the emissions
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func e() {
    let scheduler = SerialDispatchQScheduler()

    let first = Observables.just(())
        .observeOn(scheduler)
    let second = Observables.just(())
        .observeOn(scheduler)

    // will use the super-prime implementation
    // because of static and dynamic equality
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func f() {
    let first = Observables.create { (handler: Handler<Void>) -> Disposable in
        return DisposableVoid()
    }
    let second = Observables.create { (handler: Handler<Void>) -> DisposableVoid in
        return DisposableVoid()
    }

    // will use the super-prime implementation
    // because of static and dynamic equality
    _ = Observables.combineLatest(first, second) { _, _ in () }
}
