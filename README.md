# lualog
一个使用lua解析excel的xlsx/xlsm格式的库。

# 编译
- msvc : 准备好lua依赖库并放到指定位置，将proj文件加到sln后编译。
- linux：准备好lua依赖库并放到指定位置，执行make -f luaxlsx.mak

# 依赖
- lua5.3
- minizip
- tinyxml2
- zlib

# 备注
本库fork自MiniExcel(https://github.com/qcdong2016/MiniExcel) ，并修改了一些存在的BUG，该库已经不再更新。
