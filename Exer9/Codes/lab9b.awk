BEGIN {
	last_f1 = 0; last_f2 = 0; last_f3 = 0; last_f4 = 0;
	sent_packets_1 = 0; data_sent_1 = 0;
	send_index2 = 0; sent_packets_2 = 0; data_sent_2 = 0;
	sent_packets_3 = 0; data_sent_3 = 0;
	send_index4 = 0; sent_packets_4 = 0; data_sent_4 = 0;
	lost1 = 0; ldata1 = 0;
	lost2 = 0; ldata2 = 0;
	lost3 = 0; ldata3 = 0;
	lost4 = 0; ldata4 = 0;
	rec_1 = 0; rec_2 = 0; rec_3 = 0; rec_4 = 0;
	rdata1 = 0; rdata2 = 0; rdata3 = 0; rdata4 = 0;
	
	if (sprintf(sqrt(2)) ~ /,/) dmfix = 1;
}
{
	if (dmfix) sub(/\./, ",", $0);
}
/^s/&&/-Ni 1/&&/-It cbr/&&/-Nl AGT/ {
	if (start_f1 == "")
		start_f1 = $3;
	sent_packets_1++;
	data_sent_1 += $37;
}
/^s/&&/-Ni 2/&&/-It tcp/&&/-Nl AGT/ {
	if (start_f2 == "")
		start_f2 = $3;
	sent_packets_2++;
	data_sent_2 += $37;
}
/^s/&&/-Ni 3/&&/-It cbr/&&/-Nl AGT/ {
	if (start_f3 == "")
		start_f3 = $3;
	sent_packets_3++;
	data_sent_3 += $37;
}
/^s/&&/-Ni 4/&&/-It tcp/&&/-Nl AGT/ {
	if (start_f4 == "")
		start_f4 = $3;
	sent_packets_4++;
	data_sent_4 += $37;
}
/^r/&&/-Ni 3/&&/-It cbr/ {
	last_f1 = $3;
}
/^r/&&/-Ni 4/&&/-It tcp/ {
	last_f2 = $3;
}
/^r/&&/-Ni 4/&&/-It cbr/ {
	last_f3 = $3;
}
/^r/&&/-Ni 1/&&/-It tcp/ {
	last_f4 = $3;
}
/^d/&&/-It cbr/ {
	if ($5 == 1) {
		lost1++;
		ldata1 += $37;
	}
	if ($5 == 3) {
		lost3++;
		ldata3 += $37;
	}
}
/^d/&&/-It tcp/ {
	if ($5 == 2) {
		lost2++;
		ldata2 += $37;
	}
	if ($5 == 4) {
		lost4++;
		ldata4 += $37;
	}
}
/^d/ {
	if ($5 == 2) {
		l2++;
		ld2 += $37;
	}
	if ($5 == 4) {
		l4++;
		ld4 += $37;
	}
}
/^r/&&/AGT/&&/-It cbr/ {
	if ($9 == 3) {
		rdata1 += $37;
		rec_1++;
	}
	if ($9 == 4) {
		rdata3 += $37;
		rec_3++;
	}
}
/^r/&&/AGT/&&/-It tcp/ {
	if ($9 == 4) {
		rdata2 += $37;
		rec_2++;
	}
	if ($9 == 1) {
		rdata4 += $37;
		rec_4++;
	}
}
END {
	printf("-----------------------------FLOW 1-----------------------------\n");
	printf("First packet sent at\t\t: %f sec\n", start_f1);
	printf("Last packet received at\t\t: %f sec\n", last_f1);
	printf("Transmition lasted\t\t: %f sec\n", last_f1-start_f1);
	printf("Total packets sent\t\t: %d\n", sent_packets_1);
	printf("Total data sent\t\t\t: %d Bytes\n", data_sent_1);
	printf("Lost packets\t\t\t: %d\n", lost1);
	printf("Lost data\t\t\t: %d Bytes\n", ldata1);
	printf("Packets received from node 3\t: %d\n", rec_1);
	printf("Data received from node 3\t: %d Bytes\n", rdata1);
	printf("-----------------------------FLOW 2-----------------------------\n");
	printf("First packet sent at\t\t: %f sec\n", start_f2);
	printf("Last packet received at\t\t: %f sec\n", last_f2);
	printf("Transmition lasted \t\t: %f sec\n", last_f2-start_f2);
	printf("Total packets sent\t\t: %d\n", sent_packets_2-l2);
	printf("Total data sent \t\t: %d Bytes\n", data_sent_2-ld2);
	printf("Lost packets\t\t\t: %d\n", lost2);
	printf("Lost data\t\t\t: %d Bytes\n", ldata2);
	printf("Packets received from node 4\t: %d\n", rec_2);
	printf("Data received from node 4\t: %d Bytes\n", rdata2);
	printf("-----------------------------FLOW 3-----------------------------\n");
	printf("First packet sent at\t\t: %f sec\n", start_f3);
	printf("Last packet received at\t\t: %f sec\n", last_f3);
	printf("Transmition lasted \t\t: %f sec\n", last_f3-start_f3);
	printf("Total packets sent\t\t: %d\n", sent_packets_3);
	printf("Total data sent \t\t: %d Bytes\n", data_sent_3);
	printf("Lost packets\t\t\t: %d\n", lost3);
	printf("Lost data\t\t\t: %d Bytes\n", ldata3);
	printf("Packets received from node 4\t: %d\n", rec_3);
	printf("Data received from node 4\t: %d Bytes\n", rdata3);
	printf("-----------------------------FLOW 4-----------------------------\n");
	printf("First packet sent at\t\t: %f sec\n", start_f4);
	printf("Last packet received at\t\t: %f sec\n", last_f4);
	printf("Transmition lasted \t\t: %f sec\n", last_f4-start_f4);
	printf("Total packets sent\t\t: %d\n", sent_packets_4-l4);
	printf("Total data sent \t\t: %d Bytes\n", data_sent_4-ld4);
	printf("Lost packets\t\t\t: %d\n", lost4);
	printf("Lost data\t\t\t: %d Bytes\n", ldata4);
	printf("Packets received from node 1\t: %d\n", rec_4);
	printf("Data received from node 1\t: %d Bytes\n", rdata4);
}