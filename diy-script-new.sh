#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# Code from https://github.com/breakings/openwrt
# Code from https://github.com/haiibo/openwrt
# File name: diy-scipr-new.sh
# Description: OpenWrt DIY script
#

# Modify default IP
  sed -i 's/192.168.1.1/192.168.1.100/g' package/base-files/files/bin/config_generate
  
# kernel
  #sed -i "s/KERNEL_PATCHVER:=5.4/KERNEL_PATCHVER:=5.10/g" target/linux/armvirt/Makefile
  #sed -i "s/KERNEL_PATCHVER:=5.10/KERNEL_PATCHVER:=5.15/g" target/linux/armvirt/Makefile

#sagernet-core
  #sed -i 's|$(LN) v2ray $(1)/usr/bin/xray|#$(LN) v2ray $(1)/usr/bin/xray|g' feeds/small8/sagernet-core/Makefile
  #sed -i 's|CONFLICTS:=v2ray-core xray-core|#CONFLICTS:=v2ray-core xray-core|g' feeds/small8/sagernet-core/Makefile

# 移除要替换的包
#rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/msd_lite
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-netgear
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-serverchan

echo "开始 DIY 配置……"
echo "========================="

function merge_package(){
    repo=`echo $1 | rev | cut -d'/' -f 1 | rev`
    pkg=`echo $2 | rev | cut -d'/' -f 1 | rev`
    find package/ -follow -name $pkg -not -path "package/custom/*" | xargs -rt rm -rf
    git clone --depth=1 --single-branch $1
    mv $2 package/custom/
    rm -rf $repo
}
function drop_package(){
    find package/ -follow -name $1 -not -path "package/custom/*" | xargs -rt rm -rf
}
function merge_feed(){
    if [ ! -d "feed/$1" ]; then
        echo >> feeds.conf.default
        echo "src-git $1 $2" >> feeds.conf.default
    fi
    ./scripts/feeds update $1
    ./scripts/feeds install -a -p $1
}
rm -rf package/custom; mkdir package/custom

# 添加额外插件
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan
git clone --depth=1 https://github.com/ilxp/luci-app-ikoolproxy package/luci-app-ikoolproxy
git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
merge_package https://github.com/kenzok8/small-package package/luci-app-filebrowser
merge_package https://github.com/kenzok8/small-package package/filebrowser
merge_package https://github.com/Lienol/openwrt-package package/luci-app-ssr-mudb-server
merge_package https://github.com/immortalwrt/luci luci/applications/luci-app-eqos
# git_sparse_clone master https://github.com/syb999/openwrt-19.07.1 package/network/services/msd_lite
rm -rf feeds/packages/utils/v2dat
merge_package https://github.com/sbwml/luci-app-mosdns feeds/packages/utils/v2dat
#rm -rf feeds/packages/libs/libxslt
#merge_package https://github.com/openwrt/packages/tree/master/libs feeds/packages/libs/libxslt

# 科学上网插件
git clone --depth=1 -b main https://github.com/fw876/helloworld package/luci-app-ssr-plus
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages 
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
merge_package https://github.com/vernesong/OpenClash package/OpenClash/luci-app-openclash

# 更改 Argon 主题背景
cp -f $GITHUB_WORKSPACE/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 晶晨宝盒
merge_package https://github.com/ophub/luci-app-amlogic luci-app-amlogic/luci-app-amlogic
sed -i "s|firmware_repo.*|firmware_repo 'https://github.com/haiibo/OpenWrt'|g" package/luci-app-amlogic/root/etc/config/amlogic
# sed -i "s|kernel_path.*|kernel_path 'https://github.com/ophub/kernel'|g" package/luci-app-amlogic/root/etc/config/amlogic
sed -i "s|ARMv8|ARMv8_PLUS|g" package/luci-app-amlogic/root/etc/config/amlogic

# SmartDNS
git clone --depth=1 -b lede https://github.com/pymumu/luci-app-smartdns package/luci-app-smartdns
git clone --depth=1 https://github.com/pymumu/openwrt-smartdns package/smartdns

# msd_lite
git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite

# MosDNS
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns

# Alist
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist

# DDNS.to
merge_package https://github.com/kenzok8/small-package package/luci-app-ddnsto
merge_package https://github.com/linkease/nas-packages package/network/services/ddnsto

# iStore
merge_package https://github.com/linkease/istore-ui package/istore-ui/app-store-ui
merge_package https://github.com/linkease/istore package/istore/luci

# 在线用户
merge_package https://github.com/kenzok8/small-package package/luci-app-onliner
sed -i '$i uci set nlbwmon.@nlbwmon[0].refresh_interval=2s' package/lean/default-settings/files/zzz-default-settings
sed -i '$i uci commit nlbwmon' package/lean/default-settings/files/zzz-default-settings
chmod 755 package/luci-app-onliner/root/usr/share/onliner/setnlbw.sh

# x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by Haiibo/g" package/lean/default-settings/files/zzz-default-settings

# 修复 hostapd 报错
cp -f $GITHUB_WORKSPACE/scripts/011-fix-mbo-modules-build.patch package/network/services/hostapd/patches/011-fix-mbo-modules-build.patch

# 修复 armv8 设备 xfsprogs 报错
sed -i 's/TARGET_CFLAGS.*/TARGET_CFLAGS += -DHAVE_MAP_SYNC -D_LARGEFILE64_SOURCE/g' feeds/packages/utils/xfsprogs/Makefile

# 修改 Makefile
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/lang\/golang\/golang-package.mk/$(TOPDIR)\/feeds\/packages\/lang\/golang\/golang-package.mk/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHREPO/PKG_SOURCE_URL:=https:\/\/github.com/g' {}
find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/PKG_SOURCE_URL:=@GHCODELOAD/PKG_SOURCE_URL:=https:\/\/codeload.github.com/g' {}

# 取消主题默认设置
find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;

# 调整 V2ray服务器 到 VPN 菜单
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
# sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm

# golang replace
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

# libxslt
#rm -rf feeds/packages/lib/libxslt
#merge_package https://github.com/openwrt/packages/libs/libxslt feeds/packages/lib/libxslt

# perl
rm rf package/openwrt_N1_test
rm -rf feeds/packages/lang/perl
git clone -b main https://github.com/very20101/openwrt_N1_test package/openwrt_N1_test
mv package/openwrt_N1_test/perl feeds/packages/lang/perl

# extra package 
rm -rf feeds/packages/lang/perl-xml-parser feeds/packages/lang/python/python-bidict 
rm -rf package/network/services/hostapd  feeds/packages/lang/python/python-setuptools-scm
rm -rf feeds/packages/lang/python/python-setuptools-scm feeds/packages/lang/python/python-dateutil
rm -rf feeds/packages/lang/python/python-installer feeds/packages/lang/python/python-installer
rm -rf feeds/packages/lang/python/python-build feeds/packages/lang/python/python-packaging
rm -rffeeds/packages/lang/python/python-typing-extensions

#git clone -b main https://github.com/very20101/openwrt_N1_test package/openwrt_N1_test
mv package/openwrt_N1_test/extra_pack/hostapd package/network/services/hostapd
mv package/openwrt_N1_test/perl feeds/packages/lang/perl-xml-parser
mv package/openwrt_N1_test/extra_pack/python-bidict feeds/packages/lang/python/python-bidict
mv package/openwrt_N1_test/extra_pack/python-setuptools-scm feeds/packages/lang/python/python-setuptools-scm
mv package/openwrt_N1_test/extra_pack/python-dateutil feeds/packages/lang/python/python-dateutil

mv package/openwrt_N1_test/extra_pack/python-wheel feeds/packages/lang/python/python-wheel
mv package/openwrt_N1_test/extra_pack/python-installer feeds/packages/lang/python/python-installer
mv package/openwrt_N1_test/extra_pack/python-build feeds/packages/lang/python/python-build
mv package/openwrt_N1_test/extra_pack/python-packaging feeds/packages/lang/python/python-packaging
mv package/openwrt_N1_test/extra_pack/python-typing-extensions feeds/packages/lang/python/python-typing-extensions

rm -rf package/openwrt_N1_test

./scripts/feeds update -a
./scripts/feeds install -f

echo "============================"
echo " DIY 配置完成……"
