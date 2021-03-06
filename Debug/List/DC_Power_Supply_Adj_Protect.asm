
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
	.DEF _Uc_Buffer_count=R13
	.DEF _Uc_Select_led=R12

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
	.DB  0x1,0x0

_0x20003:
	.DB  0xF9,0x21,0xEA,0x6B,0x33,0x5B,0xDB,0x29
	.DB  0xFB,0x7B,0x2

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0B
	.DW  _BCDLED
	.DW  _0x20003*2

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
;Uint_data_led1 = Dien ap am*10
;Uint_data_led2 = Cuong do dong dien am*10
;Uint_data_led3 = Dien ap duong*10
;Uint_data_led4 = Cuong do dong dien duong*10
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
;#define ADC_I_POSITIVE  2
;#define ADC_U_POSITIVE  1
;#define ADC_I_NEGATIVE  0
;#define ADC_U_NEGATIVE  3
;
;#define CONTROL_RELAY   PORTC.4
;
;#define PROTECT_ON   CONTROL_RELAY  = 1
;#define PROTECT_OFF   CONTROL_RELAY  = 0
;
;#define ADC_I_POSITIVE_SET  550
;#define ADC_U_POSITIVE_SET  300
;#define ADC_I_NEGATIVE_SET  550
;#define ADC_U_NEGATIVE_SET  300
;
;#define ADC_I_POSITIVE_RATIO  2.996655646//3.105845528//3.056152
;#define ADC_U_POSITIVE_RATIO  370
;#define ADC_I_NEGATIVE_RATIO  3.16656554//3.076741
;#define ADC_U_NEGATIVE_RATIO  370
;
;#define TIME_UPDATE_DISPLAY 150
;
;#define ADC_I_POSITIVE_ZERO 888//880
;#define ADC_I_NEGATIVE_ZERO 883//878
;
;#define CALIB   0
;
;#define NUM_SAMPLE  30
;#define NUM_FILTER  10
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
;unsigned int   Uint_U_Positive_Buff[NUM_SAMPLE];
;unsigned int   Uint_U_Negative_Buff[NUM_SAMPLE];
;unsigned int   Uint_I_Positive_Buff[NUM_SAMPLE];
;unsigned int   Uint_I_Negative_Buff[NUM_SAMPLE];
;
;unsigned char   Uc_Buffer_count = 0;
;
;unsigned int   Uint_Turnoff_relay_timer;
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
; 0000 005B {

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
; 0000 005C     // Reinitialize Timer1 value
; 0000 005D     TCNT1H=0x9380 >> 8;
	LDI  R30,LOW(147)
	RCALL SUBOPT_0x0
; 0000 005E     TCNT1L=0x9380 & 0xff;
; 0000 005F     if(Uint_Timer_Display < TIME_UPDATE_DISPLAY)    Uint_Timer_Display++;
	RCALL SUBOPT_0x1
	BRSH _0x3
	LDI  R26,LOW(_Uint_Timer_Display)
	LDI  R27,HIGH(_Uint_Timer_Display)
	RCALL SUBOPT_0x2
; 0000 0060     // Place your code here
; 0000 0061     SCAN_LED();
_0x3:
	RCALL _SCAN_LED
; 0000 0062     if(Uint_Turnoff_relay_timer < 500)    Uint_Turnoff_relay_timer++;
	RCALL SUBOPT_0x3
	BRSH _0x4
	LDI  R26,LOW(_Uint_Turnoff_relay_timer)
	LDI  R27,HIGH(_Uint_Turnoff_relay_timer)
	RCALL SUBOPT_0x2
; 0000 0063 }
_0x4:
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
; 0000 006A {
_read_adc:
; .FSTART _read_adc
; 0000 006B     ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	STS  124,R30
; 0000 006C     // Delay needed for the stabilization of the ADC input voltage
; 0000 006D     delay_us(10);
	__DELAY_USB 27
; 0000 006E     // Start the AD conversion
; 0000 006F     ADCSRA|=(1<<ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 0070     // Wait for the AD conversion to complete
; 0000 0071     while ((ADCSRA & (1<<ADIF))==0);
_0x5:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ _0x5
; 0000 0072     ADCSRA|=(1<<ADIF);
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 0073     return ADCW;
	LDS  R30,120
	LDS  R31,120+1
	ADIW R28,1
	RET
; 0000 0074 }
; .FEND
;
;void    PROTECT(void)
; 0000 0077 {
_PROTECT:
; .FSTART _PROTECT
; 0000 0078     unsigned int    Uint_ADC_Value;
; 0000 0079     unsigned char   Uc_Loop_count,Uc_Loop2_count;
; 0000 007A     unsigned long int Ul_Sum;
; 0000 007B     unsigned int    Uint_Buff_Temp[NUM_SAMPLE];
; 0000 007C     unsigned int    Uint_temp;
; 0000 007D 
; 0000 007E     /* I Negative */
; 0000 007F     Uint_ADC_Value = (unsigned int) read_adc(ADC_I_NEGATIVE);
	SBIW R28,63
	SBIW R28,1
	RCALL __SAVELOCR6
;	Uint_ADC_Value -> R16,R17
;	Uc_Loop_count -> R19
;	Uc_Loop2_count -> R18
;	Ul_Sum -> Y+66
;	Uint_Buff_Temp -> Y+6
;	Uint_temp -> R20,R21
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R16,R30
; 0000 0080     Uint_I_Negative_Buff[Uc_Buffer_count] = Uint_ADC_Value;
	MOV  R30,R13
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	ST   Z,R16
	STD  Z+1,R17
; 0000 0081 
; 0000 0082     if(Uint_Timer_Display >= TIME_UPDATE_DISPLAY)
	RCALL SUBOPT_0x1
	BRSH PC+2
	RJMP _0x8
; 0000 0083     {
; 0000 0084         /* Chuyen sang bo nho dem */
; 0000 0085         for(Uc_Loop_count = 0; Uc_Loop_count < NUM_SAMPLE; Uc_Loop_count++)
	LDI  R19,LOW(0)
_0xA:
	CPI  R19,30
	BRSH _0xB
; 0000 0086         {
; 0000 0087             Uint_Buff_Temp[Uc_Loop_count] = Uint_I_Negative_Buff[Uc_Loop_count];
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	MOV  R30,R19
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 0088         }
	SUBI R19,-1
	RJMP _0xA
_0xB:
; 0000 0089         /* Sap xep bo nho dem tu min -> max */
; 0000 008A         for(Uc_Loop_count = 0; Uc_Loop_count < NUM_SAMPLE; Uc_Loop_count++)
	LDI  R19,LOW(0)
_0xD:
	CPI  R19,30
	BRSH _0xE
; 0000 008B         {
; 0000 008C             for(Uc_Loop2_count = Uc_Loop_count; Uc_Loop2_count < NUM_SAMPLE; Uc_Loop2_count++)
	MOV  R18,R19
_0x10:
	CPI  R18,30
	BRSH _0x11
; 0000 008D             {
; 0000 008E                 if(Uint_Buff_Temp[Uc_Loop_count] > Uint_Buff_Temp[Uc_Loop2_count])
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xA
	BRSH _0x12
; 0000 008F                 {
; 0000 0090                     Uint_temp = Uint_Buff_Temp[Uc_Loop_count];
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xB
; 0000 0091                     Uint_Buff_Temp[Uc_Loop_count] = Uint_Buff_Temp[Uc_Loop2_count];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 0092                     Uint_Buff_Temp[Uc_Loop2_count] = Uint_temp;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xE
; 0000 0093                 }
; 0000 0094             }
_0x12:
	SUBI R18,-1
	RJMP _0x10
_0x11:
; 0000 0095         }
	SUBI R19,-1
	RJMP _0xD
_0xE:
; 0000 0096         /* Low filter & hight filter */
; 0000 0097         Ul_Sum = 0;
	RCALL SUBOPT_0xF
; 0000 0098         for(Uc_Loop_count = NUM_FILTER; Uc_Loop_count < (NUM_SAMPLE-NUM_FILTER); Uc_Loop_count++)
_0x14:
	CPI  R19,20
	BRSH _0x15
; 0000 0099         {
; 0000 009A             Ul_Sum += Uint_Buff_Temp[Uc_Loop_count];
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x10
; 0000 009B         }
	SUBI R19,-1
	RJMP _0x14
_0x15:
; 0000 009C         Uint_temp = (unsigned int)((float)Ul_Sum/(NUM_SAMPLE-2*NUM_FILTER));
	RCALL SUBOPT_0x11
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41200000
	RCALL __DIVF21
	RCALL __CFD1U
	MOVW R20,R30
; 0000 009D         #if CALIB
; 0000 009E         Uint_data_led4 = Uint_temp;
; 0000 009F         #else
; 0000 00A0         if(Uint_temp < ADC_I_NEGATIVE_ZERO) Uint_temp = ADC_I_NEGATIVE_ZERO - Uint_temp;
	__CPWRN 20,21,883
	BRSH _0x16
	LDI  R30,LOW(883)
	LDI  R31,HIGH(883)
	SUB  R30,R20
	SBC  R31,R21
	MOVW R20,R30
; 0000 00A1         else    Uint_temp = 0;
	RJMP _0x17
_0x16:
	__GETWRN 20,21,0
; 0000 00A2         Uint_data_led4 = Uint_temp*ADC_I_NEGATIVE_RATIO;
_0x17:
	MOVW R30,R20
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x404AA903
	RCALL __MULF12
	LDI  R26,LOW(_Uint_data_led4)
	LDI  R27,HIGH(_Uint_data_led4)
	RCALL __CFD1U
	ST   X+,R30
	ST   X,R31
; 0000 00A3         #endif
; 0000 00A4     }
; 0000 00A5     if(Uint_data_led4 > ADC_I_NEGATIVE_SET)
_0x8:
	RCALL SUBOPT_0x12
	CPI  R26,LOW(0x227)
	LDI  R30,HIGH(0x227)
	CPC  R27,R30
	BRLO _0x18
; 0000 00A6     {
; 0000 00A7         Uc_I_Negative_Over++;
	INC  R7
; 0000 00A8         if(Uc_I_Negative_Over > 10)
	LDI  R30,LOW(10)
	CP   R30,R7
	BRSH _0x19
; 0000 00A9         {
; 0000 00AA             Uc_I_Negative_Over = 11;
	LDI  R30,LOW(11)
	MOV  R7,R30
; 0000 00AB             Uc_I_Negative_Under = 0;
	CLR  R11
; 0000 00AC             Bit_I_Negative_Warning = 1;
	SBI  0x1E,6
; 0000 00AD             Bit_led_4_warning = 1;
	SBI  0x1E,3
; 0000 00AE         }
; 0000 00AF     }
_0x19:
; 0000 00B0     else
	RJMP _0x1E
_0x18:
; 0000 00B1     {
; 0000 00B2         Uc_I_Negative_Under++;
	INC  R11
; 0000 00B3         if(Uc_I_Negative_Under > 10)
	LDI  R30,LOW(10)
	CP   R30,R11
	BRSH _0x1F
; 0000 00B4         {
; 0000 00B5             Uc_I_Negative_Under = 11;
	LDI  R30,LOW(11)
	MOV  R11,R30
; 0000 00B6             Uc_I_Negative_Over = 0;
	CLR  R7
; 0000 00B7             Bit_I_Negative_Warning = 0;
	CBI  0x1E,6
; 0000 00B8             Bit_led_4_warning = 0;
	CBI  0x1E,3
; 0000 00B9         }
; 0000 00BA     }
_0x1F:
_0x1E:
; 0000 00BB 
; 0000 00BC     /* I Positive */
; 0000 00BD     Uint_ADC_Value = read_adc(ADC_I_POSITIVE);
	LDI  R26,LOW(2)
	RCALL _read_adc
	MOVW R16,R30
; 0000 00BE     #if !CALIB
; 0000 00BF     if(Uint_ADC_Value <= ADC_I_POSITIVE_ZERO)   Uint_ADC_Value = ADC_I_POSITIVE_ZERO - Uint_ADC_Value;
	__CPWRN 16,17,889
	BRSH _0x24
	LDI  R30,LOW(888)
	LDI  R31,HIGH(888)
	SUB  R30,R16
	SBC  R31,R17
	MOVW R16,R30
; 0000 00C0     else    Uint_ADC_Value = 0;
	RJMP _0x25
_0x24:
	__GETWRN 16,17,0
; 0000 00C1     #endif
; 0000 00C2     Uint_I_Positive_Buff[Uc_Buffer_count] = Uint_ADC_Value;
_0x25:
	MOV  R30,R13
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x5
	ST   Z,R16
	STD  Z+1,R17
; 0000 00C3     if(Uint_Timer_Display >= TIME_UPDATE_DISPLAY)
	RCALL SUBOPT_0x1
	BRSH PC+2
	RJMP _0x26
; 0000 00C4     {
; 0000 00C5         /* Chuyen sang bo nho dem */
; 0000 00C6         for(Uc_Loop_count = 0; Uc_Loop_count < NUM_SAMPLE; Uc_Loop_count++)
	LDI  R19,LOW(0)
_0x28:
	CPI  R19,30
	BRSH _0x29
; 0000 00C7         {
; 0000 00C8             Uint_Buff_Temp[Uc_Loop_count] = Uint_I_Positive_Buff[Uc_Loop_count];
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	MOV  R30,R19
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0xD
; 0000 00C9         }
	SUBI R19,-1
	RJMP _0x28
_0x29:
; 0000 00CA         /* Sap xep bo nho dem tu min -> max */
; 0000 00CB         for(Uc_Loop_count = 0; Uc_Loop_count < NUM_SAMPLE; Uc_Loop_count++)
	LDI  R19,LOW(0)
_0x2B:
	CPI  R19,30
	BRSH _0x2C
; 0000 00CC         {
; 0000 00CD             for(Uc_Loop2_count = Uc_Loop_count; Uc_Loop2_count < NUM_SAMPLE; Uc_Loop2_count++)
	MOV  R18,R19
_0x2E:
	CPI  R18,30
	BRSH _0x2F
; 0000 00CE             {
; 0000 00CF                 if(Uint_Buff_Temp[Uc_Loop_count] > Uint_Buff_Temp[Uc_Loop2_count])
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xA
	BRSH _0x30
; 0000 00D0                 {
; 0000 00D1                     Uint_temp = Uint_Buff_Temp[Uc_Loop_count];
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xB
; 0000 00D2                     Uint_Buff_Temp[Uc_Loop_count] = Uint_Buff_Temp[Uc_Loop2_count];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 00D3                     Uint_Buff_Temp[Uc_Loop2_count] = Uint_temp;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xE
; 0000 00D4                 }
; 0000 00D5             }
_0x30:
	SUBI R18,-1
	RJMP _0x2E
_0x2F:
; 0000 00D6         }
	SUBI R19,-1
	RJMP _0x2B
_0x2C:
; 0000 00D7         /* Low filter & hight filter */
; 0000 00D8         Ul_Sum = 0;
	RCALL SUBOPT_0xF
; 0000 00D9         for(Uc_Loop_count = NUM_FILTER; Uc_Loop_count < (NUM_SAMPLE-NUM_FILTER); Uc_Loop_count++)
_0x32:
	CPI  R19,20
	BRSH _0x33
; 0000 00DA         {
; 0000 00DB             Ul_Sum += Uint_Buff_Temp[Uc_Loop_count];
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x10
; 0000 00DC         }
	SUBI R19,-1
	RJMP _0x32
_0x33:
; 0000 00DD         #if !CALIB
; 0000 00DE         Ul_Sum = Ul_Sum/(NUM_SAMPLE-2*NUM_FILTER);
	__GETD2SX 66
	__GETD1N 0xA
	RCALL __DIVD21U
	__PUTD1SX 66
; 0000 00DF         // Uint_data_led4 = Ul_Sum;
; 0000 00E0         Uint_data_led2 = (unsigned int)((float)Ul_Sum*ADC_I_POSITIVE_RATIO);
	RCALL SUBOPT_0x11
	__GETD2N 0x403FC935
	RCALL __MULF12
	RCALL __CFD1U
	STS  _Uint_data_led2,R30
	STS  _Uint_data_led2+1,R31
; 0000 00E1         #else
; 0000 00E2         Uint_data_led2 = (unsigned int)((float)Ul_Sum/(NUM_SAMPLE-2*NUM_FILTER));
; 0000 00E3         #endif
; 0000 00E4     }
; 0000 00E5     if(Uint_data_led2 > ADC_I_POSITIVE_SET)
_0x26:
	RCALL SUBOPT_0x14
	CPI  R26,LOW(0x227)
	LDI  R30,HIGH(0x227)
	CPC  R27,R30
	BRLO _0x34
; 0000 00E6     {
; 0000 00E7         Uc_I_Positive_Over++;
	INC  R5
; 0000 00E8         if(Uc_I_Positive_Over > 10)
	LDI  R30,LOW(10)
	CP   R30,R5
	BRSH _0x35
; 0000 00E9         {
; 0000 00EA             Uc_I_Positive_Over = 11;
	LDI  R30,LOW(11)
	MOV  R5,R30
; 0000 00EB             Uc_I_Positive_Under = 0;
	CLR  R9
; 0000 00EC             Bit_I_Positive_Warning = 1;
	SBI  0x1E,4
; 0000 00ED             Bit_led_2_warning = 1;
	SBI  0x1E,1
; 0000 00EE         }
; 0000 00EF     }
_0x35:
; 0000 00F0     else
	RJMP _0x3A
_0x34:
; 0000 00F1     {
; 0000 00F2         Uc_I_Positive_Under++;
	INC  R9
; 0000 00F3         if(Uc_I_Positive_Under > 10)
	LDI  R30,LOW(10)
	CP   R30,R9
	BRSH _0x3B
; 0000 00F4         {
; 0000 00F5             Uc_I_Positive_Under = 11;
	LDI  R30,LOW(11)
	MOV  R9,R30
; 0000 00F6             Uc_I_Positive_Over = 0;
	CLR  R5
; 0000 00F7             Bit_I_Positive_Warning = 0;
	CBI  0x1E,4
; 0000 00F8             Bit_led_2_warning = 0;
	CBI  0x1E,1
; 0000 00F9         }
; 0000 00FA     }
_0x3B:
_0x3A:
; 0000 00FB     /* U Negative */
; 0000 00FC     Uint_U_Negative_Buff[Uc_Buffer_count] = read_adc(ADC_U_NEGATIVE);
	MOV  R30,R13
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	LDI  R26,LOW(3)
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 00FD     if(Uint_Timer_Display >= TIME_UPDATE_DISPLAY)
	RCALL SUBOPT_0x1
	BRLO _0x40
; 0000 00FE     {
; 0000 00FF         /* Chuyen sang bo nho dem */
; 0000 0100         for(Uc_Loop_count = 0; Uc_Loop_count < NUM_SAMPLE; Uc_Loop_count++)
	LDI  R19,LOW(0)
_0x42:
	CPI  R19,30
	BRSH _0x43
; 0000 0101         {
; 0000 0102             Uint_Buff_Temp[Uc_Loop_count] = Uint_U_Negative_Buff[Uc_Loop_count];
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	MOV  R30,R19
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xD
; 0000 0103         }
	SUBI R19,-1
	RJMP _0x42
_0x43:
; 0000 0104         /* Sap xep bo nho dem tu min -> max */
; 0000 0105         for(Uc_Loop_count = 0; Uc_Loop_count < NUM_SAMPLE; Uc_Loop_count++)
	LDI  R19,LOW(0)
_0x45:
	CPI  R19,30
	BRSH _0x46
; 0000 0106         {
; 0000 0107             for(Uc_Loop2_count = Uc_Loop_count; Uc_Loop2_count < NUM_SAMPLE; Uc_Loop2_count++)
	MOV  R18,R19
_0x48:
	CPI  R18,30
	BRSH _0x49
; 0000 0108             {
; 0000 0109                 if(Uint_Buff_Temp[Uc_Loop_count] > Uint_Buff_Temp[Uc_Loop2_count])
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xA
	BRSH _0x4A
; 0000 010A                 {
; 0000 010B                     Uint_temp = Uint_Buff_Temp[Uc_Loop_count];
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xB
; 0000 010C                     Uint_Buff_Temp[Uc_Loop_count] = Uint_Buff_Temp[Uc_Loop2_count];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 010D                     Uint_Buff_Temp[Uc_Loop2_count] = Uint_temp;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xE
; 0000 010E                 }
; 0000 010F             }
_0x4A:
	SUBI R18,-1
	RJMP _0x48
_0x49:
; 0000 0110         }
	SUBI R19,-1
	RJMP _0x45
_0x46:
; 0000 0111         /* Low filter & hight filter */
; 0000 0112         Ul_Sum = 0;
	RCALL SUBOPT_0xF
; 0000 0113         for(Uc_Loop_count = NUM_FILTER; Uc_Loop_count < (NUM_SAMPLE-NUM_FILTER); Uc_Loop_count++)
_0x4C:
	CPI  R19,20
	BRSH _0x4D
; 0000 0114         {
; 0000 0115             Ul_Sum += Uint_Buff_Temp[Uc_Loop_count];
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x10
; 0000 0116         }
	SUBI R19,-1
	RJMP _0x4C
_0x4D:
; 0000 0117         Uint_data_led3 = (unsigned int)((float)Ul_Sum*ADC_U_NEGATIVE_RATIO/(1024*(NUM_SAMPLE-2*NUM_FILTER)));
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x16
	STS  _Uint_data_led3,R30
	STS  _Uint_data_led3+1,R31
; 0000 0118     }
; 0000 0119     /* U Positive */
; 0000 011A     Uint_U_Positive_Buff[Uc_Buffer_count] = read_adc(ADC_U_POSITIVE);
_0x40:
	MOV  R30,R13
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	LDI  R26,LOW(1)
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 011B     if(Uint_Timer_Display >= TIME_UPDATE_DISPLAY)
	RCALL SUBOPT_0x1
	BRLO _0x4E
; 0000 011C     {
; 0000 011D         /* Chuyen sang bo nho dem */
; 0000 011E         for(Uc_Loop_count = 0; Uc_Loop_count < NUM_SAMPLE; Uc_Loop_count++)
	LDI  R19,LOW(0)
_0x50:
	CPI  R19,30
	BRSH _0x51
; 0000 011F         {
; 0000 0120             Uint_Buff_Temp[Uc_Loop_count] = Uint_U_Positive_Buff[Uc_Loop_count];
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	MOV  R30,R19
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0xD
; 0000 0121         }
	SUBI R19,-1
	RJMP _0x50
_0x51:
; 0000 0122         /* Sap xep bo nho dem tu min -> max */
; 0000 0123         for(Uc_Loop_count = 0; Uc_Loop_count < NUM_SAMPLE; Uc_Loop_count++)
	LDI  R19,LOW(0)
_0x53:
	CPI  R19,30
	BRSH _0x54
; 0000 0124         {
; 0000 0125             for(Uc_Loop2_count = Uc_Loop_count; Uc_Loop2_count < NUM_SAMPLE; Uc_Loop2_count++)
	MOV  R18,R19
_0x56:
	CPI  R18,30
	BRSH _0x57
; 0000 0126             {
; 0000 0127                 if(Uint_Buff_Temp[Uc_Loop_count] > Uint_Buff_Temp[Uc_Loop2_count])
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xA
	BRSH _0x58
; 0000 0128                 {
; 0000 0129                     Uint_temp = Uint_Buff_Temp[Uc_Loop_count];
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xB
; 0000 012A                     Uint_Buff_Temp[Uc_Loop_count] = Uint_Buff_Temp[Uc_Loop2_count];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 012B                     Uint_Buff_Temp[Uc_Loop2_count] = Uint_temp;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xE
; 0000 012C                 }
; 0000 012D             }
_0x58:
	SUBI R18,-1
	RJMP _0x56
_0x57:
; 0000 012E         }
	SUBI R19,-1
	RJMP _0x53
_0x54:
; 0000 012F         /* Low filter & hight filter */
; 0000 0130         Ul_Sum = 0;
	RCALL SUBOPT_0xF
; 0000 0131         for(Uc_Loop_count = NUM_FILTER; Uc_Loop_count < (NUM_SAMPLE-NUM_FILTER); Uc_Loop_count++)
_0x5A:
	CPI  R19,20
	BRSH _0x5B
; 0000 0132         {
; 0000 0133             Ul_Sum += Uint_Buff_Temp[Uc_Loop_count];
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x10
; 0000 0134         }
	SUBI R19,-1
	RJMP _0x5A
_0x5B:
; 0000 0135         Uint_data_led1 = (unsigned int)((float)Ul_Sum*ADC_U_POSITIVE_RATIO/(1024*(NUM_SAMPLE-2*NUM_FILTER)));
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x16
	STS  _Uint_data_led1,R30
	STS  _Uint_data_led1+1,R31
; 0000 0136         Uint_Timer_Display = 0;
	LDI  R30,LOW(0)
	STS  _Uint_Timer_Display,R30
	STS  _Uint_Timer_Display+1,R30
; 0000 0137     }
; 0000 0138     Uc_Buffer_count++;
_0x4E:
	INC  R13
; 0000 0139     if(Uc_Buffer_count >= NUM_SAMPLE)    Uc_Buffer_count = 0;
	LDI  R30,LOW(30)
	CP   R13,R30
	BRLO _0x5C
	CLR  R13
; 0000 013A 
; 0000 013B     if(Bit_I_Negative_Warning || Bit_I_Positive_Warning || Bit_U_Positive_Warning || Bit_U_Negative_Warning)
_0x5C:
	SBIC 0x1E,6
	RJMP _0x5E
	SBIC 0x1E,4
	RJMP _0x5E
	SBIC 0x1E,5
	RJMP _0x5E
	SBIS 0x1E,7
	RJMP _0x5D
_0x5E:
; 0000 013C     {
; 0000 013D         PROTECT_ON;
	SBI  0x8,4
; 0000 013E         Uint_Turnoff_relay_timer = 0;
	LDI  R30,LOW(0)
	STS  _Uint_Turnoff_relay_timer,R30
	STS  _Uint_Turnoff_relay_timer+1,R30
; 0000 013F     }
; 0000 0140     else if(Uint_Turnoff_relay_timer >= 500)
	RJMP _0x62
_0x5D:
	RCALL SUBOPT_0x3
	BRLO _0x63
; 0000 0141     {
; 0000 0142         PROTECT_OFF;
	CBI  0x8,4
; 0000 0143     }
; 0000 0144     delay_ms(10);
_0x63:
_0x62:
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0145 }
	RCALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,7
	RET
; .FEND
;
;void main(void)
; 0000 0148 {
_main:
; .FSTART _main
; 0000 0149     // Declare your local variables here
; 0000 014A 
; 0000 014B     // Crystal Oscillator division factor: 1
; 0000 014C     #pragma optsize-
; 0000 014D     CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 014E     CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 014F     #ifdef _OPTIMIZE_SIZE_
; 0000 0150     #pragma optsize+
; 0000 0151     #endif
; 0000 0152     // Input/Output Ports initialization
; 0000 0153     // Port B initialization
; 0000 0154     // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 0155     DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(40)
	OUT  0x4,R30
; 0000 0156     // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 0157     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 0158 
; 0000 0159     // Port C initialization
; 0000 015A     // Function: Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 015B     DDRC=(0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(16)
	OUT  0x7,R30
; 0000 015C     // State: Bit6=T Bit5=T Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 015D     PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 015E 
; 0000 015F     // Port D initialization
; 0000 0160     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=In Bit0=In
; 0000 0161     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (1<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(4)
	OUT  0xA,R30
; 0000 0162     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=T Bit0=T
; 0000 0163     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0164 
; 0000 0165     // Timer/Counter 0 initialization
; 0000 0166     // Clock source: System Clock
; 0000 0167     // Clock value: Timer 0 Stopped
; 0000 0168     // Mode: Normal top=0xFF
; 0000 0169     // OC0A output: Disconnected
; 0000 016A     // OC0B output: Disconnected
; 0000 016B     TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 016C     TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x25,R30
; 0000 016D     TCNT0=0x00;
	OUT  0x26,R30
; 0000 016E     OCR0A=0x00;
	OUT  0x27,R30
; 0000 016F     OCR0B=0x00;
	OUT  0x28,R30
; 0000 0170 
; 0000 0171     // Timer/Counter 1 initialization
; 0000 0172     // Clock source: System Clock
; 0000 0173     // Clock value: 8000,000 kHz
; 0000 0174     // Mode: Normal top=0xFFFF
; 0000 0175     // OC1A output: Disconnected
; 0000 0176     // OC1B output: Disconnected
; 0000 0177     // Noise Canceler: Off
; 0000 0178     // Input Capture on Falling Edge
; 0000 0179     // Timer Period: 2 ms
; 0000 017A     // Timer1 Overflow Interrupt: On
; 0000 017B     // Input Capture Interrupt: Off
; 0000 017C     // Compare A Match Interrupt: Off
; 0000 017D     // Compare B Match Interrupt: Off
; 0000 017E     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 017F     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	STS  129,R30
; 0000 0180     TCNT1H=0xC1;
	LDI  R30,LOW(193)
	RCALL SUBOPT_0x0
; 0000 0181     TCNT1L=0x80;
; 0000 0182     ICR1H=0x00;
	LDI  R30,LOW(0)
	STS  135,R30
; 0000 0183     ICR1L=0x00;
	STS  134,R30
; 0000 0184     OCR1AH=0x00;
	STS  137,R30
; 0000 0185     OCR1AL=0x00;
	STS  136,R30
; 0000 0186     OCR1BH=0x00;
	STS  139,R30
; 0000 0187     OCR1BL=0x00;
	STS  138,R30
; 0000 0188 
; 0000 0189     // Timer/Counter 2 initialization
; 0000 018A     // Clock source: System Clock
; 0000 018B     // Clock value: Timer2 Stopped
; 0000 018C     // Mode: Normal top=0xFF
; 0000 018D     // OC2A output: Disconnected
; 0000 018E     // OC2B output: Disconnected
; 0000 018F     ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 0190     TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 0191     TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 0192     TCNT2=0x00;
	STS  178,R30
; 0000 0193     OCR2A=0x00;
	STS  179,R30
; 0000 0194     OCR2B=0x00;
	STS  180,R30
; 0000 0195 
; 0000 0196     // Timer/Counter 0 Interrupt(s) initialization
; 0000 0197     TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);
	STS  110,R30
; 0000 0198 
; 0000 0199     // Timer/Counter 1 Interrupt(s) initialization
; 0000 019A     TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);
	LDI  R30,LOW(1)
	STS  111,R30
; 0000 019B 
; 0000 019C     // Timer/Counter 2 Interrupt(s) initialization
; 0000 019D     TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	LDI  R30,LOW(0)
	STS  112,R30
; 0000 019E 
; 0000 019F     // External Interrupt(s) initialization
; 0000 01A0     // INT0: Off
; 0000 01A1     // INT1: Off
; 0000 01A2     // Interrupt on any change on pins PCINT0-7: Off
; 0000 01A3     // Interrupt on any change on pins PCINT8-14: Off
; 0000 01A4     // Interrupt on any change on pins PCINT16-23: Off
; 0000 01A5     EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 01A6     EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 01A7     PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 01A8 
; 0000 01A9     // USART initialization
; 0000 01AA     // USART disabled
; 0000 01AB     UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 01AC 
; 0000 01AD     // Analog Comparator initialization
; 0000 01AE     // Analog Comparator: Off
; 0000 01AF     // The Analog Comparator's positive input is
; 0000 01B0     // connected to the AIN0 pin
; 0000 01B1     // The Analog Comparator's negative input is
; 0000 01B2     // connected to the AIN1 pin
; 0000 01B3     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 01B4     ADCSRB=(0<<ACME);
	RCALL SUBOPT_0x18
; 0000 01B5     // Digital input buffer on AIN0: On
; 0000 01B6     // Digital input buffer on AIN1: On
; 0000 01B7     DIDR1=(0<<AIN0D) | (0<<AIN1D);
	STS  127,R30
; 0000 01B8 
; 0000 01B9 
; 0000 01BA     // ADC initialization
; 0000 01BB     // ADC Clock frequency: 1000,000 kHz
; 0000 01BC     // ADC Voltage Reference: AREF pin
; 0000 01BD     // ADC Auto Trigger Source: ADC Stopped
; 0000 01BE     // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 01BF     // ADC4: On, ADC5: On
; 0000 01C0     DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	LDI  R30,LOW(0)
	STS  126,R30
; 0000 01C1     ADMUX=ADC_VREF_TYPE;
	STS  124,R30
; 0000 01C2     ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	STS  122,R30
; 0000 01C3     ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	RCALL SUBOPT_0x18
; 0000 01C4 
; 0000 01C5 
; 0000 01C6     // SPI initialization
; 0000 01C7     // SPI disabled
; 0000 01C8     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 01C9 
; 0000 01CA     // TWI initialization
; 0000 01CB     // TWI disabled
; 0000 01CC     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	LDI  R30,LOW(0)
	STS  188,R30
; 0000 01CD 
; 0000 01CE     // Global enable interrupts
; 0000 01CF     #asm("sei")
	sei
; 0000 01D0     PROTECT_OFF;
	CBI  0x8,4
; 0000 01D1     while (1)
_0x68:
; 0000 01D2     {
; 0000 01D3     // Place your code here
; 0000 01D4         PROTECT();
	RCALL _PROTECT
; 0000 01D5     }
	RJMP _0x68
; 0000 01D6 }
_0x6B:
	RJMP _0x6B
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
;
;bit Bit_led_1_warning = 0;
;bit Bit_led_2_warning = 0;
;bit Bit_led_3_warning = 0;
;bit Bit_led_4_warning = 0;
;
;unsigned int   Uint_warning_count;
;
;unsigned char   BCDLED[12]={0xF9,0x21,0xEA,0x6B,0x33,0x5B,0xDB,0x29,0xFB,0x7B,0x02,0x00};

	.DSEG
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
; 0001 001C {

	.CSEG
_SEND_DATA_LED:
; .FSTART _SEND_DATA_LED
; 0001 001D     unsigned char   i;
; 0001 001E     unsigned char   data[6];
; 0001 001F     for(i=0;i<6;i++)    data[i] = 0;
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
_0x20005:
	CPI  R17,6
	BRSH _0x20006
	RCALL SUBOPT_0x19
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R17,-1
	RJMP _0x20005
_0x20006:
; 0001 0020 data[0] = byte_1;
	LDD  R30,Y+9
	STD  Y+1,R30
; 0001 0021     data[1] = byte_2;
	LDD  R30,Y+8
	STD  Y+2,R30
; 0001 0022     data[2] = byte_3;
	LDD  R30,Y+7
	STD  Y+3,R30
; 0001 0023 
; 0001 0024     for(i=0;i<(num_bytes - 1);i++)    SPI_SENDBYTE(data[i],0);
	LDI  R17,LOW(0)
_0x20008:
	LDD  R30,Y+10
	LDI  R31,0
	SBIW R30,1
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x20009
	RCALL SUBOPT_0x19
	LD   R30,X
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _SPI_SENDBYTE
	SUBI R17,-1
	RJMP _0x20008
_0x20009:
; 0001 0025 SPI_SENDBYTE(data[i],1);
	RCALL SUBOPT_0x19
	LD   R30,X
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _SPI_SENDBYTE
; 0001 0026 }
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
; 0001 002F {
_SCAN_LED:
; .FSTART _SCAN_LED
; 0001 0030     unsigned char   byte1,byte2,byte3;
; 0001 0031     unsigned char    data;
; 0001 0032     unsigned char   bit_left;
; 0001 0033     bit_left = 0x01;
	RCALL __SAVELOCR6
;	byte1 -> R17
;	byte2 -> R16
;	byte3 -> R19
;	data -> R18
;	bit_left -> R21
	LDI  R21,LOW(1)
; 0001 0034     byte1 = 0;
	LDI  R17,LOW(0)
; 0001 0035     byte2 = 0;
	LDI  R16,LOW(0)
; 0001 0036     byte3 = 0;
	LDI  R19,LOW(0)
; 0001 0037 
; 0001 0038     Uc_Select_led++;
	INC  R12
; 0001 0039     bit_left <<= (Uc_Select_led-1);
	MOV  R30,R12
	SUBI R30,LOW(1)
	MOV  R26,R21
	RCALL __LSLB12
	MOV  R21,R30
; 0001 003A     if(Uc_Select_led > 8)
	LDI  R30,LOW(8)
	CP   R30,R12
	BRSH _0x2000A
; 0001 003B     {
; 0001 003C         Uc_Select_led = 1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0001 003D         bit_left = 0x01;
	LDI  R21,LOW(1)
; 0001 003E     }
; 0001 003F     /* 7-seg 1*/
; 0001 0040     data = Uint_data_led1/1000;
_0x2000A:
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
; 0001 0041     byte1 = BCDLED[data];
; 0001 0042     if(Bit_led_1_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,0
	RJMP _0x2000C
	RCALL SUBOPT_0x1C
	BRLO _0x2000D
_0x2000C:
	RJMP _0x2000B
_0x2000D:
; 0001 0043     {
; 0001 0044         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 0045     }
; 0001 0046     if((byte1 & bit_left)) byte3 |= 0x04;
_0x2000B:
	RCALL SUBOPT_0x1E
	BREQ _0x2000E
	ORI  R19,LOW(4)
; 0001 0047 
; 0001 0048     data = Uint_data_led1/100%10;
_0x2000E:
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1F
; 0001 0049     byte1 = BCDLED[data];
; 0001 004A     if(Bit_led_1_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,0
	RJMP _0x20010
	RCALL SUBOPT_0x1C
	BRLO _0x20011
_0x20010:
	RJMP _0x2000F
_0x20011:
; 0001 004B     {
; 0001 004C         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 004D     }
; 0001 004E     if(byte1 & bit_left) byte3 |= 0x08;
_0x2000F:
	RCALL SUBOPT_0x1E
	BREQ _0x20012
	ORI  R19,LOW(8)
; 0001 004F     data = Uint_data_led1/10%10;
_0x20012:
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
; 0001 0050     byte1 = BCDLED[data];
; 0001 0051     byte1 |= 0x04;
	ORI  R17,LOW(4)
; 0001 0052     if(Bit_led_1_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,0
	RJMP _0x20014
	RCALL SUBOPT_0x1C
	BRLO _0x20015
_0x20014:
	RJMP _0x20013
_0x20015:
; 0001 0053     {
; 0001 0054         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 0055     }
; 0001 0056     if(byte1 & bit_left) byte3 |= 0x10;
_0x20013:
	RCALL SUBOPT_0x1E
	BREQ _0x20016
	ORI  R19,LOW(16)
; 0001 0057 
; 0001 0058     data = Uint_data_led1%10;
_0x20016:
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x22
; 0001 0059     byte1 = BCDLED[data];
; 0001 005A     if(Bit_led_1_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,0
	RJMP _0x20018
	RCALL SUBOPT_0x1C
	BRLO _0x20019
_0x20018:
	RJMP _0x20017
_0x20019:
; 0001 005B     {
; 0001 005C         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 005D     }
; 0001 005E     if(byte1 & bit_left) byte2 |= 0x10;
_0x20017:
	RCALL SUBOPT_0x1E
	BREQ _0x2001A
	ORI  R16,LOW(16)
; 0001 005F     /* 7-seg 2 */
; 0001 0060     data = Uint_data_led2/1000;
_0x2001A:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x1B
; 0001 0061     byte1 = BCDLED[data];
; 0001 0062     if(Bit_led_2_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,1
	RJMP _0x2001C
	RCALL SUBOPT_0x1C
	BRLO _0x2001D
_0x2001C:
	RJMP _0x2001B
_0x2001D:
; 0001 0063     {
; 0001 0064         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 0065     }
; 0001 0066     if(byte1 & bit_left) byte2 |= 0x20;
_0x2001B:
	RCALL SUBOPT_0x1E
	BREQ _0x2001E
	ORI  R16,LOW(32)
; 0001 0067 
; 0001 0068     data = Uint_data_led2/100%10;
_0x2001E:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x1F
; 0001 0069     byte1 = BCDLED[data];
; 0001 006A     byte1 |= 0x04;
	ORI  R17,LOW(4)
; 0001 006B     if(Bit_led_2_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,1
	RJMP _0x20020
	RCALL SUBOPT_0x1C
	BRLO _0x20021
_0x20020:
	RJMP _0x2001F
_0x20021:
; 0001 006C     {
; 0001 006D         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 006E     }
; 0001 006F     if(byte1 & bit_left) byte2 |= 0x08;
_0x2001F:
	RCALL SUBOPT_0x1E
	BREQ _0x20022
	ORI  R16,LOW(8)
; 0001 0070 
; 0001 0071     data = Uint_data_led2/10%10;
_0x20022:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
; 0001 0072     byte1 = BCDLED[data];
; 0001 0073     if(Bit_led_2_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,1
	RJMP _0x20024
	RCALL SUBOPT_0x1C
	BRLO _0x20025
_0x20024:
	RJMP _0x20023
_0x20025:
; 0001 0074     {
; 0001 0075         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 0076     }
; 0001 0077     if(byte1 & bit_left) byte2 |= 0x04;
_0x20023:
	RCALL SUBOPT_0x1E
	BREQ _0x20026
	ORI  R16,LOW(4)
; 0001 0078 
; 0001 0079     data = Uint_data_led2%10;
_0x20026:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x22
; 0001 007A     byte1 = BCDLED[data];
; 0001 007B     if(Bit_led_2_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,1
	RJMP _0x20028
	RCALL SUBOPT_0x1C
	BRLO _0x20029
_0x20028:
	RJMP _0x20027
_0x20029:
; 0001 007C     {
; 0001 007D         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 007E     }
; 0001 007F     if(byte1 & bit_left) byte2 |= 0x01;
_0x20027:
	RCALL SUBOPT_0x1E
	BREQ _0x2002A
	ORI  R16,LOW(1)
; 0001 0080     /* 7-seg 3 */
; 0001 0081     data = Uint_data_led3/1000;
_0x2002A:
	RCALL SUBOPT_0x23
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	MOV  R18,R30
; 0001 0082     byte1 = BCDLED[10];
	__GETBRMN 17,_BCDLED,10
; 0001 0083     if(Bit_led_3_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,2
	RJMP _0x2002C
	RCALL SUBOPT_0x1C
	BRLO _0x2002D
_0x2002C:
	RJMP _0x2002B
_0x2002D:
; 0001 0084     {
; 0001 0085         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 0086     }
; 0001 0087     if(byte1 & bit_left) byte3 |= 0x20;
_0x2002B:
	RCALL SUBOPT_0x1E
	BREQ _0x2002E
	ORI  R19,LOW(32)
; 0001 0088 
; 0001 0089     data = Uint_data_led3/100%10;
_0x2002E:
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x1F
; 0001 008A     byte1 = BCDLED[data];
; 0001 008B     if(Bit_led_3_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,2
	RJMP _0x20030
	RCALL SUBOPT_0x1C
	BRLO _0x20031
_0x20030:
	RJMP _0x2002F
_0x20031:
; 0001 008C     {
; 0001 008D         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 008E     }
; 0001 008F     if(byte1 & bit_left) byte3 |= 0x40;
_0x2002F:
	RCALL SUBOPT_0x1E
	BREQ _0x20032
	ORI  R19,LOW(64)
; 0001 0090 
; 0001 0091     data = Uint_data_led3/10%10;
_0x20032:
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
; 0001 0092     byte1 = BCDLED[data];
; 0001 0093     byte1 |= 0x04;
	ORI  R17,LOW(4)
; 0001 0094     if(Bit_led_3_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,2
	RJMP _0x20034
	RCALL SUBOPT_0x1C
	BRLO _0x20035
_0x20034:
	RJMP _0x20033
_0x20035:
; 0001 0095     {
; 0001 0096         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 0097     }
; 0001 0098     if(byte1 & bit_left) byte3 |= 0x80;
_0x20033:
	RCALL SUBOPT_0x1E
	BREQ _0x20036
	ORI  R19,LOW(128)
; 0001 0099 
; 0001 009A     data = Uint_data_led3%10;
_0x20036:
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x22
; 0001 009B     byte1 = BCDLED[data];
; 0001 009C     if(Bit_led_3_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,2
	RJMP _0x20038
	RCALL SUBOPT_0x1C
	BRLO _0x20039
_0x20038:
	RJMP _0x20037
_0x20039:
; 0001 009D     {
; 0001 009E         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 009F     }
; 0001 00A0     if(byte1 & bit_left) byte3 |= 0x02;
_0x20037:
	RCALL SUBOPT_0x1E
	BREQ _0x2003A
	ORI  R19,LOW(2)
; 0001 00A1     /* 7-seg 4 */
; 0001 00A2     data = Uint_data_led4/1000;
_0x2003A:
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x1B
; 0001 00A3     byte1 = BCDLED[data];
; 0001 00A4     if(Bit_led_4_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,3
	RJMP _0x2003C
	RCALL SUBOPT_0x1C
	BRLO _0x2003D
_0x2003C:
	RJMP _0x2003B
_0x2003D:
; 0001 00A5     {
; 0001 00A6         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 00A7     }
; 0001 00A8     if(byte1 & bit_left) byte3 |= 0x01; //2
_0x2003B:
	RCALL SUBOPT_0x1E
	BREQ _0x2003E
	ORI  R19,LOW(1)
; 0001 00A9 
; 0001 00AA     data = Uint_data_led4/100%10;
_0x2003E:
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x1F
; 0001 00AB     byte1 = BCDLED[data];
; 0001 00AC     byte1 |= 0x04;
	ORI  R17,LOW(4)
; 0001 00AD     if(Bit_led_4_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,3
	RJMP _0x20040
	RCALL SUBOPT_0x1C
	BRLO _0x20041
_0x20040:
	RJMP _0x2003F
_0x20041:
; 0001 00AE     {
; 0001 00AF         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 00B0     }
; 0001 00B1     if(byte1 & bit_left) byte2 |= 0x40;
_0x2003F:
	RCALL SUBOPT_0x1E
	BREQ _0x20042
	ORI  R16,LOW(64)
; 0001 00B2 
; 0001 00B3     data = Uint_data_led4/10%10;
_0x20042:
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
; 0001 00B4     byte1 = BCDLED[data];
; 0001 00B5     if(Bit_led_4_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,3
	RJMP _0x20044
	RCALL SUBOPT_0x1C
	BRLO _0x20045
_0x20044:
	RJMP _0x20043
_0x20045:
; 0001 00B6     {
; 0001 00B7         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 00B8     }
; 0001 00B9     if(byte1 & bit_left) byte2 |= 0x80; //7
_0x20043:
	RCALL SUBOPT_0x1E
	BREQ _0x20046
	ORI  R16,LOW(128)
; 0001 00BA 
; 0001 00BB     data = Uint_data_led4%10;
_0x20046:
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x22
; 0001 00BC     byte1 = BCDLED[data];
; 0001 00BD     if(Bit_led_4_warning == 1 && Uint_warning_count < (TIME_LED_BLINK/2))
	SBIS 0x1E,3
	RJMP _0x20048
	RCALL SUBOPT_0x1C
	BRLO _0x20049
_0x20048:
	RJMP _0x20047
_0x20049:
; 0001 00BE     {
; 0001 00BF         byte1 = BCDLED[11];
	RCALL SUBOPT_0x1D
; 0001 00C0     }
; 0001 00C1     if(byte1 & bit_left) byte2 |= 0x02;
_0x20047:
	RCALL SUBOPT_0x1E
	BREQ _0x2004A
	ORI  R16,LOW(2)
; 0001 00C2 
; 0001 00C3     bit_left = 0xff- bit_left;
_0x2004A:
	LDI  R30,LOW(255)
	SUB  R30,R21
	MOV  R21,R30
; 0001 00C4     SEND_DATA_LED(3,byte3,byte2,bit_left);
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R16
	MOV  R26,R21
	RCALL _SEND_DATA_LED
; 0001 00C5 
; 0001 00C6     Uint_warning_count++;
	LDI  R26,LOW(_Uint_warning_count)
	LDI  R27,HIGH(_Uint_warning_count)
	RCALL SUBOPT_0x2
; 0001 00C7     if(Uint_warning_count >= TIME_LED_BLINK)   Uint_warning_count = 0;
	LDS  R26,_Uint_warning_count
	LDS  R27,_Uint_warning_count+1
	CPI  R26,LOW(0xFA)
	LDI  R30,HIGH(0xFA)
	CPC  R27,R30
	BRLO _0x2004B
	LDI  R30,LOW(0)
	STS  _Uint_warning_count,R30
	STS  _Uint_warning_count+1,R30
; 0001 00C8 }
_0x2004B:
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
_Uint_U_Positive_Buff:
	.BYTE 0x3C
_Uint_U_Negative_Buff:
	.BYTE 0x3C
_Uint_I_Positive_Buff:
	.BYTE 0x3C
_Uint_I_Negative_Buff:
	.BYTE 0x3C
_Uint_Turnoff_relay_timer:
	.BYTE 0x2
_Uint_Timer_Display:
	.BYTE 0x2
_Uint_warning_count:
	.BYTE 0x2
_BCDLED:
	.BYTE 0xC

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	STS  133,R30
	LDI  R30,LOW(128)
	STS  132,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x1:
	LDS  R26,_Uint_Timer_Display
	LDS  R27,_Uint_Timer_Display+1
	CPI  R26,LOW(0x96)
	LDI  R30,HIGH(0x96)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDS  R26,_Uint_Turnoff_relay_timer
	LDS  R27,_Uint_Turnoff_relay_timer+1
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(_Uint_I_Negative_Buff)
	LDI  R27,HIGH(_Uint_I_Negative_Buff)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0x6:
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x5
	MOVW R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x8:
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x9:
	RCALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0xA:
	RCALL SUBOPT_0x8
	LD   R0,X+
	LD   R1,X
	MOV  R30,R18
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	RCALL SUBOPT_0x8
	RCALL __GETW1P
	CP   R30,R0
	CPC  R31,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0x8
	LD   R20,X+
	LD   R21,X
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xC:
	MOV  R30,R18
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0x8
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0x5
	ST   Z,R20
	STD  Z+1,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	__CLRD1SX 66
	LDI  R19,LOW(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0x8
	RCALL __GETW1P
	__GETD2SX 66
	CLR  R22
	CLR  R23
	RCALL __ADDD12
	__PUTD1SX 66
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x11:
	__GETD1SX 66
	RCALL __CDF1U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x12:
	LDS  R26,_Uint_data_led4
	LDS  R27,_Uint_data_led4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(_Uint_I_Positive_Buff)
	LDI  R27,HIGH(_Uint_I_Positive_Buff)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x14:
	LDS  R26,_Uint_data_led2
	LDS  R27,_Uint_data_led2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(_Uint_U_Negative_Buff)
	LDI  R27,HIGH(_Uint_U_Negative_Buff)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x16:
	__GETD2N 0x43B90000
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x46200000
	RCALL __DIVF21
	RCALL __CFD1U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(_Uint_U_Positive_Buff)
	LDI  R27,HIGH(_Uint_U_Positive_Buff)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	STS  123,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x19:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	LDS  R26,_Uint_data_led1
	LDS  R27,_Uint_data_led1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	MOV  R18,R30
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:88 WORDS
SUBOPT_0x1C:
	LDS  R26,_Uint_warning_count
	LDS  R27,_Uint_warning_count+1
	CPI  R26,LOW(0x7D)
	LDI  R30,HIGH(0x7D)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1D:
	__GETBRMN 17,_BCDLED,11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1E:
	MOV  R30,R21
	AND  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x1F:
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
SUBOPT_0x20:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x21:
	RCALL __DIVW21U
	MOVW R26,R30
	RCALL SUBOPT_0x20
	RCALL __MODW21U
	MOV  R18,R30
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x22:
	RCALL SUBOPT_0x20
	RCALL __MODW21U
	MOV  R18,R30
	LDI  R31,0
	SUBI R30,LOW(-_BCDLED)
	SBCI R31,HIGH(-_BCDLED)
	LD   R17,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	LDS  R26,_Uint_data_led3
	LDS  R27,_Uint_data_led3+1
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
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
