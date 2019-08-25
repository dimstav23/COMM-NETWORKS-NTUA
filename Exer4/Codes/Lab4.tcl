set ns [new Simulator]
#Set the nam trace file 
set nf [open lab4.nam w]
$ns namtrace-all $nf
#Set the trace file
set trf [open lab4.tr w]
$ns trace-all $trf
#define a 'finish' procedure
proc finish {} {
		global ns nf trf acc2 acc3
		$ns flush-trace
		#Close the trace file
		close $nf
		close $trf
		exit 0
}
#Create the nodes
for {set i 0} {$i < 4} {incr i} {
	set n($i) [$ns node]
}
$ns at 0.0 "$n(0) label GBN_sender"
$ns at 0.0 "$n(3) label GBN_receiver"
$ns at 0.0 "$n(1) label SW_sender"
$ns at 0.0 "$n(2) label SW_receiver"
#Create a duplex link between the nodes
for {set i 0} {$i < 4} {incr i} {
		$ns duplex-link $n($i) $n([expr ($i+1)%4]) 3Mb 48ms DropTail
		#Sets the queue limit of the two simplex links too the number specified
		$ns queue-limit $n($i) $n([expr ($i+1)%4]) 150
		$ns queue-limit $n([expr ($i+1)%4]) $n($i) 150
}
$ns duplex-link-op $n(0) $n(1) orient right
$ns duplex-link-op $n(1) $n(2) orient down
$ns duplex-link-op $n(2) $n(3) orient left
$ns duplex-link-op $n(3) $n(0) orient up
#Define color index
$ns color 0 blue
$ns color 1 orange
#Setup go-back-n sender-receiver
set tcp0 [new Agent/TCP/Reno]
$tcp0 set packetSize_ 960
$tcp0 set window_ 10
#Disable modelling the initial SYN/SYNACK exchange
$tcp0 set syn_ false
#The initial size of the congestion window on slow-start
$tcp0 set windowInit_ 10
#Set flow ID
$tcp0 set fid_ 0
$ns attach-agent $n(0) $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n(3) $sink0
$ns connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
#Setup stop-and-wait sender-receiver
set tcp1 [new Agent/TCP/Reno]
$tcp1 set packetSize_ 960
$tcp1 set window_ 1
#Disable modelling the initial SYN/SYNACK exchange
$tcp1 set syn_ false
#The initial size of the congestion window on slow-start
$tcp1 set windowInit_ 1
#Set flow ID
$tcp1 set fid_ 1
$ns attach-agent $n(1) $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n(2) $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
#Events
$ns at 0.25 "$ftp0 produce 100"
$ns at 0.25 "$ftp1 produce 100"
$ns at 15.0 "finish"
#Run the simulation 
$ns run

	