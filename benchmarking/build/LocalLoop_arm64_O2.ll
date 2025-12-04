; ModuleID = 'native/helper_Loop.c'
source_filename = "native/helper_Loop.c"
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx14.0.0"

@.str.1 = private unnamed_addr constant [31 x i8] c"C Sieve function time: %.f ms\0A\00", align 1
@.str.2 = private unnamed_addr constant [38 x i8] c"There are %d prime numbers up to %d.\0A\00", align 1
@str = private unnamed_addr constant [25 x i8] c"Memory allocation failed\00", align 1

; Function Attrs: nounwind ssp uwtable(sync)
define void @nativeSieve(i32 noundef %0) local_unnamed_addr #0 {
  %2 = add nsw i32 %0, 1
  %3 = sext i32 %2 to i64
  %4 = tail call ptr @malloc(i64 noundef %3) #8
  %5 = icmp eq ptr %4, null
  br i1 %5, label %11, label %6

6:                                                ; preds = %1
  %7 = icmp slt i32 %0, 0
  br i1 %7, label %13, label %8

8:                                                ; preds = %6
  %9 = zext i32 %0 to i64
  %10 = add nuw nsw i64 %9, 1
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(1) %4, i8 1, i64 %10, i1 false), !tbaa !6
  br label %13

11:                                               ; preds = %1
  %12 = tail call i32 @puts(ptr nonnull dereferenceable(1) @str)
  br label %111

13:                                               ; preds = %8, %6
  %14 = getelementptr inbounds i8, ptr %4, i64 1
  store i8 0, ptr %14, align 1, !tbaa !6
  %15 = tail call i64 @"\01_clock"() #9
  %16 = icmp slt i32 %0, 4
  br i1 %16, label %17, label %78

17:                                               ; preds = %94, %13
  %18 = tail call i64 @"\01_clock"() #9
  %19 = sub i64 %18, %15
  %20 = uitofp i64 %19 to double
  %21 = fmul double %20, 1.000000e+03
  %22 = fdiv double %21, 1.000000e+06
  %23 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.1, double noundef %22)
  %24 = icmp slt i32 %0, 2
  br i1 %24, label %99, label %25

25:                                               ; preds = %17
  %26 = zext i32 %2 to i64
  %27 = add nsw i64 %26, -2
  %28 = icmp ult i64 %27, 8
  br i1 %28, label %75, label %29

29:                                               ; preds = %25
  %30 = icmp ult i64 %27, 32
  br i1 %30, label %56, label %31

31:                                               ; preds = %29
  %32 = and i64 %27, -32
  br label %33

33:                                               ; preds = %33, %31
  %34 = phi i64 [ 0, %31 ], [ %46, %33 ]
  %35 = phi <16 x i32> [ zeroinitializer, %31 ], [ %44, %33 ]
  %36 = phi <16 x i32> [ zeroinitializer, %31 ], [ %45, %33 ]
  %37 = or i64 %34, 2
  %38 = getelementptr inbounds i8, ptr %4, i64 %37
  %39 = load <16 x i8>, ptr %38, align 1, !tbaa !6
  %40 = getelementptr inbounds i8, ptr %38, i64 16
  %41 = load <16 x i8>, ptr %40, align 1, !tbaa !6
  %42 = zext <16 x i8> %39 to <16 x i32>
  %43 = zext <16 x i8> %41 to <16 x i32>
  %44 = add <16 x i32> %35, %42
  %45 = add <16 x i32> %36, %43
  %46 = add nuw i64 %34, 32
  %47 = icmp eq i64 %46, %32
  br i1 %47, label %48, label %33, !llvm.loop !10

48:                                               ; preds = %33
  %49 = add <16 x i32> %45, %44
  %50 = tail call i32 @llvm.vector.reduce.add.v16i32(<16 x i32> %49)
  %51 = icmp eq i64 %27, %32
  br i1 %51, label %99, label %52

52:                                               ; preds = %48
  %53 = or i64 %32, 2
  %54 = and i64 %27, 24
  %55 = icmp eq i64 %54, 0
  br i1 %55, label %75, label %56

56:                                               ; preds = %29, %52
  %57 = phi i32 [ 0, %29 ], [ %50, %52 ]
  %58 = phi i64 [ 0, %29 ], [ %32, %52 ]
  %59 = and i64 %27, -8
  %60 = or i64 %59, 2
  %61 = insertelement <8 x i32> <i32 poison, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, i32 %57, i64 0
  br label %62

62:                                               ; preds = %62, %56
  %63 = phi i64 [ %58, %56 ], [ %70, %62 ]
  %64 = phi <8 x i32> [ %61, %56 ], [ %69, %62 ]
  %65 = or i64 %63, 2
  %66 = getelementptr inbounds i8, ptr %4, i64 %65
  %67 = load <8 x i8>, ptr %66, align 1, !tbaa !6
  %68 = zext <8 x i8> %67 to <8 x i32>
  %69 = add <8 x i32> %64, %68
  %70 = add nuw i64 %63, 8
  %71 = icmp eq i64 %70, %59
  br i1 %71, label %72, label %62, !llvm.loop !13

72:                                               ; preds = %62
  %73 = tail call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> %69)
  %74 = icmp eq i64 %27, %59
  br i1 %74, label %99, label %75

75:                                               ; preds = %25, %52, %72
  %76 = phi i64 [ 2, %25 ], [ %53, %52 ], [ %60, %72 ]
  %77 = phi i32 [ 0, %25 ], [ %50, %52 ], [ %73, %72 ]
  br label %102

78:                                               ; preds = %13, %94
  %79 = phi i64 [ %95, %94 ], [ 2, %13 ]
  %80 = phi i32 [ %97, %94 ], [ 4, %13 ]
  %81 = getelementptr inbounds i8, ptr %4, i64 %79
  %82 = load i8, ptr %81, align 1, !tbaa !6, !range !15
  %83 = icmp eq i8 %82, 0
  %84 = icmp sgt i32 %80, %0
  %85 = select i1 %83, i1 true, i1 %84
  br i1 %85, label %94, label %86

86:                                               ; preds = %78
  %87 = zext i32 %80 to i64
  br label %88

88:                                               ; preds = %86, %88
  %89 = phi i64 [ %87, %86 ], [ %91, %88 ]
  %90 = getelementptr inbounds i8, ptr %4, i64 %89
  store i8 0, ptr %90, align 1, !tbaa !6
  %91 = add i64 %89, %79
  %92 = trunc i64 %91 to i32
  %93 = icmp sgt i32 %92, %0
  br i1 %93, label %94, label %88, !llvm.loop !16

94:                                               ; preds = %88, %78
  %95 = add nuw i64 %79, 1
  %96 = trunc i64 %95 to i32
  %97 = mul nsw i32 %96, %96
  %98 = icmp sgt i32 %97, %0
  br i1 %98, label %17, label %78, !llvm.loop !17

99:                                               ; preds = %102, %48, %72, %17
  %100 = phi i32 [ 0, %17 ], [ %50, %48 ], [ %73, %72 ], [ %108, %102 ]
  tail call void @free(ptr noundef nonnull %4)
  %101 = tail call i32 (ptr, ...) @printf(ptr noundef nonnull dereferenceable(1) @.str.2, i32 noundef %100, i32 noundef %0)
  br label %111

102:                                              ; preds = %75, %102
  %103 = phi i64 [ %109, %102 ], [ %76, %75 ]
  %104 = phi i32 [ %108, %102 ], [ %77, %75 ]
  %105 = getelementptr inbounds i8, ptr %4, i64 %103
  %106 = load i8, ptr %105, align 1, !tbaa !6, !range !15
  %107 = zext i8 %106 to i32
  %108 = add nuw nsw i32 %104, %107
  %109 = add nuw nsw i64 %103, 1
  %110 = icmp eq i64 %109, %26
  br i1 %110, label %99, label %102, !llvm.loop !18

111:                                              ; preds = %99, %11
  ret void
}

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0)
declare noalias noundef ptr @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: nofree nounwind
declare noundef i32 @printf(ptr nocapture noundef readonly, ...) local_unnamed_addr #2

declare i64 @"\01_clock"() local_unnamed_addr #3

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn allockind("free")
declare void @free(ptr allocptr nocapture noundef) local_unnamed_addr #4

; Function Attrs: nofree nounwind
declare noundef i32 @puts(ptr nocapture noundef readonly) local_unnamed_addr #5

; Function Attrs: argmemonly nocallback nofree nounwind willreturn writeonly
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #6

; Function Attrs: nocallback nofree nosync nounwind readnone willreturn
declare i32 @llvm.vector.reduce.add.v16i32(<16 x i32>) #7

; Function Attrs: nocallback nofree nosync nounwind readnone willreturn
declare i32 @llvm.vector.reduce.add.v8i32(<8 x i32>) #7

attributes #0 = { nounwind ssp uwtable(sync) "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #1 = { inaccessiblememonly mustprogress nofree nounwind willreturn allockind("alloc,uninitialized") allocsize(0) "alloc-family"="malloc" "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #2 = { nofree nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #3 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #4 = { inaccessiblemem_or_argmemonly mustprogress nounwind willreturn allockind("free") "alloc-family"="malloc" "frame-pointer"="non-leaf" "no-trapping-math"="true" "probe-stack"="__chkstk_darwin" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz" }
attributes #5 = { nofree nounwind }
attributes #6 = { argmemonly nocallback nofree nounwind willreturn writeonly }
attributes #7 = { nocallback nofree nosync nounwind readnone willreturn }
attributes #8 = { allocsize(0) }
attributes #9 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 14, i32 4]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Apple clang version 15.0.0 (clang-1500.3.9.4)"}
!6 = !{!7, !7, i64 0}
!7 = !{!"_Bool", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = distinct !{!10, !11, !12}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{!"llvm.loop.isvectorized", i32 1}
!13 = distinct !{!13, !11, !12, !14}
!14 = !{!"llvm.loop.unroll.runtime.disable"}
!15 = !{i8 0, i8 2}
!16 = distinct !{!16, !11}
!17 = distinct !{!17, !11}
!18 = distinct !{!18, !11, !14, !12}
