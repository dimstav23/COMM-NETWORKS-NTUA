BEGIN {
	last_f1 = 0; last_f2 = 0; last_f3 = 0; last_f4 = 0;
	send_index1 = 0; sent_packets_1 = 0; data_sent_1 = 0;
	send_index2 = 0; sent_packets_2 = 0; data_sent_2 = 0;
	send_index3 = 0; sent_packets_3 = 0; data_sent_3 = 0;
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
/^r/{
	if ($6 == 1000)
		if ($8 == 1)
			last_f1 = $2;
		else if ($8 == 2)
			last_f2 = $2;
		else if ($8 == 3)
			last_f3 = $2;
		else
			last_f4 = $2;
}
/^r/ {
	if (($5 != "ack")&&($5 != "rtProtoDV"))
		if (($8 == 1)&&($4 == 3)) {
			rec_1++;
			rdata1 += $6;
		}
		else if (($8 == 2)&&($4 == 4)) {
			rec_2++;
			rdata2 += $6;
		}
		else if (($8 == 3)&&($4 == 4)) {
			rec_3++;
			rdata3 += $6;
		}
		else if (($8 == 4)&&($4 == 1)) {
			rec_4++;
			rdata4 += $6;
		}
}
/^+/{
	if ((start_f1 == "")&&($8 == 1))
		start_f1 = $2;
	if ((start_f2 == "")&&($8 == 2))
		start_f2 = $2;
	if ((start_f3 == "")&&($8 == 3))
		start_f3 = $2;
	if ((start_f4 == "")&&($8 == 4))
		start_f4 = $2;
	if (($11 == send_index1)&&($8 == 1)) {
		if ($5 == "cbr") {
			sent_packets_1++;
			data_sent_1 += $6;
		}
		send_index1++;
	}
	if (($11 == send_index2)&&($8 == 2)) {
		if ($5 == "tcp") {
			sent_packets_2++;
			data_sent_2 += $6;
		}
		send_index2++;
	}
	if (($11 == send_index3)&&($8 == 3)) {
		if ($5 == "exp") {
			sent_packets_3++;
			data_sent_3 += $6;
		}
		send_index3++;
	}
	if (($11 == send_index4)&&($8 == 4)) {
		if ($5 == "tcp") {
			sent_packets_4++;
			data_sent_4 += $6;
		}
		send_index4++;
	}
}
/^d/ {
	if (($5 != "ack")&&($5 != "rtProtoDV"))
		if ($8 == 1) {
			lost1++
			ldata1 += $6;
		}
		else if ($8 == 2) {
			lost2++
			ldata2 += $6;
		}
		else if ($8 == 3) {
			lost3++
			ldata3 += $6;
		}
		else if ($8 == 4) {
			lost4++
			ldata4 += $6;
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
	printf("Total packets sent\t\t: %d\n", sent_packets_2);
	printf("Total data sent \t\t: %d Bytes\n", data_sent_2);
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
	printf("Total packets sent\t\t: %d\n", sent_packets_4);
	printf("Total data sent \t\t: %d Bytes\n", data_sent_4);
	printf("Lost packets\t\t\t: %d\n", lost4);
	printf("Lost data\t\t\t: %d Bytes\n", ldata4);
	printf("Packets received from node 1\t: %d\n", rec_4);
	printf("Data received from node 1\t: %d Bytes\n", rdata4);
}