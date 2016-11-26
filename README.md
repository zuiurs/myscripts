# myscripts

myscripts is a repository for own good.  
This includes some scripts which is handmade or porting.  

## Usage

Add the below path to $PATH.

```
export PATH=$PATH:/path/to/myscripts/bin
```

Sample case. (Installed in your home directory)

```
export PATH=$PATH:~/myscripts/bin
```

## Script Index

- [docker-container-clean](#docker-image-clean.sh)
- [docker-image-clean](#docker-image-clean.sh)
- [ffmpeg_installer](#ffmpeg_installer.sh)
- [wttr](#wttr)

## docker-container-clean.sh

Output commands for removing all containers.  
**This command does nothing.**  

- example

```
# docker ps -a
CONTAINER ID        IMAGE                  COMMAND             CREATED             STATUS                     PORTS               NAMES
ac54fe3cec9b        docker.io/centos:6     "/bin/bash"         2 minutes ago       Exited (0) 2 minutes ago                       devel03
09e29cda18cd        docker.io/centos:6     "/bin/bash"         2 minutes ago       Exited (0) 2 minutes ago                       devel02
b95781ef9f12        docker.io/centos:7     "/bin/bash"         2 minutes ago       Exited (0) 2 minutes ago                       devel01
f0f3b0bc44f8        docker.io/centos:7     "/bin/bash"         3 minutes ago       Exited (0) 3 minutes ago                       test02
1b3b4ef8364b        lympt/centos/7:plain   "/sbin/init"        4 minutes ago       Up 4 minutes               22/tcp              test01

# docker-container-clean.sh
docker rm -f devel03 devel02 devel01 test02 test01
```

## docker-image-clean.sh

Output commands for removing designated images.  
**This command does nothing usually.**  

NOTE: "-x" option execute removing commands.

- example

```
# docker images
REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE
lympt/debian/jessie   plain               5df28d43198f        5 months ago        251 MB
lympt/centos/7        plain               8b8dd620a4a4        5 months ago        375.9 MB
lympt/centos/7        httpd               f072948172b0        5 months ago        426 MB
lympt/centos/7        base                ef7f15e99f9a        5 months ago        527 MB
lympt/centos/6        plain               c33e3ba7a4e8        5 months ago        391.8 MB
docker.io/debian      jessie              fb435671a96a        5 months ago        125.1 MB
docker.io/centos      6                   6a77ab6655b9        5 months ago        194.6 MB
docker.io/centos      7                   904d6c400333        5 months ago        196.7 MB

# docker-image-clean lympt
------- Target Image -------
lympt/debian/jessie:plain
lympt/centos/7:plain
lympt/centos/7:httpd
lympt/centos/7:base
lympt/centos/6:plain
----------------------------
docker rmi lympt/debian/jessie:plain lympt/centos/7:plain lympt/centos/7:httpd lympt/centos/7:base lympt/centos/6:plain

# docker-image-clean -x lympt
------- Target Image -------
lympt/debian/jessie:plain
lympt/centos/7:plain
lympt/centos/7:httpd
lympt/centos/7:base
lympt/centos/6:plain
----------------------------
Above images will delete, is it OK? [y/n]: y
Are you sure? [y/n]: y
Deleting images...
Complete!
```

## ffmpeg_installer.sh

Install ffmpeg for CentOS 7.  
This is based on official procedure below.  
[CompilationGuide/Centos – FFmpeg](https://trac.ffmpeg.org/wiki/CompilationGuide/Centos)

First, instruct installing packages to solving dependencies.  
After that, installation starts.  
Finally, this script add installation path to $PATH.  

```
export PATH=$PATH:/path/to/ffmpeg/build/bin
```

NOTE: Use "-v" option to debugging.

- example 1

```
$ ffmpeg_installer
---> Check package autoconf
autoconf-2.69-11.el7.noarch
---> Check package automake
automake-1.13.4-3.el7.noarch
---> Check package bzip2
bzip2-1.0.6-13.el7.x86_64
---> Check package cmake
cmake-2.8.11-5.el7.x86_64
---> Check package freetype-devel
freetype-devel-2.4.11-11.el7.x86_64
---> Check package gcc
gcc-4.8.5-4.el7.x86_64
---> Check package gcc-c++
gcc-c++-4.8.5-4.el7.x86_64
---> Check package git
git-1.8.3.1-6.el7_2.1.x86_64
---> Check package libtool
libtool-2.4.2-21.el7_2.x86_64
---> Check package make
make-3.82-21.el7.x86_64
---> Check package mercurial
mercurial-2.6.2-6.el7_2.x86_64
---> Check package nasm
nasm-2.10.07-7.el7.x86_64
---> Check package pkgconfig
pkgconfig-0.27.1-4.el7.x86_64
---> Check package zlib-devel
zlib-devel-1.2.7-15.el7.x86_64
------------------------
| Dependency is clear! |
------------------------
Can I install in /path/to/current_directory/ffmpeg? [y/N]
```

- example 2

```
$ ffmpeg_installer /usr/local/bin
<output_omitted>
Can I install in /usr/local/bin/ffmpeg? [y/N]
```

## wttr

Display weather in designated region.

- example

```
$ wttr tokyo
[Weather for City: Tokyo, Japan

     \   /     Sunny
      .-.      5 – 7 °C
   ― (   ) ―   ↓ 14 km/h
      `-’      10 km
     /   \     0.0 mm
```

- -v option
	- Display detail
	- like http://wttr.in/tokyo

- -m option
	- Display moon
	- like http://wttr.in/moon
