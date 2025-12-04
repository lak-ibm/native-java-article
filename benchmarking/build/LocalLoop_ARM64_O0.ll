; ModuleID = 'native/helper_Loop.c'
source_filename = "native/helper_Loop.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@.str = private unnamed_addr constant [26 x i8] c"Memory allocation failed\0A\00", align 1
@.str.1 = private unnamed_addr constant [31 x i8] c"C Sieve function time: %.f ms\0A\00", align 1
@.str.2 = private unnamed_addr constant [38 x i8] c"There are %d prime numbers up to %d.\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define void @nativeSieve(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i64, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %11 = load i32, ptr %2, align 4
  %12 = add nsw i32 %11, 1
  %13 = sext i32 %12 to i64
  %14 = mul i64 %13, 1
  %15 = call ptr @malloc(i64 noundef %14) #3
  store ptr %15, ptr %3, align 8
  %16 = load ptr, ptr %3, align 8
  %17 = icmp eq ptr %16, null
  br i1 %17, label %18, label %20

18:                                               ; preds = %1
  %19 = call i32 (ptr, ...) @printf(ptr noundef @.str)
  br label %106

20:                                               ; preds = %1
  store i32 0, ptr %4, align 4
  br label %21

21:                                               ; preds = %30, %20
  %22 = load i32, ptr %4, align 4
  %23 = load i32, ptr %2, align 4
  %24 = icmp sle i32 %22, %23
  br i1 %24, label %25, label %33

25:                                               ; preds = %21
  %26 = load ptr, ptr %3, align 8
  %27 = load i32, ptr %4, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds i8, ptr %26, i64 %28
  store i8 1, ptr %29, align 1
  br label %30

30:                                               ; preds = %25
  %31 = load i32, ptr %4, align 4
  %32 = add nsw i32 %31, 1
  store i32 %32, ptr %4, align 4
  br label %21, !llvm.loop !6

33:                                               ; preds = %21
  %34 = load ptr, ptr %3, align 8
  %35 = getelementptr inbounds i8, ptr %34, i64 1
  store i8 0, ptr %35, align 1
  %36 = load ptr, ptr %3, align 8
  %37 = getelementptr inbounds i8, ptr %36, i64 0
  store i8 0, ptr %37, align 1
  %38 = call i64 @"\01_clock"()
  store i64 %38, ptr %5, align 8
  store i32 2, ptr %6, align 4
  br label %39

39:                                               ; preds = %71, %33
  %40 = load i32, ptr %6, align 4
  %41 = load i32, ptr %6, align 4
  %42 = mul nsw i32 %40, %41
  %43 = load i32, ptr %2, align 4
  %44 = icmp sle i32 %42, %43
  br i1 %44, label %45, label %74

45:                                               ; preds = %39
  %46 = load ptr, ptr %3, align 8
  %47 = load i32, ptr %6, align 4
  %48 = sext i32 %47 to i64
  %49 = getelementptr inbounds i8, ptr %46, i64 %48
  %50 = load i8, ptr %49, align 1
  %51 = trunc i8 %50 to i1
  br i1 %51, label %52, label %70

52:                                               ; preds = %45
  %53 = load i32, ptr %6, align 4
  %54 = load i32, ptr %6, align 4
  %55 = mul nsw i32 %53, %54
  store i32 %55, ptr %7, align 4
  br label %56

56:                                               ; preds = %65, %52
  %57 = load i32, ptr %7, align 4
  %58 = load i32, ptr %2, align 4
  %59 = icmp sle i32 %57, %58
  br i1 %59, label %60, label %69

60:                                               ; preds = %56
  %61 = load ptr, ptr %3, align 8
  %62 = load i32, ptr %7, align 4
  %63 = sext i32 %62 to i64
  %64 = getelementptr inbounds i8, ptr %61, i64 %63
  store i8 0, ptr %64, align 1
  br label %65

65:                                               ; preds = %60
  %66 = load i32, ptr %6, align 4
  %67 = load i32, ptr %7, align 4
  %68 = add nsw i32 %67, %66
  store i32 %68, ptr %7, align 4
  br label %56, !llvm.loop !8

69:                                               ; preds = %56
  br label %70

70:                                               ; preds = %69, %45
  br label %71

71:                                               ; preds = %70
  %72 = load i32, ptr %6, align 4
  %73 = add nsw i32 %72, 1
  store i32 %73, ptr %6, align 4
  br label %39, !llvm.loop !9

74:                                               ; preds = %39
  %75 = call i64 @"\01_clock"()
  store i64 %75, ptr %8, align 8
  %76 = load i64, ptr %8, align 8
  %77 = load i64, ptr %5, align 8
  %78 = sub i64 %76, %77
  %79 = uitofp i64 %78 to double
  %80 = fmul double %79, 1.000000e+03
  %81 = fdiv double %80, 1.000000e+06
  %82 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, double noundef %81)
  store i32 0, ptr %9, align 4
  store i32 2, ptr %10, align 4
  br label %83

83:                                               ; preds = %98, %74
  %84 = load i32, ptr %10, align 4
  %85 = load i32, ptr %2, align 4
  %86 = icmp sle i32 %84, %85
  br i1 %86, label %87, label %101

87:                                               ; preds = %83
  %88 = load ptr, ptr %3, align 8
  %89 = load i32, ptr %10, align 4
  %90 = sext i32 %89 to i64
  %91 = getelementptr inbounds i8, ptr %88, i64 %90
  %92 = load i8, ptr %91, align 1
  %93 = trunc i8 %92 to i1
  br i1 %93, label %94, label %97

94:                                               ; preds = %87
  %95 = load i32, ptr %9, align 4
  %96 = add nsw i32 %95, 1
  store i32 %96, ptr %9, align 4
  br label %97

97:                                               ; preds = %94, %87
  br label %98

98:                                               ; preds = %97
  %99 = load i32, ptr %10, align 4
  %100 = add nsw i32 %99, 1
  store i32 %100, ptr %10, align 4
  br label %83, !llvm.loop !10

101:                                              ; preds = %83
  %102 = load ptr, ptr %3, align 8
  call void @free(ptr noundef %102)
  %103 = load i32, ptr %9, align 4
  %104 = load i32, ptr %2, align 4
  %105 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef %103, i32 noundef %104)
  br label %106

106:                                              ; preds = %101, %18
  ret void
}

; Function Attrs: allocsize(0)
declare ptr @malloc(i64 noundef) #1

declare i32 @printf(ptr noundef, ...) #2

declare i64 @"\01_clock"() #2

declare void @free(ptr noundef) #2

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #2 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { allocsize(0) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 4]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Apple clang version 15.0.0 (clang-1500.3.9.4)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
