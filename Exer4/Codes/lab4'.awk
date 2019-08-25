BEGIN {

}
/^r/&&/ack/ {
flow_id = $8;
if (flow_id == 0) {

last_ts_0 = $2;
}
if (flow_id == 1) {

last_ts_1 = $2;
}
}
END {
printf("Last ack packet received for flow ID 0\t: %s sec\n",last_ts_0);

printf("Last ack packet received for flow ID 1\t: %s sec\n",last_ts_1);
}