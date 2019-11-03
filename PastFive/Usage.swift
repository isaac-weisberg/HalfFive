func usage() {
    enum EquityProof { }

    let foo = Observables.just(())
    let bar = Observables.just(())
        .observeOn(DispatchQueueScheduler(queue: .global()))
    let baz = Observables.just(())
        .observeOn(MainScheduler())


    print(foo, bar, baz)
}


func combineLatest() {
    let firstA = Observables.just(())
    let secondA = Observables.just(())

    // won't compile
//    let Acombine = Observables.combineLatest(firstA, secondA) { _, _ in () }

    let Bfirst = Observables.just(())
        .observeOn(MainScheduler())
    let Bsecond = Observables.just(())
        .observeOn(MainScheduler())

    // compiles!
    let Bcombine: Observable<Void, AsyncRunner<MainScheduler>> = Observables.combineLatest(Bfirst, Bsecond) { _, _ in () }
}
