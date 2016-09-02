################################################################################
#
# libtasn1
#
################################################################################

LIBTASN1_VERSION = 4.9
LIBTASN1_SITE = http://ftp.gnu.org/gnu/libtasn1
LIBTASN1_DEPENDENCIES = host-bison
LIBTASN1_LICENSE = GPLv3+, LGPLv2.1+
LIBTASN1_LICENSE_FILES = COPYING COPYING.LIB
LIBTASN1_INSTALL_STAGING = YES
# 'missing' fallback logic botched so disable it completely
LIBTASN1_CONF_ENV = MAKEINFO="true"
# For 0001-configure-don-t-add-Werror-to-build-flags.patch
LIBTASN1_AUTORECONF = YES

$(eval $(autotools-package))
