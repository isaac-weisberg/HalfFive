func usage() {
    enum EquityProof { }

    let foo = Observables.just(())
    let bar = Observables.just(())
        .observeOn(DispatchQueueScheduler<EquityProof>(queue: .global()))
    let baz = Observables.just(())
        .observeOn(MainScheduler())


    print(foo, bar, baz)
}
