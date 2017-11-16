scan: scan.c
	gcc -o scan scan.c

scan.c: zad2.l
	flex -oscan.c zad2.l

clean:
	rm scan.c scan
