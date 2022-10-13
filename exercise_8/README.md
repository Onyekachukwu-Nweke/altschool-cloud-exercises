# Exercise 6

**Task:**

193.16.20.35/29

What is the Network IP, number of hosts, range of IP addresses and broadcast IP from this subnet?


**_Instruction:_**
Submit all your answer as a markdown file in the folder for this exercise.


## Procedure
 - To calculate Network IP we have to find the number of hosts(IP addresses) in the subnet

```
Netmask -> 255.255.255.248
Wildcard -> 0.0.0.7
```

We have **8 IP addresses** but only **6 IPs** will be usable

```
Network ID: floor(Host Address / Subnet number of hosts) * Subnet number of hosts

Our network address is 35
Subnet number of hosts is 8

Network ID: floor(35/8) * 8 = 32

Network IP is 193.16.20.32
```

- Number of Hosts

```
    From my earlier calculation we have 8 IPs but only 6 IPs are usable
    Therefore, we have only 6 hosts on the network
```

- Range of IP

```
    Host Min: 193.16.20.33
    Host Max: 193.16.20.38
```

- Broadcast IP

```
    Broadcast ID: (Network ID + (Subnet number of hosts - 1)) = (32 + (8 - 1))
    Broadcast ID: 39

    Broadcast IP: 193.16.20.39
```
