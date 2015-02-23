xquery version "3.0";
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

let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-attribute('group')
let $step := request:get-attribute('step')
let $version := request:get-parameter('version','1')
let $filename := request:get-attribute('filename')
let $data-collection := concat($ct-home-data,'/', $group, '/')

let $step_local := fn:doc(concat($data-collection, 'step_', $step, '.xml'))/cs:step
let $checkset_local := $step_local/cs:checkset/*
let $checkset_group := fn:doc(concat($data-collection, 'step.xml'))/cs:checkset-group/*
let $checkset_global := fn:doc(concat($ct-home-data, '/step.xml'))/cs:checkset-group/*
return
    if ($version="1") then    
        <cs:step xmlns:xs="http://www.w3.org/2001/XML/Schema" xmlns:cs="http://checker.bintellix.de/checkset/" version="1">
            {$step_local/cs:identity}
            <cs:namespaces type="GLOBAL">{$checkset_global[local-name()='namespaces' and namespace-uri()='http://checker.bintellix.de/checkset/' and @type="GLOBAL"]/*}</cs:namespaces>           
            <cs:namespaces type="GROUP">{$checkset_group[local-name()='namespaces' and namespace-uri()='http://checker.bintellix.de/checkset/' and @type="GROUP"]/*}</cs:namespaces>
            <cs:checksets version="1" type="GLOBAL">{$checkset_global[local-name()='checksets' and namespace-uri()='http://checker.bintellix.de/checkset/' and @type="GLOBAL"]/*}</cs:checksets>
            <cs:checksets version="1" type="GROUP">{$checkset_group[local-name()='checksets' and namespace-uri()='http://checker.bintellix.de/checkset/' and @type="GROUP"]/*}</cs:checksets>
            
            <cs:checkset version="1">
                { response:set-header("Content-Disposition",concat("attachment; filename=", $filename)) }
            
                <!-- selected step values -->
                {$checkset_local[not(local-name()=("variables","groups") and namespace-uri()='http://checker.bintellix.de/checkset/')] }
                
                <!-- local given values -->
                <cs:variables type="LOCAL">{$checkset_local[local-name()='variables' and namespace-uri()='http://checker.bintellix.de/checkset/']/*}</cs:variables>
                
                <cs:groups type="LOCAL">{$checkset_local[local-name()='groups' and namespace-uri()='http://checker.bintellix.de/checkset/' and @type="LOCAL"]/*}</cs:groups>
            
                <!-- group given values -->
                {$checkset_group[not(local-name()=("variables","groups") and namespace-uri()='http://checker.bintellix.de/checkset/')] }
                <cs:groups type="GROUP">{$checkset_group[local-name()='groups' and namespace-uri()='http://checker.bintellix.de/checkset/' and @type="GROUP"]/*}</cs:groups>
                
                <!-- global given values -->
                {$checkset_global[not(name()=("variables","groups") and namespace-uri()='http://checker.bintellix.de/checkset/')] }
                <cs:groups type="GLOBAL">{$checkset_global[local-name()='groups' and namespace-uri()='http://checker.bintellix.de/checkset/' and @type="GLOBAL"]/*}</cs:groups>
                
            </cs:checkset>
        </cs:step>
    else
    ()
