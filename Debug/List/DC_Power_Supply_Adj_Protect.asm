
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega88P
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega88P
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Uc_I_Positive_Over=R5
	.DEF _Uc_U_Positive_Over=R4
	.DEF _Uc_I_Negative_Over=R7
	.DEF _Uc_U_Negative_Over=R6
	.DEF _Uc_I_Positive_Under=R9
	.DEF _Uc_U_Positive_Under=R8
	.DEF _Uc_I_Negative_Under=R11
	.DEF _Uc_U_Negative_Under=R10
	.DEF _Uint_Timer_Display=R12
	.DEF _Uint_Timer_Display_msb=R13

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x20003:
	.DB  0x1
_0x20004:
	.DB  0xF9,0x21,0xEA,0x6B,0x33,0x5B,0xDB,0x29
	.DB  0xFB,0x7B

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _Uc_Select_led
	.DW  _0x20003*2

	.DW  0x0A
	.DW  _BCDLED
	.DW  _0x20004*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x200

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : DC_Power_Supply_Adj_Protect
;Version :
;Date    : 29/11/2018
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8A
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega88.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif
;#include <scan_led.h>
;#include <delay.h>
;
;#define ADC_I_POSITIVE  0
;#define ADC_U_POSITIVE  1
;#define ADC_I_NEGATIVE  2
;#define ADC_U_NEGATIVE  3
;
;#define CONTROL_RELAY   PORTC.4
;
;#define PROTECT_ON   CONTROL_RELAY  = 1
;#define PROTECT_OFF   CONTROL_RELAY  = 0
;
;#define ADC_I_POSITIVE_SET  100
;#define ADC_U_POSITIVE_SET  100
;#define ADC_I_NEGATIVE_SET  100
;#define ADC_U_NEGATIVE_SET  100
;
;#define ADC_I_POSITIVE_RATIO  100
;#define ADC_U_POSITIVE_RATIO  100
;#define ADC_I_NEGATIVE_RATIO  100
;#define ADC_U_NEGATIVE_RATIO  100
;
;unsigned char   Uc_I_Positive_Over = 0;
;unsigned char   Uc_U_Positive_Over = 0;
;unsigned char   Uc_I_Negative_Over = 0;
;unsigned char   Uc_U_Negative_Over = 0;
;
;unsigned char   Uc_I_Positive_Under = 0;
;unsigned char   Uc_U_Positive_Under = 0;
;unsigned char   Uc_I_Negative_Under = 0;
;unsigned char   Uc_U_Negative_Under = 0;
;
;bit     Bit_I_Positive_Warning = 0;
;bit     Bit_U_Positive_Warning = 0;
;bit     Bit_I_Negative_Warning = 0;
;bit     Bit_U_Negative_Warning = 0;
;
;unsigned int    Uint_Timer_Display = 0;
;
;// Declare your global variables here
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0045 {

	.CSEG
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0046     // Reinitialize Timer1 value
; 0000 0047     TCNT1H=0x9380 >> 8;
	LDI  R30,LOW(147)
	RCALL SUBOPT_0x0
; 0000 0048     TCNT1L=0x9380 & 0xff;
; 0000 0049     // Place your code here
; 0000 004A     SCAN_LED();
	RCALL _SCAN_LED
; 0000 004B 
; 0000 004C }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0053 {
; 0000 0054     ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 0055     // Delay needed for the stabilization of the ADC input voltage
; 0000 0056     delay_us(10);
; 0000 0057     // Start the AD conversion
; 0000 0058     ADCSRA|=(1<<ADSC);
; 0000 0059     // Wait for the AD conversion to complete
; 0000 005A     while ((ADCSRA & (1<<ADIF))==0);
; 0000 005B     ADCSRA|=(1<<ADIF);
; 0000 005C     return ADCW;
; 0000 005D }
;
;void    PROTECT(void)
; 0000 0060 {
; 0000 0061     unsigned int    Uint_ADC_Value;
; 0000 0062 
; 0000 0063     /* I Negative */
; 0000 0064     Uint_ADC_Value = read_adc(ADC_I_NEGATIVE);
;	Uint_ADC_Value -> R16,R17
; 0000 0065     Uint_data_led2 = Uint_ADC_Value*ADC_I_NEGATIVE_RATIO/1024;
; 0000 0066     if(Uint_ADC_Value > ADC_I_NEGATIVE_SET)
; 0000 0067     {
; 0000 0068         Uc_I_Negative_Over++;
; 0000 0069         if(Uc_I_Negative_Over > 10)
; 0000 006A         {
; 0000 006B             Uc_I_Negative_Over = 11;
; 0000 006C             Uc_I_Negative_Under = 0;
; 0000 006D             Bit_I_Negative_Warning = 1;
; 0000 006E         }
; 0000 006F     }
; 0000 0070     else
; 0000 0071     {
; 0000 0072         Uc_I_Negative_Under++;
; 0000 0073         if(Uc_I_Negative_Under > 10)
; 0000 0074         {
; 0000 0075             Uc_I_Negative_Under = 11;
; 0000 0076             Uc_I_Negative_Over = 0;
; 0000 0077             Bit_I_Negative_Warning = 0;
; 0000 0078         }
; 0000 0079     }
; 0000 007A     /* I Positive */
; 0000 007B     Uint_ADC_Value = read_adc(ADC_I_POSITIVE);
; 0000 007C     Uint_data_led4 = Uint_ADC_Value*ADC_I_POSITIVE_RATIO/1024;
; 0000 007D     if(Uint_ADC_Value > ADC_I_POSITIVE_SET)
; 0000 007E     {
; 0000 007F         Uc_I_Positive_Over++;
; 0000 0080         if(Uc_I_Positive_Over > 10)
; 0000 0081         {
; 0000 0082             Uc_I_Positive_Over = 11;
; 0000 0083             Uc_I_Positive_Under = 0;
; 0000 0084             Bit_I_Positive_Warning = 1;
; 0000 0085         }
; 0000 0086     }
; 0000 0087     else
; 0000 0088     {
; 0000 0089         Uc_I_Positive_Under++;
; 0000 008A         if(Uc_I_Positive_Under > 10)
; 0000 008B         {
; 0000 008C             Uc_I_Positive_Under = 11;
; 0000 008D             Uc_I_Positive_Over = 0;
; 0000 008E             Bit_I_Positive_Warning = 0;
; 0000 008F         }
; 0000 0090     }
; 0000 0091     /* U Negative */
; 0000 0092     Uint_ADC_Value = read_adc(ADC_U_NEGATIVE);
; 0000 0093     Uint_data_led1 = Uint_ADC_Value*ADC_U_NEGATIVE_RATIO/1024;
; 0000 0094     if(Uint_ADC_Value > ADC_U_NEGATIVE_SET)
; 0000 0095     {
; 0000 0096         Uc_U_Negative_Over++;
; 0000 0097         if(Uc_U_Negative_Over > 10)
; 0000 0098         {
; 0000 0099             Uc_U_Negative_Over = 11;
; 0000 009A             Uc_U_Negative_Under = 0;
; 0000 009B             Bit_U_Negative_Warning = 1;
; 0000 009C         }
; 0000 009D     }
; 0000 009E     else
; 0000 009F     {
; 0000 00A0         Uc_U_Negative_Under++;
; 0000 00A1         if(Uc_U_Negative_Under > 10)
; 0000 00A2         {
; 0000 00A3             Uc_U_Negative_Under = 11;
; 0000 00A4             Uc_U_Negative_Over = 0;
; 0000 00A5             Bit_U_Negative_Warning = 0;
; 0000 00A6         }
; 0000 00A7     }
; 0000 00A8     /* U Positive */
; 0000 00A9     Uint_ADC_Value = read_adc(ADC_U_POSITIVE);
; 0000 00AA     Uint_data_led3 = Uint_ADC_Value*ADC_U_POSITIVE_RATIO/1024;
; 0000 00AB     if(Uint_ADC_Value > ADC_U_POSITIVE_SET)
; 0000 00AC     {
; 0000 00AD         Uc_U_Positive_Over++;
; 0000 00AE         if(Uc_U_Positive_Over > 10)
; 0000 00AF         {
; 0000 00B0             Uc_U_Positive_Over = 11;
; 0000 00B1             Uc_U_Positive_Under = 0;
; 0000 00B2             Bit_U_Positive_Warning = 1;
; 0000 00B3         }
; 0000 00B4     }
; 0000 00B5     else
; 0000 00B6     {
; 0000 00B7         Uc_U_Positive_Under++;
; 0000 00B8         if(Uc_U_Positive_Under > 10)
; 0000 00B9         {
; 0000 00BA             Uc_U_Positive_Under = 11;
; 0000 00BB             Uc_U_Positive_Over = 0;
; 0000 00BC             Bit_U_Positive_Warning = 0;
; 0000 00BD         }
; 0000 00BE     }
; 0000 00BF     if(Bit_I_Negative_Warning || Bit_I_Positive_Warning || Bit_U_Positive_Warning || Bit_U_Negative_Warning)
; 0000 00C0     {
; 0000 00C1         PROTECT_ON;
; 0000 00C2     }
; 0000 00C3     else
; 0000 00C4     {
; 0000 00C5         PROTECT_OFF;
; 0000 00C6     }
; 0000 00C7     delay_ms(10);
; 0000 00C8 }
;
;void main(void)
; 0000 00CB {
_main:
; .FSTART _main
; 0000 00CC     // Declare your local variables here
; 0000 00CD 
; 0000 00CE     // Crystal Oscillator division factor: 1
; 0000 00CF     #pragma optsize-
; 0000 00D0     CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00D1     CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00D2     #ifdef _OPTIMIZE_SIZE_
; 0000 00D3     #pragma optsize+
; 0000 00D4     #endif
; 0000 00D5     // Input/Output Ports initialization
; 0000 00D6     // Port B initialization
; 0000 00D7     // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 00D8     DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(40)
	OUT  0x4,R30
; 0000 00D9     // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 00DA     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 00DB 
; 0000 00DC     // Port C initialization
; 0000 00DD     // Function: Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00DE     DDRC=(0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(16)
	OUT  0x7,R30
; 0000 00DF     // State: Bit6=T Bit5=T Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00E0     PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 00E1 
; 0000 00E2     // Port D initialization
; 0000 00E3     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=In Bit0=In
; 0000 00E4     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (1<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(4)
	OUT  0xA,R30
; 0000 00E5     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=T Bit0=T
; 0000 00E6     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00E7 
; 0000 00E8     // Timer/Counter 0 initialization
; 0000 00E9     // Clock source: System Clock
; 0000 00EA     // Clock value: Timer 0 Stopped
; 0000 00EB     // Mode: Normal top=0xFF
; 0000 00EC     // OC0A output: Disconnected
; 0000 00ED     // OC0B output: Disconnected
; 0000 00EE     TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 00EF     TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0000 00F0     TCNT0=0x00;
	OUT  0x26,R30
; 0000 00F1     OCR0A=0x00;
	OUT  0x27,R30
; 0000 00F2     OCR0B=0x00;
	OUT  0x28,R30
; 0000 00F3 
; 0000 00F4     // Timer/Counter 1 initialization
; 0000 00F5     // Clock source: System Clock
; 0000 00F6     // Clock value: 8000,000 kHz
; 0000 00F7     // Mode: Normal top=0xFFFF
; 0000 00F8     // OC1A output: Disconnected
; 0000 00F9     // OC1B output: Disconnected
; 0000 00FA     // Noise Canceler: Off
; 0000 00FB     // Input Capture on Falling Edge
; 0000 00FC     // Timer Period: 2 ms
; 0000 00FD     // Timer1 Overflow Interrupt: On
; 0000 00FE     // Input Capture Interrupt: Off
; 0000 00FF     // Compare A Match Interrupt: Off
; 0000 0100     // Compare B Match Interrupt: Off
; 0000 0101     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 0102     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	STS  129,R30
; 0000 0103     TCNT1H=0xC1;
	LDI  R30,LOW(193)
	RCALL SUBOPT_0x0
; 0000 0104     TCNT1L=0x80;
; 0000 0105     ICR1H=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 0106     ICR1L=0x00;
	STS  134,R30
; 0000 0107     OCR1AH=0x00;
	STS  137,R30
; 0000 0108     OCR1AL=0x00;
	STS  136,R30
; 0000 0109     OCR1BH=0x00;
	STS  139,R30
; 0000 010A     OCR1BL=0x00;
	STS  138,R30
; 0000 010B 
; 0000 010C     // Timer/Counter 2 initialization
; 0000 010D     // Clock source: System Clock
; 0000 010E     // Clock value: Timer2 Stopped
; 0000 010F     // Mode: Normal top=0xFF
; 0000 0110     // OC2A output: Disconnected
; 0000 0111     // OC2B output: Disconnected
; 0000 0112     ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 0113     TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 0114     TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 0115     TCNT2=0x00;
	STS  178,R30
; 0000 0116     OCR2A=0x00;
	STS  179,R30
; 0000 0117     OCR2B=0x00;
	STS  180,R30
; 0000 0118 
; 0000 0119     // Timer/Counter 0 Interrupt(s) initialization
; 0000 011A     TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 011B 
; 0000 011C     // Timer/Counter 1 Interrupt(s) initialization
; 0000 011D     TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);
	LDI  R30,LOW(1)
	STS  111,R30
; 0000 011E 
; 0000 011F     // Timer/Counter 2 Interrupt(s) initialization
; 0000 0120     TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	LDI  R30,LOW(0)
	STS  112,R30
; 0000 0121 
; 0000 0122     // External Interrupt(s) initialization
; 0000 0123     // INT0: Off
; 0000 0124     // INT1: Off
; 0000 0125     // Interrupt on any change on pins PCINT0-7: Off
; 0000 0126     // Interrupt on any change on pins PCINT8-14: Off
; 0000 0127     // Interrupt on any change on pins PCINT16-23: Off
; 0000 0128     EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 0129     EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 012A     PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 012B 
; 0000 012C     // USART initialization
; 0000 012D     // USART disabled
; 0000 012E     UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 012F 
; 0000 0130     // Analog Comparator initialization
; 0000 0131     // Analog Comparator: Off
; 0000 0132     // The Analog Comparator's positive input is
; 0000 0133     // connected to the AIN0 pin
; 0000 0134     // The Analog Comparator's negative input is
; 0000 0135     // connected to the AIN1 pin
; 0000 0136     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0137     ADCSRB=(0<<ACME);
	RCALL SUBOPT_0x1
; 0000 0138     // Digital input buffer on AIN0: On
; 0000 0139     // Digital input buffer on AIN1: On
; 0000 013A     DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 013B 
; 0000 013C 
; 0000 013D     // ADC initialization
; 0000 013E     // ADC Clock frequency: 1000,000 kHz
; 0000 013F     // ADC Voltage Reference: AREF pin
; 0000 0140     // ADC Auto Trigger Source: ADC Stopped
; 0000 0141     // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 0142     // ADC4: On, ADC5: On
; 0000 0143     DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	LDI  R30,LOW(0)
	STS  126,R30
; 0000 0144     ADMUX=ADC_VREF_TYPE;
	STS  124,R30
; 0000 0145     ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	STS  122,R30
; 0000 0146     ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	RCALL SUBOPT_0x1
; 0000 0147 
; 0000 0148 
; 0000 0149     // SPI initialization
; 0000 014A     // SPI disabled
; 0000 014B     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 014C 
; 0000 014D     // TWI initialization
; 0000 014E     // TWI disabled
; 0000 014F     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	LDI  R30,LOW(0)
	STS  188,R30
; 0000 0150 
; 0000 0151     // Global enable interrupts
; 0000 0152     #asm("sei")
	sei
; 0000 0153 
; 0000 0154     while (1)
_0x2E:
; 0000 0155     {
; 0000 0156     // Place your code here
; 0000 0157         //PROTECT();
; 0000 0158     }
	RJMP _0x2E
; 0000 0159 }
_0x31:
	RJMP _0x31
; .FEND
;#include "scan_led.h"
;#include "SPI_SOFTWARE.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif
;
;unsigned int    Uint_data_led1 = 0;
;unsigned int    Uint_data_led2 = 0;
;unsigned int    Uint_data_led3 = 0;
;unsigned int    Uint_data_led4 = 0;
;unsigned char   Uc_Select_led=1;

	.DSEG
;
;unsigned char   BCDLED[11]={0xF9,0x21,0xEA,0x6B,0x33,0x5B,0xDB,0x29,0xFB,0x7B,0};
;
;/* Day du lieu quet led qua duong spi_software
;Co thẻ day tu 1 den 3 byte du lieu.
;Du lieu sau khi day ra day du moi tien hanh xuat du lieu
;num_bytes : so byte duoc day ra
;data_first : du lieu dau tien
;data_second: du lieu thu 2
;data_third ; du lieu thu 3
;*/
;void    SEND_DATA_LED(unsigned char num_bytes,unsigned char  byte_1,unsigned char  byte_2,unsigned char  byte_3)
; 0001 0015 {

	.CSEG
_SEND_DATA_LED:
; .FSTART _SEND_DATA_LED
; 0001 0016     unsigned char   i;
; 0001 0017     unsigned char   data[6];
; 0001 0018     for(i=0;i<6;i++)    data[i] = 0;
	ST   -Y,R26
	SBIW R28,6
	ST   -Y,R17
;	num_bytes -> Y+10
;	byte_1 -> Y+9
;	byte_2 -> Y+8
;	byte_3 -> Y+7
;	i -> R17
;	data -> Y+1
	LDI  R17,LOW(0)
_0x20006:
	CPI  R17,6
	BRSH _0x20007
	RCALL SUBOPT_0x2
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20006
_0x20007:
; 0001 0019 data[0] = byte_1;
	LDD  R30,Y+9
	STD  Y+1,R30
; 0001 001A     data[1] = byte_2;
	LDD  R30,Y+8
	STD  Y+2,R30
; 0001 001B     data[2] = byte_3;
	LDD  R30,Y+7
	STD  Y+3,R30
; 0001 001C 
; 0001 001D     for(i=0;i<(num_bytes - 1);i++)    SPI_SENDBYTE(data[i],0);
	LDI  R17,LOW(0)
_0x20009:
	LDD  R30,Y+10
	LDI  R31,0
	SBIW R30,1
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x2000A
	RCALL SUBOPT_0x2
	LD   R30,X
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _SPI_SENDBYTE
	SUBI R17,-1
	RJMP _0x20009
_0x2000A:
; 0001 001E SPI_SENDBYTE(data[i],1);
	RCALL SUBOPT_0x2
	LD   R30,X
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _SPI_SENDBYTE
; 0001 001F }
	LDD  R17,Y+0
	ADIW R28,11
	RET
; .FEND
;
;
;/*
;Ham quet led
;num_led: Thu tu led
;data: Du lieu hien thi tren led.
;*/
;void    SCAN_LED(void)
; 0001 0028 {
_SCAN_LED:
; .FSTART _SCAN_LED
; 0001 0029     unsigned char   byte1,byte2,byte3;
; 0001 002A     unsigned char    data;
; 0001 002B     unsigned char   bit_left;
; 0001 002C     bit_left = 0x01;
	RCALL __SAVELOCR6
;	byte1 -> R17
;	byte2 -> R16
;	byte3 -> R19
;	data -> R18
;	bit_left -> R21
	LDI  R21,LOW(1)
; 0001 002D     byte1 = 0;
	LDI  R17,LOW(0)
; 0001 002E     byte2 = 0;
	LDI  R16,LOW(0)
; 0001 002F     byte3 = 0;
	LDI  R19,LOW(0)
; 0001 0030 
; 0001 0031     Uint_data_led1 = 1234;
	LDI  R30,LOW(1234)
	LDI  R31,HIGH(1234)
	STS  _Uint_data_led1,R30
	STS  _Uint_data_led1+1,R31
; 0001 0032     Uint_data_led2 = 5678;
	LDI  R30,LOW(5678)
	LDI  R31,HIGH(5678)
	STS  _Uint_data_led2,R30
	STS  _Uint_data_led2+1,R31
; 0001 0033     Uint_data_led3 = 1357;
	LDI  R30,LOW(1357)
	LDI  R31,HIGH(1357)
	STS  _Uint_data_led3,R30
	STS  _Uint_data_led3+1,R31
; 0001 0034     Uint_data_led4 = 2468;
	LDI  R30,LOW(2468)
	LDI  R31,HIGH(2468)
	STS  _Uint_data_led4,R30
	STS  _Uint_data_led4+1,R31
; 0001 0035 
; 0001 0036     Uc_Select_led++;
	LDS  R30,_Uc_Select_led
	SUBI R30,-LOW(1)
	STS  _Uc_Select_led,R30
; 0001 0037     bit_left <<= (Uc_Select_led-1);
	SUBI R30,LOW(1)
	MOV  R26,R21
	RCALL __LSLB12
	MOV  R21,R30
; 0001 0038     if(Uc_Select_led > 8)
	LDS  R26,_Uc_Select_led
	CPI  R26,LOW(0x9)
	BRLO _0x2000B
; 0001 0039     {
; 0001 003A         Uc_Select_led = 1;
	LDI  R30,LOW(1)
	STS  _Uc_Select_led,R30
; 0001 003B         bit_left = 0x01;
	LDI  R21,LOW(1)
; 0001 003C     }
; 0001 003D     /* 7-seg 1*/
; 0001 003E     data = Uint_data_led1/1000;
_0x2000B:
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0001 003F     byte1 = BCDLED[data];
; 0001 0040     // byte1 = 0xFE;
; 0001 0041     if((byte1 & bit_left)) byte3 |= 0x04;
	BREQ _0x2000C
	ORI  R19,LOW(4)
; 0001 0042     data = Uint_data_led1/100%10;
_0x2000C:
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x5
; 0001 0043     byte1 = BCDLED[data];
; 0001 0044     // byte1 = 0x06;
; 0001 0045     if(byte1 & bit_left) byte3 |= 0x08;
	RCALL SUBOPT_0x6
	BREQ _0x2000D
	ORI  R19,LOW(8)
; 0001 0046     data = Uint_data_led1/10%10;
_0x2000D:
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0001 0047     byte1 = BCDLED[data];
; 0001 0048     byte1 |= 0x04;
	RCALL SUBOPT_0x9
; 0001 0049     // byte1 = 0x06;
; 0001 004A     if(byte1 & bit_left) byte3 |= 0x10;
	BREQ _0x2000E
	ORI  R19,LOW(16)
; 0001 004B     data = Uint_data_led1%10;
_0x2000E:
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xA
; 0001 004C     byte1 = BCDLED[data];
; 0001 004D     // byte1 = 0x06;
; 0001 004E     if(byte1 & bit_left) byte2 |= 0x10;
	BREQ _0x2000F
	ORI  R16,LOW(16)
; 0001 004F     /* 7-seg 2 */
; 0001 0050     data = Uint_data_led2/1000;
_0x2000F:
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x4
; 0001 0051     byte1 = BCDLED[data];
; 0001 0052     if(byte1 & bit_left) byte2 |= 0x20;
	BREQ _0x20010
	ORI  R16,LOW(32)
; 0001 0053     data = Uint_data_led2/100%10;
_0x20010:
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x5
; 0001 0054     byte1 = BCDLED[data];
; 0001 0055     byte1 |= 0x04;
	RCALL SUBOPT_0x9
; 0001 0056     if(byte1 & bit_left) byte2 |= 0x08;
	BREQ _0x20011
	ORI  R16,LOW(8)
; 0001 0057     data = Uint_data_led2/10%10;
_0x20011:
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0001 0058     byte1 = BCDLED[data];
; 0001 0059     if(byte1 & bit_left) byte2 |= 0x04;
	RCALL SUBOPT_0x6
	BREQ _0x20012
	ORI  R16,LOW(4)
; 0001 005A     data = Uint_data_led2%10;
_0x20012:
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xA
; 0001 005B     byte1 = BCDLED[data];
; 0001 005C     if(byte1 & bit_left) byte2 |= 0x01;
	BREQ _0x20013
	ORI  R16,LOW(1)
; 0001 005D     /* 7-seg 3 */
; 0001 005E     data = Uint_data_led3/1000;
_0x20013:
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x4
; 0001 005F     byte1 = BCDLED[data];
; 0001 0060     if(byte1 & bit_left) byte3 |= 0x20;
	BREQ _0x20014
	ORI  R19,LOW(32)
; 0001 0061     data = Uint_data_led3/100%10;
_0x20014:
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x5
; 0001 0062     byte1 = BCDLED[data];
; 0001 0063     // byte1 |= 0x80;
; 0001 0064     if(byte1 & bit_left) byte3 |= 0x40;
	RCALL SUBOPT_0x6
	BREQ _0x20015
	ORI  R19,LOW(64)
; 0001 0065     data = Uint_data_led3/10%10;
_0x20015:
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0001 0066     byte1 = BCDLED[data];
; 0001 0067     byte1 |= 0x04;
	RCALL SUBOPT_0x9
; 0001 0068     if(byte1 & bit_left) byte3 |= 0x80;
	BREQ _0x20016
	ORI  R19,LOW(128)
; 0001 0069     data = Uint_data_led3%10;
_0x20016:
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xA
; 0001 006A     byte1 = BCDLED[data];
; 0001 006B     if(byte1 & bit_left) byte3 |= 0x02;
	BREQ _0x20017
	ORI  R19,LOW(2)
; 0001 006C     /* 7-seg 4 */
; 0001 006D     data = Uint_data_led4/1000;
_0x20017:
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x4
; 0001 006E     byte1 = BCDLED[data];
; 0001 006F     if(byte1 & bit_left) byte3 |= 0x01; //2
	BREQ _0x20018
	ORI  R19,LOW(1)
; 0001 0070     data = Uint_data_led4/100%10;
_0x20018:
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x5
; 0001 0071     byte1 = BCDLED[data];
; 0001 0072     byte1 |= 0x04;
	RCALL SUBOPT_0x9
; 0001 0073     if(byte1 & bit_left) byte2 |= 0x40;
	BREQ _0x20019
	ORI  R16,LOW(64)
; 0001 0074     data = Uint_data_led4/10%10;
_0x20019:
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0001 0075     byte1 = BCDLED[data];
; 0001 0076     // byte1 |= 0x80;
; 0001 0077     if(byte1 & bit_left) byte2 |= 0x80; //7
	RCALL SUBOPT_0x6
	BREQ _0x2001A
	ORI  R16,LOW(128)
; 0001 0078     data = Uint_data_led4%10;
_0x2001A:
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xA
; 0001 0079     byte1 = BCDLED[data];
; 0001 007A     if(byte1 & bit_left) byte2 |= 0x02;
	BREQ _0x2001B
	ORI  R16,LOW(2)
; 0001 007B     bit_left = 0xff- bit_left;
_0x2001B:
	LDI  R30,LOW(255)
	SUB  R30,R21
	MOV  R21,R30
; 0001 007C     SEND_DATA_LED(3,byte3,byte2,bit_left);
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R16
	MOV  R26,R21
	RCALL _SEND_DATA_LED
; 0001 007D }
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;
;#include "SPI_SOFTWARE.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif
;
;
;void    SPI_SENDBYTE(unsigned char  data,unsigned char action)
; 0002 0005 {

	.CSEG
_SPI_SENDBYTE:
; .FSTART _SPI_SENDBYTE
; 0002 0006     unsigned char   i;
; 0002 0007     for(i=0;i<8;i++)
	ST   -Y,R26
	ST   -Y,R17
;	data -> Y+2
;	action -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x40004:
	CPI  R17,8
	BRSH _0x40005
; 0002 0008     {
; 0002 0009         if((data & 0x80) == 0x80)    DO_SPI_MOSI_HIGHT;
	LDD  R30,Y+2
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x40006
	SBI  0x5,3
; 0002 000A         else    DO_SPI_MOSI_LOW;
	RJMP _0x40009
_0x40006:
	CBI  0x5,3
; 0002 000B         data <<= 1;
_0x40009:
	LDD  R30,Y+2
	LSL  R30
	STD  Y+2,R30
; 0002 000C         DO_SPI_SCK_HIGHT;
	SBI  0x5,5
; 0002 000D         DO_SPI_SCK_LOW;
	CBI  0x5,5
; 0002 000E     }
	SUBI R17,-1
	RJMP _0x40004
_0x40005:
; 0002 000F     if(action)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x40010
; 0002 0010     {
; 0002 0011         DO_SPI_LATCH_HIGHT;
	SBI  0xB,2
; 0002 0012         DO_SPI_LATCH_LOW;
	CBI  0xB,2
; 0002 0013     }
; 0002 0014 }
_0x40010:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND

	.DSEG
_Uint_data_led1:
	.BYTE 0x2
_Uint_data_led2:
	.BYTE 0x2
_Uint_data_led3:
	.BYTE 0x2
_Uint_data_led4:
	.BYTE 0x2
_Uc_Select_led:
	.BYTE 0x1
_BCDLED:
	.BYTE 0xB

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	STS  133,R30
	LDI  R30,LOW(128)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	STS  123,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDS  R26,_Uint_data_led1
	LDS  R27,_Uint_data_led1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	MOV  R18,R30
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
	MOV  R30,R21
	AND  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	MOV  R18,R30
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	MOV  R30,R21
	AND  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x8:
	RCALL __DIVW21U
	MOVW R26,R30
	RCALL SUBOPT_0x7
	RCALL __MODW21U
	MOV  R18,R30
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	ORI  R17,LOW(4)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xA:
	RCALL SUBOPT_0x7
	RCALL __MODW21U
	MOV  R18,R30
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	LDS  R26,_Uint_data_led2
	LDS  R27,_Uint_data_led2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDS  R26,_Uint_data_led3
	LDS  R27,_Uint_data_led3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDS  R26,_Uint_data_led4
	LDS  R27,_Uint_data_led4+1
	RET


	.CSEG
__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
