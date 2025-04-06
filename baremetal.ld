MEMORY
{
	FLASH(rx) : ORIGIN = 0x10000000, LENGTH = 2048k
	RAM(rwx) : ORIGIN =  0x20000000, LENGTH = 256k
}

 ENTRY(__boot2_start__)

SECTIONS
{
	.boot2 : {
		__boot2_start__ = .;
		KEEP (*(.boot2))
		. = __boot2_start__ + 0x100;
		__logical_binary_start = .;
		KEEP (*(.vectors))
		. = __logical_binary_start + 0x100;
		KEEP (*(.main))
	} > FLASH	

	.data : {
		 *(.data*)
		 . = ALIGN(4);
	} > RAM AT> FLASH
}
