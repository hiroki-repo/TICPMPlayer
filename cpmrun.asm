.org 0d1a881h-2
.db $EF,$7B
.assume ADL=1
	jp main4cpmemu
	.db 1
	.db 16,16
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db "CP/M",0
objname4dimg:
	.db $15,"CPM00000",0
objname4bdata
	.db $15,"BUF4PGIN",0
main4cpmemu:
	ld hl,objname4bdata
	;call 0020320h	;_Mov9ToOP1
	;call 002050Ch	;_ChkFindSym
	;jp nc,main4cpmemu_2
main4cpmemu_1:
	ld hl,0020000h
	;call 0021338h	;_CreateVar
	;ld (ptr4allocedmem+0),hl
	ld bc,0010000h
	add hl,bc
	;ld (ptr4allocedmem+3),hl
	ld hl,(ptr4allocedmem+0)
	ld bc,0020000h
	ld a,0
	ld (disktrk+0),a
	ld (disktrk+1),a
	ld (disktrk+2),a
	;call 0210e0h	;_MemSet
	call backupcpmram_2
	ld bc,010000h
	ld hl,0d00000h
	ld a,0
	call 0210e0h	;_MemSet
	ld bc,biossize
	ld de,0d0fa00h
	ld hl,buffer4trampoline
	ldir
	ld hl,08000h
	ld (diskdma),hl
	ld a,mb
	ld (diskdma+2),a
	ld a,0
	ld (disksec+0),a
	ld (disksec+1),a
	ld (disksec+2),a
	call.lil bios_adl_read
	and a,a
	jp z,cpm00000found
	ld bc,01600h
	ld de,0d0dc00h
	ld hl,cpm62k
	ldir
	ld bc,128
	ld de,0d08000h
	ld hl,cpmbtl
	ldir
cpm00000found:
	;call backupcpmram_2
	ld a,0c3h
	ld hl,08000h
	ld (0d08080h),a
	ld (0d08081h),hl
	ld hl,08000h
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
;lplp:	jr lplp
	call _em180
	ld ix,(ixiybak+0)
	ld iy,(ixiybak+3)
notfound:
	call backupcpmram
	call restorecpmram_2
	ld hl,objname4bdata
	;call 0020320h	;_Mov9ToOP1
	;call 002050Ch	;_ChkFindSym
	;call 0020588h	;_DelVar
	jp 002120Ch	;_ErrCustom1
	ret
main4cpmemu_2:
	;call 0020588h	;_DelVar
	jp main4cpmemu_1
backupcpmram:
	ld hl,0d00000h
	ld de,(ptr4allocedmem+0)
	ld bc,65536
	ldir
	ret
restorecpmram:
	ld hl,(ptr4allocedmem+0)
	ld de,0d00000h
	ld bc,65536
	ldir
	ret

backupcpmram_2:
	ld hl,0d00000h
	ld de,(ptr4allocedmem+3)
	ld bc,65536
	ldir
	ret
restorecpmram_2:
	ld hl,(ptr4allocedmem+3)
	ld de,0d00000h
	ld bc,65536
	ldir
	ret

buffer4trampoline:
.org 0fa00H
.assume ADL=0
biosstart:
	jp bgbioscalltrptoadl+(6*0)
	jp bgbioscalltrptoadl+(6*1)
	jp bgbioscalltrptoadl+(6*2)
	jp bgbioscalltrptoadl+(6*3)
	jp bgbioscalltrptoadl+(6*4)
	jp bgbioscalltrptoadl+(6*5)
	jp bgbioscalltrptoadl+(6*6)
	jp bgbioscalltrptoadl+(6*7)
	jp bgbioscalltrptoadl+(6*8)
	jp bgbioscalltrptoadl+(6*9)
	jp bgbioscalltrptoadl+(6*10)
	jp bgbioscalltrptoadl+(6*11)
	jp bgbioscalltrptoadl+(6*12)
	jp bgbioscalltrptoadl+(6*13)
	jp bgbioscalltrptoadl+(6*14)
	jp bgbioscalltrptoadl+(6*15)
	jp bgbioscalltrptoadl+(6*16)
	jp bgbioscalltrptoadl+(6*17)
	jp bgbioscalltrptoadl+(6*18)
	jp bgbioscalltrptoadl+(6*19)
	jp bgbioscalltrptoadl+(6*20)
	jp bgbioscalltrptoadl+(6*21)
	jp bgbioscalltrptoadl+(6*22)
	jp bgbioscalltrptoadl+(6*23)
	jp bgbioscalltrptoadl+(6*24)
	jp bgbioscalltrptoadl+(6*25)
	jp bgbioscalltrptoadl+(6*26)
	jp bgbioscalltrptoadl+(6*27)
	jp bgbioscalltrptoadl+(6*28)
	jp bgbioscalltrptoadl+(6*29)
	jp bgbioscalltrptoadl+(6*30)
	jp bgbioscalltrptoadl+(6*31)
	jp bgbioscalltrptoadl+(6*32)
biostrpend:
biostrpsize:	.equ (biostrpend-biosstart)
dpbase:
	.dw	0000h, 0000h
	.dw	0000h, 0000h
	.dw	dirbf, dpblk
	.dw	chk00, all00
dpblk:
	.dw	256		;sectors per track
	.db	4		;block shift factor
	.db	15		;block mask - with block shift, sets block size to 1024
	.db	0		;null mask
	.dw	1023		;disk size-1 = number of blocks in a disk - 1
	.dw	256		;directory max = no. directory entries/disk, arbitrary
	.db	240		;alloc 0 -- need 4 bits (blocks) for 256 directory entries -- 
	.db	0		;alloc 1 -- no. bits = (directory max x 32)/block size	
	.dw	0		;check size -- no checking, so zero
	.dw	1		;track offset -- first track for system

;It's for time function!
	.dw 0
	.db 0
	.db 0
	.db 0
	.fill 0ch
bgbioscalltrptoadl:
	call.lil bios_adl_boot
	jp (hl)
	call.lil bios_adl_wboot
	jp (hl)
	call.lil bios_adl_const
	ret
	call.lil bios_adl_conin
	ret
	call.lil bios_adl_conout
	ret
	call.lil bios_adl_list
	ret
	call.lil bios_adl_punch
	ret
	call.lil bios_adl_reader
	ret
	call.lil bios_adl_home
	ret
	call.lil bios_adl_seldsk
	ret
	call.lil bios_adl_settrk
	ret
	call.lil bios_adl_setsec
	ret
	call.lil bios_adl_setdma
	ret
	call.lil bios_adl_read
	ret
	call.lil bios_adl_write
	ret
	call.lil bios_adl_listst
	ret
	call.lil bios_adl_sectran
	ret
	call.lil bios_adl_conost
	ret
	call.lil bios_adl_auxist
	ret
	call.lil bios_adl_auxost
	ret
	call.lil bios_adl_devtbl
	ret
	call.lil bios_adl_devini
	ret
	call.lil bios_adl_drvtbl
	ret
	call.lil bios_adl_multio
	ret
	call.lil bios_adl_flush
	ret
	call.lil bios_adl_move
	ret
	call.lil bios_adl_time
	ret
	call.lil bios_adl_selmem
	ret
	call.lil bios_adl_setbnk
	ret
	call.lil bios_adl_xmove
	ret
	call.lil bios_adl_userf
	ret
	call.lil bios_adl_reserv1
	ret
	call.lil bios_adl_reserv2
	ret
track:	.fill	2		;two bytes for expansion
sector:	.fill	2		;two bytes for expansion
dmaad:	.fill	2		;direct memory address
diskno:	.fill	1		;disk number 0-15

begdat:	.equ	$	 	;beginning of data area
dirbf:	.fill	128	 	;scratch directory area

all00:	.fill	128	 	;allocation vector 0

chk00:	.fill	1		;check vector 0

enddat:	.equ	$	 	;end of data area
datsiz:	.equ	$-begdat;	;size of data area
hstbuf: 	.fill 256		;buffer for host disk sector
addrbeepconf:.db 00h
biosend:
biossize:	.equ biosend-biosstart
.org buffer4trampoline+(biosend-biosstart)
.assume ADL=1

bios_adl_boot:
;lplp_4_wboot:	jr lplp_4_wboot
	;out0 (3),a
	ld a,0
	ld.sis (4),a
	ld a,095h
	ld.sis (3),a
	jp bios_adl_wboot
	ret.l
bios_adl_wboot:
	ld a,0
	ld (disktrk+0),a
	ld (disktrk+1),a
	ld (disktrk+2),a
	ld hl,(cpmbegin)
	ld bc,(cpmsize-1)
	;inc b
	ld c,1
bios_adl_wboot_1:
	ld (diskdma),hl
	ld a,mb
	ld (diskdma+2),a
	ld a,c
	ld (disksec+0),a
	ld a,0
	ld (disksec+1),a
	ld (disksec+2),a
	call.lil bios_adl_read
	and a,a
	jr nz,bios_adl_wboot_2
	inc c
	ld a,l
	add a,080h
	ld l,a
	ld a,h
	adc a,0
	ld h,a
	djnz bios_adl_wboot_1
bios_adl_wboot_2:
	ld bc,(cpmsize-1)
	ld c,128
	mlt bc
	ld hl,(cpmbegin)
	add.sis hl,bc
	ex de,hl
	ld hl,biosstart
	ld bc,biostrpsize
	ldir.sis
	ex de,hl
	ld a,0c3h
	ld.sis (0),a
	ld hl,0fa03h
	ld.sis (1),hl
	ld bc,(bdospos)
	ld hl,(cpmbegin)
	add hl,bc
	ld.sis (5),a
	ld.sis (6),hl
	ld.sis sp,0080h
	ld.sis a,(4)
	ld c,a
	ld hl,(cpmbegin)
	ret.l
bios_adl_const:
	ld.sis a,(3)
	and a,3
	jr z,bios_adl_const_tty
	cp a,1
	jr z,bios_adl_const_crt
	cp a,2
	jp z,bios_adl_listst
	ret.l
bios_adl_const_tty:
	ld a,0h
	ret.l
bios_adl_const_crt:
	call backupcpmram
	call restorecpmram_2
	ld (ixiybak+6),ix
	ld (ixiybak+9),iy
	ld ix,(ixiybak+0)
	ld iy,(ixiybak+3)
	call 02014ch	;GetCSC
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram
	ld (buff4sc),a
	or a,a
	jr z,bios_adl_const_crt_1
	ld a,0ffh
	ret.l
bios_adl_const_crt_1:
	ld a,0h
	ret.l
bios_adl_conin:
	ld.sis a,(3)
	and a,3
	jr z,bios_adl_conin_tty
	cp a,1
	jr z,bios_adl_conin_crt
	cp a,2
	jp z,bios_adl_reader
	ret.l
bios_adl_conin_tty:
	ld a,0h
	ret.l
bios_adl_conin_crt:
	ld a,(buff4sc)
	or a,a
	jr z,bios_adl_conin_crt_2
bios_adl_conin_crt_1:
	ld b,a
	ld a,0
	ld (buff4sc),a
	ld a,b
	ld hl,bios_adl_ksc
	ld bc,0
	ld c,a
	add hl,bc
	ld a,(hl)
	cp a,255
	jr z,bios_adl_conin_crt_3
	cp a,254
	jp z,bios_adl_conin_crt_4
	ret.l
bios_adl_conin_crt_2:
	call backupcpmram
	call restorecpmram_2
	ld (ixiybak+6),ix
	ld (ixiybak+9),iy
	ld ix,(ixiybak+0)
	ld iy,(ixiybak+3)
	call 02014ch	;GetCSC
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram
	or a,a
	jr z,bios_adl_conin_crt_2
	jr bios_adl_conin_crt_1
bios_adl_conin_crt_3:
	call backupcpmram
	call restorecpmram_2
	ld (ixiybak+6),ix
	ld (ixiybak+9),iy
	ld ix,(ixiybak+0)
	ld iy,(ixiybak+3)
	call 02014ch	;GetCSC
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram
	or a,a
	jr z,bios_adl_conin_crt_3
	ld hl,bios_adl_ksc_2
	ld bc,0
	ld c,a
	add hl,bc
	ld a,(hl)
	cp a,255
	jp z,bios_adl_conin_crt_2
	ret.l
bios_adl_conin_crt_4:
	call backupcpmram
	call restorecpmram_2
	ld (ixiybak+6),ix
	ld (ixiybak+9),iy
	ld ix,(ixiybak+0)
	ld iy,(ixiybak+3)
	call 02014ch	;GetCSC
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram
	or a,a
	jr z,bios_adl_conin_crt_4
	ld hl,bios_adl_ksc_3
	ld bc,0
	ld c,a
	add hl,bc
	ld a,(hl)
	cp a,255
	jp z,bios_adl_conin_crt_2
	ret.l
bios_adl_conout:
	ld.sis a,(3)
	and a,3
	jr z,bios_adl_conout_tty
	cp a,1
	jr z,bios_adl_conout_crt
	cp a,2
	jp z,bios_adl_list
	;out0 (4),c
	ret.l
bios_adl_conout_tty:
	ld a,c
	ret.l
bios_adl_conout_crt:
	ld a,c
	call backupcpmram
	call restorecpmram_2
	ld (ixiybak+6),ix
	ld (ixiybak+9),iy
	ld ix,(ixiybak+0)
	ld iy,(ixiybak+3)
	cp a,0ah
	jr z,bios_adl_conout_crt_lf
	cp a,0dh
	jr z,bios_adl_conout_crt_cr
	call 0207b8h	;PutC
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram
	ret.l
bios_adl_conout_crt_cr:
	ld a,0
	ld (0D00596h),a	;curCol
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram
	ret.l
bios_adl_conout_crt_lf:
	;ld a,(0D00595h)	;curRow
	;inc a
	;ld (0D00595h),a	;curRow
	;cp a,6
	;jr nc,bios_adl_conout_crt_lf_skp
	;ld a,6
	;ld (0D00595h),a	;curRow
	ld a,25
	ld (0D00596h),a	;curCol
	ld a,32
	call 0207b8h	;PutC
bios_adl_conout_crt_lf_skp:
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram
	ret.l
bios_adl_list:
	ld.sis a,(3)
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and a,3
	jp z,bios_adl_conout_tty
	cp a,1
	jp z,bios_adl_conout_crt
	ret.l
bios_adl_punch:
	ld.sis a,(3)
	rrca
	rrca
	rrca
	rrca
	and a,3
	jp z,bios_adl_conin_tty
	ret.l
bios_adl_reader:
	ld.sis a,(3)
	rrca
	rrca
	and a,3
	jp z,bios_adl_conin_tty
	ld a,26
	ret.l
bios_adl_home:
	ld bc,0
	ld (disktrk),bc
	ret.l
bios_adl_seldsk:
	ld a,c
	and a,a
	jr nz,bios_adl_seldsk_err
	ld.sis hl,dpbase
	ret.l
bios_adl_seldsk_err:
	ld.sis hl,0
	ret.l
bios_adl_settrk:
	ld (disktrk),bc
	ret.l
bios_adl_setsec:
	ld (disksec),bc
	ret.l
bios_adl_setdma:
	ld (diskdma),bc
	ret.l
bios_adl_read:
	di
	ld (backup4bcdehl+(3*0)),bc
	ld (backup4bcdehl+(3*1)),de
	ld (backup4bcdehl+(3*2)),hl
	call backupcpmram
	call restorecpmram_2
	ld (ixiybak+6),ix
	ld (ixiybak+9),iy
	ld ix,(ixiybak+0)
	ld iy,(ixiybak+3)

	ld a,(disksec)
	call dec2hex
	ld (objname4dimg+8),a
	ld a,(disksec)
	rrca
	rrca
	rrca
	rrca
	call dec2hex
	ld (objname4dimg+7),a

	ld a,(disktrk)
	call dec2hex
	ld (objname4dimg+6),a
	ld a,(disktrk)
	rrca
	rrca
	rrca
	rrca
	call dec2hex
	ld (objname4dimg+5),a

	ld hl,objname4dimg
	call 0020320h	;_Mov9ToOP1
	call 002050Ch	;_ChkFindSym
	ld (0D0257Bh),hl	;tSymPtr1
	jp c,bios_adl_read_ramdisk
	;jp c,bios_adl_rw_error
	call 0021F98h	;_ChkInRam
	jr z,bios_adl_read_inram
	call 0021448h	;_Arc_Unarc
bios_adl_read_inram:
	ld hl,objname4dimg
	call 0020320h	;_Mov9ToOP1
	call 002050Ch	;_ChkFindSym
	ex de,hl
	ld de,dmabuff
	ld bc,128
	ldir
	ex de,hl
	call 002050Ch	;_ChkFindSym
	call 0021448h	;_Arc_Unarc

	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram

	ld hl,dmabuff
	ld a,mb
	ld (diskdma+2),a
	ld de,(diskdma)
	ld bc,128
	ldir

	ld bc,(backup4bcdehl+(3*0))
	ld de,(backup4bcdehl+(3*1))
	ld hl,(backup4bcdehl+(3*2))
	xor a,a
	ei
	ret.l
bios_adl_rw_error:
;lplp_diskroutine:	jr lplp_diskroutine
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram
	ld bc,(backup4bcdehl+(3*0))
	ld de,(backup4bcdehl+(3*1))
	ld hl,(backup4bcdehl+(3*2))
	ld a,0ffh
	ei
	ret.l
bios_adl_read_ramdisk:
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram

	ld hl,0
	ld a,(disktrk)
	ld h,a
	ld a,(disksec)
	ld l,a
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld bc,cpmbtl
	add hl,bc

	ld bc,128
	ld a,mb
	ld (diskdma+2),a
	ld de,(diskdma)
;lplp4ramdisk:	jr lplp4ramdisk
	ldir

	ld bc,(backup4bcdehl+(3*0))
	ld de,(backup4bcdehl+(3*1))
	ld hl,(backup4bcdehl+(3*2))
	ld a,0h
	ei
	ret.l
bios_adl_write:
	di
	ld (backup4bcdehl+(3*0)),bc
	ld (backup4bcdehl+(3*1)),de
	ld (backup4bcdehl+(3*2)),hl

	ld de,dmabuff
	ld a,mb
	ld (diskdma+2),a
	ld hl,(diskdma)
	ld bc,128
	ldir

	call backupcpmram
	call restorecpmram_2
	ld (ixiybak+6),ix
	ld (ixiybak+9),iy
	ld ix,(ixiybak+0)
	ld iy,(ixiybak+3)

	ld a,(disksec)
	call dec2hex
	ld (objname4dimg+8),a
	ld a,(disksec)
	rrca
	rrca
	rrca
	rrca
	call dec2hex
	ld (objname4dimg+7),a

	ld a,(disktrk)
	call dec2hex
	ld (objname4dimg+6),a
	ld a,(disktrk)
	rrca
	rrca
	rrca
	rrca
	call dec2hex
	ld (objname4dimg+5),a

	ld hl,objname4dimg
	call 0020320h	;_Mov9ToOP1
	call 002050Ch	;_ChkFindSym
	ld (0D0257Bh),hl	;tSymPtr1
	jp c,bios_adl_write_newfile
	;jp c,bios_adl_write_ramdisk
	;jp c,bios_adl_rw_error
	call 0021F98h	;_ChkInRam
	jr z,bios_adl_write_inram
	call 0021448h	;_Arc_Unarc
bios_adl_write_inram:
	ld hl,objname4dimg
	call 0020320h	;_Mov9ToOP1
	call 002050Ch	;_ChkFindSym
	ld hl,dmabuff
	ld bc,128
	ldir
	call 002050Ch	;_ChkFindSym
	call 0021448h	;_Arc_Unarc
	
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram
	ld bc,(backup4bcdehl+(3*0))
	ld de,(backup4bcdehl+(3*1))
	ld hl,(backup4bcdehl+(3*2))
	xor a,a
	ei
	ret.l
bios_adl_write_newfile:
	ld hl,objname4dimg
	call 0020320h	;_Mov9ToOP1
	call 002050Ch	;_ChkFindSym
	ld (0D0257Bh),hl	;tSymPtr1
	jr c,bios_adl_write_newfile_1
	call 0021434h	;_DelVarArc
bios_adl_write_newfile_1:
	ld hl,128
	ld a,015h
	call 0021338h	;_CreateVar
	ld hl,dmabuff
	ld bc,128
	call 002050Ch	;_ChkFindSym
	call 0021F98h	;_ChkInRam
	jr nz,bios_adl_write_newfile_2
	call 0021448h	;_Arc_Unarc
bios_adl_write_newfile_2:
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram
	ld bc,(backup4bcdehl+(3*0))
	ld de,(backup4bcdehl+(3*1))
	ld hl,(backup4bcdehl+(3*2))
	xor a,a
	ei
	ret.l
bios_adl_write_ramdisk:
	ld (ixiybak+0),ix
	ld (ixiybak+3),iy
	ld ix,(ixiybak+6)
	ld iy,(ixiybak+9)
	call backupcpmram_2
	call restorecpmram

	ld hl,0
	ld a,(disktrk)
	ld h,a
	ld a,(disksec)
	ld l,a
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld bc,cpmbtl
	add hl,bc

	ld bc,128
	ld a,mb
	ld (diskdma+2),a
	ld de,(diskdma)
	ex de,hl
	ldir
	ex de,hl

	ld bc,(backup4bcdehl+(3*0))
	ld de,(backup4bcdehl+(3*1))
	ld hl,(backup4bcdehl+(3*2))
	ld a,0h
	ei
	ret.l

bios_adl_listst:
	ld.sis a,(3)
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and a,3
	jp z,bios_adl_const_tty
	cp a,1
	jp z,bios_adl_const_crt
	ld a,0
	ret.l
bios_adl_sectran:
	ex de,hl
	add hl,bc
	ret.l
bios_adl_conost:
	ld a,0ffh
	ret.l
bios_adl_auxist:
	ld.sis a,(3)
	rrca
	rrca
	and a,3
	jp z,bios_adl_const_tty
	ld a,0h
	ret.l
bios_adl_auxost:
	ld a,0ffh
	ret.l
bios_adl_devtbl:
	ld hl,0
	ret.l
bios_adl_devini:
	ret.l
bios_adl_drvtbl:
	ld hl,0
	ret.l
bios_adl_multio:
	ret.l
bios_adl_flush:
	ld a,1
	ret.l
bios_adl_move:
	ldir.sis
	ret.l
bios_adl_time:
	ld c,0
	ret.l
bios_adl_selmem:
	ret.l
bios_adl_setbnk:
	ret.l
bios_adl_xmove:
	ret.l
bios_adl_userf:
	cp a,0
	jp z,bios_adl_userf_0
	cp a,1
	jp z,bios_adl_userf_1
	cp a,2
	jp z,bios_adl_userf_2
	ret.l
bios_adl_userf_0:
	ld (cpmbegin),bc
	ld a,mb
	ld (cpmbegin+2),a
	ret.l
bios_adl_userf_1:
	ld (cpmsize),bc
	ret.l
bios_adl_userf_2:
	ld (bdospos),bc
	ld a,0
	ld (bdospos+2),a
	ret.l
bios_adl_reserv1:
	ret.l
bios_adl_reserv2:
	ret.l

cpmbegin:
.dl 0d0dc00h
cpmsize:
.dl 44
bdospos:
.dl 0806h

dmabuff:
.fill 128

ixiybak:
.dl 0
.dl 0
.dl 0
.dl 0

ptr4allocedmem:
.dl backupeddata16384
.dl backupeddata16384_2

buff4sc:
.db 0

bios_adl_ksc:
.db 000,028,029,030,031,013,013,000,000,013,043,045,042,047,094,008
.db 000,000,051,054,057,041,000,000,000,046,050,053,056,040,000,003
.db 032,048,049,052,055,044,000,000,000,000,000,000,000,000,000,000
.db 255,000,000,000,000,000,254,000,000,000,000,000,000,000,000,000
.db 003,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 043,045,042,047,094,040,041,091,093,000,000,044,000,046,048,049
.db 050,051,052,053,054,055,056,057,000,032,065,066,067,068,069,070
.db 071,072,073,074,075,076,077,078,079,080,081,082,083,084,085,086
.db 087,088,089,090,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,058,000,000,000,063,034,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,097,098,099,100,101,102,103,104,105,106,107,108,109,110
.db 111,112,113,114,115,116,117,118,119,120,121,122,255,000,000,000
bios_adl_ksc_2:
.db 000,000,000,000,000,000,000,000,000,000,034,087,082,077,072,000
.db 000,063,000,086,081,076,071,000,000,058,090,085,080,075,070,067
.db 000,095,089,084,079,074,069,066,000,066,088,083,078,073,068,065
.db 255,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,123,125,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
bios_adl_ksc_3:
.db 000,000,000,000,000,000,000,000,000,000,000,093,091,000,000,000
.db 000,000,000,000,000,125,000,000,000,000,000,000,000,123,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,026,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000
.db 000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000


dec2hex:
	and a,0fh
	ld (dec2hex_bchlbak+0),bc
	ld (dec2hex_bchlbak+3),hl
	ld bc,0
	ld hl,dec2hexsmp
	ld c,a
	add hl,bc
	ld a,(hl)
	ld bc,(dec2hex_bchlbak+0)
	ld hl,(dec2hex_bchlbak+3)
	ret
dec2hex_bchlbak:
.dl 0
.dl 0

dec2hexsmp:
.db "0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"

disktrk:
.dl 0
disksec:
.dl 0
diskdma:
.dl 0

backup4bcdehl:
.dl 0
.dl 0
.dl 0

#include "cpu_static.asm"

backupeddata16384:	.equ 0d20000h
;.fill 16384
backupeddata16384_2:	.equ 0d30000h
;.fill 16384

cpmbtl:
.db 0c3h
.dw 0fa00h
.fill 128-3
cpm62k:
#include "CPM.SYS.ASM"