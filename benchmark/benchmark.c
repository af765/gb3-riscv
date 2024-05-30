void Instruction_test(int A)
{
	int B = 8979;
	int C = 1;
	unsigned int D = 17;
	
	unsigned char ch = 'A'; //SB
	unsigned short sh = 0x1234; //SH
	unsigned char *cptr = &ch;
	unsigned short *sptr = &sh;
	signed char ch2 = 'q';
	signed short sh2 = 0x5678;
	signed char *cptr2 = &ch2;
	signed short *sptr2 = &sh2;

	ch2 = *cptr2; //LB
	sh2 = *sptr2; //LH

	ch = *cptr; //LBU
	sh = *sptr; //LHU

	A += 2796; //ADDI
	A += C; //ADD
	A -= B; //SUB

	if (A % 2 == 0 && D < 20) //branching
	{
		A = A >> 2; //SRAI
		A = A >>C; //SRA
		D = D >> 2; //SRLI
		D = D >> C; //SRL

		D = D << 2; //SLLI
		D = D << C; //SLL

		int E = (A < 100) ? 1:0; //SLTI
		E = A < B; //SLT
		unsigned int F = (D < 59) ? 1:0; //SLTUI
		F = A < D; //SLTU

		A = A ^ B; //XOR
		A = A ^ 10; //XORI
		A = A | B; //OR
		A = A | 15; //ORI
		A = A & B; //AND
	}
}

//This should visably blink the LED twice to check the ALU is working
void check_func(void){
	volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
	int cond = 4 + 3 - 5;
	for(int i=0; i<cond; i++){
		//*gDebugLedsMemoryMappedRegister = 0xFF;

		for (int j = 0; j < 400000; j++)
			;

		//*gDebugLedsMemoryMappedRegister = 0x00;

		for (int j = 0; j < 400000; j++)
			;
	}
}

int main(void)
{
	//Verify the ALU works
	check_func();

	volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
	int A = 1;
	int counter = 0;
	
	//Flash to indicate start
	*gDebugLedsMemoryMappedRegister = 0xFF; 
	for (int j = 0; j < 200000; j++)
		;
	*gDebugLedsMemoryMappedRegister = 0x00;

	//Stress the processor
	while(counter<300000){
		Instruction_test(A+counter);
		counter ++;
	}
	
	for (int j = 0; j < 200000; j++)
		;

	//Flash to indicate end
	*gDebugLedsMemoryMappedRegister = 0xFF;
	for (int j = 0; j < 200000; j++)
		;
	*gDebugLedsMemoryMappedRegister = 0x00;

	for (int j = 0; j < 400000; j++)//spin at finish - avoid looping causing issues
		;
	return 0;
}