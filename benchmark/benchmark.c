void ALU_test(int A)
{
	int B = 8979;
	int C = 1;

	A += 2796; //Add
	A += C; //Add
	A -= B; //Subtract

	A = A >> 2; //Shift

	A = A ^ 5894; //XOR
	A = A | B; //Bitwise OR
	A = A & B; //Bitwise AND
}

int main(void)
{
	volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
	int A = 1;
	int counter = 0;
	for (int i = 0; i < 100000; i++)
	{
		*gDebugLedsMemoryMappedRegister = 0xFF;
	}
	while(counter<500000)
	{
		*gDebugLedsMemoryMappedRegister = 0x00;
		ALU_test(A+counter);
		counter += 1;
	}
	for (int i = 0; i < 100000; i++)
	{
		*gDebugLedsMemoryMappedRegister = 0xFF;
	}
	return 0;
}