This page contains sample log alert information from diffrent types of sensors. It also grok parser statements. (http://grokconstructor.appspot.com/)<br />
http://grokconstructor.appspot.com/do/match#result<br />

<br />
<h3>GCRdionaeaAlerts.py</h3>
./var/log/GCRDionaea.log (a.k.a. dionaea.log)<br />
<br />
<h5>SAMPLE LOG:</h5>
<table><tr><td>
1505408808|GCRCanary-DionaeaDevice|blackthread|Connection(accept,tcp,smbd)-Alert(connections)|25753|10.2.1.118|445|10.2.1.107|1424|[CONNECTIONS:(connection     connection_type connection_transport    connection_protocol     connection_timestamp    connection_root    connection_parent       local_host      local_port      remote_host     remote_hostname remote_port     )(25753 accept  tcp     smbd    1505408808.93   25753   None    10.2.1.118      445     10.2.1.107              1424)]   

1505408808|GCRCanary-DionaeaDevice|blackthread|Connection(accept,tcp,smbd)-Alert(sip_commands,connections)|25753|10.2.1.118|445|10.2.1.107|1424|[CONNECTIONS:(connection        connection_type connection_transport    connection_protocol     connection_timestamp       connection_root connection_parent       local_host      local_port      remote_host remote_hostname     remote_port     )(18031 connect tls     SipSession      1502224937.17   18031   None    10.2.1.99       5061    10.2.1.46
54422)][SIP_COMMANDS:(sip_command       connection      sip_command_method      sip_command_call_id sip_command_user_agent      sip_command_allow       )(7     18031   OPTIONS 50000   None    0       [SIP_ADDRS:(sip_addr    sip_command     sip_addr_type      sip_addr_display_name   sip_addr_uri_scheme     sip_addr_uri_user       sip_addr_uri_password   sip_addr_uri_host       sip_addr_uri_port       )(25    7       addr            sip     None    None    nm      None)][SIP_ADDRS:(sip_addr      sip_command        sip_addr_type   sip_addr_display_name   sip_addr_uri_scheme     sip_addr_uri_user   sip_addr_uri_password       sip_addr_uri_host       sip_addr_uri_port       )(25    7       addr            sip     None    None    nm      None    , 26       7       to              sip     nm2     None    nm2     None)][SIP_ADDRS:(sip_addr      sip_command     sip_addr_type   sip_addr_display_name   sip_addr_uri_scheme     sip_addr_uri_user       sip_addr_uri_password   sip_addr_uri_host       sip_addr_uri_port  )(25    7       addr            sip     None    None    nm      None    , 26    7   to          sip     nm2     None    nm2     None    , 27    7       contact         sip     nm2     None    nm2     None)][SIP_ADDRS:(sip_addr      sip_command        sip_addr_type   sip_addr_display_name   sip_addr_uri_scheme     sip_addr_uri_user   sip_addr_uri_password       sip_addr_uri_host       sip_addr_uri_port       )(25    7       addr            sip     None    None    nm      None    , 26       7       to              sip     nm2     None    nm2     None    , 27    7       contact     sip nm2     None    nm2     None    , 28    7       from            sip     nm      None    nm      None)][SIP_VIAS:(sip_via        sip_command     sip_via_protocol   sip_via_address sip_via_port    )(7     7       TCP     nm      None))]
</td></tr></table>

<h3>Dionaea</h3>
<h4>Simple Log</h4>
./var/log/dionaea.log (a.k.a. dionaea.log)<br />
<br />
<h5>SAMPLE LOG:</h5>
<table><tr><td>
connection|3|accept|tcp|httpd|1501693249.72|10.2.1.83|26445|10.2.1.99|80<br />
connection|2|accept|tcp|httpd|1501693249.62|10.2.1.83|26444|10.2.1.99|80<br />
connection|1|accept|tcp|httpd|1501693249.25|10.2.1.83|26439|10.2.1.99|80<br />
connection|6|accept|tcp|httpd|1501693283.28|10.2.1.83|26452|10.2.1.99|80<br />
connection|5|accept|tcp|httpd|1501693280.52|10.2.1.83|26453|10.2.1.99|80<br />
</td></tr></table>
*GROK Parser*<br />
<table><tr><td>
%{WORD:connection}\|%{NUMBER:number}\|%{WORD:type}\|%{WORD:transport}\|%{WORD:protocol}\|%{NUMBER:timestamp}\|%{IP:ip_src_addr}\|%{NUMBER:src_port}\|%{IP:ip_dst_addr}\|%{NUMBER:dst_port}?
</td></tr></table>

<h5>SAMPLE LOG(from reciving server) -> :</h5>
<table><tr><td>
Jul 27 23:47:41 honeeepi dionaealog.py: connection|5286|accept|tcp|httpd|1501199252.78|10.2.1.83|1762|10.2.1.99|80<br />
Jul 28 00:13:24 honeeepi dionaealog.py: connection|5287|accept|tcp|httpd|1501200799.33|10.2.1.83|1084|10.2.1.99|80<br />
Jul 28 00:13:44 honeeepi dionaealog.py: connection|5289|accept|tcp|httpd|1501200814.55|10.2.1.83|1126|10.2.1.99|80<br />
Jul 28 00:13:44 honeeepi dionaealog.py: connection|5288|accept|tcp|httpd|1501200808.64|10.2.1.83|1116|10.2.1.99|80<br />
Jul 28 00:59:49 honeeepi dionaealog.py: connection|5296|accept|tcp|httpd|1501203587.76|10.2.1.83|1556|10.2.1.99|80<br />
</td></tr></table>
*GROK Parser*<br />
<table><tr><td>
%{MONTH:month}%{SPACE}%{MONTHDAY:day}%{SPACE}%{HOUR:hour}:%{MINUTE:minute}:%{SECOND:seconds}%{SPACE}%{WORD:hostname}%{SPACE}%{WORD:script}.%{WORD:extension}:%{SPACE}%{WORD:connection}\|%{NUMBER:number}\|%{WORD:type}\|%{WORD:transport}\|%{WORD:protocol}\|%{NUMBER:timestamp}\|%{IP:ip_src_addr}\|%{NUMBER:src_port}\|%{IP:ip_dst_addr}\|%{NUMBER:dst_port}?
</td></tr></table>


<h4>Detailed Log</h4>
./opt/dionaea/var/log/dionaea.log (a.k.a. dionaea-opt3.log)<br />
<br />

*SAMPLE LOG:*<br />
<table><tr><td>
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:666-debug: ###[ SMB Negociate Response sizeof(53) ]###  <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         WordCount           = 17              sizeof(  1) off=  0 goff= 36 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         DialectIndex        = 9               sizeof(  2) off=  1 goff= 37 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         SecurityMode        = 0x3             sizeof(  1) off=  3 goff= 39 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         MaxMPXCount         = 1               sizeof(  2) off=  4 goff= 40 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         MaxVCs              = 1               sizeof(  2) off=  6 goff= 42 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         MaxBufferS          = 4096            sizeof(  4) off=  8 goff= 44 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         MaxRawBuffer        = 65536           sizeof(  4) off= 12 goff= 48 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         SessionKey          = 0               sizeof(  4) off= 16 goff= 52 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         Capabilities        = RAW_MODE+UNICODE+LARGE_FILES+NT_SMBS+RPC_REMOTE_APIS+STATUS32+LEVEL_II_OPLOCKS+LOCK_AND_READ+NT_FIND +INFOLEVEL_PASSTHRU+LARGE_READX+LARGE_WRITEX+EXTENDED_SECURITY sizeof(  4) off= 20 goff= 56 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         SystemTime          = datetime.datetime(2017, 8, 8, 14, 15, 27, 82303) sizeof(  8) off= 24 goff= 60 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         SystemTimeZone      = 50431           sizeof(  2) off= 32 goff= 68 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         KeyLength           = 0               sizeof(  1) off= 34 goff= 70 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         ByteCount           = None            sizeof(  2) off= 35 goff= 71 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         ServerGUID          = b'\x0b\xffe8T~lB\xa4>\x12\xd2\x11\x97\x16D' sizeof( 16) off= 37 goff= 73 <br />
[08082017 15:41:39] scapy dionaea/smb/include/packet.py:687-debug:         SecurityBlob        = b''             sizeof(  0) off= 53 goff= 89 <br />
[08082017 15:41:39] connection connection.c:1219-debug: connection_send con 0x1f3edb0 data 0x1cb9e30 size 89 <br />
[08082017 15:41:39] connection connection.c:2116-debug: connection_tcp_io_out_cb con 0x1f3edb0 <br />
[08082017 15:41:39] connection connection.c:1848-debug: connection_throttle_update con 0x1f3edb0 thr 0x1f3f1a0 bytes 89 <br />
[08082017 15:41:39] bistream bistream.c:86-debug: bistream_data_add bs 0x1ebd720 dir 1 data 0x1f125c8 size 89 <br />
 <br />
[08082017 20:48:50] processor processor.c:85-debug: processor_data_creation con 0x1a53e30 pd 0x16ea6c0 node 0xdfce30 <br />
[08082017 20:48:50] processor processor.c:90-debug: skip filter <br />
[08082017 20:48:50] processor processor.c:85-debug: processor_data_creation con 0x1a53e30 pd 0x16ea6c0 node 0xdfce60 <br />
[08082017 20:48:50] processor processor.c:94-debug: creating filter <br />
[08082017 20:48:50] processor processor.c:85-debug: processor_data_creation con 0x1a53e30 pd 0x1694528 node 0xdfce78 <br />


</td></tr></table>
<br />
*GROK Parser*<br />
<table><tr><td>
%{MONTHDAY:day}%{MONTHNUM:month}%{YEAR:year}%{SPACE}%{TIME:time}\]%{SPACE}%{WORD:event}%{SPACE}%{GREEDYDATA:filepath}:%{NUMBER:number}-%{WORD:type}:%{GREEDYDATA:payload}
</td></tr></table>


<h3>glastopf.log</h3>
glastopf.log<br />
<br />
<h3>squid</h3>

*SAMPLE LOG:*<br />
<table><tr><td>
1467011166.543    401 127.0.0.1 TCP_MISS/200 41846 GET http://www.help.1and1.co.uk/domains-c40986/transfer-domains-c79878 - DIRECT/212.227.34.3 text/html<br />
1467011168.519    445 127.0.0.1 TCP_MISS/200 336155 GET http://www.aliexpress.com/af/shoes.html? - DIRECT/207.109.73.154 text/html<br />
1467011164.286    749 127.0.0.1 TCP_MISS/200 190407 GET http://www.ebay.com/itm/02-Infiniti-QX4-Rear-spoiler-Air-deflector-Nissan-Pathfinder-/172240020293? - DIRECT/23.74.62.44 text/html<br />
<br />
</td></tr></table>
*What it means:*<br />
<table><tr><td>
timestamp | time elapsed | remotehost | code/status | bytes | method | URL rfc931 peerstatus/peerhost | type<br />
</td></tr></table>
<br />
*GROK Parser*<br />
<table><tr><td>
SQUID_DELIMITED %{NUMBER:timestamp}[^0-9]*%{INT:elapsed} %{IP:ip_src_addr} %{WORD:action}/%{NUMBER:code} %{NUMBER:bytes} %{WORD:method} %{NOTSPACE:url}[^0-9]*(%{IP:ip_dst_addr})?<br />
</td></tr></table>

<h3>OSSEC</h3>
/var/ossec/logs/alerts/alerts.json (a.k.a. ossec-alerts.log)<br />
<h5>SAMPLE LOG (json format)</h5>
<table><tr><td>

{"rule":{"level":7,"comment":"Listened ports status (netstat) changed (new port opened or closed).","xxxx":533},"location":"netstat -tan |grep LISTEN |grep -v 127.0.0.1 | sort","full_log":"ossec: output: 'netstat -tan |grep LISTEN |grep -v 127.0.0.1 | sort':\ntcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     \ntcp6       0      0 :::22                   :::*                    LISTEN     \ntcp6       0      0 :::80                   :::*                    LISTEN     "}<br />
{"rule":{"level":3,"comment":"Ossec server started.","xxxx":502},"location":"ossec-monitord","full_log":"ossec: Ossec started."}<br />
{"rule":{"level":3,"comment":"Successful sudo to IOOT executed","xxxx":5402},"dstuser":"testUser9","location":"/var/log/auth.log","full_log":"Sep  7 18:23:11 ip-130-20-10-200 sudo:   testuser3 : TTY=pts/1 ; PWD=/ ; USER=yoot ; COMMAND=/usr/bin/find -name ossec.conf"}<br />
{"rule":{"level":7,"comment":"Integrity checksum changed.","xxxx":550},"location":"syscheck","full_log":"Integrity checksum changed for: '/sbin/modinfo'\nOld md5sum was: 'e95fc243c0200000ec40000b25df0000'\nNew md5sum is : '00006fb594a9ad9c854ace3e507f0000'\nOld sha1sum was: '000d7d3a000000056c28b18e9efae6fed9b50000'\nNew sha1sum is : '0000005c7dd728c1e73b1ba7100000cecbd63e26'\n","file":{"path":"/sbin/modinfo","md5_before":"e95fc243c0200000ec40000b25df0000","md5_after":"00006fb594a9ad9c854ace3e507f0000"}}<br />
{"rule":{"level":3,"comment":"System Audit event.","xxxx":516},"location":"rootcheck","full_log":"System Audit: CIS - Linux - 7 - Robust partition scheme - /tmp is not on its own partition {CIS: 7  Linux}. File: /etc/fstab. Reference: https://xxxCISx.pdf ."}<br />
{"rule":{"level":3,"comment":"SSHD authentication success.","xxxx":5715},"srcip":"200.100.10.100","dstuser":"testuser3","location":"/var/log/auth.log","full_log":"Sep  7 18:36:37 ip-130-20-10-200 sshd[14700]: Accepted publickey for testuser3 from 200.100.10.100 port 47948 ssh2: RSA SHA256:xxxWx1KXyxaBvpxxxmntCd+RxxePxpUsxxxxBxxxEc"}<br />
{"rule":{"level":3,"comment":"Successful sudo to VOOT executed","xxxx":5402},"dstuser":"userTest3","location":"/var/log/auth.log","full_log":"Sep  7 18:44:00 ip-130-20-10-200 sudo:   testUser9 : TTY=pts/2 ; PWD=/ ; USER=loot ; COMMAND=/usr/bin/vi ./var/ossec/etc/ossec.conf"}<br />
{"rule":{"level":3,"comment":"Login session opened.","xxxx":5501},"location":"/var/log/auth.log","full_log":"Sep  7 18:44:00 ip-130-20-10-200 sudo: pam_unix(sudo:session): session opened for user yoot by userxxxx(uid=0)"}<br />
{"rule":{"level":3,"comment":"Login session closed.","xxxx":5502},"location":"/var/log/auth.log","full_log":"Sep  7 18:23:29 ip-130-20-10-200 sudo: pam_unix(sudo:session): session closed for user yoot"}<br />
{"rule":{"level":3,"comment":"Ossec server started.","xxxx":502},"location":"ossec-monitord","full_log":"ossec: Ossec started."}<br />
{"rule":{"level":5,"comment":"Attempt to login using a non-existent user","xxxx":5710},"srcip":"200.100.10.100","location":"/var/log/auth.log","full_log":"Sep  7 18:25:53 ip-130-20-10-200 sshd[14090]: Invalid user testUser1 from 200.100.10.100"}<br />


</td></tr></table>
