redo: resources/include/EasyBMP/EasyBMP.cpp
	g++ resources/include/EasyBMP/EasyBMP.cpp -c -o resources/include/EasyBMP/EasyBMP.o
	[ -z img ] && mkdir img && echo "(l." > img/database.pickle
