	area     exponential, CODE, READONLY
	 EXPORT __main
     ENTRY 
__main  FUNCTION
		 VLDR.F32 s0, =3	;a
		 VLDR.F32 s1, =4	;b
		 LDR r5, =0x00000000; 
		 VMOV.F32 s2, r5		;0 constant	
		 VLDR.F32 s3, =1		;1 constant		 
		 B apowb
		 
apowb
		VCMP.F32 s1,s2						;if b = 0 then a^0 = 1
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s5,s3
		BEQ	done
		
		VCMP.F32 s1,s3						;if b = 1 then a^1 = a
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s5,s0
		BEQ	done
											;else for other cases
		VMOV.F32 s6,s0	
		VMOV.F32 s5,s3
exploop				
		VCMP.F32 s6,s3
		VMRS    APSR_nzcv, FPSCR
		VMULGE.F32 s5,s5,s0
		VSUBGE.F32 s6,s6,s3
		BGE exploop
		BLT done
done
stop    B stop
        ENDFUNC
        END	