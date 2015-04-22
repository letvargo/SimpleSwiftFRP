# SimpleSwiftFRP
A simple Functional Reactive Programming library for Swift

Now updated for Swift 1.2.

## Overview

`SimpleSwiftFRP` is a framework that helps separate program logic from program state. Application events are channeled through an event stream where they are transformed, filtered, stored and otherwise manipulated before being turned into program output. 

Values enter the event stream through an instance of the `Source` class, and exit as output through an instance of the `Outlet` class, but in between the `Source` and the `Outlet` the event stream is a closed system that is referentially transparent and produces no side effects.

`SimpleSwiftFRP` uses a set of six primitive infix operators (described later) that provide a visual language for constructing complex application behaviors. The following is a simple example of a `Source` being lifted into a `Cell` and then connected to an `Outlet` using two of the primitive operators. It is a basic "Hello World" type behavior:

    let srcMessage = Source<String>()
    let cMessage = Cell<String>(initialValue: "")
    let oMessage = Outlet<String>()
    
    srcMessage
        --^ cMessage                      // the lift operator:   --^ 
        --< (oMessage, println)           // the outlet operator: --<
      
    srcMessage.send("Hello World!")       // Output: "Hello World!"
    srcMessage.send("Goodbye for now.")   // Output: "Goodbye for now."
      
The above example is very simple, but complex behaviors derived from multiple `Source`s, `Stream`s and `Cell`s can be built up from less complex patterns, while the code itself retains the feel of a wiring diagram or a flowchart. Note that the *behavior* (printing the message) occurs automatically whenever a new value is introduced.

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

`Cell` and `Source` are both subclasses of `Stream`, but they are discussed here in the order in which they play a role in a typical event stream.

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

A `Source` does not have a value of its own, per se. None of its values are stored or used after they are introduced into the event stream. A `Source` does not have any public properties.
    
A `Stream` can be used as the left-hand argument for the `map` ( `>--` ), `filter` ( `--|` ), `filterNil` ( `--!` ), or `lift` ( `--^` ) primitive operators. It cannot be used as the right-hand argument for any of the operators.

A full discussion of the primitive operators occurs below.

### `Stream<T>`

`Stream` does not have any public instance methods or publicly available properties. The purpose of a `Stream` is to provide a node in the event stream where values can be transformed, filtered, or lifted from, but it does not have a value of its own that can be accessed.

`Stream` has one publicly available initializer:

    init()
    
You use a `Stream` by using it as an argument with one of the primitive infix operators. It can be used as the left-hand argument or right-hand argument for the `map` ( `>--` ), `filter` ( `--|` ) or `filterNil` ( `--!` ) operators, and as the left-hand argument for the `lift` ( `--^` ) operator.

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
    
`Cell` also has a `send` instance method. When `send` is called on a `Cell` the `Cell`'s value is sent to any `Outlet`'s that are attached to it. It is primarily used as a means of configuring user interface elements after initialization.
    
A `Cell` can be the left-hand argument for all six of the primitive operators. It can be the right-hand argument for the `lift` ( `--^` ) operator.

A full discussion of the primitive operators occurs below.

### `Outlet<T>`

The sole purpose of an `Outlet` is to perform some kind of an output operation. Anything that alters some aspect of the program state outside of the event stream is considered output. Updates to the user interface are the most obvious example.

`Outlet` has one public initializer:

    init()
    
`Outlet` has no public properties and no public instance methods.

An `Outlet` must be attached to a `Cell` in order to work. You cannot attach an `Outlet` to a `Source`, a `Stream`, or another `Outlet`.

An `Outlet` can be the right-hand argument for the `outlet` ( `--<` ) operator. It cannot be the left-hand argument for any operator.

A full discussion of the primitive operators occurs below.

## Primitive Operators

`SimpleSwiftFRP` uses six primitive infix operators:

 1. The `map` operator: `>--`
 2. The `filter` operator: `--|`
 3. The `filterNil` operator: `--!`
 4. The `merge` operator: `--&`
 5. The `lift` operator: `--^`
 6. The `outlet` operator: `--<`

Using these six operators it is possible to build complex application behaviors that are referentially transparent and produce no side effects except through designated `Outlet`s.

### The `map` operator: >--
    
    public func >-- <T, U>(stream: Stream<T>, args: (stream: Stream<U>, f: T -> U)) -> Stream<U>

The `map` operator let's you connect two `Stream`s of different types together using a transformation closure. The syntax looks like this:

    // Example: map operator syntax
    streamA
        >-- (streamB, transformAToB)

The left-hand argument is a `Stream` or one of its subclasses. The right-hand argument is a tuple consisting of the `Stream` that you are mapping to and the closure that will transform the values.

In the above example, if `streamA` is a `Stream<Int>` and `streamB` is a `Stream<Double>`, then `transformAToB` must be a closure that takes an `Int` as its input parameter and returns a `Double`.

The `map` operator returns the `Stream` on the right-hand side so that it can be used as the left-hand side argument in a chain of operations:

    // Example: chaining mapped Streams
    streamA
        >-- (streamB, transformAToB)
        >-- (streamC, transformBToC)

## Synchronization

Grand Central Dispatch is used to manage synchronization. Events in the event stream are handled on a serial queue using `dispatch_async`. Events are processed in the order in which they occur but do not block the rest of the application.

When an `Outlet` produces output of some kind, those changes are handled on the main queue using `dispatch_async`.

Changes to all other internal properties of a `Source`, `Stream` or `Cell` are synchronized using their own private queues and should be thread safe.

Concurrency among different program behaviors should be possible eventually but as of yet that feature has not been implemented.
