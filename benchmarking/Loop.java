package benchmarking;

public class Loop {

    // public static native int CSort(int target);
    public static native void c_counter(int num);
    // public static native void asm_counter(int num);
    public static native void c_sieve(int num);

    public static final int num = 1000001;
    private static int j_count;
    private volatile static int v_count;

    static {
        System.loadLibrary("nativeLoop");
    }

    public static void main(String args[]){
        System.out.println("Finding prime numbers up to " + num + "\n");
        Loop.java_sieve(num);
        Loop.c_sieve(num);
    }

    public static void java_sieve(int num){
        boolean[] isPrime = new boolean[num + 1];

        for (int i = 0; i <= num; i++) {
            isPrime[i] = true;
        }

        isPrime[0] = isPrime[1] = false;

        final long startTime = System.currentTimeMillis();

        for (int p = 2; p * p <= num; p++) {
            if (isPrime[p]) {
                for (int i = p * p; i <= num; i += p) {
                    isPrime[i] = false;
                }
            }
        }

        final long endTime = System.currentTimeMillis();
        System.out.println("Java function time: " + (endTime - startTime) + " ms");

        int count = 0;
        for (int i = 2; i <= num; i++) {
            if (isPrime[i]) {
                count++;
            }
        }
        System.out.print("There are " + count + " prime numbers up to " + num + ".\n");
    }

}