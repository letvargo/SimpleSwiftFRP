# SimpleSwiftFRP
A simple Functional Reactive Programming library for Swift

Now updated for Swift 1.2.

I am in the process of coding examples. The first, <a href="https://github.com/letvargo/SimpleFRPBindings">`SimpleFRPBindings` is available here</a>.

## Overview

`SimpleSwiftFRP` is a framework that helps separate program logic from program state. Application events are channeled through an event stream where they are transformed, filtered, stored and otherwise manipulated before being turned into program output.

The design is intentionally simple. The intention is to make it easy for people to experiment with Functional Reactive Programming in Swift without having to master a complex system. 

Right now the entire public API consists of the following:

 - Four classes: `Source<T>`, `Stream<T>`, `Cell<T>` and `Outlet<T>`
 - Four public instance methods (two for `Source` and two for `Cell`)
 - One public property (a `Cell`'s `value` property)

Despite its outward simplicity, `SimpleSwiftFRP` can be used to create complex application behaviors.

Values enter the event stream through an instance of the `Source` class, and exit as output through an instance of the `Outlet` class, but in between the `Source` and the `Outlet` the event stream is a closed system that is referentially transparent and produces no side effects.

`SimpleSwiftFRP` uses a set of six primitive infix operators (described later) that provide a visual language for constructing complex application behaviors. The following is a simple example of a `Source` being lifted into a `Cell` and then connected to an `Outlet` using two of the primitive operators. It is a basic "Hello World" type behavior:

    let srcMessage = Source<String>()
    let cMessage = Cell<String>(initialValue: "")
    let oMessage = Outlet<String>()
    
    srcMessage
        --^ cMessage                      // the lift operator:   --^ 
        --< (oMessage, println)           // the output operator: --<
      
    srcMessage.send("Hello World!")       // Output: "Hello World!"
    srcMessage.send("Goodbye for now.")   // Output: "Goodbye for now."
      
The above example is very simple, but complex behaviors derived from multiple `Source`s, `Stream`s and `Cell`s can be built up from less complex patterns, while the code itself retains the feel of a wiring diagram or a flowchart. Note that the *behavior* (printing the message) occurs automatically whenever a new value is introduced.

While the code above is more complicated than you would normally use to execute a call to `println`, it offers benefits that become important as application behaviors become more complex. All stored values are immutable and stored as a series of events occurring at a specific point in time. Inside the event stream there are no side effects and referential integrity is maintained. Access to all values is synchronized and thread-safe and the behaviors are non-blocking.

`SimpleSwiftFRP` works very well with Cocoa. Any application event can cause a value to be transmitted through the event stream. Cocoa is one giant event factory. Generally all you need to do is have an event trigger a call to a `Source`'s `send` method and supply a value. The following example is a typical `IBAction` type function that takes the string value of a text field and sends it into the event stream for processing:

    // In this example srcTextFieldInput is a Source<String>
    @IBAction func textFieldInput(sender: AnyObject) {
        srcTextFieldInput.send(sender.stringValue)
    }

All actual processing of the input is handled inside the event stream. While `IBAction`s are the most obvious way to send a value into the event stream, you can use any type of system event. Notifications sent from `NSNotificationCenter` are another common way to trigger the event stream.

## Primary Classes

`SimpleSwiftFRP` utilizes four main classes:

1. `Source<T>`
2. `Stream<T>`
3. `Cell<T>`
4. `Outlet<T>`

### `Source<T>`

The sole purpose of a  `Source` is to provide a place where values enter the event stream. 

`Source` has a single publicly available initializer:
    
    init()

`Source` has a public instance method called `send:` that is used to introduce a new value into the event stream:

    public func send(value: T)
    
You can also provide a callback closure which will be called immediately after the value is sent:

    public func send(value: T, callback: () -> ())
    
Note that the callback is executed immediately after the value is sent. It does not wait for all actions that may flow from the sending of the new value to complete. However, if the callback is another call to `send`, the second `send` will be processed immediately after the first on a serial queue, so they will be processed in order. 

Consequently, if you have multiple values that you need to send in a particular order, you can accomplish this using nested callbacks:

    srcA.send("First message") {
        self.srcA.send("Second message")   // "Second Message" will be sent
    }                                      // immediately after "First Message"

Using nested `send` callbacks also ensures that the values will be sent back-to-back and no other value will be sent in between.

A `Source` does not have any public properties and does not have a value of its own. None of the values that it sends are stored or used after they are introduced into the event stream. 
    
A `Source` can be used as the left-hand argument for the `map` ( `>--` ), `filter` ( `--|` ), `filterNil` ( `--!` ), or `lift` ( `--^` ) primitive operators. It cannot be used as the right-hand argument for any of the operators.

A full discussion of the primitive operators occurs below.

### `Stream<T>`

`Stream` does not have any public instance methods or publicly available properties. The purpose of a `Stream` is to provide a node in the event stream where values can be transformed, filtered, or lifted from, but it does not have a value of its own that can be accessed.

`Stream` has one publicly available initializer:

    init()
    
You use a `Stream` by using it as an argument with one of the primitive infix operators. It can be used as the left-hand argument or right-hand argument for the `map` ( `>--` ), `filter` ( `--|` ), and `filterNil` ( `--!` ) operators, and as the left-hand argument for the `merge` ( `--&` ) and `lift` ( `--^` ) operators.

A full discussion of the primitive operators occurs below.

### `Cell<T>`

The purpose of a `Cell` is to store values as they occur and to provide a node for `Outlet`s that transform the value of a `Cell` into output.

`Cell` has two public initializers:

    init(initialValue: T, limit: Int = Int.max)
    init(constant: T)
    
If you have a value that will not change but that you would like to use in the event stream, the preferred method is to use create a `Cell` that is initialized with that value, but that never changes. That is the purpose of the `init(constant: T)` initializer. The value can be used inside the event stream without the event stream having to look to "outside" values - i.e., this practice maintains the closed-system quality of the event stream and ensures that the event stream will not be influenced by side effects produced by other parts of your application.

A `Cell` is guaranteed to always have at least one value - the value that you supply when the `Cell` is initialized. Whenever an event occurs that affects the value of a `Cell`, the `Cell` creates a `(time, value)` tuple and stores the tuple as an event. By default a `Cell` can store any number of events up to `Int.max`. For memory management purposes you can set a limit to the number of events that will be stored by a `Cell`. The initial value supplied at initialization is always stored in addition to any subsequent events such that the actual number of events that is stored is `limit + 1`. Once the number of events exceeds `limit + 1`, the `Cell` will discard older events (not including the initial value) each time a new event is created.

`Cell` has one publicly available property, `value`:

    public var value: T

`value` returns the value of the `Cell` at the time that the value is requested. It is a shortcut for calling `valueAt(now())`.

`Cell` also has a public function called `valueAt(time: Time)`:

    public func valueAt(time: Time) -> T

`valueAt` returns the `Cell`'s value at the specified time. Right now this has limited functionality, but the plan is to implement a means of tracking, browsing, and restoring values. Theoretically, the history of every value stored in a `Cell` is retrievable and it ought to be possible to recreate the application state as it existed at any point in time after its launch.
    
A `Cell` can be the left-hand argument for all six of the primitive operators except for the `merge` ( `--&` ) operator. It can be the right-hand argument for the `lift` ( `--^` ) operator.

A full discussion of the primitive operators occurs below.

### `Outlet<T>`

The sole purpose of an `Outlet` is to perform some kind of an output operation. Anything that alters some aspect of the program state outside of the event stream is considered output. Updates to the user interface are the most obvious example.

`Outlet` has one public initializer:

    init()
    
`Outlet` has no public properties and no public instance methods.

An `Outlet` must be attached to a `Cell` in order to work. You cannot attach an `Outlet` to a `Source`, a `Stream`, or another `Outlet`.

An `Outlet` can be the right-hand argument for the `output` ( `--<` ) operator. It cannot be the left-hand argument for any operator.

A full discussion of the primitive operators occurs below.

## Primitive Operators

`SimpleSwiftFRP` uses six primitive infix operators:

 1. The `map` operator: `>--`
 2. The `filter` operator: `--|`
 3. The `filterNil` operator: `--!`
 4. The `merge` operator: `--&`
 5. The `lift` operator: `--^`
 6. The `output` operator: `--<`

Using these six operators it is possible to build complex application behaviors that are referentially transparent and produce no side effects except through designated `Outlet`s.

### The `map` operator: `>--`
    
    public func >-- <T, U>(stream: Stream<T>, args: (stream: Stream<U>, f: T -> U)) -> Stream<U>
    public func >-- <T, U>(source: Source<T>, args: (stream: Stream<U>, f: T -> U)) -> Stream<U>
    public func >-- <T>(source: Source<T>, stream: Stream<T>) -> Stream<T>
    public func >-- <T, U>(cell: Cell<T>, args: (stream: Stream<U>, f: T -> U)) -> Stream<U>
    public func >-- <T>(cell: Cell<T>, stream: Stream<T>) -> Stream<T>

The `map` operator let's you connect two `Stream`s of different types together using a transformation closure. The syntax looks like this:

    // Example: map operator syntax
    streamA
        >-- (streamB, transformAToB)

The left-hand argument is a `Stream`, a `Source` or a `Cell`. The right-hand argument is a tuple consisting of the `Stream` that you are mapping to and the closure that will transform the values.

In the above example, if `streamA` is a `Stream<Int>` and `streamB` is a `Stream<Double>`, then `transformAToB` must be a closure that takes an `Int` as its input parameter and returns a `Double`.

The `map` operator returns the `Stream` on the right-hand side so that it can be used as the left-hand side argument in a chain of operations:

    // Example: chaining mapped Streams
    streamA
        >-- (streamB, transformAToB)
        >-- (streamC, transformBToC)

### The `filter` operator: `--|`

    public func --| <T>(stream: Stream<T>, args: (stream: Stream<T>, f: T -> Bool)) -> Stream<T>
    public func --| <T>(source: Source<T>, args: (stream: Stream<T>, f: T -> Bool)) -> Stream<T>
    public func --| <T>(cell: Cell<T>, args: (stream: Stream<T>, f: T -> Bool)) -> Stream<T>

The `filter` operator lets you set a condition for what type of values will continue to be passed through the event stream.

    // Example: filter operator syntax
    streamA
        --| (streamB, { $0 >= 0 })

In the above example, assuming `streamA` and `streamB` are both instances of `Stream<Int>`, `streamB` will only pass on positive integers.

The left-hand argument is a `Stream`, a `Source` or a `Cell`. The right-hand argument is a tuple consisting of the `Stream` that will pass on unfiltered values and a closure that represents the filter predicate.

The `filter` operator supports chaining off of the `Stream` element of the right-hand side argument:

    // Example: chaining off of a filtered stream
    streamA
        --| (streamB, { $0 >= 0 })
        >-- (streamC, { $0 * 10 })
        
In the above example, again assuming that all constants are instances of `Stream<Int>`, `streamA` is filtered to `streamB` and `streamB` is mapped to `streamC`.

### The `filterNil` operator: `--!`

    public func --! <T>(streamA: Stream<T?>, streamB: Stream<T>) -> Stream<T>
    public func --! <T>(source: Source<T?>, stream: Stream<T>) -> Stream<T>
    public func --! <T>(cell: Cell<T?>, stream: Stream<T>) -> Stream<T>

The `filterNil` operator operates in exactly the same way as the `filter` operator, except that it is designed to filter `nil` values only, allowing you to convert a stream of `Optional` values to a stream of non-`Optional` values.

    // Example: filterNil operator syntax
    let srcA = Source<String>()
    let streamA = Stream<Int?>()
    let streamB = Stream<Int>()
    
    srcA
        >-- (streamA, { $0.toInt() })
        --! streamB

In the example above, a `String`'s `toInt()` method is used to convert `srcA`'s value to an `Int?`, and then the `filterNil` operator is applied to `streamA` such that `streamB` will only pass on values that are non-`nil`.

The left-hand side argument is a `Source`, `Stream` or `Cell` and the right-hand argument is a `Stream`.

The `filterNil` operator supports chaining off of the right-hand side `Stream` in the same manner as the `filter` operator.

### The `merge` operator: `--&`

    public func --& <T, U>(streams: [Stream<T>], args: (cell: Cell<U>, f: T -> U)) -> Cell<U>
    public func --& <T>(streams: [Stream<T>], cell: Cell<T>) -> Cell<T>
    
The `merge` operator is used to merge multiple `Stream`s of the same type and lift them into a `Cell`. You have the option of providing a closure that will transform the values as they are lifted.

    // Example: merge operator syntax
    let streamA = Stream<CFTimeInterval>()
    let streamB = Stream<CFTimeInterval>()
    let cLatestEvent = Cell<CFTimeInterval>(initialValue: CACurrentMediaTime())
    
    [
        streamA, 
        streamB
    ]
            --& cLatestEvent

In the above example, `streamA` and `streamB` each send values of type `CFTimeInterval`. The `Cell` `cLatestEvent` will update whenever `streamA` or `streamB` fires, storing the value provided. There is no transformation of the value, so no closure parameter is supplied.

When you merge two or more `Stream`s the `Cell` updates its value anytime that one of the `Stream`s sends a value. The `Cell`s value will always be the most recent value passed by any of the component `Stream`s. Note that the transformation closure that can be supplied takes only one value as its input - the value that is passed by whichever `Stream` fired last. It does not take a value for each merged `Stream`.

The left-hand argument is an array of type `[Stream<T>]`. The right-hand side argument is a `Cell<T>` if no transformation is applied, or `Cell<U>` if you are transforming the value.

The `merge` operator supports chaining off of the right-hand `Cell`.

### The `lift` operator: `--^`

    public func --^<T, U>(stream: Stream<T>, args: (cell: Cell<U>, f: T -> U)) -> Cell<U>
    public func --^<T>(stream: Stream<T>, cell: Cell<T>) -> Cell<T>
    public func --^<T, U>(source: Source<T>, args: (cell: Cell<U>, f: T -> U)) -> Cell<U>
    public func --^<T>(source: Source<T>, cell: Cell<T>) -> Cell<T>
    public func --^<T, U>(cell: Cell<T>, args: (cell: Cell<U>, f: T -> U)) -> Cell<U>
    public func --^<T>(cellA: Cell<T>, cellB: Cell<T>) -> Cell<T>
    public func --^<C1, C2, T>(cells: (Cell<C1>, Cell<C2>), args: (cell: Cell<T>, f: (C1, C2) -> T)) -> Cell<T>
    public func --^<C1, C2, C3, T>(cells: (Cell<C1>, Cell<C2>, Cell<C3>), args: (cell: Cell<T>, f: (C1, C2, C3) -> T)) -> Cell<T>
    public func --^<C1, C2, C3, C4, T>(cells: (Cell<C1>, Cell<C2>, Cell<C3>, Cell<C4>), args: (cell: Cell<T>, f: (C1, C2, C3, C4) -> T)) -> Cell<T>
    public func --^<C1, C2, C3, C4, C5, T>(cells: (Cell<C1>, Cell<C2>, Cell<C3>, Cell<C4>, Cell<C5>), args: (cell: Cell<T>, f: (C1, C2, C3, C4, C5) -> T)) -> Cell<T>
    public func --^<C1, C2, C3, C4, C5, C6, T>(cells: (Cell<C1>, Cell<C2>, Cell<C3>, Cell<C4>, Cell<C5>, Cell<C6>), args: (cell: Cell<T>, f: (C1, C2, C3, C4, C5, C6) -> T)) -> Cell<T>
    public func --^<C1, C2, C3, C4, C5, C6, C7, T>(cells: (Cell<C1>, Cell<C2>, Cell<C3>, Cell<C4>, Cell<C5>, Cell<C6>, Cell<C7>), args: (cell: Cell<T>, f: (C1, C2, C3, C4, C5, C6, C7) -> T)) -> Cell<T>
    
The `lift` operator is used to lift a `Source`, `Stream` or `Cell` into a `Cell`, or to lift multiple `Cell`s into another `Cell`.

    // Example 1: lift operator syntax
    let srcNameInput = Source<String>()
    let cGreeting = Cell<String>(initialValue: "")
    
    srcTextInput
        --^ (cGreeting,  { "Hello, \($0)!" })
        
In the above example, we assume that `srcNameInput` takes as input someone's name. That value is transformed into the message, "Hello, \($0)!", and the message is stored in the `cGreeting`.

    // Example 2: lifting multiple cells into a single Cell
    let srcFirstName = Source<String>()
    let srcLastName = Source<String>()
    let cFirstName = Cell<String>(initialValue: "")
    let cLastName = Cell<String>(initialValue: "")
    let cFullName = Cell<String>(initialValue: "")
    
    srcFirstName
        --^ cFirstName
    srcLastName
        --^ cLastName
    
    (
        cFirstName,
        cLastName
    )
        --^ cFullName
            
In the above example, the two `Source`s are first lifted into their own `Cell`s, and then the two `Cell`s are combined into the final `Cell`, `cFullName`.

The left-hand argument is a `Source`, a `Stream`, a `Cell`, or a tuple made up of two or more `Cell`s. (Right now the maximum number of `Cell`s that can be lifted is seven, but that can be easily expanded.) The right-hand argument is either:

 1. A `Cell<T>` if you are lifting from a `Source<T>` or a `Stream<T>` or a single `Cell<T>` and not transforming the value; or
 2. A `Cell<U>` if you are lifting from a `Source<T>` or a `Stream<T>` or a single `Cell<T>` and you are transforming the value with a closure `T -> U`; or
 3. A tuple composed of a `Cell<T>` and a closure that takes as arguments all of the `Cell`s from the left-hand argument and returns a value, `T`.

The `lift` operator supports chaining off of the `Cell` on the right-hand side of the operator. Because it supports chaining, `Example 2` above can be re-written like this:

    // Example 3: chaining with the lift operator
    (
        srcFirstName
            --^ cFirstName,
        srcLastName
            --^ cLastName
    )
            --^ (cFullName, { $0 + $1 })

In the above example, this expression:

    srcFirstName
        --^ cFirstName

evaluates to the `Cell`, `cFirstName`. The two lifted `Source`s each evaluate to their respective `Cell`s, allowing you to use those `Cell`s as the tuple parameters in the tuple that is the left-hand argument for the final `lift` operation.

### The `output` operator: `--<`

    public func --< <T>(cell: Cell<T>, args: (outlet: Outlet<T>, f: T -> ())) -> Cell<T>
    
The `output` operator is used to attach an `Outlet<T>` to a `Cell<T>`.

    // Example: output operator syntax
    cellTrueFalse
        --< (oSetEnabled, { button.enabled = $0 })

In the above example, a `Cell` that stores a `Bool` value is used as input for an `Outlet` that sets whether or not a particular control (in this case a button named `button`) is enabled or disabled. The closure will be called every time that the `Cell`'s value changes. It operates much like a binding between the `Cell`'s value and the state of the control.

The left-hand argument is a `Cell`. The right-hand argument is a tuple composed of the `Outlet` that is being attached and a closure that takes a value of type `T` and performs some output operation with it - e.g., updates the user interface, writes to disk, etc.

In a properly constructed behavior, the `Outlet` is the only part of the event stream that causes any kind of a side-effect in the larger application.

The `output` operator supports chaining off of the left-hand argument (`Cell<T>`) so that you can connect multiple `Outlet`s to a `Cell` in succession in a single chain.

    // Example: chaining with the output operator
    cellTrueFalse
        --< (oSetEnabledA, { buttonA.enabled = $0 })
        --< (oSetEnabledB, { buttonB.enabled = $0 })
        
In the above example, the state of two different buttons (`buttonA` and `buttonB`) is bound to the value of the `Cell`. Though it is not enforced, the encouraged practice is to use a separate `Outlet` for every individual side effect that is associated with the `Outlet`.

## Synchronization

Grand Central Dispatch is used to manage synchronization. Events in the event stream are handled on a serial queue using `dispatch_async`. Events are processed in the order in which they occur but do not block the rest of the application.

When an `Outlet` produces output of some kind, those changes are handled on the main queue using `dispatch_async`.

Changes to all other internal properties of a `Source`, `Stream` or `Cell` are synchronized using their own private queues and should be thread safe.

Concurrency among different program behaviors should be possible eventually but as of yet that feature has not been implemented.
