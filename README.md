# What I Learned About Virtualization, Compilers, and Systems from a Counter Loop

This project began with a simple question: could I use Java Native Interface (JNI) to escape the limitations of the JVM and access low-level system functionality, like syscalls on a mainframe or other hardware? I knew Java didn’t allow direct syscalls, and I was curious whether JNI might offer a clever workaround. Also, how simple is it to increase the speed of a Java program by natively implementing some functionality in C? I've been wanting to improve my C and Assembly skills and was excited to avoid setting up a full system VM or risking my local machine.

Along the way, I uncovered more questions than answers: What exactly is the JVM doing under the hood? What are the real costs of abstraction? And is native code always faster?

## Setup and Initial Surprises

People usually turn to JNI for three reasons: reusing legacy C/C++ libraries, interacting with hardware, or squeezing out more performance. I was focused on the third but figured it went hand in hand with the second.

A Java program calls C code through JNI by declaring a Java method as native. The Java compiler treats this method like any other static method, but does not provide an implementation. At runtime, the JVM links the method to a precompiled C binary based on a special naming convention defined by JNI. My first roadblock was eye-opening: I’m running an ARM-based Mac, but to compile C program inside my JVM, I had to add a flag and execute `gcc -arch x86_64`. I then discovered that the JRE on my machine is installed for an AMD64. It works because of Apple's Rosetta 2 interpreter for backwards compatibility with the old chip architecture. Everything seemed to work, and I've been using this JRE and Mac for the past 4 years. However, it led me to rabbit hole #2: how exactly is the JVM a virtual machine, how do system and process VMs differ, and what does virtualization really mean?

Depending on which developer you ask, abstraction is either a brilliant engineering strategy or an annoying limitation. I began thinking of virtualization as abstraction at the lowest level of the stack, one that tries to hide physical hardware from the software entirely.

While ChatGPT, online resources, and my coworkers were helpful in answering many of my questions, I think there's no better way to drill down a concept than trial-and-error coding.

### What I Wanted to Understand

- What is the JVM really doing? What limitations and abstractions does it impose?
- Which of those can I bypass using C via JNI?
- Which can only be implemented in native C?
- How portable is native code when used with Java's "write once, run everywhere" mantra?

## Benchmarking the Counter Loop

To test performance trade-offs, I wrote a simple benchmark: count from 0 to `INT_MAX` (2147483647) and measure the time. To ensure the loop wasn’t optimized away, I included a final check that the result wasn’t -1. These were the initial setups that I tried:

### Java (Baseline)

A pure Java method using a standard int counter. Timed using `System.currentTimeMillis()`. This version was surprisingly the fastest — around **210 ms** on my machine.

### C via JNI

A C function doing the same loop with a `volatile int` count. This prevents the compiler from optimizing the variable away because the variable may be shared across threads and needs to be reaccessed at every use from memory. I compiled with no gcc optimization (`-O0`), so I am not sure how much this mattered. I invoked it through JNI and timed the loop using `clock()`. This was about **4.5x slower (~950 ms)** **than the Java version.**

### Standalone C

I compiled the same C code as a standalone executable (also default `-O0`/no optimization). Surprisingly, this version was even **slower** — about **9x slower (~1880 ms)** than the pure Java loop. Removing `volatile` appeared to have no effect on the time.

### C with Inline x86 Assembly (via JNI)

I wrote a loop in inline x86 Assembly and called it via JNI. This ran only **3x slower (about 620 ms)** than the Java version, but faster than the standard C code. Even though I could compile for both ARM and AMD architectures and run the standalone C code, I was not able to run the inline x86 Assembly version as a standalone program (something to explore another day).

### Java with volatile

I added a Java version using a `volatile int` counter, to try to be more consistent with the C code. This was by far the **slowest**, about **50x slower (~10,000 ms)** than the non-volatile Java version. I was relieved one of my experiments took an expected amount of time, and this reinforced how costly memory barriers and visibility guarantees are.

### Static variable in C program

Another implementation detail I tried in the Java program was making the counter variables static. I found that it did not make a performance difference, but again wanted to make sure the compiler didn't optimize the variables away. I made the `count` variable in the C code static (tried volatile and not), and discovered that the C loop ran **80x slower (~4000 ms)** than the Java loop for both the standalone program and JNI linked program! The most interesting part: the code invoked two different ways had the same performance, which I hadn't seen before. (I only tried this at the last minute, so definitely something I will look more into next time.)

## Bytecode/Machine Code Insights

### Implications of Volatile

Why is the C code so much slower? I thought it would be faster. I started to look at what was happening under the hood to get more insights on these performance outcomes. Since Java bytecode is compiled enough to then get (more or less) interpreted to run on the local machine, I figured it couldn't be too hard to follow the logic compared to Assembly. When comparing the bytecode of the volatile and non-volatile Java counters, I saw no difference. Turns out, the difference lies in the class metadata, where `volatile` is stored as a flag. The JVM uses this metadata at runtime to enforce that instructions are not reordered by the JIT through "memory fences". My interpretation is that a "fence" is a lock/mutex, and this prevents race conditions that may get presented by compiler optimization. (The next step to see this in action would be to run Java with the `-XX:+PrintCompilation` flag.)

This is where the meaning of "virtual" started to click for me. The JVM knows nothing of the local machine. The JDK, which wraps around the JVM, and JRE, which wraps around both of those, do. The Java **runtime environment** enforces abstractions such as memory safety, no raw pointers, no direct syscalls, and automatic garbage collection. Funny enough, most of the open source version of the JRE is written in C/C++ and Assembly, which makes sense with my initial assumption that is why C is sometimes chosen over Java.

I then looked at the differences in the `.S` files of the C code that declared the counter volatile and the other that didn't; there was no difference.

### Experimenting with Optimizations

To better understand why the native code was slower, I compiled the C code (count variable `volatile`) with various optimization levels. I have JIT turned on for my JVM, but didn't want to experiment with turning it off. I figured JIT is always turned on in production, and a gcc optimizer is very likely also used in production. With `-O0` being the baseline, here's what I saw:

- **-O2:** **3x faster**, thanks to **loop unrolling** and reduced branching  
  - There are one-quarter of compare, move, and jump instructions as before.  
  - A few different instructions were used too. `jge` was swapped for `jne` and `addl $1` swapped for `incl`. In this moment, I saw why RISC was invented.  
  - When I removed `volatile` from the counter variable, the entire loop disappeared in the ASM file. Sure enough, the runtime was **0 ms** as the only thing that happened in between the two calls to `clock()` in the `.S` file was a move instruction.

- **-O3:** same speed as -O2, no additional improvement  
  - I read in documentation that -O3 is supposed to vectorize with SIMD. I was really excited to see this because that is a skill I want to learn next.

When compiling the JNI version with -O2, it actually became **slower**, possibly due to alignment or inlining issues. I also observed that my hand-written Assembly was very different from what `gcc -S` output, and I couldn’t make much sense of why. (Adding to the list of potential next articles.)

### JIT, javac, and Dead Code

I learned that `javac` is not an aggressive optimizer. The Java loop with an unused counter was still present in the bytecode, but executed very quickly — likely optimized away by the JIT at runtime. The JVM's JIT may also apply vectorization or loop optimizations, depending on the implementation and profiling results.

### Rosetta 2 Caveat

I have no idea how much performance was affected by having a JRE meant for a different chip on my machine.

## Conclusions

This wasn’t meant to be groundbreaking. It was a personal deep dive to move beyond backend development and start understanding system programming and compilers. I’ve always considered time complexity when developing algorithms, but not as much the effects of language, compilation, runtime setup. I started with the assumption that C would crush Java in performance due to having less abstraction. I ended up realizing how complex compilation and runtime environments really are—they can optimize suboptimal code, but only if guided correctly. Understanding variable storage and what’s happening at the machine code layer can really improve my implementation skills as a backend developer. I’ve always enjoyed thinking about memory allocation when working in C/C++, and I’ve missed that in Java, but analyzing the bytecode helped me see their underlying similarities. Although I didn’t quite answer the second and third questions I originally set out to explore, the understanding I gained through this process was the prerequisite for getting there.

Code, bytecode, and `.S` files are all included in the repository under `benchmarking/`. I hope this helps someone else scratching the same itch. There are a hundred directions to take this exploration, but I decided to stop here for now.

## Online References

- [Operating Systems: Three Easy Pieces](https://pages.cs.wisc.edu/~remzi/OSTEP/) (Introduction)  
- [Java Bytecode Crash Course](https://youtu.be/e2zmmkc5xI0?si=bWOKuCW8v5YOxNZ9) (YouTube video)  
- [GCC documentation: Options That Control Optimization](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html)  

## Compiling and Running on Mac

```
$ cd benchmarking
```

Add execution permissions with
```
$ chmod +x build_and_run.sh
$ chmod +x clean.sh
```

Run

```
$ ./build_and_run.sh
```
Note that gcc has to compile for the same architecture as your JVM, which is x86_64 for me even though I have an ARM chip on my local machine. Run `$ java -XshowSettings:properties -version | grep os.arch` to see what your JVM uses and you may have to change `build_and_run.sh:46`

to clean:
```
$ ./clean.sh
```