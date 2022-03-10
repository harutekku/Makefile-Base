# Compiler & Linker
#-----------------------------------------------------------
export COMP      := 
export LD        := # Don't use LD unless you need to

# Flags
#-----------------------------------------------------------
export COMPFLAGS := 
export LDFLAGS   := 
CPPFLAGS         := -I include
DEPFLAGS          = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.d

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

# Files
#-----------------------------------------------------------
SRCFILES         := # Source files
export OBJFILES  := $(SRCFILES:%.$(SRCEXT)=%.o)
DEPFILES         := $(SRCFILES:%.$(SRCEXT)=$(DEPDIR)/%.d)

# Target
#-----------------------------------------------------------
export TARGET    := # Target name

# Final command
#-----------------------------------------------------------
COMPILE           = $(COMP) $(CPPFLAGS) $(DEPFLAGS) $(COMPFLAGS) 
export LINK       = $(LD) $(LDFLAGS)

# Paths
#-----------------------------------------------------------
vpath %.$(INCEXT)   $(INCDIR) 
vpath %.$(SRCEXT)   $(SRCDIR) 
vpath %.o           $(OBJDIR)

# Commands
#-----------------------------------------------------------
$(TARGET): $(OBJFILES)
	make --directory=$(OBJDIR)/

%.o: %.$(SRCEXT)
%.o: %.$(SRCEXT) $(DEPDIR)/%.d | $(DEPDIR)
	@echo Compiling $@
	@$(COMPILE) -o $(OBJDIR)/$@ $<

$(DEPDIR): ; @mkdir -p $@

$(DEPFILES):
include $(wildcard $(DEPFILES))
