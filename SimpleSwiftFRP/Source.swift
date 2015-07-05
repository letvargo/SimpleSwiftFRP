//
//  Source.swift
//  SimpleSwiftFRP
//
//  Created by letvargo on 2/20/15.
//  Copyright (c) 2015 letvargo. All rights reserved.
//


/** A helper function for initializing instances of `Source<T>`
    
    ### Usage

    This function is an alternative to `Source<T>`'s publicly available `init` method. Instead of writing,
    
    ```swift
    let mySource = Source<Int>()
    ```
    
    ... you can use this helper function to initialize a `Source<T>` like this:
    ```swift
    let mySource = src(Int)
    ```

    The two techniques produce the same result, so which you choose is purely a matter of personal preference.

    - Parameter type: the `Type` of the Source's value

    - Returns: `Source<T>`
*/

public func src<T>(type: T.Type) -> Source<T> {
    return Source<T>()
}

/** A type for introducing values into the event stream

    #### Overview:
    
    A `Source<T>` is used to introduce a value into the event stream. 
    
    A `Source<T>` can be linked to a `Behavior` using the `>--` (`Input`) operator, or to an `Outlet` using the `>-<` (`Direct`) operator. 
    
    When you send a new value using one of the global `send:` functions, all objects that have been connected to the `Source<T>` will be notified of the change.

    #### Initialization:

    A `Source<T>` can be created using one of two techniques. You can use its publicly available `init()` method like this:

    ```swift
    let mySource = Source<Int>()
    ```

    Or, alternatively, you can use the globally available `src:` function to initialize a `Source<T>` like this:
    ```swift
    let mySource = src(Int)
    ```

    The two techniques produce the same result, so which you choose is purely a matter of personal preference.
    
    #### Usage:
    
    `Source<T>` has no publicly available properties or instance methods.
    
    For a `Source<T>` to be useful, you must connect it to a `Behavior` or an `Outlet` using one of the publicly available infix operators. 
    
    The following example creates a simple printing loop:
    
    ```swift
    // Initialize a Source<String>:

    let sStringToPrint  = src(String)
    
    // Initialize a Behavior<String> with an 
    // empty string as its initial value:

    let bStoredString   = ^""
    
    // Initialize an Outlet<String>:

    let oPrintString    = out(String)
    
    // Now connect them together using the 
    // Input ( >-- ) and Output ( --< ) operators:

    sStringToPrint 
        >-- bStoredString
        --< (oPrintString, print)
        
    // Once they have been connected together in 
    // the above manner you can use the global send:
    // function to send a new value which will 
    // be stored by bStoredString and printed to 
    // the terminal by oPrintString:

    send(sStringToPrint, value: "Hello World!")
    
    // Output to terminal: "Hello World!"    
    ```
*/

final public class Source<T>: Whisperer {

    /// A set of objects that are notified when the value of this object changes
    ///
    /// This property is private and cannot be accessed outside of this file.
    ///
    /// To add a `listener`, use the `addListener:` method.

    private var listeners = ObserverSet<Time>()
    
    /// A `Source<T>`s current value function
    ///
    /// This property is private and cannot be accessed outside of this file.
    ///
    /// The only publicly available way to change the value is by using the global `send:` function.

    private var _value: (Time -> T)?
    
    /// An internal getter for the private `_value` property
    ///
    /// This computed property gives `Behavior`s and `Outlet`s read-only access to the `Source<T>`'s current value function.
    
    var value: (Time -> T)? {
        return _value
    }
    
/** `Source<T>`'s only publicly available `init` method
    
    As an alternative to using this `init` method, consider using the global `src:` function. Instead of writing,
    
    ```swift
    let mySource = Source<Int>()
    ```
    
    ... you can use the `src:` function to initialize a `Source<T>` like this:
    ```swift
    let mySource = src(Int)
    ```
    
    The two techniques produce the same result, so which you choose is purely a matter of personal preference.
*/
    
    public init() { }
    
    /// An internal method that notifies `listeners` that the `Source<T>`'s value function has changed
    ///
    /// This method is internal and cannot be accessed from outside the `SimpleSwiftFRP` module.
    ///
    /// This method is called by the global `send:` function. It must not be called from anywhere else.
    ///
    /// - Parameter value: The new value function for the `Source<T>`
    /// - Parameter time: The time of the new event
    
    func notify(value: Time -> T, time t: Time) {
        _value = value
        listeners.notify(t)
    }
    
    /// An internal method for adding an object to the `listeners` `ObserverSet`
    ///
    /// This method is required by the `Whisperer` protocol.
    
    func addListener(listener: Listener) {
        listeners.add { listener.receiveNotification($0) }
    }
}