#工程名字
PROJECT_NAME = luaxlsx

#目标名字
TARGET_NAME = luaxlsx

#系统环境
UNAME_S = $(shell uname -s)

#伪目标
.PHONY: clean all target pre_build post_build
all : pre_build target post_build

#CFLAG
MYCFLAGS =

#需要定义的FLAG
MYCFLAGS += -Wno-sign-compare

#c标准库版本
#gnu99/gnu11/gnu17
STDC = -std=gnu99

#c++标准库版本
#c++11/c++14/c++17/c++20
STDCPP = -std=c++14

#需要的include目录
MYCFLAGS += -I../lua/lua
MYCFLAGS += -I./src/zlib
MYCFLAGS += -I./src/minizip
MYCFLAGS += -I./src/tinyxml2

#需要定义的选项
ifeq ($(UNAME_S), Linux)
MYCFLAGS += -D_LARGEFILE64_SOURCE
endif
ifeq ($(UNAME_S), Darwin)
MYCFLAGS += -D_LARGEFILE64_SOURCE
endif

#LDFLAGS
LDFLAGS =

#需要附件link库目录

#源文件路径
SRC_DIR = src

#需要排除的源文件,目录基于$(SRC_DIR)
EXCLUDE =
EXCLUDE += $(SRC_DIR)/minizip/minizip.c
EXCLUDE += $(SRC_DIR)/minizip/miniunz.c

#需要连接的库文件
LIBS =
#是否启用mimalloc库
LIBS += -lmimalloc -lpthread
MYCFLAGS += -I../../mimalloc/mimalloc/include -include ../../mimalloc-ex.h
#系统库
LIBS += -lm -ldl -lstdc++
#自定义库
LIBS += -llua

#定义基础的编译选项
CC = gcc
CX = c++
CFLAGS = -g -O2 -Wall -Wno-deprecated -Wextra -Wno-unknown-pragmas $(STDC) $(MYCFLAGS)
CXXFLAGS = -g -O2 -Wall -Wno-deprecated -Wextra -Wno-unknown-pragmas $(STDCPP) $(MYCFLAGS)

#项目目录
ifndef SOLUTION_DIR
SOLUTION_DIR=./
endif

#临时文件目录
INT_DIR = $(SOLUTION_DIR)temp/$(PROJECT_NAME)

#目标文件前缀，定义则.so和.a加lib前缀，否则不加
PROJECT_PREFIX =

#目标定义
MYCFLAGS += -fPIC
TARGET_DIR = $(SOLUTION_DIR)bin
TARGET_DYNAMIC =  $(TARGET_DIR)/$(PROJECT_PREFIX)$(TARGET_NAME).so
#macos系统so链接问题
ifeq ($(UNAME_S), Darwin)
LDFLAGS += -install_name $(PROJECT_PREFIX)$(TARGET_NAME).so
endif

#link添加.so目录
LDFLAGS += -L$(TARGET_DIR)

#自动生成目标
OBJS =
#子目录
OBJS += $(patsubst $(SRC_DIR)/zlib/%.cpp, $(INT_DIR)/zlib/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/zlib/*.cpp)))
OBJS += $(patsubst $(SRC_DIR)/zlib/%.cc, $(INT_DIR)/zlib/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/zlib/*.c)))
OBJS += $(patsubst $(SRC_DIR)/zlib/%.c, $(INT_DIR)/zlib/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/zlib/*.cc)))
OBJS += $(patsubst $(SRC_DIR)/zlib/%.m, $(INT_DIR)/zlib/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/zlib/*.m)))
#子目录
OBJS += $(patsubst $(SRC_DIR)/minizip/%.cpp, $(INT_DIR)/minizip/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/minizip/*.cpp)))
OBJS += $(patsubst $(SRC_DIR)/minizip/%.cc, $(INT_DIR)/minizip/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/minizip/*.c)))
OBJS += $(patsubst $(SRC_DIR)/minizip/%.c, $(INT_DIR)/minizip/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/minizip/*.cc)))
OBJS += $(patsubst $(SRC_DIR)/minizip/%.m, $(INT_DIR)/minizip/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/minizip/*.m)))
#子目录
OBJS += $(patsubst $(SRC_DIR)/tinyxml2/%.cpp, $(INT_DIR)/tinyxml2/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/tinyxml2/*.cpp)))
OBJS += $(patsubst $(SRC_DIR)/tinyxml2/%.cc, $(INT_DIR)/tinyxml2/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/tinyxml2/*.c)))
OBJS += $(patsubst $(SRC_DIR)/tinyxml2/%.c, $(INT_DIR)/tinyxml2/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/tinyxml2/*.cc)))
OBJS += $(patsubst $(SRC_DIR)/tinyxml2/%.m, $(INT_DIR)/tinyxml2/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/tinyxml2/*.m)))
#根目录
OBJS += $(patsubst $(SRC_DIR)/%.cpp, $(INT_DIR)/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/*.cpp)))
OBJS += $(patsubst $(SRC_DIR)/%.c, $(INT_DIR)/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/*.c)))
OBJS += $(patsubst $(SRC_DIR)/%.cc, $(INT_DIR)/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/*.cc)))
OBJS += $(patsubst $(SRC_DIR)/%.m, $(INT_DIR)/%.o, $(filter-out $(EXCLUDE), $(wildcard $(SRC_DIR)/*.m)))


$(TARGET_DYNAMIC) : $(OBJS)
	$(CC) -o $@ -shared $(OBJS) $(LDFLAGS) $(LIBS)


# 编译所有源文件
$(INT_DIR)/%.o : $(SRC_DIR)/%.cpp
	$(CX) $(CXXFLAGS) -c $< -o $@
$(INT_DIR)/%.o : $(SRC_DIR)/%.cc
	$(CX) $(CXXFLAGS) -c $< -o $@
$(INT_DIR)/%.o : $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@
$(INT_DIR)/%.o : $(SRC_DIR)/%.m
	$(CC) $(CFLAGS) -c $< -o $@

#target伪目标
target : $(TARGET_DYNAMIC)

#clean伪目标
clean :
	rm -rf $(INT_DIR)

#预编译
pre_build:
	mkdir -p $(INT_DIR)
	mkdir -p $(TARGET_DIR)
	mkdir -p $(INT_DIR)/zlib
	mkdir -p $(INT_DIR)/minizip
	mkdir -p $(INT_DIR)/tinyxml2

#后编译
post_build:
