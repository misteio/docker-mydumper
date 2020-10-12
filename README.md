# docker-mydumper
Dockerized MyDumper/MyLoader Image, based on Alpine Linux and run without root user.
This image is the lightweight that you can find for this service.

# What is mydumper? Why?

* Parallelism (hence, speed) and performance (avoids expensive character set conversion routines, efficient code overall)
* Easier to manage output (separate files for tables, dump metadata, etc, easy to view/parse data)
* Consistency - maintains snapshot across all threads, provides accurate master and slave log positions, etc
* Manageability - supports PCRE for specifying database and tables inclusions and exclusions


# Usage
Quick example for dumping :
```bash
$ mydumper -h host -u username -p password --database db_name --threads 10 --rows 20000 -v 3
```
You can find more documentation [here]( https://manpages.debian.org/testing/mydumper/mydumper.1.en.html) 

Quick example for loading :
```bash
$ myloader -h host -u username -p password --database db_name --threads 10 --rows 20000 -v 3
```
Options can be found [here]( http://manpages.ubuntu.com/manpages/bionic/man1/myloader.1.html )