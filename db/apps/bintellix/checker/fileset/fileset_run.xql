xquery version "3.0";
declare namespace cs="http://checker.bintellix.de/checkset/";

import module namespace run='http://checker.bintellix.de/' at '../step/step_run.xqm';

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

declare namespace c="http://www.w3.org/ns/xproc-step";

import module namespace dbutil="http://exist-db.org/xquery/dbutil";

let $uri := request:get-attribute('uri')
let $ct-home-web := request:get-attribute('ct-home-web')
let $ct-home-db := request:get-attribute('ct-home-db')
let $ct-home-data := request:get-attribute('ct-home-data')
let $cmd-path := request:get-attribute('cmd-path')
let $cmd-file := request:get-attribute('cmd-file')
let $group := request:get-attribute('group')
let $fileset := request:get-attribute('fileset')
let $format := request:get-attribute('format')
let $debug := number(request:get-parameter('debug', '0'))
let $max-count := number(request:get-parameter('max','1000'))

let $fileset-properties := doc(concat($ct-home-data,'/',$group,'/result_',$fileset,'/properties.xml'))
(:
                <fileset xmlns="">
					<master-file-list>http://smuc4313.europe.bmw.corp:8090/exist/apps/digital/configurator/be/bmw/0/dataset/view.xml?dataset=xyz</master-file-list>
					<current-file-list>http://smuc4313.europe.bmw.corp:8090/exist/apps/digital/configurator/be/bmw/0/dataset/view.xml?dataset=abc</current-file-list>
					<master-directory-xpath>/c:directory/@xml:base</master-directory-xpath>
					<master-file-xpath>/c:directory/c:file/@name</master-file-xpath>
					<current-directory-xpath>/c:directory/@xml:base</current-directory-xpath>
					<current-file-xpath>/c:directory/c:file/@name</current-file-xpath>
                </fileset>
:)
let $step-id := $fileset-properties/fileset/step-name
let $fileset-id := $fileset-properties/fileset/fileset-name

let $master-file-variable := $fileset-properties/fileset/master-file-variable
let $master-file-list := doc($fileset-properties/fileset/master-file-list)
let $master-directory-base := util:eval(concat('$master-file-list',$fileset-properties/fileset/master-directory-xpath))
let $master-files := util:eval(concat('$master-file-list',$fileset-properties/fileset/master-file-xpath))
let $current-file-variable := $fileset-properties/fileset/current-file-variable
let $current-file-list := doc($fileset-properties/fileset/current-file-list)
let $current-directory-base := util:eval(concat('$current-file-list',$fileset-properties/fileset/current-directory-xpath))
let $current-files := util:eval(concat('$master-file-list',$fileset-properties/fileset/current-file-xpath))

let $step := collection(concat($ct-home-data,'/',$group))/cs:step[cs:identity/cs:step-id=$step-id]
let $result-set := concat('/',$group,'/result_',$fileset-id)
(: 
    let $remove := if (string-length($result-set) gt 0 and collection(concat($ct-home-data,$result-set))/*) then xmldb:remove(concat($ct-home-data,$result-set)) else () 
    let $create := xmldb:create-collection(concat($ct-home-data,'/',$group,'/'),concat('result_',$step-id)) 
:)
return
<html xmlns="http://www.w3.org/1999/xhtml">
    <body>
    <h3>Fileset <a href="view.html">'{$fileset-id}'</a> run step '<a href="../../step/{$step-id}/index.html">{$step-id}</a>' with {min((count($master-files),1))} files:</h3>
    {
    let $collection := concat($ct-home-data,'/',$group,'/result_',$step-id)
    (: cleanup: remove all old result files :)
    let $cleanup := dbutil:scan-resources($collection, 
                                          function($resource) {
                                            if (starts-with($resource, 'step_')) then
                                                xmldb:remove($collection, $resource)
                                            else 
                                                ()
                                          })
    for $file at $pos in $master-files
        return
        if ($pos lt $max-count) then
            let $variables :=
                <cs:variables>
                    <cs:variable name="{if (starts-with($master-file-variable,'$')) then substring-after($master-file-variable,'$') else $master-file-variable}" selected="{concat($master-directory-base,'/',$file)}"/>
                    <cs:variable name="{if (starts-with($current-file-variable,'$')) then substring-after($current-file-variable,'$') else $current-file-variable}" selected="{concat($current-directory-base,'/',$file)}"/>
                </cs:variables>
            return
            <div>
                <span>{$pos}. Test&#160;
                 with master '<a href="{$master-directory-base}/{$file}">{replace($master-directory-base,'^.*/','')}/{data($file)}</a>' as {{{$master-file-variable}}}
                 and current '<a href="{$current-directory-base}/{$file}">{replace($current-directory-base,'^.*/','')}/{data($file)} </a>' as {{{$current-file-variable}}}
                 with result &#160;
                </span>
                {
                    let $result := run:run($group, $step-id, $result-set, concat('step_',$step-id,'_',$file), $cmd-path, $cmd-file, $uri, $ct-home-web, $ct-home-db, $ct-home-data, $variables, $debug)
                    return 
                        if ($result//cs:run/cs:result[@status=('success','fine')]) then
                            <span style="color:green;">fine</span>
                        else if ($result//cs:run/cs:result[@status='failed']) then
                            <span style="color:yellow;">failed</span>
                        else if ($result/*) then
                            <span style="color:red;">error</span>
                        else
                            <span style="color:red;">unknown</span>
                }                
            </div>
        else
            ()
    }
    <br/>
    <div>Go back to <a href="view.html">Fileset '{$fileset-id}'</a></div>
    <div>Go back to <a href="../overview.html">Fileset Overview</a></div>
    </body>
</html>
