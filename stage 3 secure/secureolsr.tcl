
set val(chan) 	Channel/WirelessChannel ;
set val(prop) 	Propagation/TwoRayGround ;
set val(netif)	Phy/WirelessPhy ;
set val(mac) 	Mac/802_11 ;
set val(ifq) 	Queue/DropTail/PriQueue ;
set val(ll) 	LL ;
set val(ant) 	Antenna/OmniAntenna ;
set val(ifqlen) 50 ;
set val(nn) 	9 ;
set val(rp) 	OLSR ;
set val(x) 	500;
set val(y) 	400;
set val(stop) 	150;

set ns [new Simulator]

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

set tracefile [open securetrace.tr w]
$ns trace-all $tracefile


set namfile [open securenam.nam w] 
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];

$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON
        
set node_(0) [$ns node]
$node_(0) set X_ 100.0
$node_(0) set Y_ 200.0
$node_(0) set Z_ 0.0
$ns initial_node_pos $node_(0) 30	

set node_(1) [$ns node]
$node_(1) set X_ 150.0
$node_(1) set Y_ 100.0
$node_(1) set Z_ 0.0
$ns initial_node_pos $node_(1) 30	

set node_(2) [$ns node]
$node_(2) set X_ 200.0
$node_(2) set Y_ 200.0
$node_(2) set Z_ 0.0
$ns initial_node_pos $node_(2) 30	

set node_(3) [$ns node]
$node_(3) set X_ 300.0
$node_(3) set Y_ 400.0
$node_(3) set Z_ 0.0
$ns initial_node_pos $node_(3) 30	

set node_(4) [$ns node]
$node_(4) set X_ 300.0
$node_(4) set Y_ 200.0
$node_(4) set Z_ 0.0
$ns initial_node_pos $node_(4) 30	

set node_(5) [$ns node]
$node_(5) set X_ 300.0
$node_(5) set Y_ 100.0
$node_(5) set Z_ 0.0
$ns initial_node_pos $node_(5) 30	

set node_(6) [$ns node]
$node_(6) set X_ 400.0
$node_(6) set Y_ 200.0
$node_(6) set Z_ 0.0
$ns initial_node_pos $node_(6) 30	

set node_(7) [$ns node]
$node_(7) set X_ 400.0
$node_(7) set Y_ 100.0
$node_(7) set Z_ 0.0
$ns initial_node_pos $node_(7) 30	

set node_(8) [$ns node]
$node_(8) set X_ 500.0
$node_(8) set Y_ 200.0
$node_(8) set Z_ 0.0
$ns initial_node_pos $node_(8) 30

$node_(0) color green
$ns at 0.0 "$node_(0) color green"	
$ns at 0.0 "$node_(0) label Source"

$node_(8) color blue
$ns at 0.0 "$node_(8) color blue"
$ns at 0.0 "$node_(8) label Destination"

$node_(3) color red
$ns at 0.0 "$node_(3) color red"
$ns at 0.0 "$node_(3) label Attacker"

$node_(1) color yellow
$ns at 0.0 "$node_(1) color yellow"
$ns at 0.0 "$node_(1) label SecureNextHop"

$node_(2) color yellow
$ns at 0.0 "$node_(2) color yellow"
$ns at 0.0 "$node_(2) label SecureNextHop"

$node_(4) color yellow
$ns at 0.0 "$node_(4) color yellow"
$ns at 0.0 "$node_(4) label SecureNextHop"


###########################################################################################
$ns at 0.0 "[$node_(3) set ragent_] hacker"
$ns at 0.0 "[$node_(0) set ragent_] secure"

$ns at 0.0 "$node_(0) setdest 130.0 208.0 5.0"
$ns at 0.0 "$node_(1) setdest 153.0 108.0 5.0"
$ns at 1.0 "$node_(2) setdest 250.0 220.0 5.0"
$ns at 1.0 "$node_(3) setdest 310.0 267.0 5.0"
$ns at 3.0 "$node_(4) setdest 300.0 228.0 5.0"
$ns at 3.0 "$node_(5) setdest 340.0 134.0 5.0"
$ns at 2.0 "$node_(6) setdest 480.0 280.0 5.0"
$ns at 1.0 "$node_(7) setdest 485.0 120.0 5.0"
$ns at 0.0 "$node_(8) setdest 470.0 185.0 5.0"

set udp0 [new Agent/UDP]
$udp0 set class_ 2
set null0 [new Agent/Null]
$ns attach-agent $node_(0) $udp0
$ns attach-agent $node_(8) $null0
$ns connect $udp0 $null0

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 0.1Mb
$cbr0 set random_ null
$ns at 30.0 "$cbr0 start"

#$ns at 15.0 "[$node_(0) agent 255] print_rtable"
#$ns at 15.0 "[$node_(0) agent 255] print_mprset"

proc stop {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam securenam.nam &
    exit 0
    
}
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}
# ending nam and the simulation 
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at $val(stop) "puts \"end simulation\" ; $ns halt"

$ns run
