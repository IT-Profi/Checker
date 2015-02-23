#!/bin/bash

JAVA_HOME=`/usr/libexec/java_home -v 1.7`
CLASSPATH=../Calabash/calabash.jar:../Calabash/lib/commons-httpclient-4.2.5.jar:../Calabash/lib/commons-codec-1.6.jar:../Calabash/lib/commons-logging-1.1.1.jar:../Calabash/lib/commons-io-1.3.1.jar:../Calabash/lib/saxon9he.jar

#java -version
#echo starting: java com.xmlcalabash.drivers.Main bin/checkset.xproc "$@"
java -cp "$CLASSPATH" -Dcom.xmlcalabash.phonehome=false com.xmlcalabash.drivers.Main "bin/checkset.xproc" "$@"