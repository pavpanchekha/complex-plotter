all: start

redo: resources/include/EasyBMP/EasyBMP.cpp
	g++ resources/include/EasyBMP/EasyBMP.cpp -c -o resources/include/EasyBMP/EasyBMP.o
	[ -z img ] && mkdir img && echo "(l." > img/database.pickle

start:
	python2 index.py &

pull:
	git pull origin master
