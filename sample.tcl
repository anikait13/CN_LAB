# create a simulator object
set ns [new Simulator]

# open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam &
	exit 0
}


# create 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# create links between the nodes
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7Mb 20ms DropTail


# UDP traffic source
# create a UDP agent and attach it to node node 1
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

# create a TCP agent and attach it to node node 0
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp


# create a CBR traffic source and attach it to udp
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 500
$cbr set interval_ 0.005
$cbr attach-agent $udp

# create a FTP traffic source and attach it to tcp
set ftp [new Application/FTP]
set maxpkts_ 1000
$ftp attach-agent $tcp

# creat a Null agent (a traffic sink) and at
set null [new Agent/Null]
$ns attach-agent $n3 $null
$ns connect $udp $null


# creat a Sink agent (a traffic sink) and at
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink


# schedule events for all the flows
$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 4.0 "$ftp stop"
$ns at 4.5 "$cbr stop"


# call the finish procedure after 6 seconds of simulation time
$ns at 5.0 "finish"

# Print CBR packet size and interval
puts "CBR packet size = [$cbr set packet_size_]"

# run the simulation
$ns run



