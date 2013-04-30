EnMaSSe requires a number of source repositories which are each checked out and setup for development using buildout.  Basically the development libraries, python 2.7 and buildout need to be installed, then run the buildout configuration to complete the setup.

Deployment Steps
================

#. Install python 2.7 with the required packages as well as other required development libraries:
	
	::

		yum -y groupinstall "Development tools"
		yum -y install python-virtualenv git openssl openssl-devel libxml2 libxml2-devel libxslt libxslt-devel bzip2-devel libzip-devel libzip sqlite-devel python-devel mysql-devel mysql-client supervisor
		
		cd ~
		mkdir .python
		cd .python/
		virtualenv --no-site-packages build_python
		cd ~
		mkdir bin
		echo "export PATH=\$PATH:~/bin" > /etc/profile.d/home_bin.sh
		source /etc/profile
		ln -s ~/.python/build_python/bin/pip ~/bin/python_pip
		python_pip install setuptools --upgrade zc.buildout==1.4.4
		
		ln -s ~/.python/build_python/bin/buildout ~/bin/python_buildout
			
		mkdir /usr/share/python-buildout 
		cd /usr/share/python-buildout 
		git clone https://github.com/collective/buildout.python.git
		cd buildout.python/
		sed -i "s@prefix = /opt/local@prefix = /usr/share/python-buildout@g" buildout.cfg
		python_buildout
		./bin/install-links

#. Checkout this git repository
#. Create venv from python 2.7 (<python27>/bin/virtualenv --no-site-packages <location>).
#. <venv>/bin/pip install zc.buildout distribute
#. cd to the checked out repository location
#. <venv>/bin/buildout
#. Set up the provisioning interface and ingester platform as services by adding the following configuration to /etc/supervisord.conf

	::

	    [program:enmass_ingestor_platform]
	    user=enmasse
	    command=/opt/enmasse/bin/twistd -n -y /opt/enmasse-config/dc24_ingester_platform_dam_jcu.tac
	    autostart=true
	    autorestart=true
	    logfile=/var/log/supervisor/ingestor_platform.log
	    logfile_maxbytes=10MB
	    logfile_backups=10
	
	    [program:enmasse_provisioning]
	    user=enmasse
	    command=/opt/enmasse/bin/pserve /opt/enmasse-config/production.ini
	    autostart=true
	    autorestart=true
	    logfile=/var/log/supervisor/provisioning.log
	    logfile_maxbytes=10MB
	    logfile_backups=10
	
	
	    chkconfig supervisord on
	    service supervisord start


Note:  We have had trouble with installation of lxml so binaries have been included in the lxml-binaries directory.

Linux Deployment using the deploy.sh script
========================

#. Complete steps 1-2 as above.
#. cd to the checked out repository location
#. sh deploy.sh
#. Set up the services as described in step 7 above.

Linux Problems
==============

If lxml has remote connection closed problems:
----------------------------------------------

Either copy the included binaries from lxml-binaries/linux into ./eggs or:
	#. download the source
	#. <venv>\Scripts\pip install python-libxml2 libxslt 
	#. yum install libxml2-dev (or libxslt-devel)
	#. use the virtual env to run setup.py bdist
	#. copy the egg to <repository location>/eggs/

Windows Problems
================

Setup git so that it is runnable from the command line:
-------------------------------------------------------

#. Install msysgit 
#. Add to path variable as <installdir>\cmd
#. Install tortiosegit 
#. Test that git works from the command line, if its still not working try the git-bash command prompt.

Make sure the virtual env is configured with a valid c compiler:
----------------------------------------------------------------

#. Install mingw
#. Add <installdir>/bin and <installdir>/mingw32/bin to path
#. Add [build] compiler=mingw32 to venv/lib/distutils/distutils.cfg
#. Delete all -mno-cygwin within c:/python27/libs/distutils/cygwincompiler.py
		
If there are errors installing lxml
------------------------------------

Either copy all files from lxml-binaries/windows into venv/Lib/site-packages or:
::
	<venv>/Scripts/easy_install lxml==2.3 

Then copy the egg to the <repository loc>/eggs
	
The easy_install download may fail, if it does:    
	#. Use wget on a linux machine to download the found url
	#. Use scp to copy from linux machine to windows machine
	#. <venv>/Scripts/easy_install <folder egg is copied to>/lxml-2.3-py2.7-win32.egg
	#. copy the lxml... folder from <venv>/Lib/site-packages to <installdir>/eggs folder

mysql-python won't install
--------------------------

If there are errors installing mysql-python, install the mysql client dev libraries (libmysqlclient-dev) or equivalent.

How to run EnMaSSe from the command line
============================================

To start the provisioning interface:
::
	<install dir>/bin/pserve <installdir>/src/jcu.dc24.provisioning/development.ini
	
To start the Ingester Platform
::
	<install dir>/bin/twistd-script.py -n -y <install dir>/src/jcu.ed24.ingesterplatform/dc24_ingester_platform_dam_jcu.tac 
	
- Select the correct .tac file 
- While testing on windows the generated script was actually <install dir>/bin/twistd.py-script.py which worked as expected.

