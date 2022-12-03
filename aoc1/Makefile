main: part1.o
	ld -macosx_version_min 12.0.0 -o part1 part1.o -lSystem -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -e _start -arch arm64
part1.o: part1.s
	as -O3 -o part1.o part1.s
