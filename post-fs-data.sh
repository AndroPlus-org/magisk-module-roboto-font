#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}
# This script will be executed in post-fs-data mode

APILEVEL=$(getprop ro.build.version.sdk)

#Copy original fonts.xml to the MODDIR to overwrite dummy file
mkdir -p $MODDIR/system/etc $MODDIR/system/system_ext/etc $MODDIR/system/product/etc
cp /system/etc/fonts.xml $MODDIR/system/etc

#Function to remove original ja
remove_ja() {
  sed -i -e '/<family lang="ja"/,/<\/family>/d' $1
}

#Function to add ja above zh-Hans
add_ja() {
	if [ $APILEVEL -ge 31 ] ; then
		#Android 12 and later
		sed -i 's@<family lang="zh-Hans">@<family lang="ja">\n    <font weight="400" style="normal" index="0" postScriptName="NotoSansCJKjp-Regular">\n            NotoSansCJK-Regular.ttc\n        </font>\n        <font weight="400" style="normal" index="0" fallbackFor="serif" postScriptName="NotoSerifCJKjp-Regular">\n			  NotoSerifCJK-Regular.ttc\n        </font>\n    </family>\n    <family lang="zh-Hans">@g' $1
	fi
}

#Function to replace Google Sans
replace_gsans() {
	sed -i 's@GoogleSans-Italic.ttf@GoogleSans-Regular.ttf\n      <axis tag="ital" stylevalue="1" />@g' $1
}

#Change fonts.xml file
remove_ja $MODDIR/system/etc/fonts.xml
add_ja $MODDIR/system/etc/fonts.xml

gsans=/system/product/etc/fonts_customization.xml
if [ -e $gsans ]; then
	cp $gsans $MODDIR$gsans
	replace_gsans $MODDIR$gsans
fi

#Goodbye, SomcUDGothic
sed -i 's@SomcUDGothic-Light.ttf@null.ttf@g' $MODDIR/system/etc/fonts.xml
sed -i 's@SomcUDGothic-Regular.ttf@null.ttf@g' $MODDIR/system/etc/fonts.xml

#Goodbye, OnePlus Font
sed -i 's@OpFont-@Roboto-@g' $MODDIR/system/etc/fonts.xml
sed -i 's@NotoSerif-@Roboto-@g' $MODDIR/system/etc/fonts.xml

#Goodbye, OPLUS Font
if [ -f /system/fonts/SysFont-Regular.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/SysFont-Regular.ttf
fi
if [ -f /system/fonts/SysFont-Static-Regular.ttf ]; then
	cp /system/fonts/RobotoStatic-Regular.ttf $MODDIR/system/fonts/SysFont-Static-Regular.ttf
fi
if [ -f /system/fonts/SysSans-En-Regular.ttf ]; then
	sed -i 's@SysSans-En-Regular@Roboto-Regular@g' $MODDIR/system/etc/fonts.xml
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/SysSans-En-Regular.ttf
fi

#Goodbye, Xiaomi Font
/system/bin/sed -i -z 's@<family name="sans-serif">\n    <!-- # MIUI Edit Start -->.*<!-- # MIUI Edit END -->@<family name="sans-serif">@' $MODDIR/system/etc/fonts.xml
sed -i 's@MiSansVF.ttf@Roboto-Regular.ttf@g' $MODDIR/system/etc/fonts.xml
if [ -e /system/fonts/MiSansVF.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/MiSansVF.ttf
fi
#For MIUI 13+
sed -i 's@MiSansVF_Overlay.ttf@Roboto-Regular.ttf@g' $MODDIR/system/etc/fonts.xml
if [ -e /system/fonts/MiSansVF_Overlay.ttf ]; then
	cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/MiSansVF_Overlay.ttf
fi

#Goodbye, vivo Font
sed -i 's@VivoFont.ttf@RobotoStatic-Regular.ttf@g' $MODDIR/system/etc/fonts.xml
sed -i 's@DroidSansFallbackBBK.ttf@RobotoStatic-Regular.ttf@g' $MODDIR/system/etc/fonts.xml
if [ -e /system/fonts/HYQiHei-50.ttf ]; then
cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/HYQiHei-50.ttf
fi
if [ -e /system/fonts/DroidSansFallbackBBK.ttf ]; then
cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/DroidSansFallbackBBK.ttf
fi
if [ -e /system/fonts/DroidSansFallbackMonster.ttf ]; then
cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/DroidSansFallbackMonster.ttf
fi
if [ -e /system/fonts/DroidSansFallbackZW.ttf ]; then
cp /system/fonts/Roboto-Regular.ttf $MODDIR/system/fonts/DroidSansFallbackZW.ttf
fi

#Goodbye, Sansita Font
sed -i 's@Sansita-@Roboto-@g' $MODDIR/system/etc/fonts.xml

#Copy fonts_base.xml for OnePlus OxygenOS 12+
oos12=fonts_base.xml
if [ -e /system/system_ext/etc/$oos12 ]; then
    cp /system/system_ext/etc/$oos12 $MODDIR/system/system_ext/etc
	
	#Change fonts_slate.xml file
	remove_ja $MODDIR/system/system_ext/etc/$oos12
	add_ja $MODDIR/system/system_ext/etc/$oos12

	sed -i 's@SysSans-En-Regular@Roboto-Regular@g' $MODDIR/system/system_ext/etc/$oos12
	sed -i 's@NotoSerif-@Roboto-@g' $MODDIR/system/system_ext/etc/$oos12
fi
