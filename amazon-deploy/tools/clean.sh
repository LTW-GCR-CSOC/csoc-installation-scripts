rm -rf awscanary
mkdir ~/awscanary
cd ~/awscanary
wget -q https://github.com/LTW-GCR-CSOC/csoc-installation-scripts/archive/master.zip
unzip -qq master.zip
cd csoc-installation-scripts-master/
chmod +x *.sh
cd ./amazon-deploy/canary/vagrant
cp ~/creds/* ./
source aws-credentials
vagrant up
