@echo off


set ChecksDirectory=.\checkset
IF NOT DEFINED JAVA_HOME (
set JAVA_HOME=C:\Program Files\JavaSoft\jre\1.6.0_45
)


set PATH=%JAVA_HOME%\bin;%PATH%
set CLASSPATH=../Calabash/calabash.jar;../Calabash/lib/commons-httpclient-3.1.jar;../Calabash/lib/commons-codec-1.6.jar;../Calabash/lib/commons-logging-1.1.1.jar;../Calabash/lib/commons-io-1.3.1.jar;../Calabash/lib/saxon9he.jar
set ChecksDirectoryUnix=%ChecksDirectory:\=/%

rem java -version

for %%f in (%ChecksDirectory%\*.xml) do (
   echo Running %ChecksDirectoryUnix%/%%~nf.xml
   java com.xmlcalabash.drivers.Main bin\checkset.xproc ScriptRoot="http://localhost:8080/exist/apps/bintellix/compare" filename=../%ChecksDirectoryUnix%/%%~nf.xml  2> work\checkset_error.log > %ChecksDirectory%/%%~nf.html

   rem java com.xmlcalabash.drivers.Main -p group=ABC checkset=DEF checkset.xproc
   rem java com.xmlcalabash.drivers.Main --safe-mode --log-style plain simple.xpl 
   echo.
)
IF %ERRORLEVEL% LEQ 0 goto OK

:ERROR
ECHO "Program failed, please check the console output for details."
pause

:OK


