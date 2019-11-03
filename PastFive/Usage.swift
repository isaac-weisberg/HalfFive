func usage() {
    let foo = Observables.just(())
    let bar = Observables.just(())
        .observeOn(DispatchQueueScheduler(queue: .global()))
    let baz = Observables.just(())
        .observeOn(MainScheduler())


    print(foo, bar, baz)
}
