# Reference: https://www.phishingfrenzy.com/resources/install_ubuntu_linux
sudo apt-get install apache2 php mysql-server libmysqlclient-dev git curl
sudo git clone https://github.com/pentestgeek/phishing-frenzy.git /var/www/phishing-frenzy
\curl -sSL https://get.rvm.io | bash
rvm install 2.3.0
rvm all do gem install --no-rdoc --no-ri rails
rvm all do gem install --no-rdoc --no-ri passenger
sudo apt-get install build-essential libcurl4-openssl-dev apache2-dev libapr1-dev libaprutil1-dev
passenger-install-apache2-module
# add to apache /etc/apache2/sites-enabled/*.conf. With this said we are going to create the configuration 
# file pf.conf inside this directory which will enable Apache's Virtual Host to render this site when 
# the appropriate FQDN is hit in the browser.
  # <VirtualHost *:80>
  #  ServerName phishing-frenzy.com
    # !!! Be sure to point DocumentRoot to 'public'!
  #  DocumentRoot /var/www/phishing-frenzy/public
  #  RailsEnv development
  #  <Directory /var/www/phishing-frenzy/public>
      # This relaxes Apache security settings.
  #    AllowOverride all
      # MultiViews must be turned off.
  #    Options -MultiViews
  #  </Directory>
  # </VirtualHost>
  
 sudo service mysql start
# fix c
# mysql -u root -ponfig
# mysql> create database pf_dev;
# mysql> grant all privileges on pf_dev.* to 'pf_dev'@'localhost' identified by 'password';

wget http://download.redis.io/releases/redis-stable.tar.gz
tar xzf redis-stable.tar.gz
cd redis-stable/
sudo make
sudo make install
cd utils/
sudo ./install_server.sh
cd /var/www/phishing-frenzy/
bundle install
rvmsudo bundle exec rake db:migrate
rvmsudo bundle exec rake db:seed
mkdir -p /var/www/phishing-frenzy/tmp/pids
rvmsudo bundle exec sidekiq -C config/sidekiq.yml
# service sidekiq start
# service sidekiq status
# service sidekiq stop

# add to /etc/sudoers
# www-data ALL=(ALL) NOPASSWD: /etc/init.d/apache2 reload

sudo chown -R www-data:www-data /var/www/phishing-frenzy/
sudo chmod -R 755 /var/www/phishing-frenzy/public/uploads/
sudo chown -R www-data:www-data /etc/apache2/sites-enabled/
sudo chmod 755 /etc/apache2/sites-enabled/

sudo apachectl restart

