#!/bin/sh

javac -cp xt20051206.jar posts.java
java -cp .:xt20051206.jar:xp.jar posts
