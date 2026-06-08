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
                nslookup always resolves ONLY DNS server server/IP address. "What IP address corresponds to this domain?" Another part of the 'nslookup' may show the IP/server address of other facilities, different from DNS Server. 
        3.4.2 Resolutiom much detailed: dig <domain>
                Same as nslookup (only DNS server), but more modern and robust.
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

3. Check if have gateway/router and it has IP
    ip route | grep default
    Output: default via 192.168.40.2 dev ens160 proto dhcp src 192.168.40.134 metric 100 

Stage 2. Verify network connection. 

1. Ping gateway (box)
    ping -c 3 $(ip route | grep default | awk '{print $3}')
    The command will automatically take the ip of the router and apply it to the ping command as an argument. 
2. Ping via internet (IP public)
    ping 8.8.8.8
    If it is working, you have internet access. 
3. Ping one of the domain names
    ping -c google.com
    If it is working, the DNS is working well. 

Stage 3. DNS diagnostics.

1. Resolve one domain name
    nslookup google.com

    You'll get ip address(s).
    Output: 
2. Check with one specific DNS server
    dig google.com @8.8.8.8 +short

3. Check more details
    dig google.com

Stage 4. Test the web service

1. Check if port is opened (e.g., most often 443)
    nc -zv google.com 443 
    Check the https connection.

2. SSH port 
    nc -zv google.com 22
    Often closed.
3. Check the HTTPS response
    curl -I https://www.google.com
4. Test the api directly if can
    curl -I https://api.github.com
    NOte: any api can be tested. Check via postman or any other tools.

Stage 5. Check what is going on your local machine

1. List all ports on listening
    ss -tuln
2. Check the processes names
    ss -tulnp
3. Filter port specific
    ss -tulpn | grep 22

Module 2 


IP private (not in used in the public internet):
10.x.x.x, 172.16-31.x.x, 192.168.x.x (ne sortent pas sur Internet)

Mask	Notation	Adresses	Machines utilisables
/8	255.0.0.0	16 millions	Très grands réseaux
/16	255.255.0.0	65 536	Entreprises
/24	255.255.255.0	256	Réseaux locaux
/32	255.255.255.255	1	Une seule machine

1. IP address parts

Let's take and check one IP address as an example;
    192.168.1.45 with mask as /24

a. Part network - network identifier
192.168.1

b. Part host - machine identifier
.45

# can add here some images from the existing doc file or create any good suitable for md format diagrams + info about octets, bits.

So, 192.168.1.45 
where:
    - network part 24 bits
    - host part 8 bits
254 machines possible: where 2 addresses are missed? 
    - one is for network address: 192.168.1.0
    - one is for broadcast address: 192.168.1.255
 
Network mask - defines how amny bits reserved for network and how many for host. 
Le /24 signifie : les 24 premiers bits identifient le réseau.

Notation CIDR	Signification	Partie réseau	Partie hôte
/24	24 bits pour le réseau	3 octets (24 bits)	1 octet (8 bits)
/16	16 bits pour le réseau	2 octets (16 bits)	2 octets (16 bits)
/8	8 bits pour le réseau	1 octet (8 bits)	3 octets (24 bits)

OR

/24	255.255.255.0	Les 3 premiers octets sont fixes (255 = tous les bits à 1)
/16	255.255.0.0	Les 2 premiers octets sont fixes
/8	255.0.0.0	Le premier octet est fixe

/24 == 255.255.255.0

As example:
192.168.0.0/16 = one big address block

where:
    - 192.168 is the fixed network prefix
    - 0.0: host part, 65534 usable devices (2 reserved)

So, the piicture can be:
Masque	Adresses totales	Machines utilisables	Cas d'usage typique
/32	1	1	Route host (IP unique), ACL, tunnels
/31	2	2	Liaison point-à-point moderne (RFC 3021)
/30	4	2	Liaison point-à-point classique
/28	16	14	Petit réseau (équipe)
/26	64	62	Sous-réseau département
/24	256	254	Réseau local standard
/16	65 536	65 534	Grande entreprise, VPC cloud
/8	16 777 216	16 777 214	Très grand réseau
Cas spéciaux /31 et /32

/31 : Normalisé par RFC 3021, ce masque permet 2 adresses utilisables (pas de broadcast ni d'adresse réseau "sacrifiée"). Très courant sur les liens point-à-point entre routeurs.

/32 : Une seule adresse. Utilisé pour les routes host (routage vers une IP précise), les règles de firewall, ou les interfaces de loopback.


1.2 Check with command if ip addresses in the same network
Ex: ip route get 10.45.128.100
        10.45.128.100 via 192.168.40.2 dev ens160 src 192.168.40.134 uid 1000 
        cache 
Where: via 192.168.40.2 means that it went through the route, which means it is a different network. 

So, simple example:
    a. check you machine ip:
        ip addr show
        inet 192.168.40.134/24 brd 192.168.40.255 
    b. Obviously from the previous out the host is reserved for 0-255 for last bit, because mask is /24
    c. If try:
        ip route get 192.168.41.1
        where .41. it is already different network, because current network is resolved with mask 24
    d. Thus, output is:
        192.168.41.1 via 192.168.40.2 dev ens160 src 192.168.40.134 uid 1000 
        Means, got out via router, hence, another network.
    e. Now, try the same network:
        ip route get 192.168.40.20
        Output: 192.168.40.20 dev ens160 src 192.168.40.134 uid 1000
        As a result of the output, the ip was resoved in the same network, because it belongs to the same network. 

1.3 How to calculate if the ip in the same network or not:

The whole purpose of subnet masks (/24, /21, /27, etc.) is to let a machine determine:
“Is the destination on my local network, or do I need to send traffic to a router?”
For humans, masks like /8, /16, /24 are easy because they align with full decimal blocks (octets).

Example:
    192.168.40.x
clearly looks like one network.

But masks like /21 or /27 split bits inside an octet, so the network boundary is no longer visually obvious in decimal notation.

That is why computers use binary AND operations:
    - to precisely determine the network portion of an IP
    - and compare whether two machines belong to the same subnet.
So the “problem” is not the calculation itself.
The real concern is:
Humans see IPs in decimal blocks, but networks are actually defined at the bit level. 


1.3.1 Caclulation rule

Rule is simple: (IP1 AND masque) == (IP2 AND masque)

Example 1. Same network - simple mask, /24    
Input:

* IP1: `192.168.40.5/24`
* IP2: `192.168.40.222/24`
* Mask: `255.255.255.0`

```text id="r4n8zk"
IP1 :    192.168.40.5      → 11000000.10101000.00101000.00000101
Mask :   255.255.255.0     → 11111111.11111111.11111111.00000000
                               ────────────────────────────────────
Network: 192.168.40.0      → 11000000.10101000.00101000.00000000


IP2 :    192.168.40.222    → 11000000.10101000.00101000.11011110
Mask :   255.255.255.0     → 11111111.11111111.11111111.00000000
                               ────────────────────────────────────
Network: 192.168.40.0      → 11000000.10101000.00101000.00000000
```

Both calculations produce the same network address (`192.168.40.0`), so both machines are on the same subnet.

Example 2. Same network- more complex mask
Input:

* IP1: `192.168.40.5/21`
* IP2: `192.168.47.222/21`
* Mask: `255.255.248.0`

```text id="v2m9kp"
IP1 :    192.168.40.5      → 11000000.10101000.00101000.00000101
Mask :   255.255.248.0     → 11111111.11111111.11111000.00000000
                               ────────────────────────────────────
Network: 192.168.40.0      → 11000000.10101000.00101000.00000000


IP2 :    192.168.47.222    → 11000000.10101000.00101111.11011110
Mask :   255.255.248.0     → 11111111.11111111.11111000.00000000
                               ────────────────────────────────────
Network: 192.168.40.0      → 11000000.10101000.00101000.00000000
```

Even though the third octet differs (`40` vs `47`), both calculations produce the same network address (`192.168.40.0`), so both machines are on the same subnet.

### Example 3 — different networks (obvious mask `/24`)

Input:

* IP1: `192.168.10.5/24`
* IP2: `192.168.11.8/24`
* Mask: `255.255.255.0`

```text id="a1k8qp"
IP1 :    192.168.10.5      → 11000000.10101000.00001010.00000101
Mask :   255.255.255.0     → 11111111.11111111.11111111.00000000
                               ────────────────────────────────────
Network: 192.168.10.0      → 11000000.10101000.00001010.00000000


IP2 :    192.168.11.8      → 11000000.10101000.00001011.00001000
Mask :   255.255.255.0     → 11111111.11111111.11111111.00000000
                               ────────────────────────────────────
Network: 192.168.11.0      → 11000000.10101000.00001011.00000000
```

Different network addresses ⇒ different subnets.

---

### Example 4 — different networks (non-obvious mask `/21`)

Input:

* IP1: `192.168.40.5/21`
* IP2: `192.168.55.10/21`
* Mask: `255.255.248.0`

```text id="b7m2rx"
IP1 :    192.168.40.5      → 11000000.10101000.00101000.00000101
Mask :   255.255.248.0     → 11111111.11111111.11111000.00000000
                               ────────────────────────────────────
Network: 192.168.40.0      → 11000000.10101000.00101000.00000000

IP2 :    192.168.55.10     → 11000000.10101000.00110111.00001010
Mask :   255.255.248.0     → 11111111.11111111.11111000.00000000
                               ────────────────────────────────────
Network: 192.168.48.0      → 11000000.10101000.00110000.00000000
```
Different network addresses (`192.168.40.0` vs `192.168.48.0`) ⇒ different subnets.

1.3.2 Command to calculate the network boundaries:
    ipcalc 192.168.42.4/24
    NOte: need to be installed additionally.
    Note2: can be calculated manually also, with the "blocks methods"
Special addresses:

# Module 3



