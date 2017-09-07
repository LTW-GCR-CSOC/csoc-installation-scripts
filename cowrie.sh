#update&upgrade
sudo apt-get update -y && apt-get upgrade
#install dependencies
sudo apt-get install -y git python-dev python-openssl openssh-server python-pyasn1 python-twisted authbind
#set cowrie to listen to port22
touch /etc/authbind/byport/22
chown cowrie /etc/authbind/byport/22
chmod 777 /etc/authbind/byport/22
#install cowrie
git clone https://github.com/micheloosterhof/cowrie.git
cd cowrie
#script to create script
touch start.sh
{ printf %s authbind --deep; cat <./start.sh; } >/tmp/output_file
mv -- /tmp/output_file ./start.sh
rm -rf /tmp/output_file
#restart ssh
service ssh restart
