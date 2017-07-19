	org 0x7c00

	xor cx, cx
	mov ds, cx
	mov es, cx
	
	mov si, data_start
	mov di, 0x7e00
	xor ax, ax

decompress:
	; while (ip < ibuf + ilen) {
.next:
	cmp si, data_end
	jae .done

	; ctrl = *ip++
	lodsb

	; al = (ctrl & 0x7), ah = (ctrl >> 3)
	aam 8

	; if ((ctrl & 0x7) == 0) goto .literal
	jz .literal

	; len = (ctrl & 0x7)
	xchg cl, al	; al = 0
	
	; ref = op - ((ctrl >> 3) << 8) - 1
	xor dx, dx
	xchg dh, ah ; ah = 0
	not dx
	add dx, di

	; if (len == 7) len += *ip++
	cmp cl, 7
	jne .format1
.format2:
	lodsb
	add cx, ax
.format1:

	; ref -= *ip++
	lodsb
	sub dx, ax
	
	; while (len--) { *op++ = *ref++; }
	push si
	mov si, dx
	rep movsb
	pop si

	; } /* while */
	jmp .next

.literal:
	; len++
	mov cl, ah

	; while (len--) { *op++ = *ip++; }
	rep movsb

	; } /* while */
	jmp .next

.done:
	; jump to uncompressed payload
	jmp 0x7e00


	; compressed payload
data_start:
	incbin "payload.lzf"
data_end:


	times 512 - ($ - $$) - 2 db 0
	dw 0xaa55