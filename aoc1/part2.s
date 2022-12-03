	.globl	_main
	.align	2
_main:
; Calculate the addresses from precalculated offsets and load into the registers
; Set up the char array
	stp	x28, x27, [sp, #-64]!
	stp	x22, x21, [sp, #16]
	stp	x20, x19, [sp, #32]
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	sub	sp, sp, #19, lsl #12
	sub	sp, sp, #2192
; Load input file and the file mode string char arrays into the registers
LoadInputFileRegister:
	adrp	x0, InputFileNameString@PAGE
LoadInputFile:
	add	x0, x0, InputFileNameString@PAGEOFF
LoadFileModeStringRegister:
	adrp	x1, FileModeString@PAGE

; Open the input file
LoadFileModeString:
	add	x1, x1, FileModeString@PAGEOFF
	bl	_fopen
	mov	x19, x0
	add	x0, sp, #16
	mov	w1, #32
	mov	x2, x19
	bl	_fgets
	cbz	x0, CopyChar
	mov	w21, #0
	add	x20, sp, #16

; Loop through the input file and load chars into the array until reaching an EOF
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
	add	w21, w21, #1
	cbnz	x0, LoadFileIntoCharArray
	mov	w20, #0
	cbz	w21, StoreMax
	mov	w22, #0
	add	x19, sp, #16
	mov	w21, w21

; Go through char array and find max sum
ConvertCharToInt:
	mov	x0, x19
	bl	_atoi
	add	w8, w0, w22
	cmp	w0, #0
	csel	w8, wzr, w8, eq
	cmp	w22, w20
	ccmp	w0, #0, #0, gt
	csel	w20, w22, w20, eq
	add	x19, x19, #32
	mov	x22, x8
	subs	x21, x21, #1
	b.ne	ConvertCharToInt
	b	StoreMax ; If sum is greater than the max sum, switch the values
StoreMax:
	str	x20, [sp]

; Print out the answer
LoadFormatStringRegister:
	adrp	x0, FormatString@PAGE
PrintAnswer:
	add	x0, x0, FormatString@PAGEOFF
	bl	_printf
	mov	w0, #0
	add	sp, sp, #19, lsl #12
	add	sp, sp, #2192
	ldp	x29, x30, [sp, #48]
	ldp	x20, x19, [sp, #32]
	ldp	x22, x21, [sp, #16]
	ldp	x28, x27, [sp], #64
	ret
	.loh AdrpAdd	LoadFileModeStringRegister, LoadFileModeString
	.loh AdrpAdd	LoadInputFileRegister, LoadInputFile
	.loh AdrpAdd	LoadFormatStringRegister, PrintAnswer

; Copy from register to offset
CopyChar:
	mov	w20, #0

; ---------------------------------------------------------------------------
; Static Values
InputFileNameString:
	.ascii	"puzzle1.txt\0"
FileModeString:
	.ascii	"r\0"
FormatString:
	.ascii	"%d\n\0"