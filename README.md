# HalfFive - a reactive programming framework

## Features

1. Strict static information on the events' emission scheduling context
1. No `onError` and `completed` events
1. No synchronization code
1. No exceptioning support

## Rationale

One of the core concepts established by the [ReactiveX](http://reactivex.io)'s Reactive extensions API is transparency of the mutlithreaded execution context in which an `Observable` emits its events. Simply put, the interface of an observable sequence does not carry any information about the following details:

1. Will subscribing to an `Observable` cause any of its events to be emitted synchronously?
1. Will an `Observable` emit events at times when it's not opportune due to the restrictions of the platform?

The most famous implementation of Reactive extensions was established for a single threaded environment which supported scheduling of arbitrary code to be executed on the next primary event loop iteration. The platform was the JavaScript virtual machine and the language it was written in was `JavaScript`.

In JavaScript runtime, execution of client code is performed isolated from environment critical functionality, for instance, networking or rendering. Rendering, being a costly and heavily low-level operation, requires the models that represent the contents to be rendered to be frozen and immutable for the duration of rasterization process in order to provide consistent, determined results. This decision is conscious and is seen in at most all implementations in the world ever.

Modification of the models that represent the view (spoiler: DOM objects) in JavaScript can not be performed concurrently with a rendering process by design. This means that no matter how you schedule your code, all instances of it have equal rights on mutation of any objects in the scope the code can reach. 

Some other environments don't put any restrictions on scheduling just because they do support being worked with on no matter what thread. There, you are free to `subscribeOn` and `observeOn` operators multiple times and the only consideration you will have is only the context transition logic you yourself put into it.

Spoiler: Foundation platforms are not that. UIKit part of iOS - in particular. Here, a full-pledged multithreaded environment allows for arbitrary concurrently scheduled code execution. UIKit does not support a multitude of its functionality to be run *not* from the main app thread and on such occasions you get a runtime error. And there is no way to statically check whether if you are interacting with UIKit APIs from the main thread or not.

**Well, this framework is an attempt to statically check the execution context and prevent you from making mistakes that will be known only on runtime** 

## How does it work?

Whenever you have an observable sequence on your hands, it also carries with it information about the scheduling of its emissions. It is represented by a generic type parameter that conforms to `Scheduling` protocol. This is similar to how observable sequences' traits are implemented in [RxSwift](https://github.com/ReactiveX/RxSwift).

If you use a `map` operator on such observable, since `map`'s predicate is performed synchronously, it will produce a new observable **with the same scheduling trait** as the initial observable.

You might be interested to combine this observable with some other observable using the `combineLatest` operator. In RxSwift, since 2 observables might both emit their events on different dispatch queues, my bet is that you either get an observable that emits in the contexts of 2 queues, each time undetermined, or additonal synchronization code comes into play that schedules the execution to one of the queues, or maybe some other queue, which causes runtime overhead.

Well, here, 2 observables are required to have the same scheduling in order for the code to compile, forcing the programmer to actually think how are they going to expect the sequences to behave.
