; BRAINWASHER by dox
; 256 bytes speccy intro
; tomasz@slanina.pl

					org 0xe000
start:
					call $d6b	; clear
				
					ld hl,chars-'K'*8
					ld [23606],hl	; set fonts
					
					ld h,2
loop_xx:				
					ld a,'K'
					rst $10 ; print char
					dec hl
					ld a,h
					or l
					jr nz,loop_xx
					
					ld ixh,$e0
				
s_loop:
				
					ld e,32
					ld iy,tab_y
					ld hl,$c000
				
main_loop:
			
					ld a,[iy]
					
					ld [next_op+2],a ; mod the code
					inc iy
				
next_op:			
					ld a,[ix+2]
								
					ld c,a
					and 8
					add a,a
					ld b,a
					ld a,c
						
					and %111	; mask out top bits
					ld [tab_y-1],a
					inc a
		
					ld c,a
		
					push hl
					ld a,e
					ld [tab_c],a
					xor [iy-2]
					
					and 3
					
					ld de,b_col
					add a,e
					ld e,a
					ld a,[de]
					ld d,0	
					or b						
					out [254],a
					ld a,12
					sub c
					
					ld b,a
					push bc				
					ld e,32

loop_1:				
					ld [hl],d
					add hl,de
					djnz loop_1
					
					ld a,c
					add a,a
					ld b,a
					push de
					ld de,tab_c
					ld a,[de]
					add a,e
					ld e,a
					ld a,[de]
					pop de
				
loop_2:	
					ld [hl],a
					add hl,de
					djnz loop_2				
					pop bc

loop_3:				
					ld [hl],d
					add hl,de
					djnz loop_3
					
					pop hl
					inc hl
					
					ld a,[tab_c]
					
					dec a
					ld e,a
					jr nz,main_loop
	
					out [254],a		
					ei
					halt
	
					ld d,$58
					ld hl,$c000
					ld b,$3  ; c ignored
					ldir
	
					ld de,loopw
					ld a,[de]
					inc a
					ld [de],a
code_1:				
					and 3  
					jr nz,s_loop
					ld hl,code_1+1 ; modify the mask
				
					ld b,$20
					inc de
					ld a,[de]	; dirw
					or a
					jr z, sk_1
					dec ixl
					ld [hl],1
				
					jr sk_2
sk_1:
					inc ixl
					ld [hl],3
sk_2:				
					inc de
					
					ld a,[de] 	; cntw
					dec a
					ld [de],a 	; cntw
					jr nz,skip
					dec de
					ld a,[de] 	; dirw
					xor b
					ld [de],a 	; dirw
					add a,b
					inc de
					ld [de],a 	; cntw
skip:
	
					jp s_loop
	
b_col:
					db 6,6,0,2

tab_y:
					db $02,$02,$04,$05,$06,$07,$08,$08,$09,$09,$0a,$0a,$0a,$0b,$0b,$0b
					db $0c,$0c,$0c,$0d,$0d,$0d,$0e,$0e,$0f,$0f,$10,$11,$12,$13,$15,$17

tab_c:	
					db 0,$0, $10, $10, $12, $12
					db $52, $52, $32, $32, $36
					db $36, $76, $76, $3e, $3e
					db $3f, $3f, $3e, $3e, $76
					db $76, $36, $36, $32, $32
					db $52, $52, $12, $12, $10
					db $10, $0
				
chars:	
				
					db %10101010
					db %01010101
					db %10101010
					db %01010101
					db %10101010
					db %01010101
					db %10101010
					db %01010101

; vars

loopw:		                        db 1
dirw:			                db 0
cntw:			                db 1


			
end start