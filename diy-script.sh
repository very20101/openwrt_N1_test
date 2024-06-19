#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
# Code from https://github.com/haiibo/OpenWrt
# Code from https:/github.com/breakings/openwrt
# extra package from https://github.com/kenzok8
#===============================================
# 修改默认IP
sed -i 's/192.168.1.1/192.168.1.100/g' package/base-files/files/bin/config_generate
# Change default shell to zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd
# TTYD 免登录
# sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# extra package
#git clone https://github.com/kenzok8/small-package package/small-package
git clone https://github.com/kenzok8/openwrt-packages package/kenzo
git clone https://github.com/kenzok8/small package/smallpackage
#rm -rf package/small-package/firewall

# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm
# 修复 hostapd 报错
#cp -f $GITHUB_WORKSPACE/scripts/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch
# 修复 armv8 设备 xfsprogs 报错
sed -i 's/TARGET_CFLAGS.*/TARGET_CFLAGS += -DHAVE_MAP_SYNC -D_LARGEFILE64_SOURCE/g' feeds/packages/utils/xfsprogs/Makefile
# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}
# 取消主题默认设置
find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;

# extra package for perl python
rm -rf feeds/packages/lang/perl feeds/packages/lang/python/python-bidict package/network/services/hostapd 
rm -rf feeds/packages/lang/python/python-setuptools-scm  feeds/packages/lang/host-pip-requirements/setuptools-scm.txt
git clone https://github.com/very20101/openwrt_N1_test package/openwrt_N1_test

mv package/openwrt_N1_test/perl feeds/packages/lang/perl
mv package/openwrt_N1_test/extra_pack/python-bidict feeds/packages/lang/python/python-bidict
mv package/openwrt_N1_test/extra_pack/hostapd package/network/services/hostapd
mv package/openwrt_N1_test/extra_pack/python-setuptools-scm feeds/packages/lang/python/python-setuptools-scm
mv package/openwrt_N1_test/extra_pack/host-pip-requirements/setuptools-scm.txt feeds/packages/lang/host-pip-requirements/setuptools-scm.txt

rm -rf package/openwrt_N1_test

./scripts/feeds update -a
./scripts/feeds install -f
