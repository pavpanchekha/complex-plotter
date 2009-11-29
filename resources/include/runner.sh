#!/usr/bin/zsh

WIDTH=750
HEIGHT=750
RANGE_L=-2
RANGE_B=-2
RANGE_T=2
RANGE_R=2
OUTNAME="/srv/www/pavpan/sam-complex/img/output.bmp"
NUMBER=1
F1="sin(1.0/z)"
F2="cos(z*z)"

while getopts w:h:l:b:t:r:o:n:f:g: o
do
    case "$o" in
        w) WIDTH="$OPTARG";;
        h) HEIGHT="$OPTARG";;
        l) RANGE_L="$OPTARG";;
        b) RANGE_B="$OPTARG";;
        t) RANGE_T="$OPTARG";;
        r) RANGE_R="$OPTARG";;
        o) OUTNAME="$OPTARG";;
        n) NUMBER="$OPTARG";;
        f) F1="$OPTARG";;
        g) F2="$OPTARG";;
    esac
done

source plotparse/bin/activate
python plotparse/parser.py $F1 > /tmp/f1
python plotparse/parser.py $F2 > /tmp/f2

header="
#define OUTNAME \"$OUTNAME\"\n#define WIDTH   $WIDTH\n#define HEIGHT  $HEIGHT\n#define RANGE   {{$RANGE_L, $RANGE_B}, {$RANGE_R, $RANGE_T}}\n#define NUMBER  $NUMBER\n#define F1 \\"

rm /srv/www/pavpan/sam-complex/img/output-*.bmp
rm /srv/www/pavpan/sam-complex/img/output-*.bmp.png
echo $header > /tmp/plotter.cc;
cat /tmp/f1 >> /tmp/plotter.cc
echo "\n#define F2 \\" >> /tmp/plotter.cc
cat /tmp/f2 >> /tmp/plotter.cc
echo "\n\n" >> /tmp/plotter.cc
cat /srv/www/pavpan/sam-complex/complex.cc >> /tmp/plotter.cc
cp /srv/www/pavpan/sam-complex/EasyBMP /tmp -r
g++ -std=c++0x /tmp/plotter.cc /tmp/EasyBMP/EasyBMP.cpp -o /tmp/plotter.out
/tmp/plotter.out
convert $OUTNAME $OUTNAME.png
#rm /tmp/plotter.out /tmp/plotter.cc /tmp/EasyBMP -r
