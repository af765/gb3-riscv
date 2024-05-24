int main(void)
{
	volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
	int A = 3;
	int B = 5;
	int counter = A + B;
	while(counter>0)
	{
		for (int i = 0; i < 100000; i++)
		{
			*gDebugLedsMemoryMappedRegister = 0xFF;
		}
		for (int i = 0; i < 100000; i++)
		{
			*gDebugLedsMemoryMappedRegister = 0x00;
		}
		counter -= 1;
	}
	for (int i = 0; i < 5000000; i++)
	{
		*gDebugLedsMemoryMappedRegister = 0x00;
	}
	return 0;
}
