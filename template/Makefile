main: main.o
	ld -macosx_version_min 12.0.0 -o main main.o -lSystem -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -e _start -arch arm64
main.o: main.s
	as -o main.o main.s
