# What A Counter Loop Does Not Reveal about Virtualization, Compilers, and Systems

In the last few months, I have continued learning how different languages work, interoperability, and systems for other projects. I recognize some things I got wrong in [my first version](https://github.com/lak-ibm/native-java-article/tree/v1) of my article. I want to address them and take a stab at the experiment again.  

First, I had asked: can JNI be used to extend the capabilities of Java by accessing system services? I have an example to support each “yes” and “no.” First, some standard I/O libraries are implemented with JNI, such as file I/O. On the other hand, a peer recently discovered that they couldn’t use JNI to invoke a system service that supports a different word length than their JVM, as that particular processor’s architecture supports multiple word lengths. This makes sense, as I observed in my last experiment that I had to compile the C code for the architecture of my JVM, not the underlying system.  

Secondly, I had hoped to trigger vectorization but didn’t understand much about SIMD architecture. I have an M2 Pro chip with SIMD wide enough for 4 32-bit integer operations at a time, and I’ll think later about whether I can manually map relevant operations to it before expecting anything from the compiler. Also, the compiler optimizations I was applying, GCC/Clang `O2` and `O3`, produce output specific to the specified architecture, which in some cases was not my host’s architecture.  

Next, I wasn’t able to guide or control compiler behavior as I had originally intended. I had hoped that marking variables as `volatile` would influence their storage, caching, and access. I had to do this because the algorithm I chose, a dummy counting loop, had no real purpose, and the compiler “knew” that.   

Another point I had not fully considered when looking at the compiler outputs is how fundamentally different the execution models for Java and C are, and where they overlap when running C code via JNI. Virtualization introduces an additional layer of execution, which shifts where and how optimizations can occur. Initially, I tried to understand the two stacks by comparing Java bytecode to assembly, which is apples and oranges. A more meaningful comparison could be between Java bytecode and LLVM IR, as both are intermediate representations and therefore more conceptually comparable. One caveat is that LLVM IR may already include compiler optimizations, whereas Java bytecode is largely unoptimized. Comparing the two could help make informed guesses about how the AOT and JIT compilers will optimize the Java code at runtime and how effective that is.  

I hypothesize that, in practice, a developer will build and ship a program with the highest level of optimizations possible while still ensuring correctness. One important difference between the execution models for C and Java is that the out-of-the-box Java AOT and JIT do not allow developers to control optimization aggressiveness; changing this behavior would require replacing or modifying these compilers. For this reason, using the default AOT and JIT is a fine baseline for comparison. 

I also unintentionally observed the effects of Rosetta 2, Apple’s runtime translation layer for supporting x86 binaries on ARM64-based chips, since my JDK was for the wrong chip. Because of this setup, I could not pass to the compiler any microarchitecture or CPU information through the flags `-march` or `-mcpu`.  

Overall, there were too many variables in my environment in my last experiment and not enough trials (I also only tested for one input size). I’ll address each and share the results in the rest of this article.  

I also want to note that running `gcc -v` revealed that I am actually compiling with Clang. I have been using Apple Clang version 15.0.0 (clang-1500.3.9.4), which I’ll leave alone.  

One last thing I got wrong: my instructions at the bottom were “how to run on Mac,” but the brand of the machine is not the critical variable. I’ve added parameters in my build and run script for host architecture and JVM architecture. That is all anyone may need to change to run this project.



## What I expect and hope to answer in my experiment
My goal is to create a controlled environment by carefully managing runtime conditions and adjusting compiler optimization settings to produce predictable results. I will also observe system effects by comparing measured runtimes to theoretical time complexity analysis. Based on execution models and anticipated overheads, I expect that standalone C will run the fastest, the C program executed via JNI will be a close second due to some Java overhead, and the Java implementation will be the slowest. I will not test assembly via JNI in this study; I’ll make note of it in the future work section at the bottom, along with other questions and ideas for further exploration.  

In my previous experiment, I observed that standalone Java was the slowest, C via JNI got second place, and Java was the fastest.  



## My experiment part 1 and observations
To remove Rosetta 2 from the equation and get a more up-to-date Java experience, I upgraded from Java 17 for x86-64 to Java 21 for ARM64, the ISA of my M2 Pro chip. After rerunning the same code from my previous article without any optimizers, I found that standalone C performance was unchanged as expected. However, the Java loop took twice as long as before (~430 ms), and the JNI C loop also doubled (~1900 ms). Despite this slowdown, the C code invoked through JNI still ran in essentially the same time as the standalone C invocation.  

It’s highly unlikely this is a regression in Java 18–21. The main difference between this experiment and the last is that previously both Java and C were compiled for the wrong architecture and executed under Rosetta 2.  

Rosetta 2 may not claim to be an aggressive optimizer, but the speedup could be explained by Apple developing both the chip and this translator, whereas the Clang, LLVM, and JDK backends are still a bit naive. Third-party compiler backends apply architecture-specific optimizations given an ISA and some microarchitecture information but lack the deep microarchitecture details. This may give Rosetta an advantage, since AOT compilers need substantially more time to apply deep optimization passes than a JIT can afford.  

In my last experiment, when I compiled the C via JNI with the `O2` optimizer, the loop ran twice as slow. The LLVM IR optimized with `O2` for x86_64 looks very different than the IR for ARM64. I find this really interesting, that the translation either took longer or Rosetta was unable to effectively optimize. I want to observe and evaluate optimization passes and techniques individually another time. It would be interesting if I could pass microarchitecture information to my Java JIT to make my Java programs run faster, as I can't tell how aware it is already.  



## My experiment part 2 and observations
I next switched the algorithm to one still single-threaded that the compiler couldn’t optimize so easily: **Sieve of Eratosthenes**. This algorithm finds all prime numbers up to the input value, *n*. It initializes an array of size *n* to keep track of values, loops up to $\sqrt{n}$ (as that is the largest possible factor of *n*), and performs $O(n)$ work each iteration to mark multiples. Therefore, it has $O(n log log n)$ runtime. This function grows slightly faster than linear.  

The arrays for all three implementations live on the heap. I do not benchmark the time to allocate the space nor count the number of prime numbers found at the end. I just time the calculation. I did not want to dilute my results by considering system effects that I knew would have a big impact. I conducted 3–4 trials, took the average times, and rounded.  

I compiled the C code with no optimizers so I can see their impact later. Here are my results:

| Num value      | Java time (ms) | C via JNI time (ms) | Native C time (ms) |
|---------------|----------------|-------------------|------------------|
| 1,000,001     | 23             | 8                 | 9                |
| 10,000,001    | 340            | 50                | 64               |
| 100,000,001   | 320            | 640               | 635              |
| 1,000,000,001 | 5155           | 7550              | 8200             |

Next, I compiled the standalone C and C via JNI with the `O2` optimizer. `O3` was slightly slower, and since I am aiming for the fastest runtime possible, `O2` will be what I compare to in the rest of the article. I also passed the flag indicating my microarchitecture to the compiler, and I saw no difference in the LLVM IR nor assembly for both `O2` and `O3`, so LLVM and Clang must already account for it.  

Because the C programs were on the cusp of exceeding the time of the Java program, I added one more benchmark that still allowed me to allocate memory the same way on the heap.

| Num value      | Java time (ms) | C via JNI time (ms) | Native C time (ms) |
|---------------|----------------|-------------------|------------------|
| 1,000,001     | 23             | 1                 | 1                |
| 10,000,001    | 340            | 10                | 17               |
| 100,000,001   | 320            | 307               | 299              |
| 1,000,000,001 | 5155           | 4240              | 4820             |
| 2,000,000,001 | 11,900         | 10,640            | 10,580           |



## Observations and Analysis
Good news! It appears that I achieved my goal order by looking at the last benchmark.  

Some observations: as *n* increases, the runtime of the C programs almost converges to that of the Java program. Trials where I enable `O2` and `O3` result in similar runtimes for small input values, but `O2` outputs scale better than `O3`. The 2nd Java benchmark for input size *k* is slightly slower than that of the next benchmark, *10k*.  



## Future work
Ideas for 3rd article version or to inspire others:

- What other system-level factors might prevent JNI from giving a Java program the same capabilities as native C?  
- What kind of algorithm could be more effectively optimized if the optimizer was aware of the chip’s branch prediction strategy?  
- Study the full set of optimization passes that Clang applies. What are the optimizations that the JIT applies? Do any compare?  
- Could Java’s AOT or JIT be modified to account more for microarchitecture, or does it already?  
- Generate the graph of the algorithm’s time complexity function. Then plot the points for each benchmark at each optimizer level. Use some kind of ML regression model to find the “curve” of best fit of the benchmarks. Once finding the parameters, infer system and overhead effects not accounted for in theoretical time complexity analysis. (I already started a Python script for this in `benchmarking/plot.ipynb`)  
- Before taking a close look at the optimized LLVM IR code, what optimizations do I think are possible to apply based on my understanding of the Sieve of Eratosthenes? Do I see them?  
- Can I manually optimize the `O2` output anymore and get better performance (considering that `O3` gave me worse performance)?  
- Is it expected that the same logic will run faster when implemented and invoked in Assembly via JNI than in C via JNI? While the compiler likely generates more efficient code than I could manually, I understand the business logic and could potentially apply aggressive optimizations the compiler might miss. How does AI-assisted, logic-aware assembly (e.g., generated by ChatGPT) compare to compiler output across different optimization levels? This also makes me wonder how traditional compiler tools will evolve in the age of AI.  
- Apply a more formal benchmarking technique or framework, especially one that will limit variance in results across trials.  
- How does the JVM garbage collector behave during long-running native (JNI) calls, and what is the impact on application throughput and latency?  
- In what ways do architecture-specific compiler optimizations, as revealed by analysis of LLVM IR, reflect the differences between CISC (x86-64) and RISC (ARM64) (micro)architectures?  
- How could I observe CPU utilization across each setup and what would those results infer?  
- Why does the performance of optimized binaries appear to not scale well for larger input?  
- How do JVM optimizations or runtime effects sometimes lead to non-monotonic performance across increasing input sizes?  
- Is Java bytecode comparable to unoptimized LLVM IR?  
- How does the Java JIT’s versioning technique compare to profiling equivalent C programs with Clang?  



## Side note about my inspiration
A quick note: I want to give a shoutout to a YouTube video, ([*Python vs C++ Speed Comparison*](https://youtu.be/VioxsWYzoJk?si=266bhb4KGd0avsaV)) by The Builder, which I saw a few years ago and haven’t forgotten. It sparked curiosity in me about how languages work, compilers, and high-performance computing, which at the time I didn’t know were growing passions of mine. I realize now from my own investigation that there are a lot of important details left out, as I am sure this video is mostly for entertainment, but the creator does add more context in the comments section.  


## References
- [Onur Mutlu](https://www.youtube.com/@OnurMutluLectures ) and [Carnegie Mellon](https://youtube.com/playlist?list=PL5PHm2jkkXmi5CxxI7b3JCL1TWybTDtKq&si=lr-BAiZDxGXpiPy0) lectures
- [MIT Performance Engineering](https://youtube.com/playlist?list=PLUl4u3cNGP63VIBQVWguXxZZi0566y7Wf&si=rBlrD-3eb0opXXs3), first 12 lectures 
- [The Verge article](https://www.theverge.com/21304182/apple-arm-mac-rosetta-2-emulation-app-converter-explainer )


## How to Run
1. **Modify Benchmark Values**  
   - Edit `LocalLoop.c` at line 7 to set your desired benchmarking value.  
   - Edit `Loop.java` at line 10 to set the corresponding value in Java.  

2. **Configure Build Script**  
   - Update the `config` section of `build_and_run.sh` with settings for your machine and desired optimization level.  

3. **Navigate to the Benchmarking Directory**  
   ```bash
   cd benchmarking/
   ```
4. **Add Execute Permissions**
    ```bash
    chmod +x build_and_run.sh
    ```
5. **Run the Benchmark**
    ```bash
    ./build_and_run.sh
    ```
6. **Clean up (optional)**
    - Add execution permissions similar to step 4
    ```bash
    ./clean.sh
    ```
---

**Disclaimer:** Although I work at IBM, these opinions are all my own.
