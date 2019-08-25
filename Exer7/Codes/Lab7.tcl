set ns [new Simulator]
Agent/rtProto/Direct set preference_ 200
$ns rtproto DV
set nf [open lab7.nam w]
$ns namtrace-all $nf
set xf [open lab7.tr w]
$ns trace-all $xf
proc finish {} {
	global ns nf xf
	$ns flush-trace
	close $nf
	close $xf
	exit 0
}
for {set i 0} {$i < 8} {incr i} {
	set n($i) [$ns node]
}
for {set i 0} {$i < 8} {incr i} {
	if {$i == 5} {
		set j 1
	} elseif {$i == 6} {
		set j 3
	} else {
		set j 2
	}
	$ns duplex-link $n($i) $n([expr ($i+1)%8]) 1Mb [expr ($j*10)]ms DropTail
	$ns cost $n($i) $n([expr ($i+1)%8]) $j
	$ns cost $n([expr ($i+1)%8]) $n($i) $j
}
$ns duplex-link $n(7) $n(1) 1Mb 30ms DropTail
$ns cost $n(7) $n(1) 3
$ns cost $n(1) $n(7) 3
$ns duplex-link $n(7) $n(6) 1Mb 30ms DropTail
$ns cost $n(7) $n(6) 3
$ns cost $n(6) $n(7) 3
$ns duplex-link $n(5) $n(7) 1Mb 50ms DropTail
$ns cost $n(5) $n(7) 5
$ns cost $n(7) $n(5) 5
$ns duplex-link $n(6) $n(5) 1Mb 30ms DropTail
$ns cost $n(5) $n(6) 3
$ns cost $n(6) $n(5) 3
$ns duplex-link $n(1) $n(3) 1Mb 10ms DropTail
$ns cost $n(3) $n(1) 1
$ns cost $n(1) $n(3) 1
$ns duplex-link $n(5) $n(3) 1Mb 30ms DropTail
$ns cost $n(3) $n(5) 3
$ns cost $n(5) $n(3) 3
$ns color 0 blue
$ns color 1 red
set tcp0 [new Agent/TCP]
$ns attach-agent $n(0) $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n(5) $sink0
$tcp0 set packetSize_ 500
$tcp0 set fid_ 0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set tcp1 [new Agent/TCP]
$ns attach-agent $n(4) $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n(7) $sink1
$tcp1 set packetSize_ 500
$tcp1 set fid_ 1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 0.5 "$ftp0 produce 120"
$ns at 0.8 "$ftp1 produce 120"
$ns at 3.0 "finish"
$ns run
