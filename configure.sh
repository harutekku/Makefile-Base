#!/bin/bash

printHelp() {
    echo -e "Makefiles v0.1.1\n"                                                                             \
            "\rUsage: ./configure.sh [--help]\n\n"                                                           \
            "\rDescription:\n"                                                                               \
            "\rConfigure the current directory for C, C++ or NASM project\n"                                 \
            "\rIn order for the configuration process to succeed,"                                           \
            "you need to specify the following parameters:\n"                                                \
            "\r- Project type:\n"                                                                            \
            "\r    LIB if you want to create a library or EXE if you want to build executable\n"             \
            "\r- Project language:\n"                                                                        \
            "\r    C for C project, CPP for C++ one and ASM for NASM-based solution\n"                       \
            "\r- Target name:\n"                                                                             \
            "\r    The name of the final library/executable. Allowed names only include ASCII\n"             \
            "\r    characters and dots for specifying extensions\n\n"                                        \
            "\rAuthor:\n"                                                                                    \
            "\rHarutekku"
}

setForC() {
    sed -i -e  's|\bCOMP\b|CC|g'                                                          \
           -e  's|CC\s*:=.*$|CC        := gcc|g'                                          \
           -e  's|LD\s*:=.*$|LD        := gcc|g'                                          \
           -e  's|COMPFLAGS|CFLAGS|g'                                                     \
           -e  's|CFLAGS\s*:=.*$|CFLAGS    := -c -O3 -std=c2x -Wall -Wextra -Wpedantic|g' \
           -e  's|INCEXT\s*:=.*$|INCEXT           := h|g'                                 \
           -e  's|SRCEXT\s*:=.*$|SRCEXT           := c|g'                                 \
           -e  's|COMPILE|COMPILE\.c|g'                                                   \
           -e  's|COMPILE\.c           |COMPILE\.c         |g'                            \
           -e  's|POSTCOMPILE.c       =|POSTCOMPILE.c     =|g'                           ./makefile
}

setForCPP() {
    sed -i -e  's|\bCOMP\b|CXX|g'                                                             \
           -e  's|CXX\s*:=.*$|CXX       := g++|g'                                             \
           -e  's|LD\s*:=.*$|LD        := g++|g'                                              \
           -e  's|COMPFLAGS|CXXFLAGS|g'                                                       \
           -e  's|CXXFLAGS\s*:=.*$|CXXFLAGS  := -c -O3 -std=c++20 -Wall -Wextra -Wpedantic|g' \
           -e  's|INCEXT\s*:=.*$|INCEXT           := hpp|g'                                   \
           -e  's|SRCEXT\s*:=.*$|SRCEXT           := cpp|g'                                   \
           -e  's|COMPILE|COMPILE\.cpp|g'                                                     \
           -e  's|COMPILE.cpp           |COMPILE\.cpp       |g'                               \
           -e  's|POSTCOMPILE.cpp       =|POSTCOMPILE.cpp   =|g'                             ./makefile
}


setForASM() {
    pathToLinker=$(find / -name "ld-linux-x86-64.so.2" -print -quit 2>/dev/null)

    [ -z "$pathToLinker" ] && echo "ERROR: No suitable linker found" && exit 1

    sed -i -e  's|\bCOMP\b|ASM|g'                                                          \
           -e  's|ASM\s*:=.*$|ASM       := nasm|g'                                         \
           -e  's|LD\s*:=.*$|LD        := ld|g'                                            \
           -e  's|COMPFLAGS|ASMFLAGS|g'                                                    \
           -e  's|ASMFLAGS\s*:=.*$|ASMFLAGS  := -felf64|g'                                 \
           -e  's|LDFLAGS\s*:=.*$|LDFLAGS   := -dynamic-linker '"$pathToLinker"' -lc -o|g' \
           -e  's|INCEXT\s*:=.*$|INCEXT           := inc|g'                                \
           -e  's|SRCEXT\s*:=.*$|SRCEXT           := asm|g'                                \
           -e  's|-MMD|-MD|g'                                                              \
           -e  's|COMPILE|ASSEMBLE|g'                                                      \
           -e  's|ASSEMBLE           |ASSEMBLE          |g'                                \
           -e  's|POSTASSEMBLE       =|POSTASSEMBLE      =|g'                             ./makefile
}

setExecutable() {
    cp ./.makefile ./makefile

    sed -i -e 's|\bLNK\b|LD|g'                       \
           -e 's|\LNKFLAGS|LDFLAGS|g'                \
           -e 's|LDFLAGS\s*:=.*$|LDFLAGS   := -o|g' ./makefile
}

setLibrary() {
    cp ./.makefile ./makefile

    sed -i -e 's|\bLNK\b|AR|g'                       \
           -e 's|\LNKFLAGS|ARFLAGS|g'                \
           -e 's|AR\s*:=.*$|AR        := ar|g'       \
           -e 's|ARFLAGS\s*:=.*$|ARFLAGS   := rv|g' ./makefile
}

setProjectLanguage() {
    read projectLanguage

    case $projectLanguage in
        C  ) setForC  ;;
        CPP) setForCPP;;
        ASM) setForASM;;
        *  ) echo "ERROR: Unknown project language - accepted lanuages: C, CPP, ASM"; exit 1;;
    esac
}

setProjectType() {
    read projectType

    case $projectType in
        EXE) setExecutable;;
        LIB) setLibrary   ;;
        *  ) echo "ERROR: Invalid project type - accepted types: EXE, LIB"; exit 1;;
    esac
}

setTargetName() {
    read targetName

    [[ ! $targetName =~ ^[\.a-zA-Z]+$ ]] &&  echo "ERROR: Invalid project name" && exit 1

    sed -i "s|TARGET\s*:=.*$|TARGET    := $targetName|g" ./makefile
}


checkIfConfigured() {
    [ ! -f "./makefile" ] && return

    echo -n "WARNING: This project is already configured. Do you want to reconfigure it? [Y/n]: "
    read answer

    if [[ $answer =~ ^(Y|y|yes)$ ]]; then
        rm -f ./src/* ./include/* ./bin/*.o ./dep/*
        return
    fi
    exit 0
}

setDirectories() {
    mkdir -p src
    mkdir -p include
}

main() {
    echo "Makefiles, v0.1.1"

    checkIfConfigured

    setDirectories

    echo "Please enter the following information to configure your project"
    echo -n "  Project type: "
    setProjectType

    echo -n "  Project language: "
    setProjectLanguage

    echo -n "  Target name: "
    setTargetName

    echo "All done!"
}

[ "$1" = "--help" ] && printHelp && exit 1

main
