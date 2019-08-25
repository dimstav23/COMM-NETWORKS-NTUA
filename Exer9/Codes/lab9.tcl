set ns [new Simulator]

#Agent/rtProto/Direct set preference_ 200
#$ns rtproto DV

set tf [open lab9.tr w]
$ns trace-all $tf

set nf [open lab9.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exit 0
}

for {set i 0} {$i < 5} {incr i} {
	set n($i) [$ns node]
}

for {set i 1} {$i < 5} {incr i} {
	$ns duplex-link $n(0) $n($i) 1Mb 10ms DropTail
	#$ns duplex-link-op $n(0) $n($i) label "Spd:1Mbps Qlen: 25" 
	$ns queue-limit $n(0) $n($i) 25
	$ns queue-limit $n($i) $n(0) 25
	$ns cost $n(0) $n($i) 1
	$ns cost $n($i) $n(0) 1
}

$ns duplex-link $n(3) $n(4) 0.8Mbps 50ms DropTail
$ns queue-limit $n(3) $n(4) 25
$ns queue-limit $n(4) $n(3) 25
$ns cost $n(3) $n(4) 5
$ns cost $n(4) $n(3) 5
$ns duplex-link-op $n(4) $n(3) orient down
$ns duplex-link-op $n(1) $n(0) orient right-down
$ns duplex-link-op $n(2) $n(0) orient right-up
$ns duplex-link-op $n(0) $n(4) orient right-up
$ns duplex-link-op $n(0) $n(3) orient right-down

$ns color 1 blue
$ns color 2 red
$ns color 3 green
$ns color 4 yellow

set udp1 [new Agent/UDP]
$udp1 set fid_ 1
$ns attach-agent $n(1) $udp1
set null1 [new Agent/Null]
$ns attach-agent $n(3) $null1
$ns connect $udp1 $null1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 0.8mb
$cbr1 set random_ off

set tcp2 [new Agent/TCP]
$tcp2 set packetSize_ 960
$tcp2 set fid_ 2
$ns attach-agent $n(2) $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n(4) $sink2
$ns connect $tcp2 $sink2

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

set udp3 [new Agent/UDP]
$udp3 set fid_ 3
$ns attach-agent $n(3) $udp3
set null3 [new Agent/Null]
$ns attach-agent $n(4) $null3
$ns connect $udp3 $null3

set exp3 [new Application/Traffic/Exponential]
$exp3 attach-agent $udp3
$exp3 set packetSize_ 1000
$exp3 set rate_ 0.8mb

set tcp4 [new Agent/TCP]
$tcp4 set packetSize_ 960
$tcp4 set fid_ 4
$ns attach-agent $n(4) $tcp4
set sink4 [new Agent/TCPSink]
$ns attach-agent $n(1) $sink4
$ns connect $tcp4 $sink4

set telnet4 [new Application/Telnet]
$telnet4 attach-agent $tcp4
$telnet4 set interval_ 0.0025

# Events
$ns at 0.0 "$n(0) label n_0"
$ns at 0.0 "$n(1) label n_1"
$ns at 0.0 "$n(2) label n_2"
$ns at 0.0 "$n(3) label n_3"
$ns at 0.0 "$n(4) label n_4"
$ns at 0.1 "$cbr1 start"
$ns at 0.3 "$ftp2 start"
$ns at 0.5 "$exp3 start"
$ns at 0.7 "$telnet4 start"
$ns rtmodel-at 1.0 down $n(0) $n(3)
$ns rtmodel-at 3.0 up $n(0) $n(3)
$ns at 5.1 "$cbr1 stop"
$ns at 5.3 "$ftp2 stop"
$ns at 5.5 "$exp3 stop"
$ns at 5.7 "$telnet4 stop"
$ns at 20.0 "finish"
$ns run