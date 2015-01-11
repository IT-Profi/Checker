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
let $config := doc(concat($ct-home-db,'/../checker_config.xml'))

return
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <style type="text/css">
        <![CDATA[
            label {
                display: inline-block;
                width: 15ex;
            }
        ]]>
        </style>
    </head>
    <body>
        <form action="config_edit_response.html">
            <label>Web Root Path</label>
            <input type="text" name="home-web" value="{$config/bc:config/bc:home/bc:web/text()}"/>
            <br/>
            <label>DB Root Path</label>
            <input type="text" name="home-db" value="{$config/bc:config/bc:home/bc:db/text()}"/>
            <br/>
            <label>Data Root Path</label>
            <input type="text" name="home-data" value="{$config/bc:config/bc:home/bc:data/text()}"/>
            <br/>
        
            <label>Cmd Path</label>
            <input type="text" name="cmd-path" value="{$config/bc:config/bc:cmd/bc:path/text()}"/>
            <br/>
            <label>Cmd Filename</label>
            <input type="text" name="cmd-filename" value="{$config/bc:config/bc:cmd/bc:filename/text()}"/>
            <br/>
            <label>Quoting symbol</label>
            <input type="text" name="cmd-quoting-symbol" value="{$config/bc:config/bc:cmd/bc:quoting-symbol/text()}"/>
            <br/>
            <label>Filename pattern</label>
            <input type="text" name="filename-pattern" value="{$config/bc:config/bc:set/bc:filename-pattern/text()}"/>
            <br/>
            <input type="submit"/>
        </form>
    </body>
</html>