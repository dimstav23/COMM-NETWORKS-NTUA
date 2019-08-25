BEGIN {
	data = 0;
	packets = 0;
	buffersize = 10;
	sumDelay = 0;
	bufferspace = 10000;
	last_rec = 0;
	dropped = 0;
	#Do we need to fix the decimal mark?
	if (sprintf(sqrt(2)) ~ /,/) dmfix = 1;
}
{
	#Apply dm fix if needed
	if (dmfix) sub(/\./, ",", $0);
}
/^-/&&/cbr/ {
	sendtimes[$12%bufferspace] = $2;
}
/^r/&&/cbr/ {
	data += $6;
	packets++;
	sumDelay += $2 - sendtimes[$12%bufferspace];
	last_rec = $2;
}
/^d/ {
	dropped++;
}
END {
	printf("Total Data received\t: %d Bytes\n", data);
	printf("Total Packets received\t: %d\n", packets);
	printf("Average Delay\t\t: %f sec\n", (1.0*sumDelay)/packets);
	printf("Last packet successfully received at\t: %f sec\n", last_rec);
	printf("Dropped\t\t: %d\n", dropped);
}


8 periergoi awk kwdikes