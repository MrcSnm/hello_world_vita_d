# You should only use Makefile-based build if you know what you're doing.
# For most vitasdk projects, CMake is a better choice. See CMakeLists.txt for an example.

PHONY := all package clean
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

CC := arm-vita-eabi-gcc
CXX := arm-vita-eabi-g++
# D Compiler
DC := ldc2
DFLAGS := -betterC -gcc="/usr/local/vitasdk/bin/arm-vita-eabi-gcc.exe" -mtriple=armv7a-unknown-unknown --float-abi=hard -mcpu=cortex-a9
STRIP := arm-vita-eabi-strip

PROJECT_TITLE := Hello World
PROJECT_TITLEID := VSDK00007

PROJECT := vita_sample
CFLAGS += -Wl,-q -I../common
CXXFLAGS += -Wl,-q -std=c++11 -I../common

SRC_C :=$(call rwildcard, src/, *.c)
SRC_CPP :=$(call rwildcard, src/, *.cpp)
SRC_D := $(call rwildcard, src/, *.d)

OBJ_DIRS := $(addprefix out/, $(dir $(SRC_C:src/%.c=%.o))) $(addprefix out/, $(dir $(SRC_CPP:src/%.cpp=%.o))) $(addprefix out/, $(dir $(SRC_D:src/%.d=%.o)))
OBJS := $(addprefix out/, $(SRC_C:src/%.c=%.o)) $(addprefix out/, $(SRC_CPP:src/%.cpp=%.o)) $(addprefix out/, $(SRC_D:src/%.d=%.o))

# Needed by psvDebugScreenPrintf
LIBS += -lSceDisplay_stub -lDLibrary

all: package

package: $(PROJECT).vpk

$(PROJECT).vpk: eboot.bin param.sfo
	vita-pack-vpk -s param.sfo -b eboot.bin \
		--add sce_sys/icon0.png=sce_sys/icon0.png \
		--add sce_sys/livearea/contents/bg.png=sce_sys/livearea/contents/bg.png \
		--add sce_sys/livearea/contents/startup.png=sce_sys/livearea/contents/startup.png \
		--add sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml \
	$(PROJECT).vpk

eboot.bin: $(PROJECT).velf
	vita-make-fself $(PROJECT).velf eboot.bin

param.sfo:
	vita-mksfoex -s TITLE_ID="$(PROJECT_TITLEID)" "$(PROJECT_TITLE)" param.sfo

$(PROJECT).velf: $(DUB) $(PROJECT).elf
	$(STRIP) -g $<
	vita-elf-create $< $@

$(PROJECT).elf: $(OBJS)
	$(CXX) $(CXXFLAGS) $^ -L/usr/local/vitasdk/arm-vita-eabi/lib/ $(LIBS) -o $@

out/%.o : src/%.cpp | $(OBJ_DIRS)
	arm-vita-eabi-g++ -c $(CXXFLAGS) -o $@ $<

out/%.o : src/%.c | $(OBJ_DIRS)
	arm-vita-eabi-gcc -c $(CFLAGS) -o $@ $<

out/%.o : src/%.d | $(OBJ_DIRS)
	$(DC) -c $(DFLAGS) --od=out/ $<

$(DUB):
	dub --compiler=ldc2 --arch=armv7a-unknown-unknown

$(OBJ_DIRS):
	mkdir -p $@


clean:
	rm -f $(PROJECT).velf $(PROJECT).elf $(PROJECT).vpk param.sfo eboot.bin $(OBJS)
	rm -r $(abspath $(OBJ_DIRS))
