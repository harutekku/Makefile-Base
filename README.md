# A C/C++/NASM `make` starter project
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
- The GNU compilers are the default compilers - can be switched to `clang` or other compilers that support
  dependency generation
- The Netwide Assembler is the default assembler for x86-64 assembly projects - can probably be switched to 
  other assemblers as well if they support dependency generation
- All the compiled files are placed in the `bin` directory. After successful compilation,
  `make` is invoked recursively in the `bin` directory and the linking is performed
- The final makefile is generated from `.makefile` by `configure.sh` script

### Variables
- You can customize several variables in the `makefile`

| Flag           | Description                           |
|----------------|---------------------------------------|
| `C__`/`ASM`    | Compiler/assembler                    |
| `LD`           | Linker                                |
| `___FLAGS`     | Compiler/assembler flags              |
| `LDFLAGS`      | Linker flags                          |
| `CPPFLAGS`     | Preprocessor flags                    |
| `DEPFLAGS`     | Flags for dependency generation       |
| `OBJDIR`       | Output directory for object files     |
| `DEPDIR`       | Output directory for dependency files |
| `SRCFILES`     | Source files                          |
| `TARGET`       | Name of the final executable          |

# Author
- [Harutekku](https://github.com/harutekku)
