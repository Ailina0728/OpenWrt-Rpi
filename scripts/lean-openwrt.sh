#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
sed -i 's/192.168.1.1/192.168.3.33/g' package/base-files/files/bin/config_generate

# Add luci-app-ssr-plus
pushd package/lean
git clone --depth=1 https://github.com/fw876/helloworld
popd

# Clone community packages to package/community
mkdir package/community
pushd package/community

# Add Lienol's Packages
git clone --depth=1 https://github.com/Lienol/openwrt-package

# Add luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall

# Add luci-app-vssr <M>
git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
git clone --depth=1 https://github.com/jerrykuku/luci-app-vssr

# Add mentohust & luci-app-mentohust
git clone --depth=1 https://github.com/BoringCat/luci-app-mentohust
git clone --depth=1 https://github.com/KyleRicardo/MentoHUST-OpenWrt-ipk

# Add luci-proto-minieap
git clone --depth=1 https://github.com/ysc3839/luci-proto-minieap

# Add ServerChan
git clone --depth=1 https://github.com/tty228/luci-app-serverchan

# Add OpenClash
git clone --depth=1 -b master https://github.com/vernesong/OpenClash

# Add luci-app-onliner
git clone --depth=1 https://github.com/rufengsuixing/luci-app-onliner

# Add luci-app-diskman
git clone --depth=1 https://github.com/SuLingGG/luci-app-diskman
mkdir parted
cp luci-app-diskman/Parted.Makefile parted/Makefile

# Add luci-app-dockerman
rm -rf ../lean/luci-app-docker
git clone --depth=1 https://github.com/KFERMercer/luci-app-dockerman
git clone --depth=1 https://github.com/lisaac/luci-lib-docker

# Add luci-theme-argon
rm -rf ../lean/luci-theme-argon
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Add luci-theme-darkmatter
git clone --depth=1 https://github.com/apollo-ng/luci-theme-darkmatter

# Add luci-theme-infinityfreedom
git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom

# Add luci-app-advancedsetting
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-advancedsetting

# Add luci-app-smartinfo
svn co https://github.com/281677160/openwrt-package/trunk/luci-app-smartinfo

# Add luci-app-dnsfilter
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-dnsfilter

# Add luci-theme-opentomcat
svn co https://github.com/281677160/openwrt-package/trunk/luci-theme-opentomcat

# Add luci-theme-opentopd
svn co https://github.com/281677160/openwrt-package/trunk/luci-theme-opentopd

# Add luci-theme-rosy
svn co https://github.com/281677160/openwrt-package/trunk/luci-theme-rosy

# Add luci-app-ttnode
svn co https://github.com/281677160/openwrt-package/trunk/luci-app-ttnode

# Add subconverter
git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter

# Add luci-udptools
git clone --depth=1 https://github.com/zcy85611/openwrt-luci-kcp-udp

# Add OpenAppFilter
git clone --depth=1 https://github.com/destan19/OpenAppFilter

# Add luci-app-oled (R2S Only)
#git clone --depth=1 https://github.com/NateLol/luci-app-oled

# Add driver for rtl8821cu & rtl8812au-ac
#svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06-k5.4/package/kernel/rtl8812au-ac
#svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06-k5.4/package/kernel/rtl8821cu
popd

# Mod zzz-default-settings
pushd package/lean/default-settings/files
sed -i '/http/d' zzz-default-settings
export orig_version="$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')"
sed -i "s/${orig_version}/${orig_version} ($(date +"%Y-%m-%d"))/g" zzz-default-settings
popd

# 修改主机名字，把OpenWrt-123修改你喜欢的就行（不能纯数字或者使用中文）
sed -i '/uci commit system/i\uci set system.@system[0].hostname='OpenWrt-X'' package/lean/default-settings/files/zzz-default-settings

# 版本号里显示一个自己的名字（281677160 build $(TZ=UTC-8 date "+%Y.%m.%d") @ 这些都是后增加的）
sed -i "s/OpenWrt /M-Tea build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings

# Use Lienol's https-dns-proxy package
pushd feeds/packages/net
rm -rf https-dns-proxy
svn co https://github.com/Lienol/openwrt-packages/trunk/net/https-dns-proxy
popd

# Use snapshots' syncthing package
pushd feeds/packages/utils
rm -rf syncthing
svn co https://github.com/openwrt/packages/trunk/utils/syncthing
popd

# Fix mt76 wireless driver
#pushd package/kernel/mt76
#sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
#popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd
