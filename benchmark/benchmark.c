#include <stdbool.h>

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

bool led_toggle(bool led_state)
{
	volatile unsigned int *gDebugLedsMemoryMappedRegister = (unsigned int *)0x2000;
	if(led_state == 0)
	{
		led_state = 1;
		*gDebugLedsMemoryMappedRegister = 0xFF;
	}else{
		led_state = 0;
		*gDebugLedsMemoryMappedRegister = 0x00;
	}
	return led_state;
}

int main(void)
{
	int A = 1;
	int counter = 0;
	bool led_state = 0;
	while(counter<500)
	{
		if (counter%50==0){
			led_state = led_toggle(led_state);
		} 
		else {
			ALU_test(A+counter);
		}
		counter += 1;
	}

	for (int j = 0; j < 4000; j++)
			;
	return 0;
}