Deployment Steps
================

1. Checkout this git repository
2. Install python 2.7
3. Install easy_install
4. easy_install virtualenv
5. Create venv from python 2.7 (<python27>/Scripts/virtualenv --no-site-packages <location>).
6. <venv>/bin/pip install zc.buildout distribute
7. cd to the checked out repository location
8. <venv>/bin/buildout

Note:  We have had trouble with installation of lxml so binaries have been included in the lxml-binaries directory.

Deployment using scripts
========================

linux
-----

1. Complete steps 1-4 as above.
2. yum install sqlite-devel python-devel (or equivalent for our system)
3. cd <deploy dir>
4. sh deploy.sh

windows
-------

1. Complete steps 1-4 as above.
2. cd <deploy dir>
3. deploy.bat

Note: It can be a pain getting python and virtualenv to work correctly from the command line, it may be easier to follow the deploy steps above.

Linux Problems
==============

If you have unrecognised archive errors installing twistd
----------------------------------------------------------

1. yum install bzip2-devel (or equiv - libbz2-dev)
2. cd to python2.7 files (probably /usr/lib/python2.7)
3. make clean
4. ./configure
5. make
6. make install/make altinstall (only use install if python2.7 is the system python)

If lxml has remote connection closed problems:
----------------------------------------------
1. download the source
2. use the virtual env to run setup.py bdist
3. copy the egg to <repository location>/eggs/
	
If there are errors installing lxml:
------------------------------------

1. <venv>\Scripts\pip install python-libxml2 libxslt 
2. yum install libxml2-dev (or libxslt-devel)

Windows Problems
================

Setup git so that it is runnable from the command line:
-------------------------------------------------------
1. Install msysgit 
2. Add to path variable as <installdir>\cmd
3. Install tortiosegit 
4. Ensure git works from the command line, cross your fingers..., if all else fails use a git-bash command prompt.

Make sure the virtual env is configured with a valid c compiler:
----------------------------------------------------------------

1. Install mingw
2. Add <installdir>/bin and <installdir>/mingw32/bin to path
3. Add [build] compiler=mingw32 to venv/lib/distutils/distutils.cfg
4. Delete all -mno-cygwin within c:/python27/libs/distutils/cygwincompiler.py
		
If there are errors installing lxml
------------------------------------

1. <venv>\Scripts\easy_install lxml==2.3 then copy the egg to the <repository loc>\eggs
2. The easy_install download may fail, if it does:
    a. Use wget on a linux machine to download the found url
    b. Use scp to copy from linux machine to windows machine
    c. <venv>\Scripts\easy_install <folder egg is copied to>\lxml-2.3-py2.7-win32.egg
    d. copy the lxml... folder from <venv>\Lib\site-packages to <installdir>\eggs folder
	
Other problems
==============

If there are errors installing mysql-python, install the mysql client dev libraries (libmysqlclient-dev)

Running the program after deployment
====================================

To start the provisioning interface:
	bin/pserve development.ini
	
To start the Ingester Platform
	bin/twistd-script.py -n -y dc24_ingester_platform_dam_jcu.tac 
	- Select the correct .tac file 
	- While testing the generate script was actually bin/twistd.py-script.py for some reason which works as expected.

