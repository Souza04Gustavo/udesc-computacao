.class public MeuPrograma
.super java/lang/Object

.method public <init>()V
	aload_0
	invokenonvirtual java/lang/Object/<init>()V
	return
.end method

.method public static main([Ljava/lang/String;)V
	.limit stack 20
	.limit locals 8

	iconst_3
	istore 1
	iconst_2
	iconst_0
	if_icmpeq l0
	goto l1
l0:
	iconst_1
	goto l2
l1:
	iconst_0
l2:
	istore 2
l3:
	getstatic java/lang/System/out Ljava/io/PrintStream;
	iload 1
	invokevirtual java/io/PrintStream/println(I)V
	iload 2
	iconst_1
	if_icmpeq l4
	goto l5
l4:
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc " e par."
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	goto l6
l5:
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc " e impar."
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	goto l6
l6:
	iload 1
	iconst_1
	isub
	istore 1
	iload 1
	iconst_0
	if_icmpgt l3
	goto l7
l7:
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "Fim do loop!"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	return
.end method
