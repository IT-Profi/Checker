@echo off

IF NOT DEFINED JAVA_HOME (
    set JAVA_HOME=C:\Program Files\JavaSoft\jre\1.6.0_45
)

set PATH=%JAVA_HOME%\bin;%PATH%

set CLASSPATH=../Calabash/calabash.jar;../Calabash/lib/commons-httpclient-3.1.jar;../Calabash/lib/commons-codec-1.6.jar;../Calabash/lib/commons-logging-1.1.1.jar;../Calabash/lib/commons-io-1.3.1.jar;../Calabash/lib/saxon9he.jar

rem java -version

java com.xmlcalabash.drivers.Main bin\checkset.xproc %*

rem pause


