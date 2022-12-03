	.globl	_main
	.align	2
_main:
	stp	x24, x23, [sp, #-64]!
	stp	x22, x21, [sp, #16]
	stp	x20, x19, [sp, #32]
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	sub	sp, sp, #21, lsl #12
	sub	sp, sp, #2000
LoadInputFileRegister:
	adrp	x0, InputFileNameString@PAGE
LoadInputFile:
	add	x0, x0, InputFileNameString@PAGEOFF
LoadFileModeStringRegister:
	adrp	x1, FileModeString@PAGE

; Load the file
LoadFile:
	add	x1, x1, FileModeString@PAGEOFF
	bl	_fopen
	mov	x19, x0
	add	x0, sp, #1, lsl #12
	add	x0, x0, #3920
	mov	w1, #32
	mov	x2, x19
	bl	_fgets
	cbz	x0, CopyVal
	mov	w22, #0
	add	x20, sp, #1, lsl #12
	add	x20, x20, #3920

; Load the file from the file pointer into a char array
LoadFileIntoCharArray:
	mov	x0, x20
	bl	_strlen
	add	x8, x20, x0
	sturb	wzr, [x8, #-1]
	add	x20, x20, #32
	mov	x0, x20
	mov	w1, #32
	mov	x2, x19
	bl	_fgets
	add	w22, w22, #1
	cbnz	x0, LoadFileIntoCharArray
	cbz	w22, CopyVal
	mov	w21, #0
	mov	w20, #0
	add	x19, sp, #1, lsl #12
	add	x19, x19, #3920
	add	x23, sp, #16
	mov	w22, w22
	b	ConvertCharToInt

; Checks if the built string so far is a number, if it is it makes a copy
CheckNums:
	str	w21, [x23, w20, sxtw #2]
	add	w8, w20, #1
	mov	x20, x8
	mov	w21, #0
	add	x19, x19, #32
	subs	x22, x22, #1
	b.eq	CopyNum
ConvertCharToInt:
	mov	x0, x19
	bl	_atoi
	cbz	w0, CheckNums
	add	w21, w0, w21
	add	x19, x19, #32
	subs	x22, x22, #1
	b.ne	ConvertCharToInt
CopyNum:
	cbz	w20, CopyVal
	mov	x10, #0
	mov	w9, #0
	sxth	x8, w20
	add	x11, sp, #16

; Find the first max by going through the nums found
FindFirstMax:
	ldr	w12, [x11, w9, sxtw #2]
	ldr	w13, [x11, x10, lsl #2]
	cmp	w12, w13
	csel	w9, w10, w9, lt
	add	x10, x10, #1
	cmp	x8, x10
	b.ne	FindFirstMax
	mov	x11, #0
	mov	w10, #0
	sbfiz	x13, x9, #2, #32
	add	x12, sp, #16
	ldr	w9, [x12, x13]
	str	wzr, [x12, x13]

; Find the second max
FindSecondMax:
	ldr	w13, [x12, w10, sxtw #2]
	ldr	w14, [x12, x11, lsl #2]
	cmp	w13, w14
	csel	w10, w11, w10, lt
	add	x11, x11, #1
	cmp	x8, x11
	b.ne	FindSecondMax
	mov	x12, #0
	mov	w11, #0
	sbfiz	x14, x10, #2, #32
	add	x13, sp, #16
	ldr	w10, [x13, x14]
	str	wzr, [x13, x14]

; Finds the last Max value by looping through the array one final time
FindMax:
	ldr	w14, [x13, w11, sxtw #2]
	ldr	w15, [x13, x12, lsl #2]
	cmp	w14, w15
	csel	w11, w12, w11, lt
	add	x12, x12, #1
	cmp	x8, x12
	b.ne	FindMax
	sxtw	x8, w11
	b	LoadMax
LoadMax:
	add	x11, sp, #16
	ldr	w8, [x11, x8, lsl #2]
	add	w9, w9, w10
	add	w8, w9, w8
	str	x8, [sp]

LoadFormatStringRegister:
	adrp	x0, FormatString@PAGE
PrintAnswer:
	add	x0, x0, FormatString@PAGEOFF
	bl	_printf
	mov	w0, #0
	add	sp, sp, #21, lsl #12
	add	sp, sp, #2000
	ldp	x29, x30, [sp, #48]
	ldp	x20, x19, [sp, #32]
	ldp	x22, x21, [sp, #16]
	ldp	x24, x23, [sp], #64
	ret
	.loh AdrpAdd	LoadFileModeStringRegister, LoadFile
	.loh AdrpAdd	LoadInputFileRegister, LoadInputFile
	.loh AdrpAdd	LoadFormatStringRegister, PrintAnswer

; Helper Functions
CopyVal:
	mov	w10, #0
	mov	x8, #0
	ldr	w9, [sp, #16]
	str	wzr, [sp, #16]



; ---------------------------------------------------------------------------
; Static Values
InputFileNameString:
	.asciz	"puzzle1.txt"
FileModeString:
	.asciz	"r"
FormatString:
	.asciz	"%d\n"