TARGET = mega-netbsd

###############

SRC = src/MegaFuseApp.cpp src/file_cache_row.cpp src/EventsHandler.cpp src/MegaFuse.cpp  src/megafusemodel.cpp src/megaposix.cpp src/Config.cpp src/fuseImpl.cpp src/megacli.cpp src/Logger.cpp
SRC += sdk/megabdb.cpp sdk/megaclient.cpp sdk/megacrypto.cpp 

OUT = $(TARGET)
OBJ = $(patsubst %.cpp,%.o,$(patsubst %.c,%.o,$(SRC)))

INSTALLDIR = ${PREFIX}/bin

.PHONY:	

# include directories
INCLUDES = -I inc -I /usr/include/g++/ -I ${PREFIX}/include -I ${PREFIX}/include/cryptopp -I ${PREFIX}/include/db6  -I sdk

# C compiler flags (-g -O2 -Wall)
CCFLAGS =   -O0 -g -fstack-protector-all -Wall -Wno-unused-variable #-non-call-exceptions
CCFLAGS += $(shell pkg-config --cflags libcurl fuse)
CPPFLAGS = -std=c++11  $(CCFLAGS) -D_GLIBCXX_DEBUG 

# compiler
CC = ${PKGSRC_CC}
CPP = ${PKGSRC_CPP}
CXX = ${PKGSRC_CXX}

# library paths
LIBS = -lcryptopp -lfreeimage -ldb6_cxx

# compile flags
LDFLAGS = -L ${PREFIX}/lib -Wl,-R${PREFIX}/lib ${LIBS}
LDFLAGS += $(shell pkg-config --libs libcurl ) -lrefuse -lperfuse

megafuse: $(OUT)

all: megafuse

$(OUT): $(OBJ) 
	$(CPP) $(CPPFLAGS) -o $(OUT) $(OBJ) $(LDFLAGS)

.cpp.o:
	$(CPP) $(INCLUDES) $(CPPFLAGS) -c $< -o $@

install:
	install -d -m0755 -o root -g wheel $(INSTALLDIR)
	install -m0755 -o root -g wheel mega-netbsd $(INSTALLDIR)

clean:	
	rm -f $(OBJ) $(OUT)
