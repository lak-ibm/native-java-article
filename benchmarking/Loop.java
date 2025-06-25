package benchmarking;

public class Loop {

    public static native int CSort(int target);
    public static native void c_counter(int num);
    public static native void asm_counter(int num);

    public static final int num = Integer.MAX_VALUE;
    private static int j_count;
    private volatile static int v_count;

    static {
        System.loadLibrary("nativeLoop");
    }

    public static void main(String args[]){
        System.out.println("Counting to " + num + "\n");
        Loop.java_counter(Loop.num);
        Loop.java_volatile_counter(Loop.num);
        // Loop.java_counter_with_opt(Loop.num);
        final Long startTime = System.currentTimeMillis();
        Loop.c_counter(Loop.num);
        final Long endTime = System.currentTimeMillis();
        System.out.println("Time to invoke and run JNI C counter = " + (endTime - startTime));
        Loop.asm_counter(Loop.num);
    }

    public static void java_counter(int num){
        Loop.j_count = 0;
        final long startTime = System.currentTimeMillis();
        for(int i = 0; i < num; i++){
            Loop.j_count++;
        }
        final long endTime = System.currentTimeMillis();
        System.out.println("Java (non volatile) function time: " + (endTime - startTime) + " ms");

        if(j_count == -1) {
            System.out.println("Dummy code to prevent optimization");
        }
    }

    public static void java_counter_with_opt(int num){
        int count = 0;
        final long startTime = System.currentTimeMillis();
        for(int i = 0; i < num; i++){
            count++;
        }
        final long endTime = System.currentTimeMillis();
        System.out.println("Java function time (with compiler opt): " + (endTime - startTime) + " ms");
    }

    public static void java_volatile_counter(int num){
        Loop.v_count = 0;
        final long startTime = System.currentTimeMillis();
        for(int i = 0; i < num; i++){
            Loop.v_count++;
        }
        final long endTime = System.currentTimeMillis();
        System.out.println("Java (volatile) function time: " + (endTime - startTime) + " ms");

        if(Loop.v_count == -1) {
            System.out.println("Dummy code to prevent optimization");
        }
    }
}