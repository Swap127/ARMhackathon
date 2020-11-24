	area     SineCalculator, CODE, READONLY
    IMPORT printMsg
	 EXPORT __main
     ENTRY 
__main  FUNCTION
		LDR r5, =0x00000000; 
		VMOV.F32 s10, r5		;0 constant		
		VLDR.F32 s11, =-1		;-1 constant
		VLDR.F32 s12, =1		;1 constant
		VLDR.F32 s13,=11       ;upper value of k
		;MOV r4, #90				;The value of x for Sin(x)
		
		VMOV.F32 s15,s10;		 ;initialising k value to 0 
		VMOV.F32 s22,s10;		 ;storing the sum is initialised to 0
		VLDR.F32 s14, = 6.28319	 ;Value of x
		
Loop1	
		VCMP.F32 s15,s13
		VMRS    APSR_nzcv, FPSCR
		BGT	stop
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
		
		
stop    B stop	
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


        ENDFUNC
        END