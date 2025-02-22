## Initial Steps on how to setup DNS server for environment

```bash
$ ip r # check how ip is assigned to the server , that is going to act as DNS server

$ cd /etc/netplan
$ ls # see how and who is configuring networking for the server (network-manager)

## turn the existing yaml file into backup version -> rename

$ touch 00-installer-config.yaml

## to reflect changes reboot the server

## change hostname of the server
$ sudo hostnamectl set-hostname demondns

## give FQDN to our server
$ touch /etc/hosts

## replace the entry for server_name (127.0.1.1) with <ip of server>  demondns.demon.com

## check if hostname changed or  not
$ hostname

## check if FQDN is changed or not
$ hostname --fqdn

## update and install bind9 packages
$ sudo apt update
$ sudo apt install bind9 bind9utils bind9-doc
```

```yaml
network:
  renderer: networkd
  ethernets:
    ens33:
      addresses:
        - <ifconfig output>/24
      nameservers:
        addresses: [4.4.4.4,8.8.8.8]
      routes:
        - to: default
          via: <ip r output>
  version: 2

```

```bash
## we want bind9 to operate in ipv4 mode
$ sudo nano /etc/bind/named

## add line OPTIONS="-4 -u bind"
## restart bind9
$ sudo systemctl restart bind9

## check if port 53 is open or not
$ netstat -antu | grep 53

## if not open then,
$ sudo ufw allow Bind9

## lets configure bind9 config files
$ cd /etc/bind
$ ls -lrt

## named.conf is the base config  file

## manage configuration in different files for easy mgmt
## named.conf.options and named.conf.local

## zones and records related config  ==>  named.conf.local

## general configs  ==> named.conf.options
## general configs mean, allowing recursive query or not, access control lists , etc

## add following lines to first options {} block in named.conf.options
## recursion yes;
## listen-on port 53 {dns-server-ip-address;};
## allow-query {any;};

## add following lines to named.conf.local
## zone "demon.com" IN {
##       type master;
##        file "/etc/bind/zones/forward.zone.demon.com"
##    // file path of forward/reverse lookup files
##        allow-update {none;}; 
##      // donot allow dynamic  update 
## };

## make /etc/bind/zones
$ sudo mkdir /etc/bind/zones
$ sudo nano /etc/bind/zones/forward.zone.demon.com
```