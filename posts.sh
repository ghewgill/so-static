#!/bin/sh

#grep '<question' unify.xml | cut -d\" -f2 | xargs -L 1 -I{} xt unify/{}.xml posts.xsl
javac -cp /home/greg/build/xt20051206.jar posts.java
java -cp .:/home/greg/build/xt20051206.jar:/home/greg/build/xp/xp.jar posts
