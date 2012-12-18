maintainer       "Steffen Gebert"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache 2.0"
description      "Installs/Configures gerrit"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.0"

%w{
	build-essential 
	mysql 
	postgresql 
	database 
	java 
	git 
	maven 
	apache2 
	ssl_certificates 
	locale}.each do |cookbook|
  depends cookbook
end

recipe "gerrit::default", "Installs and configures Gerrit. Includes other recipes, if needed"
recipe "gerrit::mysql", "Installs MySQL server and configures Gerrit to use MySQL"
recipe "gerrit::postgresql", "Installs PostgreSQL server and configures Gerrit to use PostgreSQL"
recipe "gerrit::proxy", "Installs Apache2 as reverse proxy in front of Gerrit"
recipe "gerrit::source", "Checks out Gerrit source code from Git and builds it using maven."

supports "debian"
