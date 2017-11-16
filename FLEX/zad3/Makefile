scan: scan.c
	gcc -o scan scan.c

scan.c: zad3.l
	flex -oscan.c zad3.l

clean:
	rm scan.c scan
