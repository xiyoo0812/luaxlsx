# luaxlsx
一个使用lua解析excel的xlsx/xlsm格式的库。

# 依赖
- miniz (已经包含在库内)
- [lua](https://github.com/xiyoo0812/lua.git)5.2以上
- [luakit](https://github.com/xiyoo0812/luakit.git)一个luabind库
- 项目路径如下<br>
  |--proj <br>
  &emsp;|--lua <br>
  &emsp;|--luaxlsx <br>
  &emsp;|--luakit

# 编译
- msvc: 准备好lua依赖库并放到指定位置，将proj文件加到sln后编译。
- linux: 准备好lua依赖库并放到指定位置，执行make -f luaxlsx.mak

# 注意事项
- mimalloc: 参考[quanta](https://github.com/xiyoo0812/quanta.git)使用，不用则在工程文件中注释

# 用法
```lua
local lexcel = require('luaxlsx')
local log_debug = logger.debug

local excel = lexcel.open(full_name)
if not excel then
    print(sformat("open excel %s failed!", file))
    return
end

--只导出sheet1
local books = excel.workbooks()
local book = books and books[1]

--sheet_name
local book_name = book.name
for row = 1, book.last_row do
    for col = 1, book.last_col do
        print(book.get_cell_value(row, col))
    end
end


local excel = xlsx.open("test.xlsx")
local book  = excel.open("Sheet1")
local a1    = book.get_cell_value(1, 1)
local b1    = book.get_cell_value(1, 2)
local a14   = book.get_cell_value(14, 1)
local b14   = book.get_cell_value(14, 2)
local c14   = book.get_cell_value(14, 3)
local c1    = book.get_cell_value(1, 3)

log_debug("get cell a1: {}", a1)
log_debug("get cell b1: {}", b1)
log_debug("get cell c1: {}", c1)
log_debug("get cell a14: {}", a14)
log_debug("get cell b14: {}", b14)
log_debug("get cell c14: {}", c14)

--设置单元格值
book.set_cell_value(1, 1, "word")
book.set_cell_value(1, 2, 0.5)
book.set_cell_value(14, 1, 0.6)
book.set_cell_value(14, 2, 18880)
book.set_cell_value(14, 3, 0.6)
book.set_cell_value(1, 3, 88)
book.set_cell_value(13, 4, nil)

excel.save("test2.xlsx")
```
