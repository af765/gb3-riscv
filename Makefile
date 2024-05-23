.PHONY: \
	softwareblink \
	hardwareblink \
	bubblesort \
	template \
	benchmark \
	clean

softwareblink:
	cd softwareblink; make; make install
	cd processor; make

hardwareblink:
	cd hardwareblink; make clean; make;

bubblesort:
	cd bubblesort; make; make install
	cd processor; make

template:
	cd template; make; make install
	cd processor; make

benchmark:
	cd benchmark; make; make install
	cd processor; make

clean:
	cd softwareblink; make clean
	cd hardwareblink; make clean
	cd bubblesort; make clean
	cd template; make clean
	cd benchmark; make clean
	cd processor; make clean
	rm -f build/*.bin
	rm -f build/*.txt
