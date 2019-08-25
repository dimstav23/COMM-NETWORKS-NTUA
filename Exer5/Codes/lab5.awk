BEGIN {
	data=0;
	packets=0;
	time2=0;
}
/^r/&&/ack/ {
	time = $2;
}
/^r/&&/tcp/ {
	data+=$6;
	packets++;
}

END {
	printf("Total Data received\t: %d Bytes\n", data);
	printf("Total Packets received\t: %d\n", packets);
	printf("Total duration of data transmission\t : %f sec\n", time-0.25);
}