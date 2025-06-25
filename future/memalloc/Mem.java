package future.memalloc;

public class Mem {

    public static native void c_allocator(int num);

    public static final int num = Integer.MAX_VALUE;
    private static int count;
    
    static {
        System.loadLibrary("nativeMem");
    }

    public static void main(String args[]){
        Mem.java_allocator(Mem.num);
        Mem.c_allocator(Mem.num);
    }

    public static void java_allocator(int num){
        final long startTime = System.currentTimeMillis();
        // TODO
        final long endTime = System.currentTimeMillis();
        System.out.println("Java function time: " + (endTime - startTime) + " ms");

        if(count == -1) {
            System.out.println("Dummy code to prevent optimization");
        }
    }
}