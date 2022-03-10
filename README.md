# A simple starter project for developing small NASM/C/C++ programs
## Purpose
- This, by no means, is meant to be used in large projects,
  spanning several directories with multiple dependencies
- If you want to build a small program, such as a small network client
  or a simple LL(1) parser, this might be for you

## Structure
```
├── bin
│   └── makefile
├── configure.sh
├── LICENSE
├── .makefile
└── README.md
```

### `bin`
- Contains compiled object files that can be linked together during the final step

### `include`
- Created in `configure.sh` script
- Contains the header/`inc` files

### `src`
- Created in `configure.sh` script
- Contains the source files

## Build system
### General info
- Uses `make` by default with automatic dependency generation
- The GNU compilers are the default compilers - can be switched to `clang++` or `clang-cl.exe` on Windows
- The Netwide Assembler is the default assembler for x86-64 assembly projects - can probably be switched to 
  other assemblers as well if they support dependency generation
- All the compiled files are placed in the `bin` directory. After successful compilation,
  `make` is invoked recursively in the `bin` directory and the linking is performed
- The final makefile is generated from `.makefile` by `configure.sh` script

### Variables
- You can customize several variables in the `makefile`

| Flag           | Description                                   |   
|----------------|-----------------------------------------------|
| `C__`/`ASM`    | Which compiler/assembler to use               |
| `LD`           | Which linker to use                           |
| `___FLAGS`     | What compiler/assembler flags to pass         |
| `LDFLAGS`      | What linker flags to pass                     |
| `CPPFLAGS`     | What preprocessor flags to pass               |
| `DEPFLAGS`     | What flags to pass for dependency generation  |
| `OBJDIR`       | Where to place object files                   |
| `DEPDIR`       | Where to place generated the dependency files |
| `SRCFILES`     | What are the source files                     |
| `TARGET`       | What's the name of the final executable       |

# Author
- [Harutekku](https://github.com/harutekku)