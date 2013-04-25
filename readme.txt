1. Checkout this git repository
2. Install python 2.7
3. Install easy_install + easy_install virtualenv
4. Create venv from python 2.7 (<python27>/Scripts/virtualenv --no-site-packages <location>)
5. <venv>/bin/pip install zc.buildout distribute
6. cd to the checked out repository location
7. <venv>/bin/buildout

Windows Problems
----------------
Setup git so that it is runnable from the command line:
	- Install msysgit 
	- Add to path variable as <installdir>\cmd
	- Install tortiosegit 
	- Ensure git works from the command line, cross your fingers..., if all else fails use a git-bash command prompt.
Make sure the virtual env is configured with a valid c compiler:
	- Install mingw
	- Add <installdir>/bin and <installdir>/mingw32/bin to path
	- Add [build] compiler=mingw32 to venv/lib/distutils/distutils.cfg
	- Delete all -mno-cygwin within c:/python27/libs/distutils/cygwincompiler.py
		
If there are errors installing lxml:
	- <venv>\Scripts\easy_install lxml==2.3 then copy the egg to the <repository loc>\eggs
	- The easy_install download may fail, if it does:
	    - Use wget on a linux machine to download the found url
	    - Use scp to copy from linux machine to windows machine
	    - <venv>\Scripts\easy_install <folder egg is copied to>\lxml-2.3-py2.7-win32.egg
	    - copy the lxml... folder from <venv>\Lib\site-packages to <installdir>\eggs folder

Linux Problems
--------------
If you have unrecognised archive errors installing twistd:
	- yum install bzip2-devel (or equiv - libbz2-dev)
	- cd to python2.7 files (probably /usr/lib/python2.7)
	- make clean
	- ./configure
	- make
	- make install/make altinstall (only use install if python2.7 is the system python)

If lxml has remote connection closed problems:
	- download the source
	- use the virtual env to run setup.py bdist
	- copy the egg to <repository location>/eggs/
	
If there are errors installing lxml:
	- <venv>\Scripts\pip install python-libxml2 libxslt 
	- yum install libxml2-dev (or libxslt-devel)

	
Other problems
--------------
If there are errors installing mysql-python:
	- install the mysql client dev libraries (libmysqlclient-dev)

	
To start the provisioning interface
-----------------------------------
	bin/pserve development.ini
	
To start the Ingester Platform
------------------------------
	bin/twistd-script.py -n -y dc24_ingester_platform_dam_jcu.tac 
	- Select the correct .tac file 
	- While testing the generate script was actually bin/twistd.py-script.py for some reason which works as expected.

