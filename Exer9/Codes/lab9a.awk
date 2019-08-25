BEGIN {
	time = 0;
	if (sprintf(sqrt(2)) ~ /,/) dmfix = 1;
}
{
	if (dmfix) sub(/\./, ",", $0);
}
{
	if (($3 == 3)&&($4 == 0)&&(time < 3)&&($5 != "rtProtoDV"))
		time = $2;	
}
END {
	printf("time : %f\n", time); 
}