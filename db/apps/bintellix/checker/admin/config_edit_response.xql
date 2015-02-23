xquery version "3.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace bc="http://checker.bintellix.de/";
declare namespace cs="http://checker.bintellix.de/checkset/";

(:
========================================================================
LICENSE AGREEMENT:
This software is distributed WITHOUT ANY WARRANTY and without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
========================================================================
This copy of Checker (an automated compare tool) is licensed under the
Lesser General Public License (LGPL), version 3 ("the License").

See the License for details about distribution rights, 
modification and transformation of it.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/.
========================================================================
Copyright:
(c) 2010-2015 by InterSecurity GmbH &amp; Co. KG, Germany
========================================================================
@Author: Eduard Huber
@Version: 1.0
======================================================================== 
:)

let $ct-home-db := request:get-attribute('ct-home-db')

let $HomeWeb := request:get-parameter("home-web", "'/exist/apps/bintellix/compare'")     (: concat('/exist',$exist:prefix,$exist:controller) :)
let $HomeDb := request:get-parameter("home-db", "/db/apps/bintellix/compare")            (: concat('/db',$exist:prefix,$exist:controller,'/data') :)
let $HomeData := request:get-parameter("home-data", "{concat($HomeDb,'/data')}")
        
let $CmdPath := request:get-parameter("cmd-path", "'%ProgramFiles%\'")
let $CmdFilename := request:get-parameter("cmd-filename", "'Compare.cmd'")
let $CmdQuotingSymbol := request:get-parameter("cmd-quoting-symbol","")
let $CmdQuotingSymbol := request:get-parameter("cmd-quoting-symbol","")
let $FilenamePattern := request:get-parameter("filename-pattern", "step_{{$group}}_{{$step}}.xml")

let $config :=
<bc:compare-tool xmlns:ct="http://compare.bintellix.de">
    <bc:home>
        <bc:web>{$HomeWeb}</bc:web> 
        <bc:db>{$HomeDb}</bc:db>
        <bc:data>{$HomeData}</bc:data> 
    </bc:home>
    <bc:commandline>
        <bc:path>{$CmdPath}</bc:path>
        <bc:filename>{$CmdFilename}</bc:filename>
        <bc:quoting-symbol>{$CmdQuotingSymbol}</bc:quoting-symbol>
    </bc:commandline>
    <bc:set>
        <bc:filename-pattern>{$FilenamePattern}</bc:filename-pattern>
    </bc:set>    
</bc:compare-tool>
return

<html xmlns="http://www.w3.org/1999/xhtml">
    <body>
        <div>All parameters updated successfully.</div>
    </body>
</html>
