all: setup

setup: bottle.py img/database.pickle resources/include/EasyBMP/EasyBMP.o config.py

run: setup
	nohup python2 index.py

%.o: %.cpp
	$(CC) -O3 $< -c -o $@

img/database.pickle:
	mkdir -p img
	echo "(l." > $@

bottle.py:
	wget 'https://raw.githubusercontent.com/defnull/bottle/release-0.12/bottle.py' -O $@

EasyBMP.zip:
	wget 'https://downloads.sourceforge.net/project/easybmp/easybmp/EasyBMP%20Library%20Files%20Version%201.06/EasyBMP_1.06.zip' -O $@

resources/include/EasyBMP: EasyBMP.zip
	mkdir $@
	unzip -d $@ $^ 

clean:
	rm EasyBMP.zip
	rm bottle.py
	rm -r img
	rm resources/include/EasyBMP
