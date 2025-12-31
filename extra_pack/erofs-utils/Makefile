#
# Copyright (C) 2009-2025 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=erofs-utils
PKG_VERSION:=1.8.10
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
#PKG_SOURCE_URL=https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git
PKG_SOURCE_URL=https://kernel.googlesource.com/pub/scm/linux/kernel/git/xiang/erofs-utils.git
#PKG_SOURCE_URL=https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.8.10.tar.gz
#PKG_SOURCE_URL=https://raw.githubusercontent.com/very20101/Openwrt_N1_try/refs/heads/main/extra_pack/erofs-utils-1.8.10.tar.gz
PKG_MIRROR_HASH:=a21d244aee8cb216ac4436bf7f790e75fca113ea9a5512c8e4ac530c4983ef32
#PKG_MIRROR_HASH:=05eb4edebe11decce6ecb34e98d2f80c8cd283c2f2967d8ba7efd58418570514 
PKG_SOURCE_DATE:=2025-07-15
PKG_SOURCE_VERSION:=51b5939b5f783221310d25146e6a2019ba8129b6

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/host-build.mk

HOST_CONFIGURE_ARGS=\
	--enable-multithreading \
	--enable-lzma \
	--enable-lz4 \
	--disable-fuse \
	--with-uuid

define Host/Install
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/mkfs/mkfs.erofs $(STAGING_DIR_HOST)/bin/
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/fsck/fsck.erofs $(STAGING_DIR_HOST)/bin/
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/bin/mkfs.erofs
	rm -f $(STAGING_DIR_HOST)/bin/fsck.erofs
endef

$(eval $(call HostBuild))
