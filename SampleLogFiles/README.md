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
*-Detailed Log*<br />
./opt/dionaea/var/log/dionaea.log (a.k.a. dionaea-opt3.log)<br />
<br />
**glastopf.log**<br />
glastopf.log<br />
<br />
**squid**<br />




*REAL LOG INFO:*<br />
1467011166.543    401 127.0.0.1 TCP_MISS/200 41846 GET http://www.help.1and1.co.uk/domains-c40986/transfer-domains-c79878 - DIRECT/212.227.34.3 text/html<br />
1467011168.519    445 127.0.0.1 TCP_MISS/200 336155 GET http://www.aliexpress.com/af/shoes.html? - DIRECT/207.109.73.154 text/html<br />
1467011164.286    749 127.0.0.1 TCP_MISS/200 190407 GET http://www.ebay.com/itm/02-Infiniti-QX4-Rear-spoiler-Air-deflector-Nissan-Pathfinder-/172240020293? - DIRECT/23.74.62.44 text/html<br />
<br />
*What it means:*<br />
timestamp | time elapsed | remotehost | code/status | bytes | method | URL rfc931 peerstatus/peerhost | type<br />
<br />
*GROCK Parser*<br />
SQUID_DELIMITED %{NUMBER:timestamp}[^0-9]*%{INT:elapsed} %{IP:ip_src_addr} %{WORD:action}/%{NUMBER:code} %{NUMBER:bytes} %{WORD:method} %{NOTSPACE:url}[^0-9]*(%{IP:ip_dst_addr})?<br />
