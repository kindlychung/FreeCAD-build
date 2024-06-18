FROM fedora:latest
WORKDIR /work

# Build deps.  (Not runtime deps)
RUN dnf install -y git gcc med-devel xerces-c-devel Coin4 Coin4-devel qt5-qtbase-devel qt5-qtxmlpatterns-devel qt5-qtsvg-devel qt5-qttools-devel qt5-qttools-static opencascade-devel make boost-devel yaml-cpp-devel

