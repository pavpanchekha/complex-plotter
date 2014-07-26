all: start

%.o: %.cpp
	g++ $< -c -o $@

img/database.pickle:
	mkdir -p img
	echo "(l." > $@

bottle.py:
	wget 'https://raw.githubusercontent.com/defnull/bottle/release-0.12/bottle.py' -O bottle.py

start: bottle.py img/database.pickle resources/include/EasyBMP/EasyBMP.o config.py
	nohup python2 index.py

clean:
	rm bottle.py
	rm -r img
	rm resources/include/EasyBMP/EasyBMP.o
