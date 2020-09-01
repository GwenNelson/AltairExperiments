extern void printf(const char* s,...) __stdc __z88dk_callee;

void main() {
	printf("Hello world\n\r");
	printf("Testing: %s\n\r","YAY!");
	printf("Hex: 0x%x\n\r",0xDEAD);
}
