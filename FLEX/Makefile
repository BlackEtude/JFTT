scan: scan.c
	gcc -o scan scan.c -lm

scan.c: zadanie4.l
	flex -oscan.c zadanie4.l

clean:
	rm scan.c scan
