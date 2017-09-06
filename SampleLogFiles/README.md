This page contains sample log alert information. It also intends to provide grok parsers (http://grokconstructor.appspot.com/)<br />
http://grokconstructor.appspot.com/do/match#result<br />
<br />


location of alert logs: <br />
**OSSEC**<br />
/var/ossec/logs/alerts/alerts.log (a.k.a. ossec-alerts.log)<br />
<br />
**Dionaea** <br />
*-Simple Log*<br />
./var/log/dionaea.log (a.k.a. dionaea.log)<br />
<br />
*REAL LOG INFO:*<br />
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

*-Detailed Log*<br />
./opt/dionaea/var/log/dionaea.log (a.k.a. dionaea-opt3.log)<br />
<br />
**glastopf.log**<br />
glastopf.log<br />
<br />
**squid**<br />

*REAL LOG INFO:*<br />
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

