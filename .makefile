# Compiler & Linker
#-----------------------------------------------------------
export COMP      := 
export LNK       := # Don't use LD unless you need to

# Flags
#-----------------------------------------------------------
export COMPFLAGS := 
export LNKFLAGS  := 
CPPFLAGS         := -I include
DEPFLAGS          = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.temp.d

# Directories
#-----------------------------------------------------------
INCDIR           := include
SRCDIR           := src
OBJDIR           := bin
DEPDIR           := dep

# File extensions
#-----------------------------------------------------------
INCEXT           :=
SRCEXT           :=

# Modules
#-----------------------------------------------------------
export SRCFILES  := # Each module will append to this
MODULES          := # Modules
include $(patsubst %,$(SRCDIR)/%/module.mk,$(MODULES))

# Build files
#-----------------------------------------------------------
export OBJFILES  := $(subst /,.,$(SRCFILES:%.$(SRCEXT)=%.o))
DEPFILES         := $(patsubst %,$(DEPDIR)/%.d,$(subst /,.,$(basename $(SRCFILES))))

# Target
#-----------------------------------------------------------
export TARGET    := # Target name

# Final commands
#-----------------------------------------------------------
COMPILE           = $(COMP) $(CPPFLAGS) $(DEPFLAGS) $(COMPFLAGS) 
POSTCOMPILE       = mv -f $(DEPDIR)/$*.temp.d $(DEPDIR)/$*.d && touch $(OBJDIR)/$@
export LINK       = $(LNK) $(LNKFLAGS)

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
.SECONDEXPANSION:
%.o: $$(subst .,/,%).$(SRCEXT) $(DEPDIR)/%.d | $(DEPDIR)
	@echo Compiling $@
	@$(COMPILE) -o $(OBJDIR)/$@ $<
	@echo Updating timestamps...
	@$(POSTCOMPILE)

$(DEPDIR): ; @mkdir -p $@

$(DEPFILES):
include $(wildcard $(DEPFILES))
