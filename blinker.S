.cpu cortex-m0plus
.thumb

.section .vectors, "ax"

.word	0x20042000	//start of stack pointer
.word	0x10000201	//reset
// Technically should have another 30 interrupt addresses
// See crt0.s for list/order

.section .main
.global start
start:
	// release the peripheral reset for iobank_0
	ldr r0, =rst_clr // atomic register for clearing reset controller (0x4000c000+0x3000) 
	mov r1, #0x20 // load a 1 into bit 5
	str r1, [r0, #0] // store into atomic register to clear

	// check that hardware reset is done
rst:
	ldr r0, =rst_base // base address for reset controller
	ldr r1, [r0, #0x8] // offset to get to the reset_done register
	mov r2, #0x20 // load 1 in bit 5 of register 2 (...0000000000100000)
	and r1, r1, r2 // isolate bit 5
	beq rst // if bit five is 0 then check again, if not, reset is done


	// set the control
	ldr r0, =ctrl // control register for GPIO25
	mov r1, #5 // Function 5, select SIO for GPIO25 2.19.2
	str r1, [r0] // Store function_5 in GPIO25 control register

	mov r1, #1 // load 1
	lsl r1, r1, #25 // move the bit over to align with GPIO25 (0x02000000)
	ldr r0, =sio_base // SIO base 
	str r1, [r0, #0x24] // 0x24 GPIO output enable set

led_loop:
	str r1, [r0, #0x14] // 0x14 GPIO output value set
	bl delay
	str r1, [r0, #0x18] // 0x18 GPIO output value clear
	bl delay
	b led_loop // Loop

delay:
	ldr r3, =big_num // load countdown number
delay_loop:
	sub r3, #1
	bne delay_loop // loop while not zero
	bx lr

.data
.equ rst_clr, 0x4000f000 // atomic register for clearing reset controller 2.1.2
.equ rst_base, 0x4000c000 // reset controller base 2.14.3
.equ ctrl, 0x400140cc // GPIO25_CTRL 2.19.6.1
.equ sio_base, 0xd0000000 // SIO base 2.3.1.7
.equ big_num, 0x00200000 // large number for the delay loop

