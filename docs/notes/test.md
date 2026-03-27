multitask in autonomous driving
ML System. 关老师的主页抄下来。
computer vision research in images, videos

```
FLL3_dataset
├─train
│  ├─bbox
│  ├─landmark
│  └─picture_mask
└─val
    ├─bbox
    └─picture_mask
```

Summary:
The author methodically describes the historical development processes of Linux scheduler, from single-CPU system to multi-core systems. They find some inherent bugs in the Linux scheduler. The main contribution of this work is the discovery and study of four performance bugs, the group imbalance bug, scheduling group construction bug, overload-on-wakeup bug, missing scheduling domains bug in the Linux scheduler. These bugs, with different root causes but a common symptom, cause the scheduler to leave cores idle while runnable threads are waiting for their turn to run, resulting in performance degradations for typical Linux workloads. Short-term occurrences of this condition are acceptable, but Long-term presence of this symptom will significantly hurt performance. Therefore, the author develops two tools, Online Sanity Checker and Scheduler Visualization tool, to track and fix the bugs. The experimental results show that the system performance has been greatly improved after the bug is fixed.


### The linux scheduler

On a single-CPU system, CFS is very simple as the scheduler defines a fixed time interval during which each thread in the system must run at least once. The interval is divided among threads proportionally to their weights. But, on multi-core systems, CFS becomes quite complex. Scalability concerns dictate using per-core run-queues. The motivation for per-core run-queues is that upon a context switch the core would access only its local run-queue, when it looks for a thread to run. Context switches are on a critical path, so they must be fast. Accessing only a core-local queue prevents the scheduler from making potentially expensive synchronized accesses, which would be required if it accessed a globally shared run-queue. In order for the scheduling algorithm to still work correctly and efficiently in the presence of per-core run-queues, it’s very important to keep run-queues balanced.

A basic load balancing algorithm would compare the load of all cores and then transfer tasks from the most loaded core to the least loaded core. Unfortunately, the author says this would result in threads being migrated across the machine without considering cache locality or NUMA. Instead, the load balancer uses a hierarchical strategy. 

The scheduler prevents duplicating work by running the load-balancing algorithm only on the designated core for the given scheduling domain. This is the lowest numbered core in a domain if all cores are busy, or the lowest numbered idle core if one or more cores are idle. If idle cores are sleeping (power management) then the only way for them to get work is to be awoken by another core. If a core thinks it is overloaded it checks whether there have been tickless idle cores in the system for some time, and if so it wakes up the first one and asks it to run the periodic load balancing routine on behalf of itself and all of the other tickless idle cores.





Strength:
+ The author designed two new tools to confirm the bugs and understanding their root causes with negligible overhead. Sanity checker periodically checks for the violation of the aforementioned invariant, catches the bugs on a live system and collects a trace with relevant information for offline analysis. Scheduler visualization tool visualizes traces of scheduling activity to expedite debugging.

+ For four different bugs, the author clearly analyses the possible reasons and the solutions. For instance, with regard to the group imbalance bug, it is because the current kernel can’t find the correct high priority jobs across multi-group due to the average strategy. The author gives the solutions to compare minimum loads of the least loaded core in the group instead of the average.

+ The experimental results show that the system performance has been significantly improved after the proposed bugs are fixed.



Weakness:
-	The figures in this paper are quite hard to understand, the author may try another way, like histogram and pie chart to interpret their results.
-	The author doesn’t consider context switch overhead between different threads on multiple kernels. I don’t know whether it is 	negligible.

This paper clearly shows existing bugs in Linux systems, and give some insightful solutions to fix these bugs. Experimental results show that the system performance has been significantly improved after the proposed bugs are fixed. Base on the strength, I recommend this paper to be accepted.

