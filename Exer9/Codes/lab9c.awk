BEGIN {
	
	#receive
	data_1=0;
	packets_1=0;
	data_3=0;
	packets_3=0;
	data_4a=0;
	data_4b=0;
	packets_4a=0; 
	packets_4b=0;
	
	#send
	data_1s=0;
		data_1sd=0;
			data_1sack=0;
	packets_1s=0;
		packets_1sd=0;
			packets_1sack=0;
	data_2s=0;
	data_2sd=0;
	data_2sack=0;
	packets_2s=0;
		packets_2sd=0;
			packets_2sack=0;
	data_3s=0;
	data_3sd=0;
	data_3sack=0;
	packets_3s=0;
	packets_3sd=0;
	packets_3sack=0;
	data_4s=0;
		data_4sd=0;
			data_4sack=0;
	packets_4s=0;
	packets_4sd=0;
	packets_4sack=0;
	
	# Do we need to fix the decimal mark?
	if (sprintf(sqrt(2)) ~ /,/) dmfix = 1;
}

{
	# Apply dm fix if needed
	if (dmfix) sub(/\./, ",", $0);
}

#--------------Apostolh dedomenwn---------------------
#apostolh apo ton komvo 1
/^s/&&/_1_ AGT/&&/cbr/ {
		data_1s += $8;
		packets_1s++;
}
/^D/&&/_1_ IFQ/&&/cbr/ {
		data_1sd += $8;
		packets_1sd++;
}

#apostolh apo ton komvo 3
/^s/&&/_3_ AGT/&&/cbr/ {
		data_3s += $8;
		packets_3s++;
}
/^D/&&/_3_ IFQ/&&/cbr/ {
		data_3sd += $8;
		packets_3sd++;
}


#apostoli apo ton komvo 2
/^s/&&/_2_ AGT/&&/tcp/ {
		data_2s += $8;
		packets_2s++;
}
/^D/&&/_2_ IFQ/&&/tcp/ {
		data_2sd += $8;
		packets_2sd++;
}
/^D/&&/IFQ/&&/ack/&&/4:0 2:0/ {
		data_2sack += 1020;
		packets_2sack++
}

#apostoli apo ton komvo 4
/^s/&&/_4_ AGT/&&/tcp/ {
		data_4s += $8;
		packets_4s++;
}
/^D/&&/_4_ IFQ/&&/tcp/ {
		data_4sd += $8;
		packets_4sd++;
}
/^D/&&/IFQ/&&/ack/&&/1:1 4:2/ {
		data_4sack += 1020;
		packets_4sack++
}

#---------Lhpsh dedomenwn----------------
/^r/&&/AGT/&&/tcp/ {
		data_1 += $8;
		packets_1++;
		last_ts_4 = $2;
}
/^r/&&/_3_ AGT/&&/cbr/ {
		data_3 += $8;
		packets_3++;
		last_ts_1= $2;
}

/^r/&&/_4_ AGT/&&/cbr/ {
		data_4a += $8;
		packets_4a++;
		last_ts_3= $2;
}

/^r/&&/_4_ AGT/&&/tcp/ {
		data_4b+= $8;
		packets_4b++;
		last_ts_2= $2;
}

END{

printf("Duration of files transmition for flow 1: %s sec\n", last_ts_1-0.1);
printf("Duration of files transmition for flow 2: %s sec\n", last_ts_2-0.3);
printf("Duration of files transmition for flow 3: %s sec\n", last_ts_3-0.5);
printf("Duration of files transmition for flow 4: %s sec\n", last_ts_4-0.7);
printf("\n");

printf("Total    Data sent from Node  1\t\t: %d Bytes\n", data_1s-data_1sd-data_1sack);
printf("Total Packets sent from Node  1\t\t: %d\n", packets_1s- packets_1sd-packets_1sack);
printf("Total    Data sent from Node  2\t\t: %d Bytes\n", data_2s-data_2sd-data_2sack);
printf("Total Packets sent from Node  2\t\t: %d\n", packets_2s- packets_2sd-packets_2sack);
printf("Total    Data sent from Node  3\t\t: %d Bytes\n", data_3s-data_3sd-data_3sack);
printf("Total Packets sent from Node  3\t\t: %d\n", packets_3s- packets_3sd-packets_3sack);
printf("Total    Data sent  from Node 4\t\t: %d Bytes\n", data_4s-data_4sd-data_4sack);
printf("Total Packets sent from Node  4\t\t: %d\n", packets_4s- packets_4sd-packets_4sack);
printf("\n");

printf("Dropped    Data for flow 1-3 \t\t: %d Bytes\n", data_1sd);
printf("Dropped Packets for flow 1-3 \t\t: %d\n", packets_1sd);
printf("Dropped    Data for flow 2-4 \t\t: %d Bytes\n", data_2sd);
printf("Dropped Packets for flow 2-4 \t\t: %d\n", packets_2sd);
printf("Dropped    Data for flow 3-4 \t\t: %d Bytes\n", data_3sd);
printf("Dropped Packets for flow 3-4 \t\t: %d\n", packets_3sd);
printf("Dropped    Data for flow 4-1 \t\t: %d Bytes\n", data_4sd);
printf("Dropped Packets for flow 4-1 \t\t: %d\n", packets_4sd);

printf("\n");

printf("Total    Data received to Node  1\t: %d Bytes\n", data_1);
printf("Total Packets received to Node  1\t: %d\n", packets_1);
printf("Total    Data received to Node  3\t: %d Bytes\n", data_3);
printf("Total Packets received to Node  3\t: %d\n", packets_3);
printf("Total    Data received to Node  4\t: %d Bytes\n", data_4a+data_4b);
printf("Total Packets received to Node  4\t: %d\n", packets_4a+packets_4b);
printf("\n");

}


