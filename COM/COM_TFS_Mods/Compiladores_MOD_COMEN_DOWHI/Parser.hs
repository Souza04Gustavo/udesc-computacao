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

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32
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
	| HappyAbsSyn30 t30
	| HappyAbsSyn31 t31
	| HappyAbsSyn32 t32

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,489) ([0,0,0,0,0,0,0,0,60,0,0,64,7680,0,0,0,0,0,0,0,0,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,448,0,0,0,0,0,0,0,0,4,0,0,512,33280,47,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,136,0,0,0,1024,0,0,0,0,8,0,0,0,256,0,0,0,32768,0,0,0,0,64,0,0,0,8704,50180,3,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,49152,1,0,0,38912,0,0,0,0,0,0,0,5632,504,0,0,0,0,0,0,0,0,0,0,0,32768,8,241,0,0,1088,30848,0,0,0,0,0,0,0,272,7712,0,0,0,0,0,0,0,0,0,0,0,8192,0,0,0,0,0,0,0,0,2176,61696,0,0,16384,32772,120,0,0,544,15424,0,0,0,0,2048,0,0,0,0,0,0,0,0,2,0,0,98,964,0,0,4352,57856,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8192,64,0,0,0,0,0,0,0,0,0,0,0,0,1,6081,0,0,0,0,0,0,0,0,0,0,0,0,32,0,0,49328,15,0,0,0,16386,0,0,0,57388,3,0,0,0,0,0,0,0,64,0,0,0,32768,32768,3040,0,0,0,0,0,0,1024,0,0,0,0,12292,1,0,0,49240,7,0,0,11264,993,0,0,0,128,38,0,0,25088,50176,3,0,0,0,0,0,0,4096,1216,0,0,24576,7945,0,0,0,0,0,0,0,4096,8193,30,0,0,136,3856,0,0,17408,34816,7,0,0,34,964,0,0,4352,57856,1,0,32768,8,241,0,0,0,0,0,0,8192,16386,60,0,0,272,7712,0,0,34816,4096,15,0,0,68,1928,0,0,8704,50176,3,0,0,17,482,0,0,2176,61696,0,0,16384,32772,120,0,0,1024,128,0,0,0,0,0,0,0,0,1024,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,32,0,0,0,0,32768,3,0,45056,3968,2,0,0,0,0,0,0,0,0,0,0,0,61462,1,0,0,2816,248,0,0,32768,31749,0,0,0,704,62,0,0,24576,7937,0,0,0,32944,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32772,0,0,0,0,0,0,0,0,2,0,0,0,2048,0,0,0,32768,0,0,0,0,17,482,0,0,0,0,0,0,0,128,0,0,0,0,0,0,0,4096,8193,30,0,0,0,0,0,0,0,0,0,0,0,63499,0,0,0,0,0,0,0,0,49168,4,0,0,0,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,68,1928,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parsePrograma","Programa","ListaFuncoes","Funcao","TipoRetorno","DeclParametros","Parametro","BlocoPrincipal","Declaracoes","Declaracao","Tipo","ListaID","Bloco","ListaCmd","Comando","Retorno","CmdSe","CmdEnquanto","CmdDoWhile","CmdAtrib","CmdEscrita","CmdLeitura","ChamadaProc","ChamadaFuncao","ListaParametros","ExprL","ExprR","Expr","Term","Factor","'%'","'+'","'-'","'*'","'/='","'/'","'('","')'","'{'","'}'","'='","';'","'<='","'>='","'>'","'<'","'=='","'&&'","'||'","'!'","','","'?'","':'","NUM","INT_LIT","ID","STRING_LIT","'int'","'float'","'string'","'void'","'read'","'do'","'while'","'print'","'if'","'else'","'return'","%eof"]
        bit_start = st * 71
        bit_end = (st + 1) * 71
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..70]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (41) = happyShift action_12
action_0 (60) = happyShift action_6
action_0 (61) = happyShift action_7
action_0 (62) = happyShift action_8
action_0 (63) = happyShift action_9
action_0 (4) = happyGoto action_10
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 (7) = happyGoto action_4
action_0 (10) = happyGoto action_11
action_0 (13) = happyGoto action_5
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (60) = happyShift action_6
action_1 (61) = happyShift action_7
action_1 (62) = happyShift action_8
action_1 (63) = happyShift action_9
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 (7) = happyGoto action_4
action_1 (13) = happyGoto action_5
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (41) = happyShift action_12
action_2 (60) = happyShift action_6
action_2 (61) = happyShift action_7
action_2 (62) = happyShift action_8
action_2 (63) = happyShift action_9
action_2 (6) = happyGoto action_35
action_2 (7) = happyGoto action_4
action_2 (10) = happyGoto action_36
action_2 (13) = happyGoto action_5
action_2 _ = happyFail (happyExpListPerState 2)

action_3 _ = happyReduce_4

action_4 (58) = happyShift action_34
action_4 _ = happyFail (happyExpListPerState 4)

action_5 _ = happyReduce_8

action_6 _ = happyReduce_20

action_7 _ = happyReduce_21

action_8 _ = happyReduce_22

action_9 _ = happyReduce_9

action_10 (71) = happyAccept
action_10 _ = happyFail (happyExpListPerState 10)

action_11 _ = happyReduce_2

action_12 (42) = happyReduce_29
action_12 (58) = happyShift action_27
action_12 (60) = happyShift action_6
action_12 (61) = happyShift action_7
action_12 (62) = happyShift action_8
action_12 (64) = happyShift action_28
action_12 (65) = happyShift action_29
action_12 (66) = happyShift action_30
action_12 (67) = happyShift action_31
action_12 (68) = happyShift action_32
action_12 (70) = happyShift action_33
action_12 (11) = happyGoto action_13
action_12 (12) = happyGoto action_14
action_12 (13) = happyGoto action_15
action_12 (16) = happyGoto action_16
action_12 (17) = happyGoto action_17
action_12 (18) = happyGoto action_18
action_12 (19) = happyGoto action_19
action_12 (20) = happyGoto action_20
action_12 (21) = happyGoto action_21
action_12 (22) = happyGoto action_22
action_12 (23) = happyGoto action_23
action_12 (24) = happyGoto action_24
action_12 (25) = happyGoto action_25
action_12 (26) = happyGoto action_26
action_12 _ = happyReduce_29

action_13 (58) = happyShift action_27
action_13 (60) = happyShift action_6
action_13 (61) = happyShift action_7
action_13 (62) = happyShift action_8
action_13 (64) = happyShift action_28
action_13 (65) = happyShift action_29
action_13 (66) = happyShift action_30
action_13 (67) = happyShift action_31
action_13 (68) = happyShift action_32
action_13 (70) = happyShift action_33
action_13 (12) = happyGoto action_64
action_13 (13) = happyGoto action_15
action_13 (16) = happyGoto action_65
action_13 (17) = happyGoto action_17
action_13 (18) = happyGoto action_18
action_13 (19) = happyGoto action_19
action_13 (20) = happyGoto action_20
action_13 (21) = happyGoto action_21
action_13 (22) = happyGoto action_22
action_13 (23) = happyGoto action_23
action_13 (24) = happyGoto action_24
action_13 (25) = happyGoto action_25
action_13 (26) = happyGoto action_26
action_13 _ = happyReduce_29

action_14 _ = happyReduce_17

action_15 (58) = happyShift action_63
action_15 (14) = happyGoto action_62
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (42) = happyShift action_61
action_16 (58) = happyShift action_27
action_16 (64) = happyShift action_28
action_16 (65) = happyShift action_29
action_16 (66) = happyShift action_30
action_16 (67) = happyShift action_31
action_16 (68) = happyShift action_32
action_16 (70) = happyShift action_33
action_16 (17) = happyGoto action_60
action_16 (18) = happyGoto action_18
action_16 (19) = happyGoto action_19
action_16 (20) = happyGoto action_20
action_16 (21) = happyGoto action_21
action_16 (22) = happyGoto action_22
action_16 (23) = happyGoto action_23
action_16 (24) = happyGoto action_24
action_16 (25) = happyGoto action_25
action_16 (26) = happyGoto action_26
action_16 _ = happyFail (happyExpListPerState 16)

action_17 _ = happyReduce_28

action_18 _ = happyReduce_37

action_19 _ = happyReduce_30

action_20 _ = happyReduce_33

action_21 _ = happyReduce_34

action_22 _ = happyReduce_32

action_23 _ = happyReduce_31

action_24 _ = happyReduce_35

action_25 _ = happyReduce_36

action_26 (44) = happyShift action_59
action_26 _ = happyFail (happyExpListPerState 26)

action_27 (39) = happyShift action_57
action_27 (43) = happyShift action_58
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (39) = happyShift action_56
action_28 _ = happyFail (happyExpListPerState 28)

action_29 (41) = happyShift action_55
action_29 (15) = happyGoto action_54
action_29 _ = happyFail (happyExpListPerState 29)

action_30 (39) = happyShift action_53
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (39) = happyShift action_52
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (39) = happyShift action_51
action_32 _ = happyFail (happyExpListPerState 32)

action_33 (35) = happyShift action_43
action_33 (39) = happyShift action_44
action_33 (44) = happyShift action_45
action_33 (52) = happyShift action_46
action_33 (56) = happyShift action_47
action_33 (57) = happyShift action_48
action_33 (58) = happyShift action_49
action_33 (59) = happyShift action_50
action_33 (28) = happyGoto action_38
action_33 (29) = happyGoto action_39
action_33 (30) = happyGoto action_40
action_33 (31) = happyGoto action_41
action_33 (32) = happyGoto action_42
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (39) = happyShift action_37
action_34 _ = happyFail (happyExpListPerState 34)

action_35 _ = happyReduce_3

action_36 _ = happyReduce_1

action_37 (40) = happyShift action_104
action_37 (60) = happyShift action_6
action_37 (61) = happyShift action_7
action_37 (62) = happyShift action_8
action_37 (8) = happyGoto action_101
action_37 (9) = happyGoto action_102
action_37 (13) = happyGoto action_103
action_37 _ = happyReduce_12

action_38 (50) = happyShift action_98
action_38 (51) = happyShift action_99
action_38 (54) = happyShift action_100
action_38 _ = happyFail (happyExpListPerState 38)

action_39 _ = happyReduce_55

action_40 (34) = happyShift action_89
action_40 (35) = happyShift action_90
action_40 (37) = happyShift action_91
action_40 (44) = happyShift action_92
action_40 (45) = happyShift action_93
action_40 (46) = happyShift action_94
action_40 (47) = happyShift action_95
action_40 (48) = happyShift action_96
action_40 (49) = happyShift action_97
action_40 _ = happyFail (happyExpListPerState 40)

action_41 (33) = happyShift action_86
action_41 (36) = happyShift action_87
action_41 (38) = happyShift action_88
action_41 _ = happyReduce_65

action_42 _ = happyReduce_69

action_43 (35) = happyShift action_43
action_43 (39) = happyShift action_44
action_43 (52) = happyShift action_46
action_43 (56) = happyShift action_47
action_43 (57) = happyShift action_48
action_43 (58) = happyShift action_49
action_43 (59) = happyShift action_50
action_43 (28) = happyGoto action_38
action_43 (29) = happyGoto action_39
action_43 (30) = happyGoto action_78
action_43 (31) = happyGoto action_41
action_43 (32) = happyGoto action_85
action_43 _ = happyFail (happyExpListPerState 43)

action_44 (35) = happyShift action_43
action_44 (39) = happyShift action_44
action_44 (52) = happyShift action_46
action_44 (56) = happyShift action_47
action_44 (57) = happyShift action_48
action_44 (58) = happyShift action_49
action_44 (59) = happyShift action_50
action_44 (28) = happyGoto action_83
action_44 (29) = happyGoto action_39
action_44 (30) = happyGoto action_84
action_44 (31) = happyGoto action_41
action_44 (32) = happyGoto action_42
action_44 _ = happyFail (happyExpListPerState 44)

action_45 _ = happyReduce_39

action_46 (35) = happyShift action_43
action_46 (39) = happyShift action_44
action_46 (52) = happyShift action_46
action_46 (56) = happyShift action_47
action_46 (57) = happyShift action_48
action_46 (58) = happyShift action_49
action_46 (59) = happyShift action_50
action_46 (28) = happyGoto action_82
action_46 (29) = happyGoto action_39
action_46 (30) = happyGoto action_78
action_46 (31) = happyGoto action_41
action_46 (32) = happyGoto action_42
action_46 _ = happyFail (happyExpListPerState 46)

action_47 _ = happyReduce_70

action_48 _ = happyReduce_71

action_49 (39) = happyShift action_81
action_49 _ = happyReduce_72

action_50 _ = happyReduce_73

action_51 (35) = happyShift action_43
action_51 (39) = happyShift action_44
action_51 (52) = happyShift action_46
action_51 (56) = happyShift action_47
action_51 (57) = happyShift action_48
action_51 (58) = happyShift action_49
action_51 (59) = happyShift action_50
action_51 (28) = happyGoto action_80
action_51 (29) = happyGoto action_39
action_51 (30) = happyGoto action_78
action_51 (31) = happyGoto action_41
action_51 (32) = happyGoto action_42
action_51 _ = happyFail (happyExpListPerState 51)

action_52 (35) = happyShift action_43
action_52 (39) = happyShift action_44
action_52 (52) = happyShift action_46
action_52 (56) = happyShift action_47
action_52 (57) = happyShift action_48
action_52 (58) = happyShift action_49
action_52 (59) = happyShift action_50
action_52 (28) = happyGoto action_38
action_52 (29) = happyGoto action_39
action_52 (30) = happyGoto action_79
action_52 (31) = happyGoto action_41
action_52 (32) = happyGoto action_42
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (35) = happyShift action_43
action_53 (39) = happyShift action_44
action_53 (52) = happyShift action_46
action_53 (56) = happyShift action_47
action_53 (57) = happyShift action_48
action_53 (58) = happyShift action_49
action_53 (59) = happyShift action_50
action_53 (28) = happyGoto action_77
action_53 (29) = happyGoto action_39
action_53 (30) = happyGoto action_78
action_53 (31) = happyGoto action_41
action_53 (32) = happyGoto action_42
action_53 _ = happyFail (happyExpListPerState 53)

action_54 (66) = happyShift action_76
action_54 _ = happyFail (happyExpListPerState 54)

action_55 (42) = happyShift action_75
action_55 (58) = happyShift action_27
action_55 (64) = happyShift action_28
action_55 (65) = happyShift action_29
action_55 (66) = happyShift action_30
action_55 (67) = happyShift action_31
action_55 (68) = happyShift action_32
action_55 (70) = happyShift action_33
action_55 (16) = happyGoto action_74
action_55 (17) = happyGoto action_17
action_55 (18) = happyGoto action_18
action_55 (19) = happyGoto action_19
action_55 (20) = happyGoto action_20
action_55 (21) = happyGoto action_21
action_55 (22) = happyGoto action_22
action_55 (23) = happyGoto action_23
action_55 (24) = happyGoto action_24
action_55 (25) = happyGoto action_25
action_55 (26) = happyGoto action_26
action_55 _ = happyFail (happyExpListPerState 55)

action_56 (58) = happyShift action_73
action_56 _ = happyFail (happyExpListPerState 56)

action_57 (35) = happyShift action_43
action_57 (39) = happyShift action_44
action_57 (40) = happyShift action_72
action_57 (52) = happyShift action_46
action_57 (56) = happyShift action_47
action_57 (57) = happyShift action_48
action_57 (58) = happyShift action_49
action_57 (59) = happyShift action_50
action_57 (27) = happyGoto action_70
action_57 (28) = happyGoto action_38
action_57 (29) = happyGoto action_39
action_57 (30) = happyGoto action_71
action_57 (31) = happyGoto action_41
action_57 (32) = happyGoto action_42
action_57 _ = happyFail (happyExpListPerState 57)

action_58 (35) = happyShift action_43
action_58 (39) = happyShift action_44
action_58 (52) = happyShift action_46
action_58 (56) = happyShift action_47
action_58 (57) = happyShift action_48
action_58 (58) = happyShift action_49
action_58 (59) = happyShift action_50
action_58 (28) = happyGoto action_38
action_58 (29) = happyGoto action_39
action_58 (30) = happyGoto action_69
action_58 (31) = happyGoto action_41
action_58 (32) = happyGoto action_42
action_58 _ = happyFail (happyExpListPerState 58)

action_59 _ = happyReduce_47

action_60 _ = happyReduce_27

action_61 _ = happyReduce_15

action_62 (44) = happyShift action_67
action_62 (53) = happyShift action_68
action_62 _ = happyFail (happyExpListPerState 62)

action_63 _ = happyReduce_23

action_64 _ = happyReduce_16

action_65 (42) = happyShift action_66
action_65 (58) = happyShift action_27
action_65 (64) = happyShift action_28
action_65 (65) = happyShift action_29
action_65 (66) = happyShift action_30
action_65 (67) = happyShift action_31
action_65 (68) = happyShift action_32
action_65 (70) = happyShift action_33
action_65 (17) = happyGoto action_60
action_65 (18) = happyGoto action_18
action_65 (19) = happyGoto action_19
action_65 (20) = happyGoto action_20
action_65 (21) = happyGoto action_21
action_65 (22) = happyGoto action_22
action_65 (23) = happyGoto action_23
action_65 (24) = happyGoto action_24
action_65 (25) = happyGoto action_25
action_65 (26) = happyGoto action_26
action_65 _ = happyFail (happyExpListPerState 65)

action_66 _ = happyReduce_14

action_67 _ = happyReduce_19

action_68 (58) = happyShift action_136
action_68 _ = happyFail (happyExpListPerState 68)

action_69 (34) = happyShift action_89
action_69 (35) = happyShift action_90
action_69 (37) = happyShift action_91
action_69 (44) = happyShift action_135
action_69 (45) = happyShift action_93
action_69 (46) = happyShift action_94
action_69 (47) = happyShift action_95
action_69 (48) = happyShift action_96
action_69 (49) = happyShift action_97
action_69 _ = happyFail (happyExpListPerState 69)

action_70 (40) = happyShift action_133
action_70 (53) = happyShift action_134
action_70 _ = happyFail (happyExpListPerState 70)

action_71 (34) = happyShift action_89
action_71 (35) = happyShift action_90
action_71 (37) = happyShift action_91
action_71 (45) = happyShift action_93
action_71 (46) = happyShift action_94
action_71 (47) = happyShift action_95
action_71 (48) = happyShift action_96
action_71 (49) = happyShift action_97
action_71 _ = happyReduce_51

action_72 _ = happyReduce_49

action_73 (40) = happyShift action_132
action_73 _ = happyFail (happyExpListPerState 73)

action_74 (42) = happyShift action_131
action_74 (58) = happyShift action_27
action_74 (64) = happyShift action_28
action_74 (65) = happyShift action_29
action_74 (66) = happyShift action_30
action_74 (67) = happyShift action_31
action_74 (68) = happyShift action_32
action_74 (70) = happyShift action_33
action_74 (17) = happyGoto action_60
action_74 (18) = happyGoto action_18
action_74 (19) = happyGoto action_19
action_74 (20) = happyGoto action_20
action_74 (21) = happyGoto action_21
action_74 (22) = happyGoto action_22
action_74 (23) = happyGoto action_23
action_74 (24) = happyGoto action_24
action_74 (25) = happyGoto action_25
action_74 (26) = happyGoto action_26
action_74 _ = happyFail (happyExpListPerState 74)

action_75 _ = happyReduce_26

action_76 (39) = happyShift action_130
action_76 _ = happyFail (happyExpListPerState 76)

action_77 (40) = happyShift action_129
action_77 (50) = happyShift action_98
action_77 (51) = happyShift action_99
action_77 (54) = happyShift action_100
action_77 _ = happyFail (happyExpListPerState 77)

action_78 (34) = happyShift action_89
action_78 (35) = happyShift action_90
action_78 (37) = happyShift action_91
action_78 (45) = happyShift action_93
action_78 (46) = happyShift action_94
action_78 (47) = happyShift action_95
action_78 (48) = happyShift action_96
action_78 (49) = happyShift action_97
action_78 _ = happyFail (happyExpListPerState 78)

action_79 (34) = happyShift action_89
action_79 (35) = happyShift action_90
action_79 (37) = happyShift action_91
action_79 (40) = happyShift action_128
action_79 (45) = happyShift action_93
action_79 (46) = happyShift action_94
action_79 (47) = happyShift action_95
action_79 (48) = happyShift action_96
action_79 (49) = happyShift action_97
action_79 _ = happyFail (happyExpListPerState 79)

action_80 (40) = happyShift action_127
action_80 (50) = happyShift action_98
action_80 (51) = happyShift action_99
action_80 (54) = happyShift action_100
action_80 _ = happyFail (happyExpListPerState 80)

action_81 (35) = happyShift action_43
action_81 (39) = happyShift action_44
action_81 (40) = happyShift action_126
action_81 (52) = happyShift action_46
action_81 (56) = happyShift action_47
action_81 (57) = happyShift action_48
action_81 (58) = happyShift action_49
action_81 (59) = happyShift action_50
action_81 (27) = happyGoto action_125
action_81 (28) = happyGoto action_38
action_81 (29) = happyGoto action_39
action_81 (30) = happyGoto action_71
action_81 (31) = happyGoto action_41
action_81 (32) = happyGoto action_42
action_81 _ = happyFail (happyExpListPerState 81)

action_82 (50) = happyShift action_98
action_82 (51) = happyShift action_99
action_82 (54) = happyShift action_100
action_82 _ = happyReduce_54

action_83 (40) = happyShift action_124
action_83 (50) = happyShift action_98
action_83 (51) = happyShift action_99
action_83 (54) = happyShift action_100
action_83 _ = happyFail (happyExpListPerState 83)

action_84 (34) = happyShift action_89
action_84 (35) = happyShift action_90
action_84 (37) = happyShift action_91
action_84 (40) = happyShift action_123
action_84 (45) = happyShift action_93
action_84 (46) = happyShift action_94
action_84 (47) = happyShift action_95
action_84 (48) = happyShift action_96
action_84 (49) = happyShift action_97
action_84 _ = happyFail (happyExpListPerState 84)

action_85 (33) = happyReduce_76
action_85 (34) = happyReduce_76
action_85 (35) = happyReduce_76
action_85 (36) = happyReduce_76
action_85 (37) = happyReduce_76
action_85 (38) = happyReduce_76
action_85 (45) = happyReduce_76
action_85 (46) = happyReduce_76
action_85 (47) = happyReduce_76
action_85 (48) = happyReduce_76
action_85 (49) = happyReduce_76
action_85 _ = happyReduce_76

action_86 (35) = happyShift action_43
action_86 (39) = happyShift action_44
action_86 (52) = happyShift action_46
action_86 (56) = happyShift action_47
action_86 (57) = happyShift action_48
action_86 (58) = happyShift action_49
action_86 (59) = happyShift action_50
action_86 (28) = happyGoto action_38
action_86 (29) = happyGoto action_39
action_86 (30) = happyGoto action_78
action_86 (31) = happyGoto action_41
action_86 (32) = happyGoto action_122
action_86 _ = happyFail (happyExpListPerState 86)

action_87 (35) = happyShift action_43
action_87 (39) = happyShift action_44
action_87 (52) = happyShift action_46
action_87 (56) = happyShift action_47
action_87 (57) = happyShift action_48
action_87 (58) = happyShift action_49
action_87 (59) = happyShift action_50
action_87 (28) = happyGoto action_38
action_87 (29) = happyGoto action_39
action_87 (30) = happyGoto action_78
action_87 (31) = happyGoto action_41
action_87 (32) = happyGoto action_121
action_87 _ = happyFail (happyExpListPerState 87)

action_88 (35) = happyShift action_43
action_88 (39) = happyShift action_44
action_88 (52) = happyShift action_46
action_88 (56) = happyShift action_47
action_88 (57) = happyShift action_48
action_88 (58) = happyShift action_49
action_88 (59) = happyShift action_50
action_88 (28) = happyGoto action_38
action_88 (29) = happyGoto action_39
action_88 (30) = happyGoto action_78
action_88 (31) = happyGoto action_41
action_88 (32) = happyGoto action_120
action_88 _ = happyFail (happyExpListPerState 88)

action_89 (35) = happyShift action_43
action_89 (39) = happyShift action_44
action_89 (52) = happyShift action_46
action_89 (56) = happyShift action_47
action_89 (57) = happyShift action_48
action_89 (58) = happyShift action_49
action_89 (59) = happyShift action_50
action_89 (28) = happyGoto action_38
action_89 (29) = happyGoto action_39
action_89 (30) = happyGoto action_78
action_89 (31) = happyGoto action_119
action_89 (32) = happyGoto action_42
action_89 _ = happyFail (happyExpListPerState 89)

action_90 (35) = happyShift action_43
action_90 (39) = happyShift action_44
action_90 (52) = happyShift action_46
action_90 (56) = happyShift action_47
action_90 (57) = happyShift action_48
action_90 (58) = happyShift action_49
action_90 (59) = happyShift action_50
action_90 (28) = happyGoto action_38
action_90 (29) = happyGoto action_39
action_90 (30) = happyGoto action_78
action_90 (31) = happyGoto action_118
action_90 (32) = happyGoto action_42
action_90 _ = happyFail (happyExpListPerState 90)

action_91 (35) = happyShift action_43
action_91 (39) = happyShift action_44
action_91 (52) = happyShift action_46
action_91 (56) = happyShift action_47
action_91 (57) = happyShift action_48
action_91 (58) = happyShift action_49
action_91 (59) = happyShift action_50
action_91 (28) = happyGoto action_38
action_91 (29) = happyGoto action_39
action_91 (30) = happyGoto action_117
action_91 (31) = happyGoto action_41
action_91 (32) = happyGoto action_42
action_91 _ = happyFail (happyExpListPerState 91)

action_92 _ = happyReduce_38

action_93 (35) = happyShift action_43
action_93 (39) = happyShift action_44
action_93 (52) = happyShift action_46
action_93 (56) = happyShift action_47
action_93 (57) = happyShift action_48
action_93 (58) = happyShift action_49
action_93 (59) = happyShift action_50
action_93 (28) = happyGoto action_38
action_93 (29) = happyGoto action_39
action_93 (30) = happyGoto action_116
action_93 (31) = happyGoto action_41
action_93 (32) = happyGoto action_42
action_93 _ = happyFail (happyExpListPerState 93)

action_94 (35) = happyShift action_43
action_94 (39) = happyShift action_44
action_94 (52) = happyShift action_46
action_94 (56) = happyShift action_47
action_94 (57) = happyShift action_48
action_94 (58) = happyShift action_49
action_94 (59) = happyShift action_50
action_94 (28) = happyGoto action_38
action_94 (29) = happyGoto action_39
action_94 (30) = happyGoto action_115
action_94 (31) = happyGoto action_41
action_94 (32) = happyGoto action_42
action_94 _ = happyFail (happyExpListPerState 94)

action_95 (35) = happyShift action_43
action_95 (39) = happyShift action_44
action_95 (52) = happyShift action_46
action_95 (56) = happyShift action_47
action_95 (57) = happyShift action_48
action_95 (58) = happyShift action_49
action_95 (59) = happyShift action_50
action_95 (28) = happyGoto action_38
action_95 (29) = happyGoto action_39
action_95 (30) = happyGoto action_114
action_95 (31) = happyGoto action_41
action_95 (32) = happyGoto action_42
action_95 _ = happyFail (happyExpListPerState 95)

action_96 (35) = happyShift action_43
action_96 (39) = happyShift action_44
action_96 (52) = happyShift action_46
action_96 (56) = happyShift action_47
action_96 (57) = happyShift action_48
action_96 (58) = happyShift action_49
action_96 (59) = happyShift action_50
action_96 (28) = happyGoto action_38
action_96 (29) = happyGoto action_39
action_96 (30) = happyGoto action_113
action_96 (31) = happyGoto action_41
action_96 (32) = happyGoto action_42
action_96 _ = happyFail (happyExpListPerState 96)

action_97 (35) = happyShift action_43
action_97 (39) = happyShift action_44
action_97 (52) = happyShift action_46
action_97 (56) = happyShift action_47
action_97 (57) = happyShift action_48
action_97 (58) = happyShift action_49
action_97 (59) = happyShift action_50
action_97 (28) = happyGoto action_38
action_97 (29) = happyGoto action_39
action_97 (30) = happyGoto action_112
action_97 (31) = happyGoto action_41
action_97 (32) = happyGoto action_42
action_97 _ = happyFail (happyExpListPerState 97)

action_98 (35) = happyShift action_43
action_98 (39) = happyShift action_44
action_98 (52) = happyShift action_46
action_98 (56) = happyShift action_47
action_98 (57) = happyShift action_48
action_98 (58) = happyShift action_49
action_98 (59) = happyShift action_50
action_98 (28) = happyGoto action_111
action_98 (29) = happyGoto action_39
action_98 (30) = happyGoto action_78
action_98 (31) = happyGoto action_41
action_98 (32) = happyGoto action_42
action_98 _ = happyFail (happyExpListPerState 98)

action_99 (35) = happyShift action_43
action_99 (39) = happyShift action_44
action_99 (52) = happyShift action_46
action_99 (56) = happyShift action_47
action_99 (57) = happyShift action_48
action_99 (58) = happyShift action_49
action_99 (59) = happyShift action_50
action_99 (28) = happyGoto action_110
action_99 (29) = happyGoto action_39
action_99 (30) = happyGoto action_78
action_99 (31) = happyGoto action_41
action_99 (32) = happyGoto action_42
action_99 _ = happyFail (happyExpListPerState 99)

action_100 (35) = happyShift action_43
action_100 (39) = happyShift action_44
action_100 (52) = happyShift action_46
action_100 (56) = happyShift action_47
action_100 (57) = happyShift action_48
action_100 (58) = happyShift action_49
action_100 (59) = happyShift action_50
action_100 (28) = happyGoto action_38
action_100 (29) = happyGoto action_39
action_100 (30) = happyGoto action_109
action_100 (31) = happyGoto action_41
action_100 (32) = happyGoto action_42
action_100 _ = happyFail (happyExpListPerState 100)

action_101 (40) = happyShift action_107
action_101 (53) = happyShift action_108
action_101 _ = happyFail (happyExpListPerState 101)

action_102 _ = happyReduce_11

action_103 (58) = happyShift action_106
action_103 _ = happyFail (happyExpListPerState 103)

action_104 (41) = happyShift action_12
action_104 (10) = happyGoto action_105
action_104 _ = happyFail (happyExpListPerState 104)

action_105 _ = happyReduce_7

action_106 _ = happyReduce_13

action_107 (41) = happyShift action_12
action_107 (10) = happyGoto action_146
action_107 _ = happyFail (happyExpListPerState 107)

action_108 (60) = happyShift action_6
action_108 (61) = happyShift action_7
action_108 (62) = happyShift action_8
action_108 (9) = happyGoto action_145
action_108 (13) = happyGoto action_103
action_108 _ = happyFail (happyExpListPerState 108)

action_109 (34) = happyShift action_89
action_109 (35) = happyShift action_90
action_109 (37) = happyShift action_91
action_109 (45) = happyShift action_93
action_109 (46) = happyShift action_94
action_109 (47) = happyShift action_95
action_109 (48) = happyShift action_96
action_109 (49) = happyShift action_97
action_109 (55) = happyShift action_144
action_109 _ = happyFail (happyExpListPerState 109)

action_110 (50) = happyShift action_98
action_110 (51) = happyShift action_99
action_110 (54) = happyShift action_100
action_110 _ = happyReduce_52

action_111 (50) = happyShift action_98
action_111 (51) = happyShift action_99
action_111 (54) = happyShift action_100
action_111 _ = happyReduce_53

action_112 (34) = happyShift action_89
action_112 (35) = happyShift action_90
action_112 (37) = happyShift action_91
action_112 (45) = happyShift action_93
action_112 (46) = happyShift action_94
action_112 (47) = happyShift action_95
action_112 (48) = happyShift action_96
action_112 (49) = happyShift action_97
action_112 _ = happyReduce_57

action_113 (34) = happyShift action_89
action_113 (35) = happyShift action_90
action_113 (37) = happyShift action_91
action_113 (45) = happyShift action_93
action_113 (46) = happyShift action_94
action_113 (47) = happyShift action_95
action_113 (48) = happyShift action_96
action_113 (49) = happyShift action_97
action_113 _ = happyReduce_59

action_114 (34) = happyShift action_89
action_114 (35) = happyShift action_90
action_114 (37) = happyShift action_91
action_114 (45) = happyShift action_93
action_114 (46) = happyShift action_94
action_114 (47) = happyShift action_95
action_114 (48) = happyShift action_96
action_114 (49) = happyShift action_97
action_114 _ = happyReduce_58

action_115 (34) = happyShift action_89
action_115 (35) = happyShift action_90
action_115 (37) = happyShift action_91
action_115 (45) = happyShift action_93
action_115 (46) = happyShift action_94
action_115 (47) = happyShift action_95
action_115 (48) = happyShift action_96
action_115 (49) = happyShift action_97
action_115 _ = happyReduce_61

action_116 (34) = happyShift action_89
action_116 (35) = happyShift action_90
action_116 (37) = happyShift action_91
action_116 (45) = happyShift action_93
action_116 (46) = happyShift action_94
action_116 (47) = happyShift action_95
action_116 (48) = happyShift action_96
action_116 (49) = happyShift action_97
action_116 _ = happyReduce_60

action_117 (34) = happyShift action_89
action_117 (35) = happyShift action_90
action_117 (37) = happyShift action_91
action_117 (45) = happyShift action_93
action_117 (46) = happyShift action_94
action_117 (47) = happyShift action_95
action_117 (48) = happyShift action_96
action_117 (49) = happyShift action_97
action_117 _ = happyReduce_62

action_118 (33) = happyShift action_86
action_118 (34) = happyReduce_65
action_118 (35) = happyReduce_65
action_118 (36) = happyShift action_87
action_118 (37) = happyReduce_65
action_118 (38) = happyShift action_88
action_118 (45) = happyReduce_65
action_118 (46) = happyReduce_65
action_118 (47) = happyReduce_65
action_118 (48) = happyReduce_65
action_118 (49) = happyReduce_65
action_118 _ = happyReduce_64

action_119 (33) = happyShift action_86
action_119 (34) = happyReduce_65
action_119 (35) = happyReduce_65
action_119 (36) = happyShift action_87
action_119 (37) = happyReduce_65
action_119 (38) = happyShift action_88
action_119 (45) = happyReduce_65
action_119 (46) = happyReduce_65
action_119 (47) = happyReduce_65
action_119 (48) = happyReduce_65
action_119 (49) = happyReduce_65
action_119 _ = happyReduce_63

action_120 (33) = happyReduce_69
action_120 (34) = happyReduce_69
action_120 (35) = happyReduce_69
action_120 (36) = happyReduce_69
action_120 (37) = happyReduce_69
action_120 (38) = happyReduce_69
action_120 (45) = happyReduce_69
action_120 (46) = happyReduce_69
action_120 (47) = happyReduce_69
action_120 (48) = happyReduce_69
action_120 (49) = happyReduce_69
action_120 _ = happyReduce_67

action_121 (33) = happyReduce_69
action_121 (34) = happyReduce_69
action_121 (35) = happyReduce_69
action_121 (36) = happyReduce_69
action_121 (37) = happyReduce_69
action_121 (38) = happyReduce_69
action_121 (45) = happyReduce_69
action_121 (46) = happyReduce_69
action_121 (47) = happyReduce_69
action_121 (48) = happyReduce_69
action_121 (49) = happyReduce_69
action_121 _ = happyReduce_66

action_122 (33) = happyReduce_69
action_122 (34) = happyReduce_69
action_122 (35) = happyReduce_69
action_122 (36) = happyReduce_69
action_122 (37) = happyReduce_69
action_122 (38) = happyReduce_69
action_122 (45) = happyReduce_69
action_122 (46) = happyReduce_69
action_122 (47) = happyReduce_69
action_122 (48) = happyReduce_69
action_122 (49) = happyReduce_69
action_122 _ = happyReduce_68

action_123 _ = happyReduce_74

action_124 _ = happyReduce_56

action_125 (40) = happyShift action_143
action_125 (53) = happyShift action_134
action_125 _ = happyFail (happyExpListPerState 125)

action_126 _ = happyReduce_78

action_127 (41) = happyShift action_55
action_127 (15) = happyGoto action_142
action_127 _ = happyFail (happyExpListPerState 127)

action_128 (44) = happyShift action_141
action_128 _ = happyFail (happyExpListPerState 128)

action_129 (41) = happyShift action_55
action_129 (15) = happyGoto action_140
action_129 _ = happyFail (happyExpListPerState 129)

action_130 (35) = happyShift action_43
action_130 (39) = happyShift action_44
action_130 (52) = happyShift action_46
action_130 (56) = happyShift action_47
action_130 (57) = happyShift action_48
action_130 (58) = happyShift action_49
action_130 (59) = happyShift action_50
action_130 (28) = happyGoto action_139
action_130 (29) = happyGoto action_39
action_130 (30) = happyGoto action_78
action_130 (31) = happyGoto action_41
action_130 (32) = happyGoto action_42
action_130 _ = happyFail (happyExpListPerState 130)

action_131 _ = happyReduce_25

action_132 (44) = happyShift action_138
action_132 _ = happyFail (happyExpListPerState 132)

action_133 _ = happyReduce_48

action_134 (35) = happyShift action_43
action_134 (39) = happyShift action_44
action_134 (52) = happyShift action_46
action_134 (56) = happyShift action_47
action_134 (57) = happyShift action_48
action_134 (58) = happyShift action_49
action_134 (59) = happyShift action_50
action_134 (28) = happyGoto action_38
action_134 (29) = happyGoto action_39
action_134 (30) = happyGoto action_137
action_134 (31) = happyGoto action_41
action_134 (32) = happyGoto action_42
action_134 _ = happyFail (happyExpListPerState 134)

action_135 _ = happyReduce_44

action_136 _ = happyReduce_24

action_137 (34) = happyShift action_89
action_137 (35) = happyShift action_90
action_137 (37) = happyShift action_91
action_137 (45) = happyShift action_93
action_137 (46) = happyShift action_94
action_137 (47) = happyShift action_95
action_137 (48) = happyShift action_96
action_137 (49) = happyShift action_97
action_137 _ = happyReduce_50

action_138 _ = happyReduce_46

action_139 (40) = happyShift action_149
action_139 (50) = happyShift action_98
action_139 (51) = happyShift action_99
action_139 (54) = happyShift action_100
action_139 _ = happyFail (happyExpListPerState 139)

action_140 _ = happyReduce_42

action_141 _ = happyReduce_45

action_142 (69) = happyShift action_148
action_142 _ = happyReduce_41

action_143 _ = happyReduce_77

action_144 (35) = happyShift action_43
action_144 (39) = happyShift action_44
action_144 (52) = happyShift action_46
action_144 (56) = happyShift action_47
action_144 (57) = happyShift action_48
action_144 (58) = happyShift action_49
action_144 (59) = happyShift action_50
action_144 (28) = happyGoto action_38
action_144 (29) = happyGoto action_39
action_144 (30) = happyGoto action_147
action_144 (31) = happyGoto action_41
action_144 (32) = happyGoto action_42
action_144 _ = happyFail (happyExpListPerState 144)

action_145 _ = happyReduce_10

action_146 _ = happyReduce_6

action_147 (34) = happyShift action_89
action_147 (35) = happyShift action_90
action_147 (37) = happyShift action_91
action_147 (45) = happyShift action_93
action_147 (46) = happyShift action_94
action_147 (47) = happyShift action_95
action_147 (48) = happyShift action_96
action_147 (49) = happyShift action_97
action_147 _ = happyReduce_75

action_148 (41) = happyShift action_55
action_148 (15) = happyGoto action_151
action_148 _ = happyFail (happyExpListPerState 148)

action_149 (44) = happyShift action_150
action_149 _ = happyFail (happyExpListPerState 149)

action_150 _ = happyReduce_43

action_151 _ = happyReduce_40

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
happyReduction_8 (HappyAbsSyn13  happy_var_1)
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
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn9
		 ((:#:) happy_var_2 (happy_var_1,0)
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happyReduce 4 10 happyReduction_14
happyReduction_14 (_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	(HappyAbsSyn11  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 ((happy_var_2, happy_var_3)
	) `HappyStk` happyRest

happyReduce_15 = happySpecReduce_3  10 happyReduction_15
happyReduction_15 _
	(HappyAbsSyn16  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (([], happy_var_2 )
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_2  11 happyReduction_16
happyReduction_16 (HappyAbsSyn12  happy_var_2)
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1 ++ happy_var_2
	)
happyReduction_16 _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  11 happyReduction_17
happyReduction_17 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_0  11 happyReduction_18
happyReduction_18  =  HappyAbsSyn11
		 ([]
	)

happyReduce_19 = happySpecReduce_3  12 happyReduction_19
happyReduction_19 _
	(HappyAbsSyn14  happy_var_2)
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 (map (\idName -> (:#:) idName (happy_var_1,0) ) (happy_var_2)
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  13 happyReduction_20
happyReduction_20 _
	 =  HappyAbsSyn13
		 (TInt
	)

happyReduce_21 = happySpecReduce_1  13 happyReduction_21
happyReduction_21 _
	 =  HappyAbsSyn13
		 (TDouble
	)

happyReduce_22 = happySpecReduce_1  13 happyReduction_22
happyReduction_22 _
	 =  HappyAbsSyn13
		 (TString
	)

happyReduce_23 = happySpecReduce_1  14 happyReduction_23
happyReduction_23 (HappyTerminal (ID happy_var_1))
	 =  HappyAbsSyn14
		 ([happy_var_1]
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  14 happyReduction_24
happyReduction_24 (HappyTerminal (ID happy_var_3))
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_3  15 happyReduction_25
happyReduction_25 _
	(HappyAbsSyn16  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (happy_var_2
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_2  15 happyReduction_26
happyReduction_26 _
	_
	 =  HappyAbsSyn15
		 ([]
	)

happyReduce_27 = happySpecReduce_2  16 happyReduction_27
happyReduction_27 (HappyAbsSyn17  happy_var_2)
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  16 happyReduction_28
happyReduction_28 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn16
		 ([happy_var_1]
	)
happyReduction_28 _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_0  16 happyReduction_29
happyReduction_29  =  HappyAbsSyn16
		 ([]
	)

happyReduce_30 = happySpecReduce_1  17 happyReduction_30
happyReduction_30 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  17 happyReduction_31
happyReduction_31 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  17 happyReduction_32
happyReduction_32 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  17 happyReduction_33
happyReduction_33 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  17 happyReduction_34
happyReduction_34 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_1  17 happyReduction_35
happyReduction_35 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_35 _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  17 happyReduction_36
happyReduction_36 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_1  17 happyReduction_37
happyReduction_37 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_37 _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_3  18 happyReduction_38
happyReduction_38 _
	(HappyAbsSyn30  happy_var_2)
	_
	 =  HappyAbsSyn18
		 (Ret (Just happy_var_2)
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_2  18 happyReduction_39
happyReduction_39 _
	_
	 =  HappyAbsSyn18
		 (Ret Nothing
	)

happyReduce_40 = happyReduce 7 19 happyReduction_40
happyReduction_40 ((HappyAbsSyn15  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn19
		 (If happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_41 = happyReduce 5 19 happyReduction_41
happyReduction_41 ((HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn19
		 (If happy_var_3 happy_var_5 []
	) `HappyStk` happyRest

happyReduce_42 = happyReduce 5 20 happyReduction_42
happyReduction_42 ((HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn28  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (While happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_43 = happyReduce 7 21 happyReduction_43
happyReduction_43 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn28  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 (DoWhile happy_var_2 happy_var_5
	) `HappyStk` happyRest

happyReduce_44 = happyReduce 4 22 happyReduction_44
happyReduction_44 (_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (ID happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 (Atrib happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_45 = happyReduce 5 23 happyReduction_45
happyReduction_45 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (Imp happy_var_3
	) `HappyStk` happyRest

happyReduce_46 = happyReduce 5 24 happyReduction_46
happyReduction_46 (_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (ID happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (Leitura happy_var_3
	) `HappyStk` happyRest

happyReduce_47 = happySpecReduce_2  25 happyReduction_47
happyReduction_47 _
	(HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn25
		 (Proc (fst happy_var_1) (snd happy_var_1)
	)
happyReduction_47 _ _  = notHappyAtAll 

happyReduce_48 = happyReduce 4 26 happyReduction_48
happyReduction_48 (_ `HappyStk`
	(HappyAbsSyn27  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (ID happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn26
		 ((happy_var_1,happy_var_3)
	) `HappyStk` happyRest

happyReduce_49 = happySpecReduce_3  26 happyReduction_49
happyReduction_49 _
	_
	(HappyTerminal (ID happy_var_1))
	 =  HappyAbsSyn26
		 ((happy_var_1,[])
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  27 happyReduction_50
happyReduction_50 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn27  happy_var_1)
	 =  HappyAbsSyn27
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_1  27 happyReduction_51
happyReduction_51 (HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn27
		 ([happy_var_1]
	)
happyReduction_51 _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_3  28 happyReduction_52
happyReduction_52 (HappyAbsSyn28  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (Or happy_var_1 happy_var_3
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  28 happyReduction_53
happyReduction_53 (HappyAbsSyn28  happy_var_3)
	_
	(HappyAbsSyn28  happy_var_1)
	 =  HappyAbsSyn28
		 (And happy_var_1 happy_var_3
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_2  28 happyReduction_54
happyReduction_54 (HappyAbsSyn28  happy_var_2)
	_
	 =  HappyAbsSyn28
		 (Not happy_var_2
	)
happyReduction_54 _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_1  28 happyReduction_55
happyReduction_55 (HappyAbsSyn29  happy_var_1)
	 =  HappyAbsSyn28
		 (Rel happy_var_1
	)
happyReduction_55 _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  28 happyReduction_56
happyReduction_56 _
	(HappyAbsSyn28  happy_var_2)
	_
	 =  HappyAbsSyn28
		 (happy_var_2
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  29 happyReduction_57
happyReduction_57 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn29
		 (Req happy_var_1 happy_var_3
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  29 happyReduction_58
happyReduction_58 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn29
		 (Rgt happy_var_1 happy_var_3
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  29 happyReduction_59
happyReduction_59 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn29
		 (Rlt happy_var_1 happy_var_3
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  29 happyReduction_60
happyReduction_60 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn29
		 (Rle happy_var_1 happy_var_3
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  29 happyReduction_61
happyReduction_61 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn29
		 (Rge happy_var_1 happy_var_3
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_3  29 happyReduction_62
happyReduction_62 (HappyAbsSyn30  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn29
		 (Rdf happy_var_1 happy_var_3
	)
happyReduction_62 _ _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  30 happyReduction_63
happyReduction_63 (HappyAbsSyn31  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (Add happy_var_1 happy_var_3
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_3  30 happyReduction_64
happyReduction_64 (HappyAbsSyn31  happy_var_3)
	_
	(HappyAbsSyn30  happy_var_1)
	 =  HappyAbsSyn30
		 (Sub happy_var_1 happy_var_3
	)
happyReduction_64 _ _ _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_1  30 happyReduction_65
happyReduction_65 (HappyAbsSyn31  happy_var_1)
	 =  HappyAbsSyn30
		 (happy_var_1
	)
happyReduction_65 _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_3  31 happyReduction_66
happyReduction_66 (HappyAbsSyn32  happy_var_3)
	_
	(HappyAbsSyn31  happy_var_1)
	 =  HappyAbsSyn31
		 (Mul happy_var_1 happy_var_3
	)
happyReduction_66 _ _ _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_3  31 happyReduction_67
happyReduction_67 (HappyAbsSyn32  happy_var_3)
	_
	(HappyAbsSyn31  happy_var_1)
	 =  HappyAbsSyn31
		 (Div happy_var_1 happy_var_3
	)
happyReduction_67 _ _ _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_3  31 happyReduction_68
happyReduction_68 (HappyAbsSyn32  happy_var_3)
	_
	(HappyAbsSyn31  happy_var_1)
	 =  HappyAbsSyn31
		 (Mod happy_var_1 happy_var_3
	)
happyReduction_68 _ _ _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_1  31 happyReduction_69
happyReduction_69 (HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn31
		 (happy_var_1
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_1  32 happyReduction_70
happyReduction_70 (HappyTerminal (NUM happy_var_1))
	 =  HappyAbsSyn32
		 (Const (CDouble happy_var_1)
	)
happyReduction_70 _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_1  32 happyReduction_71
happyReduction_71 (HappyTerminal (INT_LIT happy_var_1))
	 =  HappyAbsSyn32
		 (Const (CInt happy_var_1)
	)
happyReduction_71 _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_1  32 happyReduction_72
happyReduction_72 (HappyTerminal (ID happy_var_1))
	 =  HappyAbsSyn32
		 (IdVar happy_var_1
	)
happyReduction_72 _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_1  32 happyReduction_73
happyReduction_73 (HappyTerminal (STRING_LIT happy_var_1))
	 =  HappyAbsSyn32
		 (Lit happy_var_1
	)
happyReduction_73 _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_3  32 happyReduction_74
happyReduction_74 _
	(HappyAbsSyn30  happy_var_2)
	_
	 =  HappyAbsSyn32
		 (happy_var_2
	)
happyReduction_74 _ _ _  = notHappyAtAll 

happyReduce_75 = happyReduce 5 32 happyReduction_75
happyReduction_75 ((HappyAbsSyn30  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn30  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn28  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn32
		 (Ternario happy_var_1 happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_76 = happySpecReduce_2  32 happyReduction_76
happyReduction_76 (HappyAbsSyn32  happy_var_2)
	_
	 =  HappyAbsSyn32
		 (Neg happy_var_2
	)
happyReduction_76 _ _  = notHappyAtAll 

happyReduce_77 = happyReduce 4 32 happyReduction_77
happyReduction_77 (_ `HappyStk`
	(HappyAbsSyn27  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (ID happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn32
		 (Chamada happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_78 = happySpecReduce_3  32 happyReduction_78
happyReduction_78 _
	_
	(HappyTerminal (ID happy_var_1))
	 =  HappyAbsSyn32
		 (Chamada happy_var_1 []
	)
happyReduction_78 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 71 71 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	MOD -> cont 33;
	ADD -> cont 34;
	SUB -> cont 35;
	MUL -> cont 36;
	RDF -> cont 37;
	DIV -> cont 38;
	LPAR -> cont 39;
	RPAR -> cont 40;
	LBRACE -> cont 41;
	RBRACE -> cont 42;
	EQ_ASSIGN -> cont 43;
	SEMI -> cont 44;
	RLE -> cont 45;
	RGE -> cont 46;
	RGT -> cont 47;
	RLT -> cont 48;
	REQ -> cont 49;
	AND -> cont 50;
	OR -> cont 51;
	NOT -> cont 52;
	COMMA -> cont 53;
	INTERROGACAO -> cont 54;
	DOIS_PONTOS -> cont 55;
	NUM happy_dollar_dollar -> cont 56;
	INT_LIT happy_dollar_dollar -> cont 57;
	ID happy_dollar_dollar -> cont 58;
	STRING_LIT happy_dollar_dollar -> cont 59;
	KW_INT -> cont 60;
	KW_FLOAT -> cont 61;
	KW_STRING -> cont 62;
	KW_VOID -> cont 63;
	KW_READ -> cont 64;
	KW_DO -> cont 65;
	KW_WHILE -> cont 66;
	KW_PRINT -> cont 67;
	KW_IF -> cont 68;
	KW_ELSE -> cont 69;
	KW_RETURN -> cont 70;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 71 tk tks = happyError' (tks, explist)
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
