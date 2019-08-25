set ns [new Simulator]
set nf [open Lab1.nam w]
$ns namtrace-all $nf
set f [open lab1.tr w]
proc record {} {
		global sink f
		set ns [Simulator instance]
		#orismos ths wras pou h diadikasia tha ksanaklhthei
		set time 0.15
		#katagrafh twn bytes
		set bw [$sink set bytes_]
		#lhpsh ths trexousas wras
		set now [$ns now]
		#ypologismos tou bandwidth kai katagrafh aytou sto arxeio
		puts $f "$now [expr ((($bw/$time)*8)/1000000)] "
		#kanei thn timh bytes_ 0
		$sink set bytes_ 0
		#epanaprogrammatismos ths diadikasias
		$ns at [expr $now+$time] "record"
}

proc finish {} {
		global ns nf f
		$ns flush-trace
		close $nf
		close $f
		exit 0
}
set n0 [$ns node]
set n1 [$ns node]
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
#Dhmiourgia enos UDP agent kai "prosartisi" tou ston komvo "n0"
set udp0 [new Agent/UDP]
$udp0 set packetSize_ 1000
$ns attach-agent $n0 $udp0
#Dhmiourgia mias phghs kinhshs CBR kai "topothethsh" ths sto "udp0"
set traffic0 [new Application/Traffic/CBR]
#Prosdiorismos ths kinhshs gia ton komvo n0
$traffic0 set packetSize_ 1000
$traffic0 set interval_ 0.005
$traffic0 attach-agent $udp0
set sink [new Agent/LossMonitor]
$ns attach-agent $n1 $sink
$ns connect $udp0 $sink
$ns at 0.0 "record"
$ns at 1.0 "$traffic0 start"
$ns at 7.0 "$traffic0 stop"
$ns at 8.0 "finish"
$ns run

