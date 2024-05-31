#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
# Code from https://github.com/haiibo/OpenWrt
# Code from https:/github.com/breakings/openwrt
# extra package from https://github.com/kenzok8/small-package
#===============================================

# 修改默认IP
sed -i 's/192.168.1.1/192.168.1.100/g' package/base-files/files/bin/config_generate

# Change default shell to zsh
# sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# TTYD 免登录
# sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# extra package
git clone --depth=1 -b main  https://github.com/kenzok8/small-package package/small-package


./scripts/feeds update -a
./scripts/feeds install -f
