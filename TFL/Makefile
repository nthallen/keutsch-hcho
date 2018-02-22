LDFLAGS=-Wl,-rpath -Wl,/usr/local/lib -L /usr/local/lib
CPPFLAGS= -I /usr/local/include
CXXFLAGS= -Wall -g
LIBS=-ltmpp -ltm -lnort

SRC = tfl.cc tfloui.c
OBJ = ${addsuffix .o, ${basename $(SRC) } } 
TGT = tfl

$(TGT) : $(OBJ)
	$(LINK.cc) -o $(TGT) $(OBJ) $(LIBS)
	usemsg $(TGT) tfloui.c
tfloui.c : tfl.oui
	oui -o tfloui.c tfl.oui
.PHONY : clean
clean :
	rm -f *.o tfloui.c tfl
