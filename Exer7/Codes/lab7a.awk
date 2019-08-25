BEGIN {
lost_green=0;
lost_orange=0;
}
/^d/&&/cbr/ {
flow_id=$8;
if (flow_id==2){
   lost_green++;
}
if (flow_id==3){
   lost_orange++;
}
}
END {
printf ("Total packets lost for green flow\t: %d\n", lost_green);
printf ("Total packets lost for orange flow\t: %d\n", lost_orange);
}
