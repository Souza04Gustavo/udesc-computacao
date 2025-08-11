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

	bipush 10
	iconst_2
	irem
	istore 1
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "Resultado de 10 % 2 (esperado 0):"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	iload 1
	invokevirtual java/io/PrintStream/println(I)V
	bipush 13
	iconst_5
	irem
	istore 2
	getstatic java/lang/System/out Ljava/io/PrintStream;
	ldc "Resultado de 13 % 5 (esperado 3):"
	invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
	getstatic java/lang/System/out Ljava/io/PrintStream;
	iload 2
	invokevirtual java/io/PrintStream/println(I)V
	return
.end method
