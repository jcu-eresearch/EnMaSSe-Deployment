Deployment Steps
================

#. Install python 2.7 with the required packages:
	
	::

		yum -y groupinstall "Development tools"
		yum -y install python-virtualenv git openssl openssl-devel libxml2 libxml2-devel libxslt libxslt-devel bzip2-devel libzip-devel libzip sqlite-devel python-devel
		
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
#. cd to the checked out repository location
#. <venv>/bin/buildout

Note:  We have had trouble with installation of lxml so binaries have been included in the lxml-binaries directory.

Deployment using scripts
========================

linux
-----

#. Complete steps 1-2 as above.
#. cd to the checked out repository location
#. sh deploy.sh

windows
-------

#. Get git, python and virtualenv-2.7 working from the command line (see windows problems below).
#. Get a valid c++ compiler working from the command line (see windows problems below).
#. Complete steps 1-2 as above.
#. cd to the checked out repository location
#. deploy.bat

Note: It can be a pain getting python and virtualenv to work correctly from the command line, it may be easier to follow the deploy steps above.

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
	
mysql-python won't install
--------------------------

If there are errors installing mysql-python, install the mysql client dev libraries (libmysqlclient-devel)

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
	#. <venv>/Scripts/easy_install lxml==2.3 then copy the egg to the <repository loc>/eggs
	#. The easy_install download may fail, if it does:    
	    #. Use wget on a linux machine to download the found url
	    #. Use scp to copy from linux machine to windows machine
	    #. <venv>/Scripts/easy_install <folder egg is copied to>/lxml-2.3-py2.7-win32.egg
	    #. copy the lxml... folder from <venv>/Lib/site-packages to <installdir>/eggs folder

mysql-python won't install
--------------------------

If there are errors installing mysql-python, install the mysql client dev libraries (libmysqlclient-dev)

Running the program after deployment
====================================

To start the provisioning interface:
	bin/pserve development.ini
	
To start the Ingester Platform
	bin/twistd-script.py -n -y dc24_ingester_platform_dam_jcu.tac 
	
	- Select the correct .tac file 
	- While testing the generate script was actually bin/twistd.py-script.py for some reason which works as expected.

