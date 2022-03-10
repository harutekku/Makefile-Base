#!/bin/bash

setCFiles() {
	[ -f "./src/main.c" ] && echo "INFO: Files already exist, skipping..." && return

	cp ./.makefile ./makefile

    printf "int main(const int argc, const char* argv[]) {\n    return 0;\n}\n" > ./src/main.c

    sed -i -e  's/\bCOMP\b/CC/g'                                                       \
           -e  's/CC\s*:=/CC        := gcc/g'                                          \
           -e  's/LD\s*:=/LD        := gcc/g'                                          \
           -e  's/COMPFLAGS/CFLAGS/g'                                                  \
           -e  's/CFLAGS\s*:=/CFLAGS    := -c -O3 -std=c2x -Wall -Wextra -Wpedantic/g' \
           -e  's/INCEXT\s*:=/INCEXT           := h/g'                                 \
           -e  's/SRCEXT\s*:=/SRCEXT           := c/g'                                 \
           -e  's/SRCFILES\s*:=/SRCFILES         := main.c/g'                          \
           -e  's/COMPILE/COMPILE\.c/g'                                                \
           -e  's/COMPILE\.c           /COMPILE\.c         /g'                        ./makefile
}

setCPPFiles() {
	[ -f "./src/main.cpp" ] && echo "INFO: Files already exist, skipping..." && return

	cp ./.makefile ./makefile

    printf "auto main(const int argc, const char* argv[]) -> int {\n    return 0;\n}\n" > ./src/main.cpp

    sed -i -e  's/\bCOMP\b/CXX/g'                                                          \
           -e  's/CXX\s*:=/CXX       := g++/g'                                             \
           -e  's/LD\s*:=/LD        := g++/g'                                              \
           -e  's/COMPFLAGS/CXXFLAGS/g'                                                    \
           -e  's/CXXFLAGS\s*:=/CXXFLAGS  := -c -O3 -std=c++20 -Wall -Wextra -Wpedantic/g' \
           -e  's/INCEXT\s*:=/INCEXT           := hpp/g'                                   \
           -e  's/SRCEXT\s*:=/SRCEXT           := cpp/g'                                   \
           -e  's/SRCFILES\s*:=/SRCFILES         := main.cpp/g'                            \
           -e  's/COMPILE/COMPILE\.cpp/g'                                                  \
           -e  's/COMPILE.cpp           /COMPILE\.cpp       /g'                           ./makefile
}


setASMFiles() {
	[ -f "./src/main.asm" ] && echo "INFO: Files already exist, skipping..." && return

	pathToLinker=$(find / -name "ld-linux-x86-64.so.2" 2>/dev/null | head -n 1)

	[ -z "$pathToLinker" ] && echo "ERROR: No suitable linker found" && exit 1

	cp ./.makefile ./makefile

    printf "section .text\n    global _start\n\n_start:\n    mov rax,60\n    xor rdi,rdi\n    syscall" > ./src/main.asm

    sed -i -e  's/\bCOMP\b/ASM/g'                                                       \
           -e  's/ASM\s*:=/ASM       := nasm/g'                                         \
           -e  's/LD\s*:=/LD        := ld/g'                                            \
           -e  's/COMPFLAGS/ASMFLAGS/g'                                                 \
           -e  's/ASMFLAGS\s*:=/ASMFLAGS  := -felf64/g'                                 \
		   -e  's,LDFLAGS\s*:=,LDFLAGS   := -dynamic-linker '"$pathToLinker"' -lc,g'    \
           -e  's/INCEXT\s*:=/INCEXT           := inc/g'                                \
           -e  's/SRCEXT\s*:=/SRCEXT           := asm/g'                                \
           -e  's/SRCFILES\s*:=/SRCFILES         := main.asm/g'                         \
		   -e  's/-MMD/-MD/g'                                                           \
           -e  's/COMPILE/ASSEMBLE/g'                                                   \
		   -e  's/ASSEMBLE           /ASSEMBLE          /g'                            ./makefile
}

setFiles() {
    read projectType

    case $projectType in
        C  ) setCFiles  ;;
        CPP) setCPPFiles;;
        ASM) setASMFiles;;
        *  ) echo "ERROR: Unknown project type - accepted types: C, CPP, ASM"; exit 1;;
    esac
}

setExecutableName() {
    read executableName

	[[ ! $executableName =~ ^[a-zA-Z]+$ ]] && echo "ERROR: Invalid project name" && exit 1

	sed -i "s/TARGET\s*:=/TARGET    := $executableName/g" ./makefile
}

checkIfConfigured() {
	[ ! -f "./makefile" ] && return

	echo -n "WARNING: This project is already configured. Do you want to reconfigure it? [Y/n]: "
	read answer

	if [[ $answer =~ ^(Y|y|yes)$ ]]; then
		rm -f ./src/* ./include/* ./bin/*.o
		cp ./.makefile ./makefile
		return
	fi
	exit 0
}

setDirectories() {
	[ ! -d "./src/" ] && mkdir src
	[ ! -d "./include" ] && mkdir include
}

main() {
    echo "Makefiles, v0.1"

	checkIfConfigured

	setDirectories

    echo "Please enter the following information to configure your project"
    echo -n "  Project type: "
    setFiles

	echo -n "  Executable name: "
	setExecutableName

    echo "All done!"
}

main
