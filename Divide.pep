;+-------------------------------------------+
;| Pep/8 Assembly Language
;| ========================================
;| Division of two numbers
;| Using shift-and-subtract algorithm
;| ========================================
;| Author: admin@jcink.com
;| Modified: 9:48 AM Sunday, April 14, 2013
;| ========================================
;| Stolen By: Miles Wearing
;| Transcribed into Pep9
;+-------------------------------------------+
BR main 
;******* int divide (int dvnd, int dvr)
remaindr: .EQUATE 0 ;local variable #2d
quotient: .EQUATE 2 ;local variabl #2d
shifts: .EQUATE 4 ;local variable #2d 
dvr: .EQUATE 8 ;formal parameter #2d
dvnd: .EQUATE 10 ;formal parameter #2d
retVal3: .EQUATE 12 ;formal parameter #2d
divide: LDWA 0x0000,i
SUBSP 6,i ; pop #shifts #quotient #remaindr
STWA shifts,s ;shifts = 0; 
STWA quotient,s ;quotient = 0; 
STWA remaindr,s ;quotient = 0; 
LDWA dvr,s; ;load the divisor
ASLA ;left shift the accumulator
CPWA dvnd,s ;if ((dvr << 1) <= dvnd
BRLE while2 
BR if2 ;skip all of this and go to the second if statement
;outside the while loop 
while2: LDWA 0,i; ;while (dvr <= dvnd) {
LDWA dvr,s ;load the divisor
ASLA ;left shift the divisor
STWA dvr,s ;push dvr 
LDWA shifts,s ;load the shift counter
ADDA 1,i ;shifts++;
STWA shifts,s ;push shifts
LDWA dvr,s
CPWA dvnd,s 
BRLE while2 ;continue looping... }
;note to see if this is working:
;when the while loop ends if you entered 50 and 5,
;you should get a shift count of 4 and dvr should be 80
while3: LDWA 0,i ;while (shifts > 0 ) {
LDWA dvr,s ;load the dvr
CPWA dvnd,s ;if (dvr <= dvnd) {
BRLE w3_if 
BR loopshif 
w3_if: LDWA quotient,s ;load the quotient
ADDA 1,i ;quotient += 1;
STWA quotient,s ;push quotient
LDWA dvnd,s ;load the quotient
SUBA dvr,s ;dvnd -= dvr;
STWA dvnd,s ;push dvnd 
w3_endif: LDWA 0,i ; }
loopshif: LDWA dvr,s ;load the dvr
ASRA ;arithmetic shift right dvr
STWA dvr,s ;push dvr
LDWA quotient,s ;load the quotient
ASLA ;arithmetic shift left quotient
STWA quotient,s ;push quotient
LDWA shifts,s ;load the shift counter
SUBA 1,i ;shifts--;
STWA shifts,s ;push shifts
LDWA shifts,s;
CPWA 0,s 
BRGT while3 ;continue looping... } 
;when the while loop eneds if you entered 50 and 5, 
;you should get a dvr of 5, and dvnd of 0
;DECO dvr,s;
;DECO dvnd,s; 
if2: LDWA dvr,s ;load the dvr
CPWA dvnd,s ;if (dvr <= dvnd) {
BRLE if4
LDWA dvr,s ;load the dvr
CPWA dvnd,s ;else if (dvr > dvnd)
BRGT if5
BR endfunc3
if4: LDWA quotient,s ;load the quotient
ADDA 1,i ;quotient += 1;
STWA quotient,s ;push quotient
LDWA dvnd,s ;load the quotient
SUBA dvr,s ;remainder = dvnd - dvr
STWA remaindr,s ;push remaindr 
BR endfunc3; 
if5: LDWA dvnd,s ;load the quotient
STWA remaindr,s ;push remaindr 
endfunc3: LDWA quotient,s ;Load the quotient, and return it!
STWA retVal3,s
ADDSP 6,i ;WARNING: Number of bytes allocated (6) not equal to number of bytes listed in trace tag (0).
RET ;pop #remaindr #quotient #shifts 
;******* main ()
ret: .EQUATE -2 ;return value from function #2d
num1: .EQUATE 4 ;local variable #2d
num2: .EQUATE 2 ;local variable #2d
result: .EQUATE 0 ;local variable #2d
main: SUBSP 6,i ;allocate #num1 #num2 #result 
STRO prompt1,d
DECI num1,s ;cin >> num1
STRO prompt2,d
DECI num2,s ;cin >> num2
LDWA num1,s ;get num1 into Acc
STWA -4,s ;push n1, skip over return value
LDWA num2,s ;get num2 into Acc
STWA -6,s ;push n2 
SUBSP 6,i ;push #retVal3 #num1 #num2 
CALL divide ;call add function, retAddr automatically pushed onto stack 
ADDSP 6,i ;pop #dvnd #dvr #result
LDWA ret,s
STWA result,s
STRO msg,d 
DECO result,s
ADDSP 6,i ;deallocate #result #num2 #num1 


STOP 
prompt1: .ASCII "Enter the dividend (dvnd) \x00"
prompt2: .ASCII "Enter the divisor (dvr) \x00"
msg: .ASCII "The result is: \x00"
.END 