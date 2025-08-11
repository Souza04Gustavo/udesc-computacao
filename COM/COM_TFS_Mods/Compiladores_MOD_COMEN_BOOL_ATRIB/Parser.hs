{-# OPTIONS_GHC -w #-}
module Parser where

import Token
import Ri
import qualified Lex as L
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.12

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5
	| HappyAbsSyn6 t6
	| HappyAbsSyn7 t7
	| HappyAbsSyn8 t8
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11
	| HappyAbsSyn12 t12
	| HappyAbsSyn13 t13
	| HappyAbsSyn14 t14
	| HappyAbsSyn15 t15
	| HappyAbsSyn16 t16
	| HappyAbsSyn17 t17
	| HappyAbsSyn18 t18
	| HappyAbsSyn19 t19
	| HappyAbsSyn20 t20
	| HappyAbsSyn21 t21
	| HappyAbsSyn22 t22
	| HappyAbsSyn23 t23
	| HappyAbsSyn24 t24
	| HappyAbsSyn25 t25
	| HappyAbsSyn26 t26
	| HappyAbsSyn27 t27
	| HappyAbsSyn28 t28
	| HappyAbsSyn29 t29

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,361) ([0,0,0,0,0,0,0,15360,16,0,8192,49152,259,0,0,0,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4096,0,0,0,4,7133,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,256,0,0,0,0,0,0,0,34816,0,0,0,32768,0,0,0,0,8,0,0,0,128,0,0,0,2048,0,0,0,34816,49168,24579,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,4124,0,49152,256,0,0,0,82,0,0,0,0,0,0,0,34816,49152,24579,0,32768,8,60,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32768,8,61,6,0,136,960,96,0,2176,15616,1536,0,0,0,1,0,32768,24,60,6,0,136,960,96,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4096,32,0,0,32768,0,0,0,34816,49152,24579,0,0,0,0,0,0,0,256,0,0,192,1,0,0,0,8193,0,0,49152,0,0,0,0,0,0,0,0,4096,0,0,0,0,3073,0,0,0,0,0,0,0,57388,3,0,0,2176,15616,1536,0,34816,53248,24579,0,49152,16,0,0,0,256,12,0,0,6272,15360,1536,0,3072,1,0,0,0,0,0,0,0,136,960,96,0,2176,15360,1536,0,34816,49152,24579,0,32768,8,60,6,0,136,960,96,0,0,0,0,0,0,8193,0,0,0,0,0,0,0,0,256,0,0,8192,0,0,0,0,0,0,0,0,0,0,0,0,512,0,0,0,0,49152,257,0,20992,0,0,0,8192,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,256,32,0,0,0,0,0,0,0,2,0,0,32768,8,61,6,0,136,976,96,0,0,1,0,0,0,0,0,0,0,49168,0,0,0,57644,3,0,0,2176,15360,1536,0,34816,49152,24579,0,32768,8,60,6,0,136,960,96,0,2176,15360,1536,0,34816,49152,24579,0,0,32,0,0,0,4096,0,0,0,0,0,0,0,34816,49152,24579,0,0,0,0,0,0,0,0,0,0,192,1,0,0,0,0,0,0,49152,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,49152,0,0,0,0,12,0,0,0,192,0,0,0,3072,0,0,0,49152,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8192,0,0,0,0,4,7133,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parsePrograma","Programa","ListaFuncoes","Funcao","TipoRetorno","DeclParametros","Parametro","BlocoPrincipal","Tipo","ListaID","Bloco","ListaCmd","Comando","Retorno","CmdSe","CmdEnquanto","CmdAtrib","CmdEscrita","CmdLeitura","ChamadaProc","ChamadaFuncao","ListaParametros","ExprL","ExprR","Expr","Term","Factor","'%'","'+'","'-'","'*'","'/='","'/'","'('","')'","'{'","'}'","'='","';'","'<='","'>='","'>'","'<'","'=='","'&&'","'||'","'!'","','","NUM","INT_LIT","ID","STRING_LIT","'int'","'float'","'string'","'void'","'read'","'while'","'print'","'if'","'else'","'return'","'bool'","'true'","'false'","%eof"]
        bit_start = st * 68
        bit_end = (st + 1) * 68
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..67]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (38) = happyShift action_13
action_0 (55) = happyShift action_6
action_0 (56) = happyShift action_7
action_0 (57) = happyShift action_8
action_0 (58) = happyShift action_9
action_0 (65) = happyShift action_10
action_0 (4) = happyGoto action_11
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 (7) = happyGoto action_4
action_0 (10) = happyGoto action_12
action_0 (11) = happyGoto action_5
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (55) = happyShift action_6
action_1 (56) = happyShift action_7
action_1 (57) = happyShift action_8
action_1 (58) = happyShift action_9
action_1 (65) = happyShift action_10
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 (7) = happyGoto action_4
action_1 (11) = happyGoto action_5
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (38) = happyShift action_13
action_2 (55) = happyShift action_6
action_2 (56) = happyShift action_7
action_2 (57) = happyShift action_8
action_2 (58) = happyShift action_9
action_2 (65) = happyShift action_10
action_2 (6) = happyGoto action_33
action_2 (7) = happyGoto action_4
action_2 (10) = happyGoto action_34
action_2 (11) = happyGoto action_5
action_2 _ = happyFail (happyExpListPerState 2)

action_3 _ = happyReduce_4

action_4 (53) = happyShift action_32
action_4 _ = happyFail (happyExpListPerState 4)

action_5 _ = happyReduce_8

action_6 _ = happyReduce_16

action_7 _ = happyReduce_17

action_8 _ = happyReduce_18

action_9 _ = happyReduce_9

action_10 _ = happyReduce_19

action_11 (68) = happyAccept
action_11 _ = happyFail (happyExpListPerState 11)

action_12 _ = happyReduce_2

action_13 (39) = happyShift action_25
action_13 (53) = happyShift action_26
action_13 (55) = happyShift action_6
action_13 (56) = happyShift action_7
action_13 (57) = happyShift action_8
action_13 (59) = happyShift action_27
action_13 (60) = happyShift action_28
action_13 (61) = happyShift action_29
action_13 (62) = happyShift action_30
action_13 (64) = happyShift action_31
action_13 (65) = happyShift action_10
action_13 (11) = happyGoto action_14
action_13 (14) = happyGoto action_15
action_13 (15) = happyGoto action_16
action_13 (16) = happyGoto action_17
action_13 (17) = happyGoto action_18
action_13 (18) = happyGoto action_19
action_13 (19) = happyGoto action_20
action_13 (20) = happyGoto action_21
action_13 (21) = happyGoto action_22
action_13 (22) = happyGoto action_23
action_13 (23) = happyGoto action_24
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (53) = happyShift action_58
action_14 (12) = happyGoto action_57
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (39) = happyShift action_56
action_15 (53) = happyShift action_26
action_15 (55) = happyShift action_6
action_15 (56) = happyShift action_7
action_15 (57) = happyShift action_8
action_15 (59) = happyShift action_27
action_15 (60) = happyShift action_28
action_15 (61) = happyShift action_29
action_15 (62) = happyShift action_30
action_15 (64) = happyShift action_31
action_15 (65) = happyShift action_10
action_15 (11) = happyGoto action_14
action_15 (15) = happyGoto action_55
action_15 (16) = happyGoto action_17
action_15 (17) = happyGoto action_18
action_15 (18) = happyGoto action_19
action_15 (19) = happyGoto action_20
action_15 (20) = happyGoto action_21
action_15 (21) = happyGoto action_22
action_15 (22) = happyGoto action_23
action_15 (23) = happyGoto action_24
action_15 _ = happyFail (happyExpListPerState 15)

action_16 _ = happyReduce_25

action_17 _ = happyReduce_33

action_18 _ = happyReduce_27

action_19 _ = happyReduce_30

action_20 _ = happyReduce_29

action_21 _ = happyReduce_28

action_22 _ = happyReduce_31

action_23 _ = happyReduce_32

action_24 (41) = happyShift action_54
action_24 _ = happyFail (happyExpListPerState 24)

action_25 _ = happyReduce_15

action_26 (36) = happyShift action_52
action_26 (40) = happyShift action_53
action_26 _ = happyFail (happyExpListPerState 26)

action_27 (36) = happyShift action_51
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (36) = happyShift action_50
action_28 _ = happyFail (happyExpListPerState 28)

action_29 (36) = happyShift action_49
action_29 _ = happyFail (happyExpListPerState 29)

action_30 (36) = happyShift action_48
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (32) = happyShift action_39
action_31 (36) = happyShift action_40
action_31 (41) = happyShift action_41
action_31 (51) = happyShift action_42
action_31 (52) = happyShift action_43
action_31 (53) = happyShift action_44
action_31 (54) = happyShift action_45
action_31 (66) = happyShift action_46
action_31 (67) = happyShift action_47
action_31 (27) = happyGoto action_36
action_31 (28) = happyGoto action_37
action_31 (29) = happyGoto action_38
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (36) = happyShift action_35
action_32 _ = happyFail (happyExpListPerState 32)

action_33 _ = happyReduce_3

action_34 _ = happyReduce_1

action_35 (37) = happyShift action_86
action_35 (55) = happyShift action_6
action_35 (56) = happyShift action_7
action_35 (57) = happyShift action_8
action_35 (65) = happyShift action_10
action_35 (8) = happyGoto action_83
action_35 (9) = happyGoto action_84
action_35 (11) = happyGoto action_85
action_35 _ = happyReduce_12

action_36 (31) = happyShift action_80
action_36 (32) = happyShift action_81
action_36 (41) = happyShift action_82
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (30) = happyShift action_77
action_37 (33) = happyShift action_78
action_37 (35) = happyShift action_79
action_37 _ = happyReduce_62

action_38 _ = happyReduce_66

action_39 (32) = happyShift action_39
action_39 (36) = happyShift action_40
action_39 (51) = happyShift action_42
action_39 (52) = happyShift action_43
action_39 (53) = happyShift action_44
action_39 (54) = happyShift action_45
action_39 (66) = happyShift action_46
action_39 (67) = happyShift action_47
action_39 (29) = happyGoto action_76
action_39 _ = happyFail (happyExpListPerState 39)

action_40 (32) = happyShift action_39
action_40 (36) = happyShift action_40
action_40 (51) = happyShift action_42
action_40 (52) = happyShift action_43
action_40 (53) = happyShift action_44
action_40 (54) = happyShift action_45
action_40 (66) = happyShift action_46
action_40 (67) = happyShift action_47
action_40 (27) = happyGoto action_75
action_40 (28) = happyGoto action_37
action_40 (29) = happyGoto action_38
action_40 _ = happyFail (happyExpListPerState 40)

action_41 _ = happyReduce_37

action_42 _ = happyReduce_67

action_43 _ = happyReduce_68

action_44 (36) = happyShift action_74
action_44 _ = happyReduce_69

action_45 _ = happyReduce_70

action_46 _ = happyReduce_73

action_47 _ = happyReduce_74

action_48 (32) = happyShift action_39
action_48 (36) = happyShift action_70
action_48 (49) = happyShift action_71
action_48 (51) = happyShift action_42
action_48 (52) = happyShift action_43
action_48 (53) = happyShift action_44
action_48 (54) = happyShift action_45
action_48 (66) = happyShift action_46
action_48 (67) = happyShift action_47
action_48 (25) = happyGoto action_73
action_48 (26) = happyGoto action_68
action_48 (27) = happyGoto action_69
action_48 (28) = happyGoto action_37
action_48 (29) = happyGoto action_38
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (32) = happyShift action_39
action_49 (36) = happyShift action_40
action_49 (51) = happyShift action_42
action_49 (52) = happyShift action_43
action_49 (53) = happyShift action_44
action_49 (54) = happyShift action_45
action_49 (66) = happyShift action_46
action_49 (67) = happyShift action_47
action_49 (27) = happyGoto action_72
action_49 (28) = happyGoto action_37
action_49 (29) = happyGoto action_38
action_49 _ = happyFail (happyExpListPerState 49)

action_50 (32) = happyShift action_39
action_50 (36) = happyShift action_70
action_50 (49) = happyShift action_71
action_50 (51) = happyShift action_42
action_50 (52) = happyShift action_43
action_50 (53) = happyShift action_44
action_50 (54) = happyShift action_45
action_50 (66) = happyShift action_46
action_50 (67) = happyShift action_47
action_50 (25) = happyGoto action_67
action_50 (26) = happyGoto action_68
action_50 (27) = happyGoto action_69
action_50 (28) = happyGoto action_37
action_50 (29) = happyGoto action_38
action_50 _ = happyFail (happyExpListPerState 50)

action_51 (53) = happyShift action_66
action_51 _ = happyFail (happyExpListPerState 51)

action_52 (32) = happyShift action_39
action_52 (36) = happyShift action_40
action_52 (37) = happyShift action_65
action_52 (51) = happyShift action_42
action_52 (52) = happyShift action_43
action_52 (53) = happyShift action_44
action_52 (54) = happyShift action_45
action_52 (66) = happyShift action_46
action_52 (67) = happyShift action_47
action_52 (24) = happyGoto action_63
action_52 (27) = happyGoto action_64
action_52 (28) = happyGoto action_37
action_52 (29) = happyGoto action_38
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (32) = happyShift action_39
action_53 (36) = happyShift action_40
action_53 (51) = happyShift action_42
action_53 (52) = happyShift action_43
action_53 (53) = happyShift action_44
action_53 (54) = happyShift action_45
action_53 (66) = happyShift action_46
action_53 (67) = happyShift action_47
action_53 (27) = happyGoto action_62
action_53 (28) = happyGoto action_37
action_53 (29) = happyGoto action_38
action_53 _ = happyFail (happyExpListPerState 53)

action_54 _ = happyReduce_44

action_55 _ = happyReduce_24

action_56 _ = happyReduce_14

action_57 (41) = happyShift action_60
action_57 (50) = happyShift action_61
action_57 _ = happyFail (happyExpListPerState 57)

action_58 (40) = happyShift action_59
action_58 _ = happyReduce_20

action_59 (32) = happyShift action_39
action_59 (36) = happyShift action_40
action_59 (51) = happyShift action_42
action_59 (52) = happyShift action_43
action_59 (53) = happyShift action_44
action_59 (54) = happyShift action_45
action_59 (66) = happyShift action_46
action_59 (67) = happyShift action_47
action_59 (27) = happyGoto action_118
action_59 (28) = happyGoto action_37
action_59 (29) = happyGoto action_38
action_59 _ = happyFail (happyExpListPerState 59)

action_60 _ = happyReduce_34

action_61 (53) = happyShift action_117
action_61 _ = happyFail (happyExpListPerState 61)

action_62 (31) = happyShift action_80
action_62 (32) = happyShift action_81
action_62 (41) = happyShift action_116
action_62 _ = happyFail (happyExpListPerState 62)

action_63 (37) = happyShift action_114
action_63 (50) = happyShift action_115
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (31) = happyShift action_80
action_64 (32) = happyShift action_81
action_64 _ = happyReduce_48

action_65 _ = happyReduce_46

action_66 (37) = happyShift action_113
action_66 _ = happyFail (happyExpListPerState 66)

action_67 (37) = happyShift action_112
action_67 (47) = happyShift action_100
action_67 (48) = happyShift action_101
action_67 _ = happyFail (happyExpListPerState 67)

action_68 _ = happyReduce_52

action_69 (31) = happyShift action_80
action_69 (32) = happyShift action_81
action_69 (34) = happyShift action_106
action_69 (42) = happyShift action_107
action_69 (43) = happyShift action_108
action_69 (44) = happyShift action_109
action_69 (45) = happyShift action_110
action_69 (46) = happyShift action_111
action_69 _ = happyFail (happyExpListPerState 69)

action_70 (32) = happyShift action_39
action_70 (36) = happyShift action_70
action_70 (49) = happyShift action_71
action_70 (51) = happyShift action_42
action_70 (52) = happyShift action_43
action_70 (53) = happyShift action_44
action_70 (54) = happyShift action_45
action_70 (66) = happyShift action_46
action_70 (67) = happyShift action_47
action_70 (25) = happyGoto action_104
action_70 (26) = happyGoto action_68
action_70 (27) = happyGoto action_105
action_70 (28) = happyGoto action_37
action_70 (29) = happyGoto action_38
action_70 _ = happyFail (happyExpListPerState 70)

action_71 (32) = happyShift action_39
action_71 (36) = happyShift action_70
action_71 (49) = happyShift action_71
action_71 (51) = happyShift action_42
action_71 (52) = happyShift action_43
action_71 (53) = happyShift action_44
action_71 (54) = happyShift action_45
action_71 (66) = happyShift action_46
action_71 (67) = happyShift action_47
action_71 (25) = happyGoto action_103
action_71 (26) = happyGoto action_68
action_71 (27) = happyGoto action_69
action_71 (28) = happyGoto action_37
action_71 (29) = happyGoto action_38
action_71 _ = happyFail (happyExpListPerState 71)

action_72 (31) = happyShift action_80
action_72 (32) = happyShift action_81
action_72 (37) = happyShift action_102
action_72 _ = happyFail (happyExpListPerState 72)

action_73 (37) = happyShift action_99
action_73 (47) = happyShift action_100
action_73 (48) = happyShift action_101
action_73 _ = happyFail (happyExpListPerState 73)

action_74 (32) = happyShift action_39
action_74 (36) = happyShift action_40
action_74 (37) = happyShift action_98
action_74 (51) = happyShift action_42
action_74 (52) = happyShift action_43
action_74 (53) = happyShift action_44
action_74 (54) = happyShift action_45
action_74 (66) = happyShift action_46
action_74 (67) = happyShift action_47
action_74 (24) = happyGoto action_97
action_74 (27) = happyGoto action_64
action_74 (28) = happyGoto action_37
action_74 (29) = happyGoto action_38
action_74 _ = happyFail (happyExpListPerState 74)

action_75 (31) = happyShift action_80
action_75 (32) = happyShift action_81
action_75 (37) = happyShift action_96
action_75 _ = happyFail (happyExpListPerState 75)

action_76 _ = happyReduce_72

action_77 (32) = happyShift action_39
action_77 (36) = happyShift action_40
action_77 (51) = happyShift action_42
action_77 (52) = happyShift action_43
action_77 (53) = happyShift action_44
action_77 (54) = happyShift action_45
action_77 (66) = happyShift action_46
action_77 (67) = happyShift action_47
action_77 (29) = happyGoto action_95
action_77 _ = happyFail (happyExpListPerState 77)

action_78 (32) = happyShift action_39
action_78 (36) = happyShift action_40
action_78 (51) = happyShift action_42
action_78 (52) = happyShift action_43
action_78 (53) = happyShift action_44
action_78 (54) = happyShift action_45
action_78 (66) = happyShift action_46
action_78 (67) = happyShift action_47
action_78 (29) = happyGoto action_94
action_78 _ = happyFail (happyExpListPerState 78)

action_79 (32) = happyShift action_39
action_79 (36) = happyShift action_40
action_79 (51) = happyShift action_42
action_79 (52) = happyShift action_43
action_79 (53) = happyShift action_44
action_79 (54) = happyShift action_45
action_79 (66) = happyShift action_46
action_79 (67) = happyShift action_47
action_79 (29) = happyGoto action_93
action_79 _ = happyFail (happyExpListPerState 79)

action_80 (32) = happyShift action_39
action_80 (36) = happyShift action_40
action_80 (51) = happyShift action_42
action_80 (52) = happyShift action_43
action_80 (53) = happyShift action_44
action_80 (54) = happyShift action_45
action_80 (66) = happyShift action_46
action_80 (67) = happyShift action_47
action_80 (28) = happyGoto action_92
action_80 (29) = happyGoto action_38
action_80 _ = happyFail (happyExpListPerState 80)

action_81 (32) = happyShift action_39
action_81 (36) = happyShift action_40
action_81 (51) = happyShift action_42
action_81 (52) = happyShift action_43
action_81 (53) = happyShift action_44
action_81 (54) = happyShift action_45
action_81 (66) = happyShift action_46
action_81 (67) = happyShift action_47
action_81 (28) = happyGoto action_91
action_81 (29) = happyGoto action_38
action_81 _ = happyFail (happyExpListPerState 81)

action_82 _ = happyReduce_36

action_83 (37) = happyShift action_89
action_83 (50) = happyShift action_90
action_83 _ = happyFail (happyExpListPerState 83)

action_84 _ = happyReduce_11

action_85 (53) = happyShift action_88
action_85 _ = happyFail (happyExpListPerState 85)

action_86 (38) = happyShift action_13
action_86 (10) = happyGoto action_87
action_86 _ = happyFail (happyExpListPerState 86)

action_87 _ = happyReduce_7

action_88 _ = happyReduce_13

action_89 (38) = happyShift action_13
action_89 (10) = happyGoto action_137
action_89 _ = happyFail (happyExpListPerState 89)

action_90 (55) = happyShift action_6
action_90 (56) = happyShift action_7
action_90 (57) = happyShift action_8
action_90 (65) = happyShift action_10
action_90 (9) = happyGoto action_136
action_90 (11) = happyGoto action_85
action_90 _ = happyFail (happyExpListPerState 90)

action_91 (30) = happyShift action_77
action_91 (33) = happyShift action_78
action_91 (35) = happyShift action_79
action_91 _ = happyReduce_61

action_92 (30) = happyShift action_77
action_92 (33) = happyShift action_78
action_92 (35) = happyShift action_79
action_92 _ = happyReduce_60

action_93 _ = happyReduce_64

action_94 _ = happyReduce_63

action_95 _ = happyReduce_65

action_96 _ = happyReduce_71

action_97 (37) = happyShift action_135
action_97 (50) = happyShift action_115
action_97 _ = happyFail (happyExpListPerState 97)

action_98 _ = happyReduce_76

action_99 (38) = happyShift action_123
action_99 (13) = happyGoto action_134
action_99 _ = happyFail (happyExpListPerState 99)

action_100 (32) = happyShift action_39
action_100 (36) = happyShift action_70
action_100 (49) = happyShift action_71
action_100 (51) = happyShift action_42
action_100 (52) = happyShift action_43
action_100 (53) = happyShift action_44
action_100 (54) = happyShift action_45
action_100 (66) = happyShift action_46
action_100 (67) = happyShift action_47
action_100 (25) = happyGoto action_133
action_100 (26) = happyGoto action_68
action_100 (27) = happyGoto action_69
action_100 (28) = happyGoto action_37
action_100 (29) = happyGoto action_38
action_100 _ = happyFail (happyExpListPerState 100)

action_101 (32) = happyShift action_39
action_101 (36) = happyShift action_70
action_101 (49) = happyShift action_71
action_101 (51) = happyShift action_42
action_101 (52) = happyShift action_43
action_101 (53) = happyShift action_44
action_101 (54) = happyShift action_45
action_101 (66) = happyShift action_46
action_101 (67) = happyShift action_47
action_101 (25) = happyGoto action_132
action_101 (26) = happyGoto action_68
action_101 (27) = happyGoto action_69
action_101 (28) = happyGoto action_37
action_101 (29) = happyGoto action_38
action_101 _ = happyFail (happyExpListPerState 101)

action_102 (41) = happyShift action_131
action_102 _ = happyFail (happyExpListPerState 102)

action_103 _ = happyReduce_51

action_104 (37) = happyShift action_130
action_104 (47) = happyShift action_100
action_104 (48) = happyShift action_101
action_104 _ = happyFail (happyExpListPerState 104)

action_105 (31) = happyShift action_80
action_105 (32) = happyShift action_81
action_105 (34) = happyShift action_106
action_105 (37) = happyShift action_96
action_105 (42) = happyShift action_107
action_105 (43) = happyShift action_108
action_105 (44) = happyShift action_109
action_105 (45) = happyShift action_110
action_105 (46) = happyShift action_111
action_105 _ = happyFail (happyExpListPerState 105)

action_106 (32) = happyShift action_39
action_106 (36) = happyShift action_40
action_106 (51) = happyShift action_42
action_106 (52) = happyShift action_43
action_106 (53) = happyShift action_44
action_106 (54) = happyShift action_45
action_106 (66) = happyShift action_46
action_106 (67) = happyShift action_47
action_106 (27) = happyGoto action_129
action_106 (28) = happyGoto action_37
action_106 (29) = happyGoto action_38
action_106 _ = happyFail (happyExpListPerState 106)

action_107 (32) = happyShift action_39
action_107 (36) = happyShift action_40
action_107 (51) = happyShift action_42
action_107 (52) = happyShift action_43
action_107 (53) = happyShift action_44
action_107 (54) = happyShift action_45
action_107 (66) = happyShift action_46
action_107 (67) = happyShift action_47
action_107 (27) = happyGoto action_128
action_107 (28) = happyGoto action_37
action_107 (29) = happyGoto action_38
action_107 _ = happyFail (happyExpListPerState 107)

action_108 (32) = happyShift action_39
action_108 (36) = happyShift action_40
action_108 (51) = happyShift action_42
action_108 (52) = happyShift action_43
action_108 (53) = happyShift action_44
action_108 (54) = happyShift action_45
action_108 (66) = happyShift action_46
action_108 (67) = happyShift action_47
action_108 (27) = happyGoto action_127
action_108 (28) = happyGoto action_37
action_108 (29) = happyGoto action_38
action_108 _ = happyFail (happyExpListPerState 108)

action_109 (32) = happyShift action_39
action_109 (36) = happyShift action_40
action_109 (51) = happyShift action_42
action_109 (52) = happyShift action_43
action_109 (53) = happyShift action_44
action_109 (54) = happyShift action_45
action_109 (66) = happyShift action_46
action_109 (67) = happyShift action_47
action_109 (27) = happyGoto action_126
action_109 (28) = happyGoto action_37
action_109 (29) = happyGoto action_38
action_109 _ = happyFail (happyExpListPerState 109)

action_110 (32) = happyShift action_39
action_110 (36) = happyShift action_40
action_110 (51) = happyShift action_42
action_110 (52) = happyShift action_43
action_110 (53) = happyShift action_44
action_110 (54) = happyShift action_45
action_110 (66) = happyShift action_46
action_110 (67) = happyShift action_47
action_110 (27) = happyGoto action_125
action_110 (28) = happyGoto action_37
action_110 (29) = happyGoto action_38
action_110 _ = happyFail (happyExpListPerState 110)

action_111 (32) = happyShift action_39
action_111 (36) = happyShift action_40
action_111 (51) = happyShift action_42
action_111 (52) = happyShift action_43
action_111 (53) = happyShift action_44
action_111 (54) = happyShift action_45
action_111 (66) = happyShift action_46
action_111 (67) = happyShift action_47
action_111 (27) = happyGoto action_124
action_111 (28) = happyGoto action_37
action_111 (29) = happyGoto action_38
action_111 _ = happyFail (happyExpListPerState 111)

action_112 (38) = happyShift action_123
action_112 (13) = happyGoto action_122
action_112 _ = happyFail (happyExpListPerState 112)

action_113 (41) = happyShift action_121
action_113 _ = happyFail (happyExpListPerState 113)

action_114 _ = happyReduce_45

action_115 (32) = happyShift action_39
action_115 (36) = happyShift action_40
action_115 (51) = happyShift action_42
action_115 (52) = happyShift action_43
action_115 (53) = happyShift action_44
action_115 (54) = happyShift action_45
action_115 (66) = happyShift action_46
action_115 (67) = happyShift action_47
action_115 (27) = happyGoto action_120
action_115 (28) = happyGoto action_37
action_115 (29) = happyGoto action_38
action_115 _ = happyFail (happyExpListPerState 115)

action_116 _ = happyReduce_41

action_117 _ = happyReduce_21

action_118 (31) = happyShift action_80
action_118 (32) = happyShift action_81
action_118 (41) = happyShift action_119
action_118 _ = happyFail (happyExpListPerState 118)

action_119 _ = happyReduce_35

action_120 (31) = happyShift action_80
action_120 (32) = happyShift action_81
action_120 _ = happyReduce_47

action_121 _ = happyReduce_43

action_122 _ = happyReduce_40

action_123 (39) = happyShift action_140
action_123 (53) = happyShift action_26
action_123 (55) = happyShift action_6
action_123 (56) = happyShift action_7
action_123 (57) = happyShift action_8
action_123 (59) = happyShift action_27
action_123 (60) = happyShift action_28
action_123 (61) = happyShift action_29
action_123 (62) = happyShift action_30
action_123 (64) = happyShift action_31
action_123 (65) = happyShift action_10
action_123 (11) = happyGoto action_14
action_123 (14) = happyGoto action_139
action_123 (15) = happyGoto action_16
action_123 (16) = happyGoto action_17
action_123 (17) = happyGoto action_18
action_123 (18) = happyGoto action_19
action_123 (19) = happyGoto action_20
action_123 (20) = happyGoto action_21
action_123 (21) = happyGoto action_22
action_123 (22) = happyGoto action_23
action_123 (23) = happyGoto action_24
action_123 _ = happyFail (happyExpListPerState 123)

action_124 (31) = happyShift action_80
action_124 (32) = happyShift action_81
action_124 _ = happyReduce_54

action_125 (31) = happyShift action_80
action_125 (32) = happyShift action_81
action_125 _ = happyReduce_56

action_126 (31) = happyShift action_80
action_126 (32) = happyShift action_81
action_126 _ = happyReduce_55

action_127 (31) = happyShift action_80
action_127 (32) = happyShift action_81
action_127 _ = happyReduce_58

action_128 (31) = happyShift action_80
action_128 (32) = happyShift action_81
action_128 _ = happyReduce_57

action_129 (31) = happyShift action_80
action_129 (32) = happyShift action_81
action_129 _ = happyReduce_59

action_130 _ = happyReduce_53

action_131 _ = happyReduce_42

action_132 (47) = happyShift action_100
action_132 _ = happyReduce_49

action_133 _ = happyReduce_50

action_134 (63) = happyShift action_138
action_134 _ = happyReduce_39

action_135 _ = happyReduce_75

action_136 _ = happyReduce_10

action_137 _ = happyReduce_6

action_138 (38) = happyShift action_123
action_138 (13) = happyGoto action_142
action_138 _ = happyFail (happyExpListPerState 138)

action_139 (39) = happyShift action_141
action_139 (53) = happyShift action_26
action_139 (55) = happyShift action_6
action_139 (56) = happyShift action_7
action_139 (57) = happyShift action_8
action_139 (59) = happyShift action_27
action_139 (60) = happyShift action_28
action_139 (61) = happyShift action_29
action_139 (62) = happyShift action_30
action_139 (64) = happyShift action_31
action_139 (65) = happyShift action_10
action_139 (11) = happyGoto action_14
action_139 (15) = happyGoto action_55
action_139 (16) = happyGoto action_17
action_139 (17) = happyGoto action_18
action_139 (18) = happyGoto action_19
action_139 (19) = happyGoto action_20
action_139 (20) = happyGoto action_21
action_139 (21) = happyGoto action_22
action_139 (22) = happyGoto action_23
action_139 (23) = happyGoto action_24
action_139 _ = happyFail (happyExpListPerState 139)

action_140 _ = happyReduce_23

action_141 _ = happyReduce_22

action_142 _ = happyReduce_38

happyReduce_1 = happySpecReduce_2  4 happyReduction_1
happyReduction_1 (HappyAbsSyn10  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (Prog (map fst happy_var_1) (map transformaFuncao happy_var_1) (fst happy_var_2) (snd happy_var_2)
	)
happyReduction_1 _ _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  4 happyReduction_2
happyReduction_2 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn4
		 (Prog [] [] (fst happy_var_1) (snd happy_var_1)
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_2  5 happyReduction_3
happyReduction_3 (HappyAbsSyn6  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  5 happyReduction_4
happyReduction_4 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 ([happy_var_1]
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_0  5 happyReduction_5
happyReduction_5  =  HappyAbsSyn5
		 ([]
	)

happyReduce_6 = happyReduce 6 6 happyReduction_6
happyReduction_6 ((HappyAbsSyn10  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (ID happy_var_2)) `HappyStk`
	(HappyAbsSyn7  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 ((happy_var_2 :->: (happy_var_4, happy_var_1), happy_var_6)
	) `HappyStk` happyRest

happyReduce_7 = happyReduce 5 6 happyReduction_7
happyReduction_7 ((HappyAbsSyn10  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (ID happy_var_2)) `HappyStk`
	(HappyAbsSyn7  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 ((happy_var_2 :->: ([], happy_var_1), happy_var_5)
	) `HappyStk` happyRest

happyReduce_8 = happySpecReduce_1  7 happyReduction_8
happyReduction_8 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_8 _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_1  7 happyReduction_9
happyReduction_9 _
	 =  HappyAbsSyn7
		 (TVoid
	)

happyReduce_10 = happySpecReduce_3  8 happyReduction_10
happyReduction_10 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_10 _ _ _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  8 happyReduction_11
happyReduction_11 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_0  8 happyReduction_12
happyReduction_12  =  HappyAbsSyn8
		 ([]
	)

happyReduce_13 = happySpecReduce_2  9 happyReduction_13
happyReduction_13 (HappyTerminal (ID happy_var_2))
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn9
		 ((:#:) happy_var_2 (happy_var_1,0)
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  10 happyReduction_14
happyReduction_14 _
	(HappyAbsSyn14  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (([], happy_var_2 )
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_2  10 happyReduction_15
happyReduction_15 _
	_
	 =  HappyAbsSyn10
		 (([], [])
	)

happyReduce_16 = happySpecReduce_1  11 happyReduction_16
happyReduction_16 _
	 =  HappyAbsSyn11
		 (TInt
	)

happyReduce_17 = happySpecReduce_1  11 happyReduction_17
happyReduction_17 _
	 =  HappyAbsSyn11
		 (TDouble
	)

happyReduce_18 = happySpecReduce_1  11 happyReduction_18
happyReduction_18 _
	 =  HappyAbsSyn11
		 (TString
	)

happyReduce_19 = happySpecReduce_1  11 happyReduction_19
happyReduction_19 _
	 =  HappyAbsSyn11
		 (TBool
	)

happyReduce_20 = happySpecReduce_1  12 happyReduction_20
happyReduction_20 (HappyTerminal (ID happy_var_1))
	 =  HappyAbsSyn12
		 ([happy_var_1]
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  12 happyReduction_21
happyReduction_21 (HappyTerminal (ID happy_var_3))
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  13 happyReduction_22
happyReduction_22 _
	(HappyAbsSyn14  happy_var_2)
	_
	 =  HappyAbsSyn13
		 (happy_var_2
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_2  13 happyReduction_23
happyReduction_23 _
	_
	 =  HappyAbsSyn13
		 ([]
	)

happyReduce_24 = happySpecReduce_2  14 happyReduction_24
happyReduction_24 (HappyAbsSyn15  happy_var_2)
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_24 _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  14 happyReduction_25
happyReduction_25 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 ([happy_var_1]
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_0  14 happyReduction_26
happyReduction_26  =  HappyAbsSyn14
		 ([]
	)

happyReduce_27 = happySpecReduce_1  15 happyReduction_27
happyReduction_27 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  15 happyReduction_28
happyReduction_28 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_28 _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  15 happyReduction_29
happyReduction_29 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  15 happyReduction_30
happyReduction_30 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  15 happyReduction_31
happyReduction_31 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  15 happyReduction_32
happyReduction_32 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  15 happyReduction_33
happyReduction_33 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_3  15 happyReduction_34
happyReduction_34 _
	(HappyAbsSyn12  happy_var_2)
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn15
		 (Decl (map (\id -> id :#: (happy_var_1, 0)) happy_var_2)
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happyReduce 5 15 happyReduction_35
happyReduction_35 (_ `HappyStk`
	(HappyAbsSyn27  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (ID happy_var_2)) `HappyStk`
	(HappyAbsSyn11  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (DeclComAtrib (happy_var_2 :#: (happy_var_1, 0)) happy_var_4
	) `HappyStk` happyRest

happyReduce_36 = happySpecReduce_3  16 happyReduction_36
happyReduction_36 _
	(HappyAbsSyn27  happy_var_2)
	_
	 =  HappyAbsSyn16
		 (Ret (Just happy_var_2)
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_2  16 happyReduction_37
happyReduction_37 _
	_
	 =  HappyAbsSyn16
		 (Ret Nothing
	)

happyReduce_38 = happyReduce 7 17 happyReduction_38
happyReduction_38 ((HappyAbsSyn13  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn13  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn25  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (If happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_39 = happyReduce 5 17 happyReduction_39
happyReduction_39 ((HappyAbsSyn13  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn25  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (If happy_var_3 happy_var_5 []
	) `HappyStk` happyRest

happyReduce_40 = happyReduce 5 18 happyReduction_40
happyReduction_40 ((HappyAbsSyn13  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn25  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 (While happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_41 = happyReduce 4 19 happyReduction_41
happyReduction_41 (_ `HappyStk`
	(HappyAbsSyn27  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (ID happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn19
		 (Atrib happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_42 = happyReduce 5 20 happyReduction_42
happyReduction_42 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn27  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Imp happy_var_3
	) `HappyStk` happyRest

happyReduce_43 = happyReduce 5 21 happyReduction_43
happyReduction_43 (_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (ID happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 (Leitura happy_var_3
	) `HappyStk` happyRest

happyReduce_44 = happySpecReduce_2  22 happyReduction_44
happyReduction_44 _
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn22
		 (Proc (fst happy_var_1) (snd happy_var_1)
	)
happyReduction_44 _ _  = notHappyAtAll 

happyReduce_45 = happyReduce 4 23 happyReduction_45
happyReduction_45 (_ `HappyStk`
	(HappyAbsSyn24  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (ID happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 ((happy_var_1,happy_var_3)
	) `HappyStk` happyRest

happyReduce_46 = happySpecReduce_3  23 happyReduction_46
happyReduction_46 _
	_
	(HappyTerminal (ID happy_var_1))
	 =  HappyAbsSyn23
		 ((happy_var_1,[])
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  24 happyReduction_47
happyReduction_47 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn24
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  24 happyReduction_48
happyReduction_48 (HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn24
		 ([happy_var_1]
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  25 happyReduction_49
happyReduction_49 (HappyAbsSyn25  happy_var_3)
	_
	(HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn25
		 (Or happy_var_1 happy_var_3
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  25 happyReduction_50
happyReduction_50 (HappyAbsSyn25  happy_var_3)
	_
	(HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn25
		 (And happy_var_1 happy_var_3
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_2  25 happyReduction_51
happyReduction_51 (HappyAbsSyn25  happy_var_2)
	_
	 =  HappyAbsSyn25
		 (Not happy_var_2
	)
happyReduction_51 _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_1  25 happyReduction_52
happyReduction_52 (HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn25
		 (Rel happy_var_1
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  25 happyReduction_53
happyReduction_53 _
	(HappyAbsSyn25  happy_var_2)
	_
	 =  HappyAbsSyn25
		 (happy_var_2
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  26 happyReduction_54
happyReduction_54 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 (Req happy_var_1 happy_var_3
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_3  26 happyReduction_55
happyReduction_55 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 (Rgt happy_var_1 happy_var_3
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  26 happyReduction_56
happyReduction_56 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 (Rlt happy_var_1 happy_var_3
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  26 happyReduction_57
happyReduction_57 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 (Rle happy_var_1 happy_var_3
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  26 happyReduction_58
happyReduction_58 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 (Rge happy_var_1 happy_var_3
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  26 happyReduction_59
happyReduction_59 (HappyAbsSyn27  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn26
		 (Rdf happy_var_1 happy_var_3
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  27 happyReduction_60
happyReduction_60 (HappyAbsSyn28  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn27
		 (Add happy_var_1 happy_var_3
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  27 happyReduction_61
happyReduction_61 (HappyAbsSyn28  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn27
		 (Sub happy_var_1 happy_var_3
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_1  27 happyReduction_62
happyReduction_62 (HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn27
		 (happy_var_1
	)
happyReduction_62 _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  28 happyReduction_63
happyReduction_63 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (Mul happy_var_1 happy_var_3
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_3  28 happyReduction_64
happyReduction_64 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (Div happy_var_1 happy_var_3
	)
happyReduction_64 _ _ _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_3  28 happyReduction_65
happyReduction_65 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (Mod happy_var_1 happy_var_3
	)
happyReduction_65 _ _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_1  28 happyReduction_66
happyReduction_66 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 (happy_var_1
	)
happyReduction_66 _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_1  29 happyReduction_67
happyReduction_67 (HappyTerminal (NUM happy_var_1))
	 =  HappyAbsSyn29
		 (Const (CDouble happy_var_1)
	)
happyReduction_67 _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_1  29 happyReduction_68
happyReduction_68 (HappyTerminal (INT_LIT happy_var_1))
	 =  HappyAbsSyn29
		 (Const (CInt happy_var_1)
	)
happyReduction_68 _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_1  29 happyReduction_69
happyReduction_69 (HappyTerminal (ID happy_var_1))
	 =  HappyAbsSyn29
		 (IdVar happy_var_1
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_1  29 happyReduction_70
happyReduction_70 (HappyTerminal (STRING_LIT happy_var_1))
	 =  HappyAbsSyn29
		 (Lit happy_var_1
	)
happyReduction_70 _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_3  29 happyReduction_71
happyReduction_71 _
	(HappyAbsSyn27  happy_var_2)
	_
	 =  HappyAbsSyn29
		 (happy_var_2
	)
happyReduction_71 _ _ _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_2  29 happyReduction_72
happyReduction_72 (HappyAbsSyn29  happy_var_2)
	_
	 =  HappyAbsSyn29
		 (Neg happy_var_2
	)
happyReduction_72 _ _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_1  29 happyReduction_73
happyReduction_73 _
	 =  HappyAbsSyn29
		 (BConst True
	)

happyReduce_74 = happySpecReduce_1  29 happyReduction_74
happyReduction_74 _
	 =  HappyAbsSyn29
		 (BConst False
	)

happyReduce_75 = happyReduce 4 29 happyReduction_75
happyReduction_75 (_ `HappyStk`
	(HappyAbsSyn24  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (ID happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn29
		 (Chamada happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_76 = happySpecReduce_3  29 happyReduction_76
happyReduction_76 _
	_
	(HappyTerminal (ID happy_var_1))
	 =  HappyAbsSyn29
		 (Chamada happy_var_1 []
	)
happyReduction_76 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 68 68 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	MOD -> cont 30;
	ADD -> cont 31;
	SUB -> cont 32;
	MUL -> cont 33;
	RDF -> cont 34;
	DIV -> cont 35;
	LPAR -> cont 36;
	RPAR -> cont 37;
	LBRACE -> cont 38;
	RBRACE -> cont 39;
	EQ_ASSIGN -> cont 40;
	SEMI -> cont 41;
	RLE -> cont 42;
	RGE -> cont 43;
	RGT -> cont 44;
	RLT -> cont 45;
	REQ -> cont 46;
	AND -> cont 47;
	OR -> cont 48;
	NOT -> cont 49;
	COMMA -> cont 50;
	NUM happy_dollar_dollar -> cont 51;
	INT_LIT happy_dollar_dollar -> cont 52;
	ID happy_dollar_dollar -> cont 53;
	STRING_LIT happy_dollar_dollar -> cont 54;
	KW_INT -> cont 55;
	KW_FLOAT -> cont 56;
	KW_STRING -> cont 57;
	KW_VOID -> cont 58;
	KW_READ -> cont 59;
	KW_WHILE -> cont 60;
	KW_PRINT -> cont 61;
	KW_IF -> cont 62;
	KW_ELSE -> cont 63;
	KW_RETURN -> cont 64;
	KW_BOOL -> cont 65;
	LIT_TRUE -> cont 66;
	LIT_FALSE -> cont 67;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 68 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = HappyIdentity
    (<*>) = ap
instance Monad HappyIdentity where
    return = pure
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (return) a
happyError' :: () => ([(Token)], [String]) -> HappyIdentity a
happyError' = HappyIdentity . (\(tokens, _) -> parseError tokens)
parsePrograma tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> a
parseError s = error ("Parse error:" ++ show s)
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $










































data Happy_IntList = HappyCons Int Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action









































indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x < y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `div` 16)) (bit `mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ((HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
