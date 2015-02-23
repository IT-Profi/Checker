xquery version "1.0";

declare namespace xdb="http://exist-db.org/xquery/xmldb";
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
let $ct-home-data := request:get-attribute('ct-home-data')
let $data-collection := concat($ct-home-db,'/data/')

return
<html xmlns="http://www.w3.org/1999/xhtml">
    <body>
        {
        let $schema := doc(concat($ct-home-db,'/base/checker.xsd'))
        for $document in collection($ct-home-data)
        return
            let $validation := validation:validate-report($document, $schema)
            return
                if ($validation/*:status[.="invalid"]) then
                    <div>
                        <subtitle>Step {$document/cs:step/cs:identity/cs:step-group}/{$document/cs:step/cs:identity/cs:step-id}</subtitle>
                        <ul>
                        { for $message in $validation/*:message 
                            return
                                <li>{$message/text()} <br/>[file '{util:document-name($document)}', line {string($message/@line)}, column {string($message/@column)}]</li>
                        }
                        </ul>
                        <div style="display: none">
                            <Validation timestamp="{current-dateTime()}" schema="{document-uri($schema)}">
                                <Validate uri="{document-uri($document)}" status="{$validation/*:status}">
                                    {$validation/*:message}
                                </Validate>
                            </Validation>
                        </div>
                    </div>
                else if (count($validation/*:status[.="valid"])=count($validation/*:status) and count($validation/*:status[.="valid"]) != 0) then
                    ()
                else
                    <div>
                        <subtitle>Step {$document/cs:step/cs:identity/cs:step-group}/{$document/cs:step/cs:identity/cs:step-id}</subtitle>
                        <div>{$validation}</div>
                    </div>
        }
        <div>Done.</div>        
        </body>
</html>

