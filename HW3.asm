TITLE Integer & Floating-Point Arithmetic     (HW3.asm)

; Author: Nicolas Barraclough			Date: 2/26/2020
; Course / Project ID: CS271
; Description:
;Write a MASM program to perform the following tasks:
;	1. Display the program title and your name.
;	2. Then get the user's name and greet the user.
;	3. Prompt the user to choose between integer or floating-point arithmetic.
;	4. Using a counted loop, prompt the user to give 5 integer or floating-point numbers based on the
;		choice they did. Push the numbers into the integer or floating-point stack based on the choice
;		they did.
;	5. Calculate and display the sum and the average of the numbers entered.
;	6. Ask the user if they want to perform another calculation or exit.
;	7. When the user chooses to exit the program, display a goodbye message that includes the user�s
;		name and terminate the program.

INCLUDE Irvine32.inc

.data
	progTitle		BYTE	"Integer and Floating-Point Arithmetic",0
	myName			BYTE	"	by Nicolas Barraclough",0
	getName			BYTE	"What is your name? ",0
	userName		BYTE	32 DUP(0)
	greeting		BYTE	"Hello, ",0
	prompt			BYTE	", do you want to perform integer or floating-point arithmetic?",0
	instruct		BYTE	"Please type ", 34, "0", 34, " for integer and ", 34, "1", 34, " for floating-point arithmetic.",0
	choseInt		BYTE	"You chose to perform integer arithmetic. Please enter 5 numbers.",0
	choseFloat	BYTE	"You chose to perform floating-point arithmetic. Please enter 5 numbers.",0
	sumMSG			BYTE	"The sum of the numbers you entered is: ",0
	avgMSG			BYTE	"The average of the numbers you entered is: ",0
	remainder		BYTE	" with a remainder of ",0
	divisor			REAL10	5.0
	redo				BYTE	"Do you want to perform another calculation?",0
	redo2				BYTE	"Please enter ", 34,"0", 34, " for NO or ", 34, "1", 34, " for YES.",0
	goodbye			BYTE	"Goodbye, ",0

.code

Integer PROC
; GET THE DATA
	mov		ECX, 5					; Loop Counter
	mov		EBX, 0					; Set up EBX for arithmetic
	getInts:
	call	ReadInt
	add		EAX, EBX				; CALCULATE SUM
	mov		EBX, EAX
	loop	getInts

; DISPLAY SUM
	mov		EDX, OFFSET sumMSG
	call	WriteString
	call	WriteDec
	call	Crlf

; CALCULATE AVERAGE & DISPLAY
	mov		EDX, OFFSET avgMSG
	call	WriteString
	cdq
	mov		EBX, 5
	div		EBX							; Sum still in EAX
	mov		EBX, EDX					; Remainder in EDX
	call	WriteDec
	mov		EDX, OFFSET remainder
	call	WriteString
	mov		EAX, EBX					; Set up to print remainder
	call	WriteDec
	call	Crlf
	ret
Integer ENDP

Float PROC
; GET THE DATA
	mov		ECX, 5
	getFloats:
	call	ReadFloat
	loop	getFloats

; CALCULATE SUM
	mov		ECX, 4
	addFloats:
	FADD
	loop	addFloats

; DISPLAY SUM
	mov		EDX, OFFSET sumMSG
	call	WriteString
	call	WriteFloat
	FSTP	st(1)						; Make a copy of Sum
	call	Crlf

; CALCULATE AVERAGE & DISPLAY
	FLD		ST(0)
	FLD		divisor
	FDIV
	mov		EDX, OFFSET avgMSG
	call	WriteString
	call	WriteFloat
	call	Crlf
	ret
Float ENDP

main PROC
; INTRODUCTION
	mov		EDX, OFFSET progTitle
	call	WriteString
	mov		EDX, OFFSET myName
	call	WriteString
	call	Crlf
	call	Crlf

; USER INSTRUCTIONS
	mov 	EDX, OFFSET getName
	call	WriteString
	mov		EDX, OFFSET userName
	mov		ECX, 31
	call	ReadString
	call	Crlf
DoAgain:									; If user wants to do arithmetic again,
	mov		EDX, OFFSET greeting			; the program will jump back to here
	call	WriteString
	mov		EDX, OFFSET userName
	call	WriteString
	mov		EDX, OFFSET prompt
	call	WriteString
	call	Crlf
	mov		EDX, OFFSET instruct
	call	WriteString
	call	Crlf
	call	ReadInt
	cmp		EAX, 1
	FINIT
	je		ChooseFloat

ChooseInt:
	mov		EDX, OFFSET choseInt
	call	WriteString
	call	Crlf
	call	Integer
	jmp		AskAgain
ChooseFloat:
	mov		EDX, OFFSET choseFloat
	call	WriteString
	call	Crlf
	call	Float

; CHOOSE BETWEEN CONTINUE OR EXIT
AskAgain:
	mov		EDX, OFFSET redo
	call	WriteString
	call	Crlf
	mov		EDX, OFFSET redo2
	call	WriteString
	call	Crlf
	call	ReadInt
	cmp		EAX, 1
	je		DoAgain

; SAY GOODBYE
	mov		EDX, OFFSET goodbye
	call	WriteString
	mov		EDX, OFFSET userName
	call	WriteString
	call	Crlf
	call	Crlf
	exit
main ENDP

END main
