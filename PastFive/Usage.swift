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

    // will compile because both are sync
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func b() {
    let first = Observables.just(())
        .observeOn(MainScheduler())
    let second = Observables.just(())
        .observeOn(MainScheduler())

    // will compile because both are equivalent in terms of EquityProofs
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func c() {
    let first = Observables.just(())
        .observeOn(SerialDispatchQScheduler())
    let second = Observables.just(())
        .observeOn(SerialDispatchQScheduler())

    // won't compile because although schedulers are
    // type equivalent, their equity is unproven
//    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func d() {
    let scheduler = SerialDispatchQScheduler()

    let first = Observables.just(())
        .observeOn(scheduler)
    let second = Observables.just(())
        .observeOn(scheduler)

    // won't compile because their equity
    // is not proven statically
//    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func e() {
    enum EquityProof { }

    let scheduler = SerialDispatchQScheduler().equitable(by: EquityProof.self)

    let first = Observables.just(())
        .observeOn(scheduler)
    let second = Observables.just(())
        .observeOn(scheduler)

    // will compile because the equity is proven statically
    _ = Observables.combineLatest(first, second) { _, _ in () }
}

func f() {
    enum EquityProof { }

    let firstScheduler = SerialDispatchQScheduler().equitable(by: EquityProof.self)
    let anotherScheduler = SerialDispatchQScheduler().equitable(by: EquityProof.self)

    let first = Observables.just(())
        .observeOn(firstScheduler)
    let second = Observables.just(())
        .observeOn(anotherScheduler)

    // UNFORTUNATELY, will compile despite the fact that
    // these are unrelated dispatch queues
    _ = Observables.combineLatest(first, second) { _, _ in () }
}
