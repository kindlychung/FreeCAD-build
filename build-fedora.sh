#!/bin/bash

#(C) 2024 Gunnar Andersson, License: MIT

MAIN_DIR="$(readlink -f "$(dirname "$0")")"
cd "$MAIN_DIR"

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

# These seem not needed for the compilation with default config (???)  
# Some might be needed at runtime though.
TBD_NOT_NEEDED="
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

#echo "Removing packages"
#dnf remove $(echo $NOT_NEEDED)

echo "Installing packages required to build FreeCAD"
sudo dnf install -y $(echo $PACKAGES)

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

(set -x ; git clone --recurse-submodule https://github.com/FreeCAD/FreeCAD)
set -xe
cd FreeCAD
mkdir -p build
cd build
build_absolute="$(readlink -f .)"
cmake ..
make -j$(nproc)
