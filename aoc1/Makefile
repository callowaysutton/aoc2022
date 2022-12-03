part1: part1.o
	ld -macosx_version_min 12.0.0 -o part1 part1.o -lSystem -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -e _main -arch arm64
part1.o: part1.s
	as -o part1.o part1.s

part2: part2.o
	ld -macosx_version_min 12.0.0 -o part2 part2.o -lSystem -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -e _main -arch arm64
part2.o: part2.s
	as -o part2.o part2.s