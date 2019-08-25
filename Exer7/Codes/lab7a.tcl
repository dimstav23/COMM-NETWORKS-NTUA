set ns [new Simulator]

Agent/rtProto/Direct set preference_ 200
$ns rtproto DV

set nf [open lab7a.nam w]
$ns namtrace-all $nf
set xf [open lab7.tr w]
$ns trace-all $xf

proc record {} {
	global sink1 sink2 xf1 xf2
	set ns [Simulator instance]
	set time 0.025
	set bw1 [$sink1 set bytes_]
	set bw2 [$sink2 set bytes_]
	set now [$ns now]
	puts $xf1 "$now [expr (($bw1/$time)*8)/1000000]"
	puts $xf2 "$now [expr (($bw2/$time)*8)/1000000]"
	$sink1 set bytes_ 0
	$sink2 set bytes_ 0
	$ns at [expr $now+$time] "record"
}

proc finish {} {
	global ns nf xf1 xf2
	$ns flush-trace
	close $nf
	close $xf1
	close $xf2
	exit 0
}

for {set i 0} {$i < 4} {incr i} {
	set n($i) [$ns node]
}

$ns duplex-link $n(0) $n(1) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(3) 3.2Mb 10ms DropTail
$ns duplex-link $n(2) $n(3) 2Mb 10ms DropTail

set udp1 [new Agent/UDP]
$udp1 set packetSize_ 500
$ns attach-agent $n(2) $udp1
$udp1 set fid_ 1
$ns color 1 blue
set sink1 [new Agent/LossMonitor]
$ns attach-agent $n(0) $sink1

set udp2 [new Agent/UDP]
$udp2 set packetSize_ 500
$ns attach-agent $n(3) $udp2
$udp2 set fid_ 2
$ns color 2 red
set sink2 [new Agent/LossMonitor]
$ns attach-agent $n(1) $sink2

$ns connect $udp1 $sink1
$ns connect $udp2 $sink2

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.0025
$cbr1 attach-agent $udp1
set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 500
$cbr2 set interval_ 0.0025
$cbr2 attach-agent $udp2

$ns at 0.0 "record"
$ns at 0.5 "$cbr1 start"
$ns at 0.5 "$cbr2 start"
$ns rtmodel-at 1.0 down $n(0) $n(1)
$ns rtmodel-at 2.0 up $n(0) $n(1)
$ns at 2.5 "$cbr1 stop"
$ns at 2.5 "$cbr2 stop"
$ns at 3.0 "finish"

$ns run