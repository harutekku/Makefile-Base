# Compiler & Linker
#-----------------------------------------------------------
export ASM       := nasm
export AR        := ar

# Flags
#-----------------------------------------------------------
export ASMFLAGS  := -felf64
export ARFLAGS   := rv
CPPFLAGS         := -I include
DEPFLAGS          = -MT $@ -MD -MP -MF $(DEPDIR)/$*.temp.d

# Directories
#-----------------------------------------------------------
INCDIR           := include
SRCDIR           := src
OBJDIR           := bin
DEPDIR           := dep

# File extensions
#-----------------------------------------------------------
INCEXT           := inc
SRCEXT           := asm

# Files
#-----------------------------------------------------------
SRCFILES         := # Source files
export OBJFILES  := $(SRCFILES:%.$(SRCEXT)=%.o)
DEPFILES         := $(SRCFILES:%.$(SRCEXT)=$(DEPDIR)/%.d)

# Target
#-----------------------------------------------------------
export TARGET    := lib.a

# Final commands
#-----------------------------------------------------------
ASSEMBLE          = $(ASM) $(CPPFLAGS) $(DEPFLAGS) $(ASMFLAGS) 
POSTASSEMBLE      = mv -f $(DEPDIR)/$*.temp.d $(DEPDIR)/$*.d && touch $(OBJDIR)/$@
export LINK       = $(AR) $(ARFLAGS)

# Paths
#-----------------------------------------------------------
vpath %.$(INCEXT)   $(INCDIR) 
vpath %.$(SRCEXT)   $(SRCDIR) 
vpath %.o           $(OBJDIR)

# Rules
#-----------------------------------------------------------
$(TARGET): $(OBJFILES)
	make --directory=$(OBJDIR)/

%.o: %.$(SRCEXT)
%.o: %.$(SRCEXT) $(DEPDIR)/%.d | $(DEPDIR)
	@echo Compiling $@
	@$(ASSEMBLE) -o $(OBJDIR)/$@ $<
	@echo Updating timestamps...
	@$(POSTASSEMBLE)

$(DEPDIR): ; @mkdir -p $@

$(DEPFILES):
include $(wildcard $(DEPFILES))
