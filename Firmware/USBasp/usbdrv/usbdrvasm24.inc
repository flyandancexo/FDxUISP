/* Name: usbdrvasm24.inc
 * Project: V-USB, virtual USB port for Atmel AVR microcontrollers
 * Target: classic AVR core (AVRe/AVRe+), including ATmega88
 * Clock: 24 MHz
 * Author: OpenAI adaptation for classic AVR, based on the V-USB clock-specific
 *         assembly structure and the experimental 24 MHz AVRxt implementation
 *         by Antigravity/AZHANAMEEN.
 * Creation Date: 2026-07-21
 * Tabsize: 4
 * License: GNU GPL v2, GNU GPL v3, or the applicable V-USB commercial license.
 *
 * EXPERIMENTAL:
 * This module has not been electrically validated on a 24 MHz ATmega88.
 * All receive/transmit paths are cycle counted for the classic AVR instruction
 * timings: PUSH=2, ST=2, SBI=2, LDS=2, POP=2 cycles.
 */

/* Do not link this file directly. Link usbdrvasm.S, which includes the
 * clock-specific implementation selected by USB_CFG_CLOCK_KHZ.
 */

/*
General Description:
This is an experimental 24 MHz implementation for the classic AVR core.
At 24 MHz, one low-speed USB bit occupies exactly 16 CPU cycles and one byte
occupies 128 cycles.

Timing-critical code must not be edited without recounting every path.
*/

; max stack usage:
; [ret(2), YL, SREG, YH, bitcnt, shift, x1, x2, x3, x4, cnt] = 12 bytes
; nominal frequency: 24 MHz -> 16 cycles per bit, 128 cycles per byte

USB_INTR_VECTOR:
; Register push order: YL, SREG, YH, bitcnt, shift, x1, x2, x3, x4, cnt
    push    YL                  ;[-28] classic AVR PUSH = 2 cycles
    in      YL, SREG            ;[-26]
    push    YL                  ;[-25]
    push    YH                  ;[-23]

;----------------------------------------------------------------------------
; Synchronize with the USB sync pattern.
; D- sync pattern, least significant bit first: 01010100
;----------------------------------------------------------------------------
waitForJ:
    inc     YL
    sbis    USBIN, USBMINUS
    brne    waitForJ            ; timeout protection: YL is below 0x80

waitForK:
; Sampling window is below one quarter of a USB bit.
    sbis    USBIN, USBMINUS     ;[-21]
    rjmp    foundK              ;[-20]
    sbis    USBIN, USBMINUS
    rjmp    foundK
    sbis    USBIN, USBMINUS
    rjmp    foundK
    sbis    USBIN, USBMINUS
    rjmp    foundK
    sbis    USBIN, USBMINUS
    rjmp    foundK
    sbis    USBIN, USBMINUS
    rjmp    foundK
    sbis    USBIN, USBMINUS
    rjmp    foundK
    sbis    USBIN, USBMINUS
    rjmp    foundK
    sbis    USBIN, USBMINUS
    rjmp    foundK
#if USB_COUNT_SOF
    lds     YL, usbSofCount
    inc     YL
    sts     usbSofCount, YL
#endif
#ifdef USB_SOF_HOOK
    USB_SOF_HOOK
#endif
    rjmp    sofError

foundK:                         ;[-18]
; The falling D- edge is found after 3 or 5 cycles, averaging 4 cycles.
; The receiver samples on a 16-cycle grid.
    push    bitcnt              ;[-18] classic AVR PUSH = 2 cycles
    lds     YL, usbInputBufOffset ;[-16] classic AVR LDS = 2 cycles
    nop                         ;[-14] match the 3-cycle setup slot
    clr     YH                  ;[-13]
    subi    YL, lo8(-(usbRxBuf));[-12]
    sbci    YH, hi8(-(usbRxBuf));[-11]
    push    shift               ;[-10] classic AVR PUSH = 2 cycles
    ldi     bitcnt, 0x55        ;[-8]
    sbis    USBIN, USBMINUS     ;[-7]
    rjmp    haveTwoBitsK        ;[-6]
    pop     shift               ;[-5]
    pop     bitcnt              ;[-3]
    rjmp    waitForK            ;[-1]
; waitForK through this retry path remains below two USB bit times.

;----------------------------------------------------------------------------
; Save the remaining registers and sample the first data bit.
;----------------------------------------------------------------------------
haveTwoBitsK:
    push    x1                  ;[-5]
    push    x2                  ;[-3]
    push    x3                  ;[-1]
    ldi     shift, 0            ;[1]
    ldi     x3, 1 << 4          ;[2] first sample is inverted; compensate it
    push    x4                  ;[3]
    in      x1, USBIN           ;[5] sample bit 0
    andi    x1, USBMASK         ;[6]
    bst     x1, USBMINUS        ;[7]
    bld     shift, 7            ;[8]
    push    cnt                 ;[9]
    ldi     cnt, USB_BUFSIZE    ;[11]
    nop                         ;[12]
    nop                         ;[13]
    nop                         ;[14]
    nop                         ;[15]
    nop                         ;[16]
    nop                         ;[17]
    nop                         ;[18]
    nop                         ;[19]
    nop                         ;[20]
; Fall through to rxbit1. The first sample there starts a new 16-cycle bit.

;----------------------------------------------------------------------------
; Receiver loop. Bracketed numbers are cycles within a 16-cycle USB bit.
;----------------------------------------------------------------------------
rxByteLoop:
    brcc    rxByteLoop_taken    ;[1],[2]
    rjmp    overflow            ;[3]

unstuff6_jump:
    rjmp    unstuff6

rxByteLoop_taken:
    andi    x1, USBMASK         ;[3]
    eor     x2, x1              ;[4]
    subi    x2, 1               ;[5]
    ror     shift               ;[6]

didUnstuff6:
    cpi     shift, 0xfc         ;[7]
    brcc    unstuff6_jump       ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    nop                         ;[14]
    nop                         ;[15]
    in      x2, USBIN           ;[16]/[0] sample bit 7
    brcc    unstuff6_jump       ;[1]
    andi    x2, USBMASK         ;[2]
    eor     x1, x2              ;[3]
    subi    x1, 1               ;[4]
    ror     shift               ;[5]

didUnstuff7:
    cpi     shift, 0xfc         ;[6]
    brcc    unstuff7_jump       ;[7]
    eor     x3, shift           ;[8] reconstruct bits changed by NRZI decode
    st      y+, x3              ;[9],[10] classic AVR ST = 2 cycles
    ldi     bitcnt, 3           ;[11]
    nop                         ;[12]
    nop                         ;[13]
    rjmp    rxBitLoop           ;[14],[15]

unstuff7_jump:
    rjmp    unstuff7

rxBitLoop:
    in      x1, USBIN           ;[0] sample bit 0/2/4
    andi    x1, USBMASK         ;[1]
    eor     x2, x1              ;[2]
    andi    x3, 0x3f            ;[3] bits 6 and 7 are handled separately
    subi    x2, 1               ;[4]
    ror     shift               ;[5]
    cpi     shift, 0xfc         ;[6]
    brcc    unstuffEven         ;[7]

didUnstuffE:
    lsr     x3                  ;[8]
    lsr     x3                  ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    nop                         ;[14]
    nop                         ;[15]

rxbit1:
    in      x2, USBIN           ;[0] sample bit 1/3/5
    andi    x2, USBMASK         ;[1]
    breq    se0_jump            ;[2]
    eor     x1, x2              ;[3]
    subi    x1, 1               ;[4]
    ror     shift               ;[5]
    cpi     shift, 0xfc         ;[6]
    brcc    unstuffOdd          ;[7]

didUnstuffO:
    dec     bitcnt              ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    brne    rxBitLoop_jump      ;[14],[15]

; Process bit 6 and check the receive-buffer limit.
    subi    cnt, 1              ;[15]
    in      x1, USBIN           ;[16]/[0] sample bit 6
    brcc    rxByteLoop_jump     ;[1],[2]
    rjmp    overflow            ;[3]

rxBitLoop_jump:
    rjmp    rxBitLoop

rxByteLoop_jump:
    rjmp    rxByteLoop

se0_jump:
    rjmp    se0

;----------------------------------------------------------------------------
; Receive-side bit unstuffing paths.
;----------------------------------------------------------------------------
unstuffEven:
    ori     x3, 1 << 6          ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    nop                         ;[14]
    nop                         ;[15]
    in      x1, USBIN           ;[16]/[0] sample the actual data bit
    andi    shift, 0x7f        ;[1]
    andi    x1, USBMASK         ;[2]
    breq    se0_jump            ;[3]
    rjmp    unstuffEven_back    ;[4],[5]

unstuffEven_back:
    lsr     x3                  ;[6]
    lsr     x3                  ;[7]
    nop                         ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    rjmp    rxbit1              ;[14],[15]

unstuffOdd:
    ori     x3, 1 << 5          ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    nop                         ;[14]
    nop                         ;[15]
    in      x2, USBIN           ;[16]/[0] sample the actual data bit
    andi    shift, 0x7f        ;[1]
    andi    x2, USBMASK         ;[2]
    breq    se0_jump            ;[3]
    rjmp    unstuffOdd_back     ;[4],[5]

unstuffOdd_back:
    dec     bitcnt              ;[6]
    nop                         ;[7]
    nop                         ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    brne    rxBitLoop_jump      ;[14],[15]
    subi    cnt, 1              ;[15]
    in      x1, USBIN           ;[16]/[0] sample bit 6
    brcc    rxByteLoop_jump     ;[1],[2]
    rjmp    overflow            ;[3]

unstuff6:
    andi    x2, USBMASK         ;[3]
    ori     x3, 1 << 6          ;[4]
    andi    shift, 0x7f        ;[5]
    mov     x1, x2              ;[6]
    nop                         ;[7]
    nop                         ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    rjmp    didUnstuff6_back    ;[14],[15]

unstuff6_jump2:
    rjmp    unstuff6

didUnstuff6_back:
    in      x2, USBIN           ;[16]/[0] sample actual bit 7
    brcc    unstuff6_jump2      ;[1]
    andi    x2, USBMASK         ;[2]
    eor     x1, x2              ;[3]
    subi    x1, 1               ;[4]
    ror     shift               ;[5]
    rjmp    didUnstuff7         ;[6],[7]

unstuff7:
    ori     x3, 1 << 7          ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    nop                         ;[14]
    nop                         ;[15]
    in      x2, USBIN           ;[16]/[0] re-sample bit 7
    andi    x2, USBMASK         ;[1]
    andi    shift, 0x7f        ;[2]
    nop                         ;[3]
    nop                         ;[4]
    nop                         ;[5]
    nop                         ;[6]
    nop                         ;[7]
    nop                         ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    rjmp    didUnstuff7_back    ;[14],[15]

didUnstuff7_back:
    eor     x3, shift           ;[16]/[0]
    st      y+, x3              ;[1],[2] classic AVR ST = 2 cycles
    ldi     bitcnt, 3           ;[3]
    nop                         ;[4]
    nop                         ;[5]
    nop                         ;[6]
    nop                         ;[7]
    nop                         ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    rjmp    rxBitLoop_jump      ;[14],[15]

macro POP_STANDARD              ; 14 cycles on classic AVR
    pop     cnt
    pop     x4
    pop     x3
    pop     x2
    pop     x1
    pop     shift
    pop     bitcnt
    endm

macro POP_RETI                  ; 7 cycles
    pop     YH
    pop     YL
    out     SREG, YL
    pop     YL
    endm

#include "asmcommon.inc"

;----------------------------------------------------------------------------
; Transmit helpers.
; Classic AVR maps r0-r31 into data addresses 0x00-0x1f, so Y=20 points
; directly at x3/r20 for one-byte ACK/NAK packets.
;----------------------------------------------------------------------------
sendNakAndReti:
    ldi     x3, USBPID_NAK      ;[-18]
    rjmp    sendX3AndReti       ;[-17]

sendAckAndReti:
    ldi     cnt, USBPID_ACK     ;[-17]

sendCntAndReti:
    mov     x3, cnt             ;[-16]

sendX3AndReti:
    ldi     YL, 20              ;[-15] x3 is r20, data-space address 20
    ldi     YH, 0               ;[-14]
    ldi     cnt, 2              ;[-13]
    rjmp    usbSendAndReti      ; single-byte replies start two cycles later

;----------------------------------------------------------------------------
; Transmit-side bit-stuff helper for bits 0 through 5.
;----------------------------------------------------------------------------
bitstuffN:
    eor     x1, x4              ;[6]
    ldi     x2, 0               ;[7]
    nop                         ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    nop                         ;[14]
    nop                         ;[15]
    out     USBOUT, x1          ;[16]/[0] output stuff bit
    rjmp    didStuffN           ;[1],[2]

;----------------------------------------------------------------------------
; USB transmitter.
; Y points to the data. cnt includes the sync byte and ranges from 2 to 12.
;----------------------------------------------------------------------------
usbSendAndReti:                 ; 12 cycles until start of packet
    in      x2, USBDDR          ;[-12]
    ori     x2, USBMASK         ;[-11]
    sbi     USBOUT, USBMINUS    ;[-10],[-9] classic AVR SBI = 2 cycles
    in      x1, USBOUT          ;[-8]
    out     USBDDR, x2          ;[-7] acquire bus
    ldi     x4, USBMASK         ;[-6]
    ldi     shift, 0x80         ;[-5] sync byte

txByteLoop:
    ldi     bitcnt, 0x35        ;[-4]

txBitLoop:
    sbrs    shift, 0            ;[-3]
    eor     x1, x4              ;[-2]
    nop                         ;[-1]
    nop                         ;[0]
    nop                         ;[1]
    nop                         ;[2]
    nop                         ;[3]
    nop                         ;[4]
    nop                         ;[5]
    nop                         ;[6]
    nop                         ;[7]
    nop                         ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    brcc    txBitLoop_back      ;[14],[15]

bitstuffN_jump:
    rjmp    bitstuffN

txBitLoop_back:
    out     USBOUT, x1          ;[16]/[0] output bits 0 through 5
    ror     shift               ;[1]
    ror     x2                  ;[2]

didStuffN:
    cpi     x2, 0xfc            ;[3]
    brcc    bitstuffN_jump      ;[4]
    lsr     bitcnt              ;[5]
    nop                         ;[6]
    nop                         ;[7]
    nop                         ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    brcc    txBitLoop           ;[14],[15]
    brne    txBitLoop           ;[16]/[0]

; Output bit 6.
    sbrs    shift, 0            ;[1]
    eor     x1, x4              ;[2]
    nop                         ;[3]
    nop                         ;[4]
    nop                         ;[5]
    nop                         ;[6]
    nop                         ;[7]
    nop                         ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    nop                         ;[14]
    out     USBOUT, x1          ;[15]

didStuff6:
    ror     shift               ;[0]
    ror     x2                  ;[1]
    cpi     x2, 0xfc            ;[2]
    brcs    noStuff6            ;[3],[4]
    nop                         ;[4]
    eor     x1, x4              ;[5]
    ldi     x2, 0               ;[6]
    rol     shift               ;[7]
    nop                         ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    rjmp    didStuff6           ;[13],[14], stuff bit output at [15]

noStuff6:
    ror     shift               ;[5]

didStuff7:
    ror     x2                  ;[6]
    sbrs    x2, 7               ;[7]
    eor     x1, x4              ;[8]
    cpi     x2, 0xfc            ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    nop                         ;[14]
    out     USBOUT, x1          ;[15] output bit 7
    brcs    noStuff7            ;[0],[1]
    nop                         ;[1]
    ldi     x2, 0               ;[2]
    nop                         ;[3]
    rjmp    didStuff7           ;[4],[5], stuff bit output at [15]

noStuff7:
    ld      shift, y+           ;[2],[3]
    dec     cnt                 ;[4]
    nop                         ;[5]
    nop                         ;[6]
    nop                         ;[7]
    nop                         ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    breq    txDone              ;[13],[14]
    rjmp    txByteLoop          ;[14],[15]

txDone:
; Generate SE0, assign a new USB address only after a data packet, then release.
    cbr     x1, USBMASK         ;[15]
    lds     x2, usbNewDeviceAddr;[16]/[0], [1]
    nop                         ;[2] classic LDS is one cycle shorter than AVRxt
    lsl     x2                  ;[3]
    subi    YL, 20 + 2          ;[4] zero only for the single-byte PID buffer
    sbci    YH, 0               ;[5]
    nop                         ;[6]
    nop                         ;[7]
    nop                         ;[8]
    nop                         ;[9]
    nop                         ;[10]
    nop                         ;[11]
    nop                         ;[12]
    nop                         ;[13]
    nop                         ;[14]
    out     USBOUT, x1          ;[15] begin SE0

    breq    skipAddrAssign      ;[0]
    sts     usbDeviceAddr, x2
skipAddrAssign:
    ldi     x2, 1 << USB_INTR_PENDING_BIT
    USB_STORE_PENDING(x2)
#if USB_INTR_PENDING < 0x40
    nop                         ; keep this slot two cycles for fixed EOP timing
#endif
    ori     x1, USBIDLE
    in      x2, USBDDR
    cbr     x2, USBMASK
    mov     x3, x1
    cbr     x3, USBMASK
    ldi     x4, 6
se0Delay:
    dec     x4
    brne    se0Delay
    nop
    nop
    nop
    out     USBOUT, x1          ; end SE0: drive J
    out     USBDDR, x2          ; release bus
    out     USBOUT, x3          ; disable pull-ups on both USB pins
    rjmp    doReturn
