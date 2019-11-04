import Dispatch

func usage() {
    enum EquityProof { }

    let foo = Observables.just(())
    let bar = Observables.just(())
        .observeOn(DispatchQueueScheduler(queue: .global()))
    let baz = Observables.just(())
        .observeOn(MainScheduler())


    print(foo, bar, baz)
}


func a() {
    let first = Observables.just(())
    let second = Observables.just(())

    // will use the super-prime implementation because both are sync
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func b() {
    let first = Observables.just(())
        .observeOn(MainScheduler())
    let second = Observables.just(())
        .observeOn(MainScheduler())

    // will use the super-prime implementation because both are equivalent in terms of EquityProofs
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func c() {
    let first = Observables.just(())
        .observeOn(SerialDispatchQScheduler())
    let second = Observables.just(())
        .observeOn(SerialDispatchQScheduler())

    // won't use the super-prime implementation because although schedulers are
    // type equivalent, their equity is unproven
    _ = Observables.combineLatest(first, second) { _, _ in () }
}


func c2() {
    let queue = DispatchQueue(label: "", attributes: .concurrent)

    let first = Observables.just(())
        .observeOn(DispatchQueueScheduler(queue: queue))
    let second = Observables.just(())
        .observeOn(DispatchQueueScheduler(queue: queue))

    // won't use the super-prime implementation because although schedulers are
    // type equivalent and are equal dynamically,
    // their equity is unproven
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func d() {
    let scheduler = SerialDispatchQScheduler()

    let first = Observables.just(())
        .observeOn(scheduler)
    let second = Observables.just(())
        .observeOn(scheduler)

    // won't use the super-prime implementation because their equity
    // is not proven statically
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func e() {
    enum EquityProof { }

    let scheduler = Equitable(SerialDispatchQScheduler(), EquityProof.self)

    let first = Observables.just(())
        .observeOn(scheduler)
    let second = Observables.just(())
        .observeOn(scheduler)

    // will use the super-prime implementation because the equity is proven statically
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func f() {
    enum EquityProof { }

    let firstScheduler = Equitable(SerialDispatchQScheduler(), EquityProof.self)
    let anotherScheduler = Equitable(SerialDispatchQScheduler(), EquityProof.self)

    let first = Observables.just(())
        .observeOn(firstScheduler)
    let second = Observables.just(())
        .observeOn(anotherScheduler)

    // UNFORTUNATELY, will use the super-prime implementation
    // despite the fact that
    // these are unrelated dispatch queues
    // BUT it will fatalError out without subscribing
    // to the inner observables with a message
    // indicating that you have accidentally used
    // same-type different-instances
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func g() {
    enum OneProof { }
    enum AnotherProof { }

    let scheduler = SerialDispatchQScheduler()

    let first = Observables.just(())
        .observeOn(Equitable(scheduler, OneProof.self))
    let second = Observables.just(())
        .observeOn(Equitable(scheduler, AnotherProof.self))

    // won't use the superprime because the EquityProofs are different
    _ = Observables.combineLatest(first, second) { _, _ in () }
}
