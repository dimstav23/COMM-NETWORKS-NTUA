BEGIN {
	blue = 0;
	red = 0;
	number_of_blue = 0;
	number_of_red = 0;
}
/^r/&&/ack/ {
	if ($4 == 0) {
		blue = $2;
		number_of_blue++;
	}
	if ($4 == 4) {
		red = $2;
		number_of_red++;
	}
}
END {
	printf("Packets in blue flow received\t\t: %d\n", 	number_of_blue-1);
	printf("Last aknowledgement received at\t\t: %s sec\n", 	blue);
	printf("Packets in red flow received\t\t: %d\n", 	number_of_red-1);
	printf("Last aknowledgement received at\t\t: %s sec\n", 	red);
	}