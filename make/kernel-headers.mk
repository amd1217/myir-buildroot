#############################################################
#
# Setup the kernel headers.  I include a generic package of
# kernel headers here, so you shouldn't need to include your
# own.  Be aware these kernel headers _will_ get blown away
# by a 'make clean' so don't put anything sacred in here...
#
#############################################################
ifneq ($(filter $(TARGETS),kernel-headers),)

LINUX_SITE:=http://ep09.pld-linux.org/~mmazur/linux-libc-headers/
LINUX_SOURCE:=linux-libc-headers-2.6.5.0.tar.bz2
LINUX_UNPACK_DIR:=$(TOOL_BUILD_DIR)/linux-libc-headers-2.6.5.0
LINUX_DIR:=$(TOOL_BUILD_DIR)/linux

# Used by pcmcia-cs and others
LINUX_SOURCE_DIR=$(LINUX_DIR)

$(DL_DIR)/$(LINUX_SOURCE):
	$(WGET) -P $(DL_DIR) $(LINUX_SITE)/$(LINUX_SOURCE)

$(LINUX_DIR)/.unpacked: $(DL_DIR)/$(LINUX_SOURCE)
	mkdir -p $(TOOL_BUILD_DIR)
	bzcat $(DL_DIR)/$(LINUX_SOURCE) | tar -C $(TOOL_BUILD_DIR) -xvf -
	mv $(LINUX_UNPACK_DIR) $(LINUX_DIR)
	touch $(LINUX_DIR)/.unpacked

$(LINUX_DIR)/.configured: $(LINUX_DIR)/.unpacked
	rm -f $(LINUX_DIR)/include/asm
	@if [ ! -f $(LINUX_DIR)/Makefile ] ; then \
	    echo -e "VERSION = 2\nPATCHLEVEL = 6\nSUBLEVEL = 5\nEXTRAVERSION =\n" > \
		    $(LINUX_DIR)/Makefile; \
	    echo -e "KERNELRELEASE=\$$(VERSION).\$$(PATCHLEVEL).\$$(SUBLEVEL)\$$(EXTRAVERSION)" >> \
		    $(LINUX_DIR)/Makefile; \
	fi;
	@if [ "$(ARCH)" = "powerpc" ];then \
	    (cd $(LINUX_DIR)/include; ln -fs asm-ppc$(NOMMU) asm;) \
	elif [ "$(ARCH)" = "mips" ];then \
	    (cd $(LINUX_DIR)/include; ln -fs asm-mips$(NOMMU) asm;) \
	elif [ "$(ARCH)" = "mipsel" ];then \
	    (cd $(LINUX_DIR)/include; ln -fs asm-mips$(NOMMU) asm;) \
	elif [ "$(ARCH)" = "arm" ];then \
	    (cd $(LINUX_DIR)/include; ln -fs asm-arm$(NOMMU) asm; \
	     cd asm; \
	     if [ ! -L proc ] ; then \
	     ln -fs proc-armv proc; \
	     ln -fs arch-ebsa285 arch; fi); \
	elif [ "$(ARCH)" = "cris" ];then \
	    (cd $(LINUX_DIR)/include; ln -fs asm-cris asm;) \
	else \
	    (cd $(LINUX_DIR)/include; ln -fs asm-$(ARCH)$(NOMMU) asm;) \
	fi
	touch $(LINUX_DIR)/include/linux/autoconf.h;
	if [ ! -f $(LINUX_DIR)/include/linux/version.h ] ; then \
	    echo "#define UTS_RELEASE \"2.6.5\"" > $(LINUX_DIR)/include/linux/version.h; \
	    echo "#define LINUX_VERSION_CODE 132613" >> $(LINUX_DIR)/include/linux/version.h; \
	    echo "#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))" >> \
		    $(LINUX_DIR)/include/linux/version.h; \
	fi;
	touch $(LINUX_DIR)/.configured

$(LINUX_KERNEL): $(LINUX_DIR)/.configured

kernel-headers: $(LINUX_DIR)/.configured

kernel-headers-source: $(DL_DIR)/$(LINUX_SOURCE)

kernel-headers-clean: clean
	rm -f $(LINUX_KERNEL)
	rm -rf $(LINUX_DIR)

kernel-headers-dirclean:
	rm -rf $(LINUX_DIR)

endif
