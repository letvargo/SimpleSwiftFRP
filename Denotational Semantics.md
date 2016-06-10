### 1. Time

Time is the set of all real numbers extended to include negative- and positive-infinity.

*type Time :: t*

*μ Time t ≣ { t ∈ ℝ | -∞ ≤ ℝ ≤ ∞ }*

### 2. Occurrence

An Occurrence is a (Time, Value) pair that represents a single 
occurrence of a discrete event.

*type Occurrence :: Time t ⇒ (t, a)*

*μ Occurrence (t, a) ≣ (μ Time t, a)*

### 3. Event

type Event e :: [Occurrence]