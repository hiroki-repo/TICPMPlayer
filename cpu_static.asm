.assume ADL=1
_em180:
	ld (em180_spbak),sp
	ld sp,em180_stack4prgs
	ld (em180_ixiybak+0),ix
	ld (em180_ixiybak+3),iy
em180_fetch:
	ei
	ld a,000h
	ld (em180_opctmp+0),a
	ld (em180_opctmp+1),a
	ld (em180_opctmp+2),a
	ld (em180_opctmp+3),a
	ld (em180_opctmp+4),a
	ld (em180_opctmp+5),a
	ld (em180_opctmp+6),a
	ld (em180_opctmp+7),a
	ld (em180_opctmp+8),a
	ld (em180_opctmp+9),a
	ld (em180_opctmp+10),a
	ld a,040h
	ld (em180_opctmp-1),a
em180_fetch_1:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+0),a
	cp a,040h
	jp z,em180_fetch_suffix
	cp a,049h
	jp z,em180_fetch_suffix
	cp a,052h
	jp z,em180_fetch_suffix
	cp a,05bh
	jp z,em180_fetch_suffix

	cp a,0c3h
	jp z,em180_op_c0_ff_jp
	cp a,0c9h
	jp z,em180_op_c0_ff_ret
	cp a,0cdh
	jp z,em180_op_c0_ff_call
	cp a,0d3h
	jp z,em180_op_c0_ff_cbpf
	cp a,0dbh
	jp z,em180_op_c0_ff_cbpf
	cp a,0e9h
	jp z,em180_op_c0_ff_jphl

	cp a,0cbh
	jp z,em180_op_c0_ff_cbpf
	cp a,0ddh
	jp z,em180_op_c0_ff_ddpf
	cp a,0edh
	jp z,em180_op_c0_ff_edpf
	cp a,0fdh
	jp z,em180_op_c0_ff_fdpf

	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and a,03h
	cp a,0
	jp z,em180_op_00_3f
	cp a,3
	jp z,em180_op_c0_ff
	jp em180_exec_trcode
em180_fetch_suffix:
	ld (em180_opctmp-1),a
	jp em180_fetch_1
em180_op_00_3f:
	ld a,(em180_opctmp+0)
	and a,07h
	cp a,0
	jp z,em180_op_00_3f_2
	cp a,1
	jp z,em180_op_00_3f_5
	cp a,2
	jp z,em180_op_00_3f_1
	cp a,6
	jp z,em180_op_00_3f_cp1
	jp em180_exec_trcode
em180_op_00_3f_cp1:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+1),a
	jp em180_exec_trcode
em180_op_00_3f_cp2:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+1),a
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+2),a
	jp em180_exec_trcode

em180_op_00_3f_1:
	ld a,(em180_opctmp+0)
	rrca
	rrca
	rrca
	rrca
	rrca
	and a,1
	jp nz,em180_op_00_3f_cp2
	jp em180_exec_trcode
em180_op_00_3f_2:
	ld a,(em180_opctmp+0)
	and a,a
	jp z,em180_exec_trcode
	cp a,08h
	jp z,em180_exec_trcode
	cp a,010h
	jp z,em180_op_00_3f_3
	cp a,018h
	jp z,em180_op_00_3f_4
	
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_addr24+0),a
	ld a,0
	ld (em180_opctmp-1),a
	ld b,0c2h
	ld a,(em180_opctmp+0)
	and a,018h
	or a,b
	ld (em180_opctmp+0),a
	ld bc,em180_jr
	ld (em180_opctmp+1),bc
	jp em180_exec_trcode
em180_op_00_3f_3:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_addr24+0),a
	ld a,0
	ld (em180_opctmp-1),a
	ld a,0c3h
	ld (em180_opctmp+0),a
	ld bc,em180_djnz
	ld (em180_opctmp+1),bc
	jp em180_exec_trcode
em180_op_00_3f_4:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_addr24+0),a
	ld a,0
	ld (em180_opctmp-1),a
	ld a,0c3h
	ld (em180_opctmp+0),a
	ld bc,em180_jr
	ld (em180_opctmp+1),bc
	jp em180_exec_trcode
em180_op_00_3f_5:
	ld a,(em180_opctmp+0)
	rrca
	rrca
	rrca
	and a,1
	jp z,em180_op_00_3f_cp2
	jp em180_exec_trcode


em180_op_c0_ff:
	ld a,(em180_opctmp+0)
	and a,07h
	cp a,0
	jp z,em180_op_c0_ff__0
	cp a,2
	jp z,em180_op_c0_ff__2
	cp a,4
	jp z,em180_op_c0_ff__4
	cp a,6
	jp z,em180_op_c0_ff__6
	cp a,7
	jp z,em180_op_c0_ff__7
	jp em180_exec_trcode
em180_op_c0_ff__0:
	ld a,(em180_opctmp-1)
	rrca
	rrca
	rrca
	and a,1
	ld (em180_spbak+3),sp
	ld sp,(em180_spbak)
	ld ix,(em180_ixiybak+0)
	ld iy,(em180_ixiybak+3)
	jp nz,em180_opctmpwp
	ld sp,(em180_spbak+3)
	ld a,0
	ld (em180_opctmp-1),a
	ld a,(em180_opctmp+0)
	and a,038h
	ld b,0c2h
	or a,b
	ld (em180_opctmp+0),a
	ld bc,em180_ret
	ld (em180_opctmp+1),bc
	ld a,0c3h
	ld (em180_opctmp+4),a
	ld bc,em180_skip4ncc
	ld (em180_opctmp+5),bc
	jp em180_exec_trcode
em180_op_c0_ff__2:
	ld a,(em180_opctmp-1)
	rrca
	rrca
	rrca
	and a,1
	jp nz,em180_op_c0_ff__cpinst2
	ld a,0
	ld (em180_opctmp-1),a
	ld a,(em180_opctmp+0)
	and a,038h
	ld b,0c2h
	or a,b
	ld (em180_opctmp+0),a
	ld bc,em180_jp
	ld (em180_opctmp+1),bc
	ld a,0c3h
	ld (em180_opctmp+4),a
	ld bc,em180_skip4ncc
	ld (em180_opctmp+5),bc
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_addr24+0),a
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_addr24+1),a
	jp em180_exec_trcode
em180_op_c0_ff__4:
	ld a,(em180_opctmp-1)
	rrca
	rrca
	rrca
	and a,1
	jp nz,em180_op_c0_ff__cpinst2
	ld a,0
	ld (em180_opctmp-1),a
	ld a,(em180_opctmp+0)
	and a,038h
	ld b,0c2h
	or a,b
	ld (em180_opctmp+0),a
	ld bc,em180_call
	ld (em180_opctmp+1),bc
	ld a,0c3h
	ld (em180_opctmp+4),a
	ld bc,em180_skip4ncc
	ld (em180_opctmp+5),bc
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_addr24+0),a
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_addr24+1),a
	jp em180_exec_trcode
em180_op_c0_ff__6:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+1),a
	jp em180_exec_trcode
em180_op_c0_ff__7:
	ld a,(em180_opctmp-1)
	rrca
	rrca
	rrca
	and a,1
	jp nz,em180_exec_trcode
	ld a,(em180_opctmp+0)
	and a,038h
	ld (em180_addr24+0),a
	ld a,0
	ld (em180_opctmp-1),a
	ld a,0c3h
	ld (em180_opctmp+0),a
	ld bc,em180_call
	ld (em180_opctmp+1),bc
	ld a,0c3h
	ld (em180_opctmp+4),a
	ld bc,em180_skip4ncc
	ld (em180_opctmp+5),bc
	jp em180_exec_trcode

em180_op_c0_ff_ret:
	ld a,(em180_opctmp-1)
	rrca
	rrca
	rrca
	and a,1
	ld (em180_spbak+3),sp
	ld sp,(em180_spbak)
	ld ix,(em180_ixiybak+0)
	ld iy,(em180_ixiybak+3)
	jp nz,em180_opctmpwp
	ld sp,(em180_spbak+3)
	ld a,0
	ld (em180_opctmp-1),a
	ld a,0c3h
	ld (em180_opctmp+0),a
	ld bc,em180_ret
	ld (em180_opctmp+1),bc
	ld a,0c3h
	ld (em180_opctmp+4),a
	ld bc,em180_skip4ncc
	ld (em180_opctmp+5),bc
	jp em180_exec_trcode
em180_op_c0_ff_jp:
	ld a,(em180_opctmp-1)
	rrca
	rrca
	rrca
	and a,1
	jp nz,em180_op_c0_ff__cpinst2
	ld a,0
	ld (em180_opctmp-1),a
	ld a,0c3h
	ld (em180_opctmp+0),a
	ld bc,em180_jp
	ld (em180_opctmp+1),bc
	ld a,0c3h
	ld (em180_opctmp+4),a
	ld bc,em180_skip4ncc
	ld (em180_opctmp+5),bc
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_addr24+0),a
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_addr24+1),a
	jp em180_exec_trcode
em180_op_c0_ff_call:
	ld a,(em180_opctmp-1)
	rrca
	rrca
	rrca
	and a,1
	jp nz,em180_op_c0_ff__cpinst2
	ld a,0
	ld (em180_opctmp-1),a
	ld a,0c3h
	ld (em180_opctmp+0),a
	ld bc,em180_call
	ld (em180_opctmp+1),bc
	ld a,0c3h
	ld (em180_opctmp+4),a
	ld bc,em180_skip4ncc
	ld (em180_opctmp+5),bc
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_addr24+0),a
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_addr24+1),a
	jp em180_exec_trcode
em180_op_c0_ff_jphl:
	ld a,(em180_opctmp-1)
	rrca
	rrca
	rrca
	and a,1
	jp nz,em180_exec_trcode
	ld a,0
	ld (em180_opctmp-1),a
	ld a,0c3h
	ld (em180_opctmp+0),a
	ld bc,em180_jphl
	ld (em180_opctmp+1),bc
	ld a,0c3h
	ld (em180_opctmp+4),a
	ld bc,em180_skip4ncc
	ld (em180_opctmp+5),bc
	jp em180_exec_trcode
em180_op_c0_ff__cpinst2:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+1),a
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+2),a
	ld a,(em180_opctmp-1)
	rrca
	rrca
	rrca
	and a,1
	jp nz,em180_op_c0_ff__cpinst2p1
	jp em180_exec_trcode
em180_op_c0_ff__cpinst2p1:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+3),a
	jp em180_exec_trcode

em180_op_c0_ff_cbpf:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+1),a
	jp em180_exec_trcode

em180_op_c0_ff_ddpf:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+1),a
	cp a,0e9h
	jp z,em180_op_c0_ff_jpix
	jp em180_op_ixypf
em180_op_c0_ff_fdpf:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+1),a
	cp a,0e9h
	jp z,em180_op_c0_ff_jpiy
	jp em180_op_ixypf
em180_op_c0_ff_jpix:
	ld a,(em180_opctmp-1)
	rrca
	rrca
	rrca
	and a,1
	jp nz,em180_exec_trcode
	ld a,0
	ld (em180_opctmp-1),a
	ld a,0c3h
	ld (em180_opctmp+0),a
	ld bc,em180_jpix
	ld (em180_opctmp+1),bc
	ld a,0c3h
	ld (em180_opctmp+4),a
	ld bc,em180_skip4ncc
	ld (em180_opctmp+5),bc
	jp em180_exec_trcode
em180_op_c0_ff_jpiy:
	ld a,(em180_opctmp-1)
	rrca
	rrca
	rrca
	and a,1
	jp nz,em180_exec_trcode
	ld a,0
	ld (em180_opctmp-1),a
	ld a,0c3h
	ld (em180_opctmp+0),a
	ld bc,em180_jpiy
	ld (em180_opctmp+1),bc
	ld a,0c3h
	ld (em180_opctmp+4),a
	ld bc,em180_skip4ncc
	ld (em180_opctmp+5),bc
	jp em180_exec_trcode
em180_op_ixypf:
	ld a,(em180_opctmp+1)
	cp a,0cbh
	jp z,em180_op_ixypf_opt1_2
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and a,3
	jp z,em180_op_ixypf_00_3f
	cp a,1
	jp z,em180_op_ixypf_40_7f
	cp a,2
	jp z,em180_op_ixypf_80_bf
	jp em180_exec_trcode
em180_op_ixypf_00_3f:
	ld a,(em180_opctmp+1)
	cp a,021h
	jp z,em180_op_ixypf_opt1_2
	cp a,022h
	jp z,em180_op_ixypf_opt1_2
	cp a,02ah
	jp z,em180_op_ixypf_opt1_2
	cp a,031h
	jp z,em180_op_ixypf_opt1_1
	cp a,03eh
	jp z,em180_op_ixypf_opt1_1
	rrca
	rrca
	rrca
	and a,7
	cp a,6
	jp z,em180_op_ixypf_00_3f_ixinsthl
	ld a,(em180_opctmp+1)
	and a,7
	cp a,6
	jp z,em180_op_ixypf_opt1_1
	cp a,7
	jp z,em180_op_ixypf_opt1_1
	jp em180_exec_trcode
em180_op_ixypf_00_3f_ixinsthl:
	ld a,(em180_opctmp+1)
	and a,7
	cp a,4
	jp z,em180_op_ixypf_opt1_1
	cp a,5
	jp z,em180_op_ixypf_opt1_1
	cp a,6
	jp z,em180_op_ixypf_opt1_2
	cp a,7
	jp z,em180_op_ixypf_opt1_1
	jp em180_exec_trcode
em180_op_ixypf_40_7f:
	ld a,(em180_opctmp+1)
	and a,7
	cp a,6
	jp z,em180_op_ixypf_opt1_1
	ld a,(em180_opctmp+1)
	rrca
	rrca
	rrca
	and a,7
	cp a,6
	jp z,em180_op_ixypf_opt1_1
	jp em180_exec_trcode
em180_op_ixypf_80_bf:
	ld a,(em180_opctmp+1)
	and a,7
	cp a,6
	jp z,em180_op_ixypf_opt1_1
	jp em180_exec_trcode

em180_op_ixypf_opt1_1:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+2),a
	jp em180_exec_trcode
em180_op_ixypf_opt1_2:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+2),a
em180_op_ixypf_opt2_1:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+3),a
	jp em180_exec_trcode
em180_op_ixypf_opt1_3:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+2),a
em180_op_ixypf_opt2_2:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+3),a
em180_op_ixypf_opt3_1:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+4),a
	jp em180_exec_trcode

em180_op_c0_ff_edpf:
	ld.sis a,(hl)
	inc.sis hl
	ld (em180_opctmp+1),a
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and a,3
	jp z,em180_op_c0_ff_edpf_00_3f
	cp a,1
	jp z,em180_op_c0_ff_edpf_40_7f
	jp em180_exec_trcode
em180_op_c0_ff_edpf_00_3f:
	ld a,(em180_opctmp+1)
	and a,7
	jp z,em180_op_ixypf_opt1_1
	cp a,1
	jp z,em180_op_ixypf_opt1_1
	cp a,2
	jp z,em180_op_ixypf_opt1_1
	cp a,3
	jp z,em180_op_ixypf_opt1_1
	jp em180_exec_trcode
em180_op_c0_ff_edpf_40_7f:
	ld a,(em180_opctmp+1)
	cp a,054h
	jp z,em180_op_ixypf_opt1_1
	cp a,055h
	jp z,em180_op_ixypf_opt1_1
	cp a,056h
	jp z,em180_op_ixypf_opt1_1
	cp a,065h
	jp z,em180_op_ixypf_opt1_1
	and a,7
	cp a,3
	jp z,em180_op_ixypf_opt1_2
	ld a,(em180_opctmp+1)
	rrca
	rrca
	rrca
	rrca
	rrca
	and a,1
	jp z,em180_op_c0_ff_edpf_40_7f_1
	jp em180_exec_trcode
em180_op_c0_ff_edpf_40_7f_1:
	ld a,(em180_opctmp+1)
	rrca
	rrca
	rrca
	and a,1
	jp z,em180_op_c0_ff_edpf_40_7f_2
	jp em180_exec_trcode
em180_op_c0_ff_edpf_40_7f_2:
	ld a,(em180_opctmp+1)
	and a,7
	cp a,4
	jp z,em180_op_ixypf_opt1_1
	jp em180_exec_trcode

em180_exec_trcode:
	di
	ld (em180_stack4z80inst+(3*11)),hl
	ld hl,(em180_stack4z80inst+(3*10))
	ld.sis sp,hl
	ld hl,(em180_stack4z80inst+(3*0))
	push hl
	pop af
	ld bc,(em180_stack4z80inst+(3*1))
	ld de,(em180_stack4z80inst+(3*2))
	ld hl,(em180_stack4z80inst+(3*3))
	ex af,af'
	exx
	ld hl,(em180_stack4z80inst+(3*4))
	push hl
	pop af
	ld bc,(em180_stack4z80inst+(3*5))
	ld de,(em180_stack4z80inst+(3*6))
	ld hl,(em180_stack4z80inst+(3*7))
	ex af,af'
	exx
	ld ix,(em180_stack4z80inst+(3*8))
	ld iy,(em180_stack4z80inst+(3*9))
	ld (em180_spbak+3),sp
	ld sp,(em180_spbak)

em180_opctmpwp:
	.db 040h
em180_opctmp:
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
em180_addr24:
	nop
	nop
	nop

em180_skip4ncc:
	ld (em180_spbak),sp
	ld sp,(em180_spbak+3)
	ld (em180_stack4z80inst+(3*1)),bc
	ld (em180_stack4z80inst+(3*2)),de
	ld (em180_stack4z80inst+(3*3)),hl
	push af
	pop hl
	ld (em180_stack4z80inst+(3*0)),hl
	ex af,af'
	exx
	ld (em180_stack4z80inst+(3*5)),bc
	ld (em180_stack4z80inst+(3*6)),de
	ld (em180_stack4z80inst+(3*7)),hl
	push af
	pop hl
	ld (em180_stack4z80inst+(3*4)),hl
	ex af,af'
	exx
	ld (em180_stack4z80inst+(3*8)),ix
	ld (em180_stack4z80inst+(3*9)),iy
	ld hl,0
	add.sis hl,sp
	ld (em180_stack4z80inst+(3*10)),hl
	ld hl,(em180_stack4z80inst+(3*11))
	jp em180_fetch

em180_call:
	ld hl,(em180_stack4z80inst+(3*11))
	push.sis hl
	ld (em180_stack4z80inst+(3*11)),hl
	ld hl,0
	add.sis hl,sp
	ld (em180_stack4z80inst+(3*10)),hl
em180_jp:
	ld hl,(em180_addr24)
	jp em180_fetch
em180_jphl:
	ld (em180_stack4z80inst+(3*11)),hl
	ld hl,(em180_stack4z80inst+(3*11))
	jp em180_fetch
em180_jpix:
	ld (em180_stack4z80inst+(3*11)),ix
	ld hl,(em180_stack4z80inst+(3*11))
	jp em180_fetch
em180_jpiy:
	ld (em180_stack4z80inst+(3*11)),iy
	ld hl,(em180_stack4z80inst+(3*11))
	jp em180_fetch
em180_ret:
	pop.sis hl
	ld (em180_stack4z80inst+(3*11)),hl
	ld hl,0
	add.sis hl,sp
	ld (em180_stack4z80inst+(3*10)),hl
	ld hl,(em180_stack4z80inst+(3*11))
	jp em180_fetch

em180_djnz:
	dec b
	ld (em180_stack4z80inst+(3*1)),bc
	ld a,b
	and a,a
	jp z,em180_fetch
em180_jr:
	ld a,(em180_addr24)
	cp a,128
	jp nc,em180_jr_1
	ld hl,(em180_stack4z80inst+(3*11))
	ld b,a
	ld a,l
	add a,b
	ld l,a
	ld a,h
	adc a,0
	ld h,a
	jp em180_fetch
em180_jr_1:
	ld b,a
	ld a,255
	sub a,b
	inc a
	ld hl,(em180_stack4z80inst+(3*11))
	ld b,a
	ld a,l
	sub a,b
	ld l,a
	ld a,h
	sbc a,0
	ld h,a
	jp em180_fetch

em180_stack4z80inst:
.dl 0
.dl 0
.dl 0
.dl 0

.dl 0
.dl 0
.dl 0
.dl 0

.dl 0
.dl 0

.dl 0
.dl 0

.fill 4096
em180_stack4prgs:
em180_spbak:
.dl 0
.dl 0
em180_ixiybak:
.dl 0
.dl 0