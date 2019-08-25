#Create a simulator object
set ns [new Simulator]
#Open the nam trace file
set nf [open lab5.nam w]
$ns namtrace-all $nf
set trf [open lab5.tr w]
$ns trace-all $trf
#Define a 'finish' procedure
proc finish {} {
	global ns nf trf
	$ns flush-trace
	#Close the trace file
	close $nf
	close $trf
	exit 0
}
#Create two nodes
set n(0) [$ns node]
set n(1) [$ns node]
$ns at 0.0 "$n(0) label SRP_sender"
$ns at 0.0 "$n(1) label SRP_receiver"
#Create a duplex link between the nodes
$ns duplex-link $n(0) $n(1) 26Mb 200ms DropTail
#The following line set the queue limit of the two simplex links that connect
#node0 and node 1 to the number specified
$ns queue-limit $n(0) $n(1) 150
$ns queue-limit $n(1) $n(0) 150
#Create TCP agent
set tcp0 [new Agent/TCP/Reno]
#Set window size
$tcp0 set window_ 117
#The initial size of the congestion window on slow-start
$tcp0 set windowInit_ 117
#Disable modelling the initial SYN/SYNACK exchange
$tcp0 set syn_ false
#Set packet size
$tcp0 set packetSize_ 2250
#Attach TCP agent to node n(0)
$ns attach-agent $n(0) $tcp0
#Create TCP sink
set sink0 [new Agent/TCPSink]
#Attach TCP sink to node n(1)
$ns attach-agent $n(1) $sink0
#Connect TCP agent to sink
$ns connect $tcp0 $sink0
$ns duplex-link-op $n(0) $n(1) orient right
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
#Events
$ns at 0.25 "$ftp0 start"
$ns at 5.25 "$ftp0 stop"
$ns at 6.0 "finish"
#Run the simulation
$ns run