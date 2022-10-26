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
set n4 [$ns node]
set n5 [$ns node]


# create links between the nodes
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n0 $n3 2Mb 10ms DropTail
$ns duplex-link $n0 $n4 2Mb 10ms DropTail
$ns duplex-link $n0 $n5 2Mb 10ms DropTail


# create a TCP agent and attach it to node node 0
set tcp [new Agent/TCP]
$ns attach-agent $n1 $tcp


# create a FTP traffic source and attach it to tcp
set ftp [new Application/FTP]
set maxpkts_ 1000
$ftp attach-agent $tcp


# create a Sink agent (a traffic sink) and at
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink


# schedule events for all the flows

$ns at 0.1 "$ftp start"
$ns at 4.0 "$ftp stop"



# call the finish procedure after 6 seconds of simulation time
$ns at 5.0 "finish"


# run the simulation
$ns run


