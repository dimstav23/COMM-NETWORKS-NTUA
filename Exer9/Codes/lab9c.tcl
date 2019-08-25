#Wireless Network
set opt(chan) Channel/WirelessChannel
set opt(prop) Propagation/TwoRayGround
set opt(ant) Antenna/OmniAntenna
set opt(ll) LL
set opt(ifq) Queue/DropTail/PriQueue
set opt(ifqlen) 25
set opt(netif) Phy/WirelessPhy
set opt(mac) Mac/802_11
set opt(rp) AODV
set opt(nn) 5
set opt(gridx) 600
set opt(gridy) 400
$opt(mac) set basicRate_ 1Mb
$opt(mac) set dataRate_ 11Mb

set ns [new Simulator]
#$ns use-newtrace
set tf [open lab9.tr w]
$ns trace-all $tf
set nf [open lab9.nam w]
$ns namtrace-all-wireless $nf $opt(gridx) $opt(gridy)

proc finish {} {
	global ns tf nf
	$ns flush-trace
	close $tf
	close $nf
	exit 0
}

# Δημιουργία αντικειμένου τοπογραφίας
set topo [new Topography]
# Επίπεδο πλέγμα ( $opt(gridx) x $opt(gridy) ) m^2
$topo load_flatgrid $opt(gridx) $opt(gridy)

create-god $opt(nn)

# Παραμετροποίηση κόμβων
$ns node-config -adhocRouting $opt(rp) \
-llType $opt(ll) \
-macType $opt(mac) \
-ifqType $opt(ifq) \
-ifqLen $opt(ifqlen) \
-antType $opt(ant) \
-propType $opt(prop) \
-phyType $opt(netif) \
-channel [new $opt(chan)] \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace OFF


# Δημιουργία κόμβων και ορισμός συντεταγμένων τους στο επίπεδο πλέγμα
for {set i 0} {$i < $opt(nn) } {incr i} {
	# Δημιουργία κόμβου
	set n($i) [$ns node]
	# Απενεργοποίηση τυχαίας κίνησης κόμβου
	$n($i) random-motion 0
	# Ορισμός θέσης κόμβου στον άξονα z
	$n($i) set Z_ 0.0
}

#orismos thesis komvou 0
$n(0) set X_ 300
$n(0) set Y_ 200
#orismos thesis komvou 1
$n(1) set X_ 158.58			;#300 - 141.42
$n(1) set Y_ 341.42			;#200 + 141.42
#orismos thesis komvou 2
$n(2) set X_ 158.58
$n(2) set Y_ 58.58
#orismos thesis komvou 3
$n(3) set X_ 441.42
$n(3) set Y_ 58.58
#orismos thesis komvou 4
$n(4) set X_ 441.42
$n(4) set Y_ 341.42

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

set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp3
$cbr3 set packetSize_ 1000
$cbr3 set rate_ 0.8mb
$cbr3 set random_ off

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

# Αρχικοποίηση κινητών κόμβων
for {set i 0} {$i < $opt(nn) } {incr i} {
$ns initial_node_pos $n($i) 5
}

$ns at 0.0 "$n(0) label Node_0"
$ns at 0.0 "$n(1) label Node_1"
$ns at 0.0 "$n(2) label Node_2"
$ns at 0.0 "$n(3) label Node_3"
$ns at 0.0 "$n(4) label Node_4"
# Events
$ns at 0.1 "$cbr1 start"
$ns at 0.3 "$ftp2 start"
$ns at 0.5 "$cbr3 start"
$ns at 0.7 "$telnet4 start"
$ns at 5.1 "$cbr1 stop"
$ns at 5.3 "$ftp2 stop"
$ns at 5.5 "$cbr3 stop"
$ns at 5.7 "$telnet4 stop"
$ns at 20.0 "finish"
$ns run