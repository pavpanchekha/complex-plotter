all: resources/include/EasyBMP/EasyBMP.cpp
	g++ resources/include/EasyBMP/EasyBMP.cpp -c -o resources/include/EasyBMP/EasyBMP.o
	mkdir img
	echo "(l." > img/database.pickle
