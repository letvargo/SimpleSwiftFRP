//
//  Behavior.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 2/20/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//

prefix operator ^ { }

/** A prefix operator for initializing instances of `Behavior<T>` to a discrete value

    ### Usage

    This function is an alternative to `Behavior<T>`'s publicly available `init(_ value: T)` method. Instead of writing,

    ```swift
    let myBehavior = Behavior<Int>(0)
    ```

    ... you can use this operator to initialize a `Behavior<T>` like this:
    ```swift
    let myBehavior = ^0
    ```

    The two techniques produce the same result, so which you choose is mostly a matter of personal preference. However, this method cannot be used to initialize a `Behavior<T>` if its value will be a function of continuous time.
    
    If the compiler has difficulty inferring the `Behavior<T>`'s type, or if the `Behavior<T>` will be used to represent a value as a function of continuous time, use one of the publicly available `init` methods instead.

    - Parameter value: The `Behavior`'s initial value

    - Returns: `Behavior<T>`
*/

public prefix func ^<T>(value: T) -> Behavior<T> {
    return Behavior(value)
}

/** A representation of a value as a function of time

    #### Overview:

    A `Behavior<T>` represents a value as a function of time. `Behavior<T>`s are guaranteed to have a value for all moments in time, and past values are fixed and immutable.

    
    #### Initialization:
    
    - `init(_ value: T)`
    
        This method creates a `Behavior<T>` that represents a value that is a function of discrete `Time`.
    
    - `init(_ f: Time -> T)`
    
        This method creates a `Behavior<T>` that represents a value as a function of continuous `Time`.
    
    - `prefix func ^ (value: T) -> Behavior<T>`
    
        This is a helper method that uses `^` as a prefix operator to lift a single value into a `Behavior<T>`. For example, the following creates a `Behavior<CGPoint>` with an inital value of `(0, 0)`:
        
        ```swift
        let bPoint = ^CGPointMake(0, 0)
        ```
    
    #### Properties:
    
    - `value`
    
        A computed property that returns the value of the `Behavior<T>` at the current moment in time.
    
    #### Methods:
    
    - `at(time: Time) -> T`
    
        A method that returns the value of the `Behavior<T>` at the supplied `Time`.

*/

final public class Behavior<T>: Listener, Whisperer {
    
    /// A private helper function for synchronizing access to variable properties
    
    private func synchronized(f: () -> ()) {
        dispatch_sync(Up.notificationQueue, f)
    }
    
    /// The `Behavior`'s value at the current moment in time
    
    public var value: T {
        return at(time: now())
    }
    
    /// A set of objects that will be notified whenever the `Behavior` is notified of a new `Event`
    
    private var listeners = ObserverSet<Time>()
    
    /// The array that holds all of the `Behavior`'s `Event`s
    
    private var events: [Event<T>] = []
    
    /// The number of `Event`s in the `events` array
    ///
    /// An `Array`'s `count` property is not cached and must be recalculated every time it is called. This `count` property is maintained manually to avoid the overhead of performing that calculation every time the `Behavior`'s value is accessed.
    
    private var count = 1
    
    /// A closure that is invoked when the `Behavior` is notified of a new event
    /// 
    /// This property is modified depending on the mechanism by which the `Behavior` is linked to other objects in the event stream.
    ///
    /// - Returns: A `Bool` value that indicates whether or not the `Behavior`'s listeners should be notified of the new event.
    
    private var addNewEvent: (Time) -> Bool = { _ in return true }

    /// Initializes a `Behavior<T>` with the given initial value
    ///
    /// - Parameter value: The initial value of the `Behavior<T>`.
    
    public init(_ value: T) {
        events = [Event(value)]
    }
    
    /// Initializes a `Behavior<T>` with the given value function
    ///
    /// - Parameter f: The initial value function of the `Behavior<T>`. The value function must be of the form `Time -> T`
    
    public init(_ f: (Time) -> T) {
        events = [Event(f)]
    }
    
    /// Searches the `events` array for the most recent `Event` at or before the specified time
    
    func eventAt(t: Time) -> Event<T> {
        
        // It is assumed that more often than not the event sought
        // will be the most recent event. Therefore, this loop starts
        // with the most recent event and works its way backwards,
        // returning events[0] if no more recent `Event` is located.
        // This algorithm ensures that most of the time the first `Event`
        // that is tested will be the `Event` that is returned, making
        // the search process as efficient as possible.
        
        var i = count - 1
        while i > 0 {
            let e = events[i]
            if e.time <= t {
                return e
            } else {
                i -= 1
            }
        }
        return events[0]
    }
    
    /// The value of the `Behavior<T>` at `Time t`
    ///
    /// - Parameter time: The `Time` for which the value should be returned
    ///
    /// - Returns: The value of the `Behavior<T>` at the specified time.
    
    public func at(time t: Time) -> T {
        var v: T? = nil
        synchronized {
            v = self.eventAt(t: t).f(t)
        }
        return v ?? events[0].f(t)
    }
    
    /// The value of the `Behavior<T>` at `Time t`
    ///
    /// This method is not synchronized and should only be invoked from inside of a single transaction for purposes of calculating a new value for the `Behavior<T>`.
    
    func f(t: Time) -> T {
        return eventAt(t: t).f(t)
    }
    
    /// Adds a new `Event` to the `events` array and updates the `count` property
    ///
    /// This method is the only available means of adding an `Event` to the `events` array. By making `events` and `count` private and updating them only through this method, we can be sure that the `count` property will always remain in sync with the size of `events`.
    
    func appendEvent(event: Event<T>) -> Bool {
        events.append(event)
        count = count + 1
        return true
    }
    
    /// Sets the `addNewEvent` property for the `Behavior<T>`
    ///
    /// This method is invoked when the `Behavior<T>` is connected to another object using one of the primitive infix operators and should not be invoked from anywhere else.
    
    func setAddNewEvent(f: (Time) -> Bool) -> Behavior<T> {
        addNewEvent = f
        return self
    }
    
    /// Changes the `Event` located at `events[0]`
    ///
    /// This method is invoked when the `Behavior<T>` is connected to another object using one of the primitive infix operators and should not be invoked from anywhere else.
    
    func setFirstEvent(event: Event<T>) -> Behavior<T> {
        events = [event]
        return self
    }
    
    /// Causes a `Behavior<T>` to listen to the specificied `Whisperer`
    ///
    /// This method is invoked when the `Behavior<T>` is linked to another object in the event stream using one of the primitive operators, and should not be invoked anywhere else.
    ///
    /// - Parameter whisperer: The object to listen to. The object must conform to the `Whisperer` protocol.
    ///
    /// - Returns: `Behavior<T>`. The `Behavior<T>` is returned so that multiple calls to `listenTo:` can be chained together.

    func listenTo(whisperer: Whisperer) -> Behavior<T> {
        whisperer.addListener(listener: self)
        return self
    }
    
    /// An internal method for handling new events
    ///
    /// This method is required by the `Listener` protocol.
    ///
    /// Parameter t: The time that the event occurred.
    
    func receiveNotification(t: Time) {
        
        // Call the addNewEvent closure...
        
        if addNewEvent(t) {
        
            // ...and if it returns true,
            // notify all listeners
            
            listeners.notify(parameters: t)
        }
    }
    
    /// An internal method for adding an object to the `listeners` `ObserverSet`
    ///
    /// This method is required by the `Whisperer` protocol.
    
    func addListener(listener: Listener) {
        _ = listeners.add { time in
            listener.receiveNotification(t: time)
        }
    }
}