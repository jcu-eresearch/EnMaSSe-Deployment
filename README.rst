EnMaSSe Deployment
==================

EnMaSSe (Environmental Monitoring and Sensor Storage) requires a number of source repositories which are each checked out and setup for development using buildout:

.. _Documentation: https://github.com/jcu-eresearch/TDH-Rich-Data-Capture-Documentation
.. _`Ingester Platform`: https://github.com/jcu-eresearch/TDH-dc24-ingester-platform
.. _`Ingester API`: https://github.com/jcu-eresearch/jcu.dc24.ingesterapi
.. _SimpleSOS: https://github.com/jcu-eresearch/python-simplesos
.. _`Provisioning Interface`: https://github.com/jcu-eresearch/TDH-rich-data-capture

* `Ingester Platform`_ - Handles ingestion of data streaming and storage for the EnMaSSe project.
* `Ingester API`_ - API for integrating the EnMaSSe provisioning interface with the ingester platform
* SimpleSOS_ - Library used for the SOSScraperDataSource.
* `Provisioning Interface`_ - User interface/website for EnMaSSe

More information can be found in the Documentation_.

In short the development libraries, python 2.7 and buildout need to be installed, then run the buildout configuration to complete the setup.

The deployment instructions below are targeted at redhat servers but the application was developed on windows and mac and should work fully.  To install on other operating systems follow the equivalent steps to below, windows specific issues/steps have been explained further below.

Deployment Steps
================

#. Install python 2.7 with the required packages as well as other required development libraries:
	
	::

		yum -y groupinstall "Development tools"
		yum -y install python-virtualenv git openssl openssl-devel libxml2 libxml2-devel libxslt libxslt-devel bzip2-devel libzip-devel libzip sqlite-devel python-devel mysql-devel mysql-client
		
		cd ~
		mkdir .python
		cd .python/
		virtualenv --no-site-packages build_python
		cd ~
		mkdir bin
		echo "export PATH=\$PATH:~/bin" > /etc/profile.d/home_bin.sh
		source /etc/profile
		ln -s ~/.python/build_python/bin/pip ~/bin/python_pip
		python_pip install setuptools --upgrade zc.buildout==1.4.4 distribute
		
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
#. <venv>/bin/pip install zc.buildout distribute uwsgi
#. cd to the checked out repository location
#. <venv>/bin/buildout
#. Set up the provisioning interface and ingester platform as services:
	#. Copy services/enmasse_provisioning to /etc/init.d 
	#. chkconfig enmasse_provisioning on
	#. service enmasse_provisioning start

	#. Cop services/enmasse_ingester_platform to /etc/init.d
	#. chkconfig enmasse_ingester_platform on
	#. service enmasse_ingester_platform start
#. Update the configuration files (src/jcu.dc24.provisioning/production.ini and src/jcu.dc24.ingesterplatform/dc24_ingester_platform.tac).

Note:  We have had trouble with installation of lxml so binaries have been included in the lxml-binaries directory.

Linux Deployment using the deploy.sh script
========================

#. Create the user that the services will run as (eg. enmasse)
#. Create the installation directory and give the user full permissions (eg. /opt/enmasse)
#. cd <installation dir> 
#. sudo yum install git
#. sh deploy.sh /opt/enmasse/services
#. Update the configuration files (src/jcu.dc24.provisioning/production.ini and src/jcu.dc24.ingesterplatform/dc24_ingester_platform.tac).

Note: Your organisation may want to de-couple the configuration and service files from the deployment, if this is the case:
	- Store your configuration and service files external to the deployment directory.
	- Update the service files with the correct configuration files.
	- Pass the directory that contains your service files into sh deploy.sh rather than /opt/enmasse/services

Linux Problems
==============

If lxml has remote connection closed problems:
----------------------------------------------

Either copy the included binaries from lxml-binaries/linux into ./eggs or:
	#. download the source
	#. <venv>/bin/pip install python-libxml2 libxslt 
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

**To start the provisioning interface:**

Production (requires UWSGI web server such as nginx)
::
	<install dir>/bin/uwsgi <installdir>/src/jcu.dc24.provisioning/production.ini

Development
::
	<install dir>/bin/pserve <installdir>/src/jcu.dc24.provisioning/development.ini		
	
**To start the Ingester Platform**
::
	<install dir>/bin/twistd-script.py -n -y <install dir>/src/jcu.ed24.ingesterplatform/dc24_ingester_platform_dam_jcu.tac 
	
- Select the correct .tac file 
- While testing on windows the generated script was actually <install dir>/bin/twistd.py-script.py which worked as expected.

Credits
-------

.. _`Australian National Data Service (ANDS)`: http://www.ands.org.au/
.. _`Queensland Cyber Infrastructure Foundation (QCIF)`: (http://www.qcif.edu.au/

This project is supported by the `Australian National Data Service (ANDS)`_ through the National Collaborative Research Infrastructure Strategy Program and the Education Investment Fund (EIF) Super Science Initiative, as well as through the `Queensland Cyber Infrastructure Foundation (QCIF)`_.

License
-------

See `LICENCE.txt`.

