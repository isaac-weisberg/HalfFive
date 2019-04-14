# HalfFive - a reactive programming framework

## Features

1. Strict static information on the events' emission scheduling context
1. Strict static information on synchronous emissions produced on subscription
1. No `onError` and `completed` events and thus no synchronization code and runtime execution order asserting code
1. No execution atomicity enforcing synchronization code for operator predicates and subscriptions handlers because it relies on execution atomicity of GCD work items in serial GCD queues
1. No disposal synchronization code because it relies on atomicity of deinitializers
1. No exceptioning support
1. No NSThread and POSIX threads support

## Rationale

One of the core concepts established by the [ReactiveX](http://reactivex.io)'s Reactive extensions API is transparency of the mutlithreaded execution context in which an `Observable` emits its events. Simply put, the interface of an observable sequence does not carry any information about the following details:

1. Will subscribing to an `Observable` cause any of its events to be emitted synchronously?
1. Will an `Observable` emit events at times when it's not opportune due to the restrictions of the platform?

Let us kick off with the second problem.

### Runtime execution context equaliy

The most famous implementation of Reactive extensions was established for a single threaded environment which supported scheduling of arbitrary code to be executed on the next primary event loop iteration. The platform was the JavaScript virtual machine and the language it was written in was `JavaScript`.

In JavaScript runtime, execution of client code is performed isolated from environment critical functionality, for instance, networking or rendering. Rendering, being a costly and heavily low-level operation, requires the models that represent the contents to be rendered to be frozen and immutable for the duration of rasterization process in order to provide consistent, determined results. This decision is conscious and is seen in at most all implementations in the world ever.

Modification of the models that represent the view (spoiler: DOM objects) in JavaScript can not be performed concurrently with a rendering process by design. This means that no matter how you schedule your code, all instances of it have equal rights on mutation of any objects in the scope the code can reach. 

Some other environments don't put any restrictions on scheduling just because they do support being worked with on no matter what thread. There, you are free to `subscribeOn` and `observeOn` operators multiple times and the only consideration you will have is only the context transition logic you yourself put into it.

Spoiler: Foundation platforms are not that. UIKit part of iOS - in particular. Here, a full-pledged multithreaded environment allows for arbitrary concurrently scheduled code execution. UIKit does not support a multitude of its functionality to be run *not* from the main app thread and on such occasions you get a runtime error. And there is no way to statically check whether if you are interacting with UIKit APIs from the main thread or not.

Well, this framework is an attempt to statically check the execution context and prevent you from making mistakes that will be known only on runtime

#### How does it work?

Whenever you have an observable sequence on your hands, it also carries with it information about the scheduling of its emissions. It is represented by a generic type parameter that conforms to `Scheduling` protocol. This is similar to how observable sequences' traits are implemented in [RxSwift](https://github.com/ReactiveX/RxSwift).

If you use a `map` operator on such observable, since `map`'s predicate is performed synchronously, it will produce a new observable **with the same scheduling trait** as the initial observable.

You might be interested to combine this observable with some other observable using the `combineLatest` operator. In RxSwift, since 2 observables might both emit their events on different dispatch queues, my bet is that you either get an observable that emits in the contexts of 2 queues, each time undetermined, or additonal synchronization code comes into play that schedules the execution to one of the queues, or maybe some other queue, which causes runtime overhead.

Well, here, 2 observables are required to have the same scheduling in order for the code to compile, forcing the programmer to actually think how are they going to expect the sequences to behave.

Changes in the execution context are performed in a fashion similar to Rx's `subscribeOn` and `observeOn` (but called different). 

And usage a `flatMap` operator commonly produces observables with the same scheduling as what you flat-map *into*.

The following `SchedulingTrait` implementations are available

- `SchedulingUnknown` - may emit events on different queues
- `SchedulingMain` - will emit events ONLY on the main queue
- `SchedulingSerial` - will emit events ONLY on a serial non-main dispatch queue 

And now let's take a look at the first problem called out earlier

### Synchronous emission upon subscription

The question is "Will subscribing to an observable cause the subscription handler to be run synchronously in the current execution context?". Another concept introduced by Reactive extensions is *Hotness* on an observable sequence. Here, an observable sequence is known to be hot in case if subscribing to it will cause the subscription handler to be run synchronously in the same execution context as the one in which the `subscribe` call is performed. And if it won't, then it's counted as cold. 

The thing however is that in Rx the observable types are totally transparent about it and becoming aware of their hotness can only be achieved by acknowledging their implementation details. For instance, we do know that `PublishSubject` doesn't hold much of internal state except for a family of connected subscribers and this state is atomic across it's emissions. However, a `BehaviorSubject` does have an internal state that upon mutation causes it to emit an event to at least one of the connected subscribers. This leaves a programmer in a situation in which he can have an `Observable` that will be emitting its events into the `BehaviorSubject` on a background queue, but in case if he will be subscribing to the subject on main queue, the subscription handler will be run once on main queue and whatever-amount-of-events times on background queue.

Now imagine that the earlier `Obsevable` used to emit events on the main thread, but later its implementation was changed to emit on background queue. Initially you used to subscribe to it on main queue and it emitted on main queue onwards, so you decide to leave the code as is knowing that in this case it's completely safe to propagate these emissions into the "view layer" of the app. You subscribing caused the Subject to emit its initial value synchronously and there, the first configuration of your view occured.

Once the earlier observable started emitting items on the background queue, it is necessary for you to transfer the scheduling of these events to the main queue using the `observeOn` operator with an async instance of `MainScheduler`. However, oh dear, it will cause the event emission upon subscription to happen through this context transfer and you will happily have a single frame of your apps view in an unconfigured state because the subscriptions handler doesn't run synchronously anymore.

This framework aims to fix that that and make the semantics more opaque.

#### How does it work?

Whenever you have an observable on your hands it also carries a trait that denotes whether if an observable is hot.

You apply a `map` operator, predecat of which is performed synchronously, and the hotness of the new observable is preserved.

Say, you had an observable that was known not to emit any of its elements synchronously on subscription and so it was cold. Then you use a `startWith` operator. The new observable, as you guess, will be hot.

One could be interested in zipping the emissions in pairs uzing a `zip` operator. If at least one of the observables is cold, this means that initially upon subscription there will just be nothing to emit and thus the resulting observable is cold. However, if both are hot, this will lead to an emission of at least one event, resulting in a hot observable. Same behavior applies to `combineLatest`.

The `PublishSubject` (spoiler: here it is called `Multiplexer`) is cold. But the `BehaviorSubject` (spoiler: `Container`) is actually hot.

**NB: the scheduling of an observable does not apply to the context of hot emissions. If it's scheduled on a background queue, but is hot and is subscribed to on the main queue - it still counts as scheduled on background queue.**

The following `HotnessTrait` implementations are available

- `HotnessHot`
- `HotnessCold`

## Thesaurus

| RxSwift semantics | HalfFive semantics |
|-----------------------------|--------------------|
| `Observable` | `Conveyor` |
| `Observer` | `Silo` |
| `subscribe` | `run` |
| `observe` | `fire` |
| `subscribeOn` | `runOn` |
| `observeOn` | `fireOn` |
| `PublishSubject` and alike | `Multiplexer` |
| `BehaviorSubject` and alike | `Container` |

## Usage Guidelines

### Prefer hot creational operators over cold whenever possible

At some point you of course get to a system-close task and feel a need to wrap an interaction with the system into an observable. These occasions most often are wrappings around `URLSession.dataTask` and `Data.init(contentsOf:)`. The rules to remember are the following:

1. If the operation can be performed synchronously, use `sync` creational operator to produce an explicitly hot observable
1. If the operation notifies of its results in an asynchronous context and you can't pefrorm it synchronously without locking the thread of execution using synchronization primitives, only then should you use `async` creational operator to produce an observable that is explicitly cold

Let's take a look at an example of wrapping a `Data.init(contentsOf:)`

```swift
func download(contentsOf url: URL) -> Conveyor<DownloadResult, SchedulingUnknown, HotnessHot> {
    return Conveyors.sync {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            return Conveyors.just(.failure(error))
        }
        return Conveyors.just(.success(data))
    }
}
```

Seems legit. The call to the `Data.init(contentsOf:)` will block the current thread until the data is downloaded. You explicitly show that the subscription event handling code will be run synchronously by creating the conveyor with `sync` operator.
