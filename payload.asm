	; Offset where the bootloader will put this after unpacking
	org 0x7e00
	
	; Print the message
	xor ax, ax
	mov ds, ax
	mov si, msg
print:
	lodsb
	test al, al
	jz .done
	mov ah, 0x0e
	int 0x10
	jmp print
.done:
	jmp $

	; ASCII art of a bean
msg:
	db "                                   DICKB", 13, 10
 	db "                               UTTDICKBUTTD", 13, 10
 	db "                          ICKBUT         TDIC", 13, 10
 	db "                         KBUTTDIC         KBU", 13, 10
 	db "                         TTDICKBUT TDICKBU TT", 13, 10
 	db "                        DIC KBUTT DICKBUTTDIC", 13, 10
 	db "                       KBUTTDICKB UTTDICKBUTT", 13, 10
 	db "                      DIC     KBUTTDICK  BUT", 13, 10
 	db "                     TDI                 CKB", 13, 10
 	db "                    UTT                 DIC", 13, 10
 	db "                    KB           UTTDI CKB", 13, 10
 	db "                    UT           TDICK BU            TTDICK", 13, 10
 	db "                    BU           TTDI CKB          UTTD  IC", 13, 10
 	db "                    KB          UTTD  ICKBUTTDIC KBUT  TDI", 13, 10
 	db "                    CK          BUT   TD  IC  KBUTT   DIC", 13, 10
 	db "                    KBU       TTDICK    BUTTDICKB   UTT", 13, 10
 	db "                     DI      CKBUTTD           ICKB  UTTD", 13, 10
 	db "                     ICK       BU          TT    DIC KBUT", 13, 10
 	db "                      TDIC              KB       UTT  DI", 13, 10
 	db "                   C    KBUTT            DI     CKBUTTDI", 13, 10
 	db "                  CKBUTTD ICKBUTTDIC      KB  UTT", 13, 10
 	db "                   DI CKBUT    TDICKBUTTDICKBUT", 13, 10
 	db "                    TDICK     BUTTDI CK", 13, 10
 	db "                     BU        TTD  IC", 13, 10
 	db "                                KBUTT", 0