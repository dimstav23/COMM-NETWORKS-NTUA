set ns [new Simulator]
set nf [open lab3.nam w]
$ns namtrace-all $nf
set f0 [open out0.tr w]
set f3 [open out3.tr w]
proc record {} {
	global sink0 sink3 f0 f3
	set ns [Simulator instance]
	# ???sµ?? t?? ???????? pe???d?? p?? ?a ?a?a????e? ? d?ad??as?a
	set time 0.015
	# ?ata??af? t?? bytes
	set bw0 [$sink3 set bytes_]
	set bw3 [$sink0 set bytes_]
	# ???sµ?? t?? ?????? t?? t?????sa? ?ata??af??
	set now [$ns now]
	# ?p?????sµ?? t?? bandwidth ?a? ?ata??af? a?t?? st? a??e??
	puts $f0 "$now [expr (($bw0/$time)*8)/1000000]"
	puts $f3 "$now [expr (($bw3/$time)*8)/1000000]"
	# ???e? t?? µetaﬂ??t? bytes 0
	$sink0 set bytes_ 0
	$sink3 set bytes_ 0
	# ?pa?ap????aµµat?sµ?? t?? d?ad??as?a?
	$ns at [expr $now+$time] "record"
}
Agent/rtProto/Direct set preference_ 200
$ns rtproto DV
proc finish {} {
	global ns nf f0 f3
	$ns flush-trace
	close $nf
	close $f0
	close $f3
	exit 0
}
for {set i 0} {$i < 9} {incr i} {
	set n($i) [$ns node]
}
for {set i 0 } {$i < 7} {incr i} {
	$ns duplex-link $n($i) $n([expr ($i+1)%7]) 2Mb 40ms DropTail
}
$ns duplex-link $n(7) $n(1) 2Mb 20ms DropTail
$ns duplex-link $n(7) $n(5) 2Mb 10ms DropTail
$ns duplex-link $n(8) $n(5) 2Mb 10ms DropTail
$ns duplex-link $n(8) $n(2) 2Mb 40ms DropTail
$ns cost $n(1) $n(0) 4
$ns cost $n(0) $n(1) 4
$ns cost $n(1) $n(2) 4
$ns cost $n(2) $n(1) 4
$ns cost $n(2) $n(3) 4
$ns cost $n(3) $n(2) 4
$ns cost $n(3) $n(4) 4
$ns cost $n(4) $n(3) 4
$ns cost $n(4) $n(5) 4
$ns cost $n(5) $n(4) 4
$ns cost $n(5) $n(6) 4
$ns cost $n(6) $n(5) 4
$ns cost $n(7) $n(5) 1
$ns cost $n(5) $n(7) 1
$ns cost $n(8) $n(2) 4
$ns cost $n(2) $n(8) 4
$ns cost $n(8) $n(5) 1
$ns cost $n(5) $n(8) 1
$ns cost $n(0) $n(6) 4
$ns cost $n(6) $n(0) 4
$ns cost $n(1) $n(7) 2
$ns cost $n(7) $n(1) 2
$ns at 0.0 "record"
# ??µﬂ?? 0: p??? ?a? p?????sµ??
set udp0 [new Agent/UDP]
# $udp0 set packetSize_ 1500
$ns attach-agent $n(0) $udp0
$udp0 set fid_ 0
$ns color 0 green
set sink0 [new Agent/LossMonitor]
$ns attach-agent $n(0) $sink0
# ??µﬂ?? 3: p??? ?a? p?????sµ??
set udp3 [new Agent/UDP]
# $udp3 set packetSize_ 1500
$ns attach-agent $n(3) $udp3
$udp3 set fid_ 3
$ns color 3 yellow
set sink3 [new Agent/LossMonitor]
$ns attach-agent $n(3) $sink3
# S??des? t?? p???? ?a? t?? p?????sµ??
$ns connect $udp0 $sink3
$ns connect $udp3 $sink0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1500
$cbr0 set interval_ 0.015
$cbr0 attach-agent $udp0
set exp3 [new Application/Traffic/Exponential]
$exp3 set packetSize_ 1500
$exp3 set rate_ 800k
$exp3 attach-agent $udp3
$ns at 0.0 "record"
$ns at 0.2 "$cbr0 start"
$ns at 0.7 "$exp3 start"
$ns at 20.0 "$exp3 stop"
$ns at 20.5 "$cbr0 stop"
$ns at 21.0 "finish"
$ns run
