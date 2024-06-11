#!/bin/bash

ARCH=$(arch)
MAIN_DIR=/tmp/FreeCAD

# Removed
#qt-devel 
#Coin3 
#Coin3-devel -> change to Coin4
#boost-python2-devel 
#boost-python2 

PACKAGES="gcc
med-devel
xerces-c-devel 
Coin4 
Coin4-devel
qt5-qtbase-devel
qt5-qtxmlpatterns-devel
qt5-qtsvg-devel
qt5-qttools-devel
qt5-qttools-static
opencascade-devel
make 
boost-devel 
yaml-cpp-devel
"

NOT_NEEDED="
gcc-c++ 
zlib-devel 
swig 
eigen3 
shiboken 
shiboken-devel 
pyside-tools 
python-pyside 
python-pyside-devel 
OCE-devel 
smesh 
graphviz 
python-pivy 
python-matplotlib 
tbb-devel 
freeimage-devel 
vtk-devel 
boost-python3 
boost-python3-devel
"

set -x
read x
#echo "Removing packages"
#dnf remove $(echo $NOT_NEEDED)
read x
dnf install -y $(echo $PACKAGES)
read x

echo "Installing packages required to build FreeCAD"
set -x
#sudo dnf -y install $PACKAGES
#cd ~
#mkdir -p $MAIN_DIR || { echo "~/$MAIN_DIR already exist. Quitting.."; exit; }
#git clone --recurse-submodules https://github.com/FreeCAD/FreeCAD.git
cd $MAIN_DIR
#mkdir $BUILD_DIR || { echo "~/$BUILD_DIR already exist. Quitting.."; exit; }

touch dnf_successful_installed.txt

try_cmake() {
   cd "$build_absolute"
   (set -x ; cmake ..) && echo "CMAKE successful here" >>dnf_successful_installed.txt
}

try_make() {
   cd "$build_absolute"
   (set -x ; make -j$(nproc)) && echo "Make successful here" >>dnf_successful_installed.txt
}

dnf_install() {
   p="$1"
   echo "*************************************************************************"
   echo "INSTALL $p"
   echo "*************************************************************************"
   dnf list --installed | grep -qE "^$p\." 
   if [ $? -eq 0 ] ; then
      echo "$p already installed" >>dnf_successful_installed.txt
   else
      echo "Trying install $p" >>dnf_successful_installed.txt
      sudo dnf install -y $p || echo "$p FAILED install" >>dnf_successful_installed.txt
   fi
}

#echo "$PACKAGES" | while read p ; do
#   dnf_install $p
#   try_cmake && { echo "CMAKE succeeded here - stopping " ; exit 333 ; }
#done
#echo "$PACKAGES" | while read p ; do
#   try_make && { echo "Make succeeded here - stopping " ; exit 334 ; }
#done

mkdir -p build
cd build
build_absolute="$(readlink -f .)"
cmake ..
make -j$(nproc)
