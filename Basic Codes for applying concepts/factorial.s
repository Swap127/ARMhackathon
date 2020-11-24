	area     factorial, CODE, READONLY
	 EXPORT __main
     ENTRY 
__main  FUNCTION
		 VLDR.F32 s0, =7	;a
		 LDR r5, =0x00000000; 
		 VMOV.F32 s2, r5		;0 constant	
		 VLDR.F32 s3, =1		;1 constant		 
		 B afact
		 
afact
		VCMP.F32 s0,s2						;if a = 0 then a! = 1
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s5,s3
		BEQ	done
		
		VCMP.F32 s0,s3						;if 1 = 1 then 1! = 1
		VMRS    APSR_nzcv, FPSCR
		VMOVEQ.F32 s5,s3
		BEQ	done
											;else for other cases
		VMOV.F32 s6,s0	
		VMOV.F32 s5,s0
exploop				
		VSUBGE.F32 s6,s6,s3
		VCMP.F32 s6,s3
		VMRS    APSR_nzcv, FPSCR
		VMULGE.F32 s5,s5,s6
		BGE exploop
		BLT done
done
stop    B stop
        ENDFUNC
        END	