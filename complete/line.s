	area     Spiral2, CODE, READONLY
    IMPORT printMsg
	IMPORT printMsgSin
	IMPORT printMsgCos	
	IMPORT printHead
	 EXPORT __main
     ENTRY 
__main  FUNCTION
		BL printHead 
		
		VLDR.F32 s3, =1				;constant
		
		VLDR.F32 s4, =-345			;x1
		VLDR.F32 s5, =1387			;y1
		VLDR.F32 s6, =3352			;x2
		VLDR.F32 s7, =2496			;y2
		
		VMOV.F32 s8,s4				; x variable
		VSUB.F32 s9,s7,s5			; y2-y1
		VSUB.F32 s10,s6,s4			; x2-x1
		VDIV.F32 s11,s9,s10			; m=(y2-y1/x2-x1)
		
lp		VCMP.F32 s8,s6
		VMRS    APSR_nzcv, FPSCR
		BLE cal
		B stop

cal		VSUB.F32 s12,s8,s4
		VMUL.F32 s12,s12,s11
		VADD.F32 s12,s12,s5
		VMOV.F32 r0,s8
		BL printMsgSin
		VMOV.F32 r0,s12
		BL printMsgCos
		VADD.F32 s8,s8,s3
		B lp
		

stop 	B	stop							;final stop	
        ENDFUNC
        END