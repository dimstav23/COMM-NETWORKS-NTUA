set opt(chan)			Channel/WirelessChannel				;# Τύπος καναλιού
set opt(prop)			Propagation/TwoRayGround			;# Μοντέλο ραδιομετάδοσης
set opt(ant)			Antenna/OmniAntenna					;# Τύπος κεραίας
set opt(ll)				LL									;# Τύπος επιπέδου σύνδεσης
set opt(ifq)			Queue/DropTail/PriQueue				;# Τύπος ουράς
set opt(ifqlen)			25									;# Μέγιστος αριθμός πακέτων
															;# στην ουρά
set opt(netif)			Phy/WirelessPhy						;# Τύπος δικτυακής επαφής
set opt(mac)			Mac/802_11							;# Πρωτόκολλο MAC
set opt(rp)				AODV								;# Πρωτόκολλο δρομολόγησης
set opt(nn)				5									;# Αριθμός κόμβων
set opt(gridx)			600									;# Μήκος πλέγματος (m)
set opt(gridy)			400									;# Πλάτος πλέγματος (m)
set opt(dist)			[expr 20*sqrt(2)]					;# Οριζόντια απόσταση μεταξύ

$opt(mac) set basicRate_ 1Mb
$opt(mac) set dataRate_ 11Mb

set ns [new Simulator]

$ns use-newtrace
set tf [open lab9a.tr w]
$ns trace-all $tf

set nf [open lab9a.nam w]
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
	
set posx(0) [expr $opt(gridx)/2]
set posy(0) [expr $opt(gridy)/2]

for {set i 0} {$i < $opt(nn)} {incr i} {
	# Δημιουργία κόμβου
	set n($i) [$ns node]
	if {$i == 0} {
		set j 0
		set k 0
	} elseif {$i == 1} {
		set j -1
		set k 1
	} elseif {$i == 2} {
		set j -1
		set k -1
	} elseif {$i == 3} {
		set j 1
		set k -1
	} else {
		set j 1
		set k 1
	}
	# Απενεργοποίηση τυχαίας κίνησης κόμβου
	$n($i) random-motion 0
	# Ορισμός θέσης κόμβου στον άξονα x
	$n($i) set X_ [expr $posx(0)+$j*$opt(dist)]
	# Ορισμός θέσης κόμβου στον άξονα y
	$n($i) set Y_ [expr $posy(0)+$k*$opt(dist)]
	# Ορισμός θέσης κόμβου στον άξονα z
	$n($i) set Z_ 0.0
}

$ns color 1 blue
$ns color 2 red
$ns color 3 green
$ns color 4 yellow

Agent/UDP set packetSize_ 1000
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

Agent/TCP set packetSize_ 960
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

for {set i 0} {$i < $opt(nn)} {incr i} {
	$ns initial_node_pos $n($i) 5
}

# Events
$ns at 0.0 "$n(0) label n_0"
$ns at 0.0 "$n(1) label n_1"
$ns at 0.0 "$n(2) label n_2"
$ns at 0.0 "$n(3) label n_3"
$ns at 0.0 "$n(4) label n_4"
$ns at 0.1 "$cbr1 start"
$ns at 0.3 "$ftp2 start"
$ns at 0.5 "$cbr3 start"
$ns at 0.7 "$telnet4 start"
$ns at 5.1 "$cbr1 stop"
$ns at 5.3 "$ftp2 stop"
$ns at 5.5 "$cbr3 stop"
$ns at 5.7 "$telnet4 stop"
for {set i 0} {$i < $opt(nn)} {incr i} {
	$ns at 20.0 "$n($i) reset";
}
$ns at 20.0 "finish"
$ns run