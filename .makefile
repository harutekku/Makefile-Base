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

# Files
#-----------------------------------------------------------
SRCFILES         := # Source files
export OBJFILES  := $(SRCFILES:%.$(SRCEXT)=%.o)
DEPFILES         := $(SRCFILES:%.$(SRCEXT)=$(DEPDIR)/%.d)

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
%.o: %.$(SRCEXT) $(DEPDIR)/%.d | $(DEPDIR)
	@echo Compiling $@
	@$(COMPILE) -o $(OBJDIR)/$@ $<
	@echo Updating timestamps...
	@$(POSTCOMPILE)

$(DEPDIR): ; @mkdir -p $@

$(DEPFILES):
include $(wildcard $(DEPFILES))
