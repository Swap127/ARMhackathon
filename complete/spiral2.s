	area     Spiral2, CODE, READONLY
    IMPORT printMsg
	IMPORT printMsgSin
	IMPORT printMsgCos	
	IMPORT printHead
	 EXPORT __main
     ENTRY 
__main  FUNCTION
		BL printHead 

		LDR r5, =0x00000000; 
		VMOV.F32 s10, r5		;0 constant		
		VLDR.F32 s11, =-1		;-1 constant
		VLDR.F32 s12, =1		;1 constant
		VLDR.F32 s25,=0		;radius
		VLDR.F32 s13,=10       ;upper value of k
		VLDR.F32 s4, =0.5		;1 constant
		
		VMOV.F32 s28,s10
		VLDR.F32 s29,=3

startc	MOV r7, 0				;initial angle 0
		VCMP.F32 s29,s28
		VMRS    APSR_nzcv, FPSCR
		MOVGT r6, 359			;final angle 360
		MOVLE r6, 144			;final angle 360

		
		;Center Points
		VLDR.F32 s30,=3000				;Centre x value	;center at(3000,3000)
										;Centre y value
		;For the case of mooon (i.e. spiral2) we are taking the centre points at (2500,2500)
		
		
		
		
starta	MOV r0, r7				;angle in degrees
		BL printMsg				;print the angle
		VADD.F32 s25,s25,s4
		;Converting degrees to radians
		VMOV.F32 s5,r7
		VCVT.F32.U32 s5,s5
		;VLDR.F32 s5, =60            	    
		VLDR.F32 s6, =0.0174533			  ;1 degree = 0.0174533	radians
		VMUL.F32 s14,s5,s6				  ;angle in radians
		
		VMOV.F32 s15,s10;		 ;initialising k value to 0 
		VMOV.F32 s22,s10;		 ;storing the sum is initialised to 0
		;VLDR.F32 s14, = 1.0472	 ;Value of x
		
Loop1	
		VCMP.F32 s15,s13
		VMRS    APSR_nzcv, FPSCR
		BGT stop1
		;VMOV.F32 s14,r4
		;VCVT.F32.S32 s14,s14	; loading value of x
		
		VLDR.F32 s16, =2		 ;2
		VMUL.F32 s16,s16,s15	 ;2k
		VADD.F32 s16,s16,s12	 ;2k+1
		
		;for exponent put the input in s7 and s8 and take the ouput from s9
		VMOV.F32 s7,s14				;a			apowb
		VMOV.F32 s8,s16				;b
		
		
		
		B exp
		;Calculating x^(2k+1)
expdone	
		VMOV.F32 s17,s9

		;for factorial put the input in s8 and take the ouput from s9
		VMOV.F32 s8,s16				;b
		B fact
		;Calculating (2k+1)!
factdone
		VMOV.F32 s18,s9
		
		;Calculating -1^k		
		VMOV.F32 s7,s11				;a			apowb
		VMOV.F32 s8,s15				;b
		B exp2

expdone2
		VMOV.F32 s19,s9
		
		VMUL.F32 s21,s19,s17
		VDIV.F32 s21,s21,s18
		VADD.F32 s22,s22,s21
		VADD.F32 s15,s15,s12
		
		B Loop1
		
		
stop1   VMULGT.F32 s26,s25,s22
		VADDGT.F32 s26,s26,s30
		VMOVGT.F32 r0,s26
		BL printMsgSin
		B COS	
;-----------------------------Exponential---------------------------------------------		
exp		; VMOV.F32 s7,s14	;a
		; VMOV.F32 s8,s16	;b		
		VCMP.F32 s8,s10						;if b = 0 then a^0 = 1
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s9,s12
		BEQ	expdone
		
		VCMP.F32 s8,s12						;if b = 1 then a^1 = a
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s9,s7
		BEQ	expdone
											;else for other cases
		VMOV.F32 s20,s8
		VMOV.F32 s9,s12
exploop				
		VCMP.F32 s20,s12
		VMRS    APSR_nzcv, FPSCR
		VMULGE.F32 s9,s9,s7
		VSUBGE.F32 s20,s20,s12
		BGE exploop
		BLT expdone
;-------------------------------------exponential2---------------------------------------
exp2	; VMOV.F32 s7,s14	;a
		; VMOV.F32 s8,s16	;b		
		VCMP.F32 s8,s10						;if b = 0 then a^0 = 1
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s9,s12
		BEQ	expdone2
		
		VCMP.F32 s8,s12						;if b = 1 then a^1 = a
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s9,s7
		BEQ	expdone2
											;else for other cases
		VMOV.F32 s20,s8	
		VMOV.F32 s9,s12
exploop2				
		VCMP.F32 s20,s12
		VMRS    APSR_nzcv, FPSCR
		VMULGE.F32 s9,s9,s7
		VSUBGE.F32 s20,s20,s12
		BGE exploop2
		BLT expdone2

;--------------------------------------Factorial-----------------------------------------
fact	
		;VMOV.F32 s21,s16	;a		 
		B afact
		 
afact
		VCMP.F32 s8,s10						;if a = 0 then a! = 1
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s9,s12
		BEQ	factdone
		
		VCMP.F32 s8,s12						;if 1 = 1 then 1! = 1
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s9,s12
		BEQ	factdone
											;else for other cases
		VMOV.F32 s23,s8	
		VMOV.F32 s9,s8
factloop				
		VSUBGE.F32 s23,s23,s12
		VCMP.F32 s23,s12
		VMRS    APSR_nzcv, FPSCR
		VMULGE.F32 s9,s9,s23
		BGE factloop
		BLT factdone
	
;--------------------------------------------------------COS----------------------------------------------------------------	
COS
		VMOV.F32 s7,s10;
		VMOV.F32 s8,s10;
		VMOV.F32 s9,s10;
		VMOV.F32 s16,s10;
		VMOV.F32 s17,s10;
		VMOV.F32 s18,s10;
		VMOV.F32 s19,s10;
		VMOV.F32 s21,s10;
		
		VMOV.F32 s15,s10;		 ;initialising k value to 0 
		VMOV.F32 s24,s10;		 ;storing the sum is initialised to 0
		;VLDR.F32 s14, = 0.785398	 ;Value of x
		
Loop1c	
		VCMP.F32 s15,s13
		VMRS    APSR_nzcv, FPSCR
		BGT	stop2
		;VMOV.F32 s14,r4
		;VCVT.F32.S32 s14,s14	; loading value of x
		
		VLDR.F32 s16, =2		 ;2
		VMUL.F32 s16,s16,s15	 ;2k
		;VADD.F32 s16,s16,s12	 ;2k+1
		
		;for exponent put the input in s7 and s8 and take the ouput from s9
		VMOV.F32 s7,s14				;a			apowb
		VMOV.F32 s8,s16				;b
		
		
		
		B expc
		;Calculating x^(2k+1)
expdonec	
		VMOV.F32 s17,s9

		;for factorial put the input in s8 and take the ouput from s9
		VMOV.F32 s8,s16				;b
		B factc
		;Calculating (2k+1)!
factdonec
		VMOV.F32 s18,s9
		
		;Calculating -1^k		
		VMOV.F32 s7,s11				;a			apowb
		VMOV.F32 s8,s15				;b
		B exp2c

expdone2c
		VMOV.F32 s19,s9
		
		VMUL.F32 s21,s19,s17
		VDIV.F32 s21,s21,s18
		VADD.F32 s24,s24,s21
		VADD.F32 s15,s15,s12
		
		B Loop1c
		
		
stop2   VMULGT.F32 s27,s25,s24
		VADDGT.F32 s27,s27,s30
		VMOVGT.F32 r0,s27
		BL printMsgCos 
		B stop3

stop3	CMP r7,r6
		ADDLE r7,r7,1
		BLE starta
		BGT stop4

stop4 	B startb
;-----------------------------Exponential---------------------------------------------		
expc		; VMOV.F32 s7,s14	;a
		; VMOV.F32 s8,s16	;b		
		VCMP.F32 s8,s10						;if b = 0 then a^0 = 1
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s9,s12
		BEQ	expdonec
		
		VCMP.F32 s8,s12						;if b = 1 then a^1 = a
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s9,s7
		BEQ	expdonec
											;else for other cases
		VMOV.F32 s20,s8
		VMOV.F32 s9,s12
exploopc				
		VCMP.F32 s20,s12
		VMRS    APSR_nzcv, FPSCR
		VMULGE.F32 s9,s9,s7
		VSUBGE.F32 s20,s20,s12
		BGE exploopc
		BLT expdonec
;-------------------------------------exponential2---------------------------------------
exp2c	; VMOV.F32 s7,s14	;a
		; VMOV.F32 s8,s16	;b		
		VCMP.F32 s8,s10						;if b = 0 then a^0 = 1
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s9,s12
		BEQ	expdone2c
		
		VCMP.F32 s8,s12						;if b = 1 then a^1 = a
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s9,s7
		BEQ	expdone2c
											;else for other cases
		VMOV.F32 s20,s8	
		VMOV.F32 s9,s12
exploop2c				
		VCMP.F32 s20,s12
		VMRS    APSR_nzcv, FPSCR
		VMULGE.F32 s9,s9,s7
		VSUBGE.F32 s20,s20,s12
		BGE exploop2c
		BLT expdone2c

;--------------------------------------Factorial-----------------------------------------
factc	
		;VMOV.F32 s21,s16	;a		 
		B afactc
		 
afactc
		VCMP.F32 s8,s10						;if a = 0 then a! = 1
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s9,s12
		BEQ	factdonec
		
		VCMP.F32 s8,s12						;if 1 = 1 then 1! = 1
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s9,s12
		BEQ	factdonec
											;else for other cases
		VMOV.F32 s23,s8	
		VMOV.F32 s9,s8
factloopc				
		VSUBGE.F32 s23,s23,s12
		VCMP.F32 s23,s12
		VMRS    APSR_nzcv, FPSCR
		VMULGE.F32 s9,s9,s23
		BGE factloopc
		BLT factdonec

startb	VCMP.F32 s28,s29					;again run the loop for further spirals
		VMRS    APSR_nzcv, FPSCR
		VADDLT.F32 s28,s12
		BLT startc
		BGE stop
	
stop 	B	stop							;final stop	
        ENDFUNC
        END