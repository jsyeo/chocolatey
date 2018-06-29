FROM ubuntu:trusty

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y

RUN apt-get install -y apt-transport-https
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu wheezy/snapshots/3.12.0 main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt-get update -y
RUN apt-get install -y mono-complete mono-devel
RUN apt-get install -y git
RUN apt-get install -y nuget

RUN git clone https://github.com/chocolatey/choco
WORKDIR choco
RUN nuget restore src/chocolatey.sln
RUN bash build.sh -v

RUN echo '#!/usr/bin/env bash' >> /usr/local/bin/choco
RUN echo 'mono /choco/build_output/chocolatey/choco.exe $@' >> /usr/local/bin/choco
RUN chmod +x /usr/local/bin/choco
WORKDIR /
