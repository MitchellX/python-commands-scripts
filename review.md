## Summary：
This paper mainly compares two different system designs in high-concurrency scenarios. The author argued that thread-based systems are not lower than event-based systems, and sometimes outperform in high-concurrency scenarios with the specific design and implementation of the compiler. In addition, the author in this paper responds to the historical Criticism and clarifies the problems in many domains, like performance, control flow, synchronization, state management, and scheduling. The quantitative results show that thread-based systems can achieve similar or even higher performance with respect to even-based systems.

### problems aren’t inherent to the threading paradigm
The claimed strengths of events over threads and show that the weaknesses of threads are artifacts of specific threading implementations and not inherent to the threading paradigm. With the specific design and implementation of the compiler, a thread-based system can achieve excellent performance in high-concurrency scenarios.

### response to criticism of threads
Performance issue. Because of poor thread implementations with respect to high concurrency. None of the currently available thread packages were designed for both high concurrency and blocking operations, and thus it is not surprising that they perform poorly. two sources of overhead are the presence of operations that are O(n) in the number of threads. and high context switches overhead when compared with events.

Control Flow issue. Complicated control flow patterns are rare in practice. In most cases, the control flow patterns used by these applications fell into three simple categories: call/return, parallel calls, and pipelines. All of these patterns can be expressed more naturally with threads.

Synchronization issue. Cooperative thread systems can reap the same benefits in synchronization.

State management issue. The author proposes a mechanism that will enable dynamic stack growth. In addition, thread systems provide automatic state management via the call stack, and this mechanism can allow programmers to be wasteful while event-based systems need manual effort.

## Strength：

+ threads provide a more natural abstraction for high-concurrency servers
+ small improvements to compilers and thread runtime systems can eliminate the historical reasons to use events
+ threads are more amenable to compiler-based enhancements
+ threads are actually a more appropriate abstraction for high-concurrency servers. Because (1) the concurrency in modern servers results from concurrent requests that are largely independent. (2) the code that handles each request is usually sequential.
+ the overhead of cleaning up task states after exceptions and after normal termination is simpler in a threaded system since the thread stack naturally tracks the live state for that task.
+ the author designs a compiler supporting for threads
    + Dynamic Stack Growth mechanism allows the size of the stack to be adjusted at run time.
    + Compilers could easily purge unnecessary states from the stack before making function calls.
+ evaluation results seem convincing.

## Weakness：

- The author only provides a fundamental property of the thread abstraction rather than an artifact of the available implementations.
- Threads more powerful than events, but power is rarely needed.
- The author admits threads are much harder to program than events, for experts only in some cases.
- there are still deadlock problems in the thread-based systems, like Circular dependencies among locks or Each process waits for some other process: the system hangs
- it seems very hard to debug in a thread-based system, due to data dependencies, timing dependencies

## possible extensions
* For highly concurrent applications, develop a thread package with better compiler support.
