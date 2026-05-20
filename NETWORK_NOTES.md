- ip addr show; show the ip address
- ip route; find and ip address of the gateway/router
- ping, send echo packages to specified IP or address

2. Troubleshooting on the network:
    a. Check your own machine (IP, interfaces)
    b. Check the network connection (ping)
    c. Check the DNS resolution (nslookup/dig)
    d. Vhevk the service (curl, nc)
Example:
- Is my machine has a IP and machine is connected to network?
    Commands: ip addr, ip link
- Which services are running on my machine and which ports?
    Commands: ss -tlnp
- Does my server reply on the network?
    Commands: ping
- Does the domain name is correctly resolved?
    Commands: nslookup, dig
- Does the HTTP is responsive? And what is the response code? 
    Commands: curl, wget
- Does the port is opened and accessible?
    Commands: nc
3. Commands in details:
    3.1 IP
        3.1.1 ip link show
Lists all interfaces on your machine which are considered as active or not
Ex:
p link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:36:b6:32 brd ff:ff:ff:ff:ff:ff
    altname enp3s0
    altname enx000c2936b632

Note: be attentive with the *state* field - which maybe UP or DOWN.
    
        3.1.2 Check you ip address: ip addr show OR ip a
Ex:
ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0c:29:36:b6:32 brd ff:ff:ff:ff:ff:ff
    altname enp3s0
    altname enx000c2936b632
    inet 192.168.40.134/24 brd 192.168.40.255 scope global dynamic noprefixroute ens160
       valid_lft 1767sec preferred_lft 1767sec
    inet6 fe80::20c:29ff:fe36:b632/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
Where inet is the ip address of the local machine.
    
        3.1.3 Shows an ip of you gateway/router: ip route show OR ip r
default via 192.168.40.2 dev ens160 proto dhcp src 192.168.40.134 metric 100 
192.168.40.0/24 dev ens160 proto kernel scope link src 192.168.40.134 metric 100

    3.2 SS
ss (Socket Statistics) replacement for netstat. Show which connections are active and which program is listening on which port.
        3.2.1 Shows the activities for the curent machine:  ss -tuln
-t	Afficher les connexions TCP
-u	Afficher les connexions UDP
-l	Afficher uniquement les ports en écoute (listening)
-n	Afficher les numéros de port (pas les noms de service)

Ex: 
    - run some service: python3 -m http.server 8080 &

    3.2.2 check the socket statistics: ss -tulnp, -p the name of the processes are using
        Output:
        Netid   State    Recv-Q   Send-Q     Local Address:Port     Peer Address:Port   Process                              
udp     UNCONN   0        0                0.0.0.0:5353          0.0.0.0:*                                           
udp     UNCONN   0        0              127.0.0.1:323           0.0.0.0:*                                           
udp     UNCONN   0        0                   [::]:5353             [::]:*                                           
udp     UNCONN   0        0                  [::1]:323              [::]:*                                           
tcp     LISTEN   0        5                0.0.0.0:8080          0.0.0.0:*       users:(("python3",pid=3630,fd=3))   
tcp     LISTEN   0        128              0.0.0.0:22            0.0.0.0:*                                           
tcp     LISTEN   0        4096           127.0.0.1:631           0.0.0.0:*                                           
tcp     LISTEN   0        128                 [::]:22               [::]:*                                           
tcp     LISTEN   0        4096               [::1]:631              [::]:*                                           
tcp     LISTEN   0        4096                   *:9090                *:*             

OR with sudo ss tulnp; to see all the users process, output:
Netid  State   Recv-Q  Send-Q    Local Address:Port     Peer Address:Port  Process                                   
udp    UNCONN  0       0               0.0.0.0:5353          0.0.0.0:*      users:(("avahi-daemon",pid=1131,fd=12))  
udp    UNCONN  0       0             127.0.0.1:323           0.0.0.0:*      users:(("chronyd",pid=1167,fd=5))        
udp    UNCONN  0       0                  [::]:5353             [::]:*      users:(("avahi-daemon",pid=1131,fd=13))  
udp    UNCONN  0       0                 [::1]:323              [::]:*      users:(("chronyd",pid=1167,fd=6))        
tcp    LISTEN  0       128             0.0.0.0:22            0.0.0.0:*      users:(("sshd",pid=1341,fd=7)) 

    3.2.3 To see the listen/established connections: ss -tan
Ex:
    - run ssh process on the local machine: ssh localhost
    - check:
        ESTAB            0              0                              [::1]:46794                        [::1]:22
    - OR ss -tnp, with process names
        ESTAB    0         0                     [::1]:46794                [::1]:22        users:(("ssh",pid=3760,fd=3))

    3.3 PING
    - ping with interval: ping -i
    - ping with the packages size: ping -s

    3.4 DNS
        3.4.1 Demand to resolve address to ip: nslookup <domain>
        3.4.2 Resolutiom much detailed: dig <domain>
        3.4.3 Check specific server: dig @<Ip_adde> <domain>
        3.4.4 DNS local: /etc/resolv.conf
    
    3.5 CURL
        Checks if the web server responses.
        Ex: curl -I https://google.com
            where -I only to download the header without complete page.
    3.6 wget 
        For downloading a file
        Ex: wget https://example.com/fichier.zip
    3.7 nc (netcat)
        Checks if a port is opened.
        Ex: nc -zv google.com 443
            where, -z scan mode, just for port check no data sent, -v verbose

Note: Connection refused and connection time out are different things. Where connection refusedmeans that the port is closed and time out a port is filtered (data packages are blocked)

# Complete troubleshooting guide

Stage 1. Verify if local machine/client/sender is ok.
1. Check if your local machine has IP.
    ip addr show | grep "inet"
        Output:
              inet 127.0.0.1/8 scope host lo
              inet6 ::1/128 scope host noprefixroute 
              inet 192.168.40.134/24 brd 192.168.40.255 scope global dynamic noprefixroute ens160
              inet6 fe80::20c:29ff:fe36:b632/64 scope link noprefixroute
2. Check your machine interface is "UP"
    ip link show | grep -E "state UP|state DOWN"
        Output: 
            : ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
        Where used commands helps to find a complete line where specified filter was applied.

3. Check gateway/router
    ip route | grep default
    Output: default via 192.168.40.2 dev ens160 proto dhcp src 192.168.40.134 metric 100 

Stage 2. Verify network connection. 

1.   
