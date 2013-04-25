If Not Exist "venv" (
    echo "Trying to use virtualenv, this will only work if python 2.7 is installed in the default directory and has virtualenv installed."
    echo "It is probably easier for you to manually create the virtual env using <path to python 2.7>\Scripts\virtualenv-2.7 --no-site-packages venv"
    c:\Python27\Scripts\virtualenv-2.7 --no-site-packages venv
)


venv/bin/easy_install zc.buildout distribute

echo "Trying to install lxml, this has been known to cause errors."
echo "If lxml installation fails you will need to find a binary distribution of lxml that works on your system.  First try copying all files out of .\lxml-binaries\windows into .\venv\Lib\site-packages."
venv/bin/easy_install lxml==2.3

venv/bin/buildout

pause