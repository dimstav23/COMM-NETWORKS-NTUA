BEGIN {
	data = 0;
	packets = 0;
	sumDelay = 0;
	#do we need to fix the decimal mark?
	if (sprintf(sqrt(2)) ~ /,/) dmfix = 1;
}
{
	#apply dmfix if needed
	if (dmfix) sub(/\./, ",", $0);
}
/^s/&&/AGT/&&/cbr/ {
	if (t_start == "")
		t_start = $2;
	sendtimes[$6] = $2;
}

/^r/&&/AGT/&&/cbr/ {
	data += $8;
	packets++;
	sumDelay += $2 - sendtimes[$6];
	t_end = $2;
}

/^s/&&/_0_/&&/AODV/ {
	if (rt_start == "")
		rt_start = $2;
}

/^r/&&/_0_/&&/AODV/ {
	rt_end = $2;
}

END {
	printf("Total data received\t: %d Bytes\n", data);
	printf("Total packets received\t: %d\n", packets);
	printf("CBR start\t\t: %s\n", t_start);
	printf("CBR end \t\t: %s\n", t_end);
	printf("Mean CBR packet delay\t: %lf sec\n", (1.0 * sumDelay) / packets);
	printf("Routing start\t\t: %s\n", rt_start);
	printf("Routing end\t\t: %s\n", rt_end);
	printf("Routing delay\t\t: %f sec\n", rt_end-rt_start);
}