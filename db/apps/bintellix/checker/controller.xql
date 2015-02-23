xquery version "3.0";
declare namespace soap="http://schemas.xmlsoap.org/soap/envelope/";
declare namespace cs="http://checker.bintellix.de/checkset/";
declare namespace ct="http://compare.bintellix.de";
declare namespace bc="http://checker.bintellix.de/";

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

declare variable $exist:root external;
declare variable $exist:prefix external;
declare variable $exist:controller external;
declare variable $exist:path external;
declare variable $exist:resource external;

(:
    <dummy>
        <exist-root>{$exist:root}</exist-root>
        <exist-prefix>{$exist:prefix}</exist-prefix>
        <exist-controller>{$exist:controller}</exist-controller>
        <exist-path>{$exist:path}</exist-path>
        <exist-resource>{$exist:resource}</exist-resource>
    </dummy>
:)
(:
let $disable-betterform := request:set-attribute("betterform.filter.ignoreResponseBody", "true")
:)

let $config := doc(concat($exist:root,$exist:controller,'/../checker_config.xml'))
let $ct-home-web := $config/bc:config/bc:home/bc:web/text()
let $ct-home-db := $config/bc:config/bc:home/bc:db/text()
let $ct-home-data := $config/bc:config/bc:home/bc:data/text()
(:
let $ct-home-web := concat('/exist',$exist:prefix,$exist:controller)
let $ct-home-db := concat('/db',$exist:prefix,$exist:controller)
let $ct-home-data := concat('/db',$exist:prefix,$exist:controller,'/data')
:)
(:
let $disable-betterform := request:set-attribute("betterform.filter.ignoreResponseBody", "true")
:)
return

if (equals($exist:path,'') or equals($exist:path,'/') or matches($exist:path, '^/index\.html')) then
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{concat('/exist/',$exist:prefix,$exist:controller,'/overview.html')}"/>
	</dispatch>
else if (matches($exist:path, '^/config\.xml$')) then
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/../checker_config.xml"/>
	</dispatch>
else if (matches($exist:path, '^/pre-install.xql$')) then
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller,'/pre-install.xql')}">
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
        </forward>
	</dispatch>
else if (matches($exist:path, '^/post-install.xql$')) then
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{concat($exist:controller,'/post-install.xql')}">
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
        </forward>
	</dispatch>
else if (matches($exist:path, '^/about\.html$')) then
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/about.html"/>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/"/>
                <set-attribute name="xslt.filename" value="about.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>                
            </forward>
        </view>      
	</dispatch>
else if (matches($exist:path, '^/admin/$')) then
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="index.html"/>
	</dispatch>
else if (matches($exist:path, '^/admin/index\.html$')) then
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/admin/index.html"/>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/admin/"/>
                <set-attribute name="xslt.filename" value="index.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
	</dispatch>
else if (matches($exist:path, '^/admin/(refresh|upgrade|validate|config_edit|config_edit_response)\.html$')) then
	let $params := subsequence(text:groups($exist:path, '/admin/(refresh|upgrade|validate|config_edit|config_edit_response)\.html$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/admin/{$params[1]}.xql">
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.ct-home-data" value="{$ct-home-data}"/>
                <set-attribute name="xslt.path" value="/admin/"/>
                <set-attribute name="xslt.filename" value="{$params[1]}.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
		<cache-control cache="no"/>
	</dispatch>

(: SYSTEM :)
else if (matches($exist:path, '^/(overview)\.html$')) then
	let $params := subsequence(text:groups($exist:path, '^/(overview)\.html$'), 2)
	return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/system_{$params[1]}.xql">
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/"/>
                <set-attribute name="xslt.filename" value="{$params[1]}.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
    </dispatch>
else if (matches($exist:path, '^/tools/(index|normalize-xml|normalize-xml_response)\.(html|xml)$')) then
	let $params := subsequence(text:groups($exist:path, '^/tools/(index|normalize-xml|normalize-xml_response)\.(html|xml)$'), 2)
	return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/tools/tools_{$params[1]}.xql">
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
        </forward>
        <view>
            {if ($params[2]!='xml') then
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/tools/"/>
                <set-attribute name="xslt.filename" value="{$params[1]}.{$params[2]}"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
            else
                ()
            }
        </view>
    </dispatch>
    
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/$')) then
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<redirect url="index.html"/>
	</dispatch>
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/(index\.html)?$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/(index\.html)?$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<redirect url="overview.html"/>
	</dispatch>

(: RULESET handling :)	
else if (matches($exist:path, '^/ruleset/(edit|edit_response|copy|copy_response)\.html')) then
	let $params := subsequence(text:groups($exist:path, '^/ruleset/(edit|edit_response|copy|copy_response)\.html'), 2)
	return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/ruleset/ruleset_{$params[1]}.xql">
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="group" value=""/>
            <set-attribute name="type" value="GLOBAL"/>
        </forward>        
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/ruleset/"/>
                <set-attribute name="xslt.filename" value="{$params[1]}.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
    </dispatch>
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/ruleset/(edit|edit_response|copy|copy_response)\.html')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/ruleset/(edit|edit_response|copy|copy_response)\.html'), 2)
	return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/ruleset/ruleset_{$params[2]}.xql">
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="group" value="{$params[1]}"/>
            <set-attribute name="type" value="GROUP"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/$group/ruleset/"/>
                <set-attribute name="xslt.group" value="{$params[1]}"/>
                <set-attribute name="xslt.filename" value="{$params[2]}.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
    </dispatch>

(: GROUP handling :)
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/(copy|copy_response|create|create_response|delete|delete_response|edit|edit_response|move|move_response|overview)\.html$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/(copy|copy_response|create|create_response|delete|delete_response|edit|edit_response|move|move_response|overview)\.html$'), 2)
	return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/group/group_{replace($params[2],'move','copy')}.xql">
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="group" value="{$params[1]}"/>
            <set-attribute name="move" value="{if (starts-with($params[2],'move')) then 'yes' else 'no'}"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/$group/"/>
                <set-attribute name="xslt.group" value="{$params[1]}"/>
                <set-attribute name="xslt.filename" value="{$params[2]}.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
    </dispatch>
    
(: STEP handling :)
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/(create|create_response|import|import_response|overview)\.html$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/(create|create_response|import|import_response|overview)\.html$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/step/step_{$params[2]}.xql">
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="filename-pattern" value="{$config/bc:config/bc:set/bc:filename-pattern/text()}"/>
            <set-attribute name="group" value="{$params[1]}"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/$group/step/"/>
                <set-attribute name="xslt.group" value="{$params[1]}"/>
                <set-attribute name="xslt.filename" value="{$params[2]}.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
	</dispatch>
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/([a-zA-Z][a-zA-Z0-9_-]+)/(create|create_response|copy|copy_response|delete|delete_response|move|move_response|order|services)\.html$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/([a-zA-Z][a-zA-Z0-9_-]+)/(create|create_response|copy|copy_response|delete|delete_response|move|move_response|order|services)\.html$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/step/step_{replace($params[3],'move','copy')}.xql">
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="group" value="{$params[1]}"/>
            <set-attribute name="step" value="{$params[2]}"/>
            <set-attribute name="move" value="{if (starts-with($params[3],'move')) then 'yes' else 'no'}"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/$group/step/$step/"/>
                <set-attribute name="xslt.group" value="{$params[1]}"/>
                <set-attribute name="xslt.step" value="{$params[2]}"/>
                <set-attribute name="xslt.filename" value="{$params[3]}.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
	</dispatch>
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/([a-zA-Z][a-zA-Z0-9_-]+)/result(.*)\.(xml|html)$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/([a-zA-Z][a-zA-Z0-9_-]+)/result(.*)\.(xml|html)$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-data,'/db/apps')}/{$params[1]}/result/step_{$params[2]}.xml"/>
        { 
        if ($params[4]='html') then
            <view>
                <forward servlet="XSLTServlet">
                    <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/checkset/checkset_result_report.xsl')}"/>
                    <!--
                    <set-attribute name="xslt.output.media-type" value="text/html"/>
                    <set-attribute name="xslt.output.method" value="xml"/>
                    -->                
                    <set-attribute name="xslt.output.indent" value="no"/>
                </forward>
            </view>
        else 
            ()
        }
	</dispatch>
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/([a-zA-Z][a-zA-Z0-9_-]+)/(run)\.(html|xml)$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/([a-zA-Z][a-zA-Z0-9_-]+)/(run)\.(html|xml)$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/step/step_{$params[3]}.xql">
            <set-attribute name="uri" value="{substring-before(request:get-url(),$ct-home-web)}"/>
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="cmd-path" value="{$config/bc:config/bc:cmd/bc:path/text()}"/>
            <set-attribute name="cmd-file" value="{$config/bc:config/bc:cmd/bc:filename/text()}"/>
            <set-attribute name="group" value="{$params[1]}"/>
            <set-attribute name="step" value="{$params[2]}"/>
            <set-attribute name="format" value="{if ($params[4]='xml') then 'xml' else 'report'}"/>
        </forward>
        { if ($params[4]!='xml') then
            <view>
                { if ($params[3]='run') then
                <forward servlet="XSLTServlet">
                    <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/checkset/checkset_result_report.xsl')}"/>
                    <set-attribute name="xslt.group" value="{$params[1]}"/>
                    <set-attribute name="xslt.step" value="{$params[2]}"/>
                    <set-attribute name="xslt.format" value="report"/>
                    <!--
                        <p:with-param name="MasterValidateDisabled" select="$MasterValidateDisabled"/>
                        <p:with-param name="MasterCheckDisabled" select="$MasterCheckDisabled"/>
                        <p:with-param name="MasterCompareDisabled" select="$MasterCompareDisabled"/>
                    -->
                    <set-attribute name="xslt.output.indent" value="no"/>
                </forward>
                else 
                    ()
                }
                <forward servlet="XSLTServlet">
                    <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                    <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                    <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                    <set-attribute name="xslt.path" value="/$group/step/$step/"/>
                    <set-attribute name="xslt.group" value="{$params[1]}"/>
                    <set-attribute name="xslt.step" value="{$params[2]}"/>
                    <set-attribute name="xslt.filename" value="{$params[3]}.{$params[4]}"/>
                    <!--
                    <set-attribute name="xslt.output.media-type" value="text/html"/>
                    <set-attribute name="xslt.output.method" value="xhtml"/>
                    -->  
                    <set-attribute name="xslt.output.indent" value="no"/>
                </forward>
            </view>
        else
            ()
        }
	</dispatch>	
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/([a-zA-Z][a-zA-Z0-9_-]+)/(.*)\.xml$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/([a-zA-Z][a-zA-Z0-9_-]+)/(.*)\.xml$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/step/step_download.xql">
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="ct-home-db" value="{$ct-home-data}"/>
            <set-attribute name="group" value="{$params[1]}"/>
            <set-attribute name="step" value="{$params[2]}"/>
            <set-attribute name="filename" value="{$params[3]}.xml"/>
        </forward>
	</dispatch>
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/([a-zA-Z][a-zA-Z0-9_-]+)/(index\.html)?$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/([a-zA-Z][a-zA-Z0-9_-]+)/(index\.html)?$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<redirect url="edit.html"/>
	</dispatch>
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/([a-zA-Z][a-zA-Z0-9_-]+)/(edit|edit_save)\.html$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/step/([a-zA-Z][a-zA-Z0-9_-]+)/(edit|edit_save)\.html?$'), 2)
	return
	(: if step type = checkset :)
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<redirect url="../../checkset/{$params[2]}/{$params[3]}.html"/>
	</dispatch>
	
(: CHECKSET handling :)
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/checkset/$')) then
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<redirect url="../step/overview.html"/>
	</dispatch>

else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/checkset/([a-zA-Z][a-zA-Z0-9_-]+)/(create|create_response|edit|edit_save|copy|copy_response|delete|delete_response)\.html$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/checkset/([a-zA-Z][a-zA-Z0-9_-]+)/(create|create_response|edit|edit_save|copy|copy_response|delete|delete_response)\.html$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/checkset/checkset_{$params[3]}.xql">
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="group" value="{$params[1]}"/>
            <set-attribute name="step" value="{$params[2]}"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/$group/checkset/$step/"/>
                <set-attribute name="xslt.group" value="{$params[1]}"/>
                <set-attribute name="xslt.step" value="{$params[2]}"/>
                <set-attribute name="xslt.filename" value="{$params[3]}.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
	</dispatch>
(: FILESET handling :)
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/fileset/$')) then
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		<redirect url="../step/overview.html"/>
	</dispatch>
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/fileset/(create|create_response|overview)\.html$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/fileset/(create|create_response|overview)\.html$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/fileset/fileset_{$params[2]}.xql">
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="group" value="{$params[1]}"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/$group/fileset/"/>
                <set-attribute name="xslt.group" value="{$params[1]}"/>
                <set-attribute name="xslt.filename" value="{$params[2]}.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
	</dispatch>
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/fileset/([a-zA-Z][a-zA-Z0-9_-]+)/(copy|copy_response|delete|delete_response|move|move_response|view)\.html$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/fileset/([a-zA-Z][a-zA-Z0-9_-]+)/(copy|copy_response|delete|delete_response|move|move_response|view)\.html$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/fileset/fileset_{replace($params[3],'move','copy')}.xql">
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="group" value="{$params[1]}"/>
            <set-attribute name="fileset" value="{$params[2]}"/>
            <set-attribute name="move" value="{if (starts-with($params[3],'move')) then 'yes' else 'no'}"/>            
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/$group/fileset/$fileset/"/>
                <set-attribute name="xslt.group" value="{$params[1]}"/>
                <set-attribute name="xslt.fileset" value="{$params[2]}"/>
                <set-attribute name="xslt.filename" value="{$params[3]}.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
	</dispatch>	
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/fileset/([a-zA-Z][a-zA-Z0-9_-]+)/step_(.*)\.(xml|html)$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/fileset/([a-zA-Z][a-zA-Z0-9_-]+)/step_(.*)\.(xml|html)$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-data,'/db/apps')}/{$params[1]}/result_{$params[2]}/step_{$params[3]}.xml"/>
        {
        if ($params[4]='html') then 
            <view>
                <forward servlet="XSLTServlet">
                    <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/checkset/checkset_result_report.xsl')}"/>
                    <set-attribute name="xslt.output.indent" value="no"/>
                </forward>
            </view>
        else
            ()
        }
	</dispatch>
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/fileset/([a-zA-Z][a-zA-Z0-9_-]+)/(run)\.(html|xml)$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/fileset/([a-zA-Z][a-zA-Z0-9_-]+)/(run)\.(html|xml)$'), 2)
	return
	<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/fileset/fileset_{$params[3]}.xql">
            <set-attribute name="uri" value="{substring-before(request:get-url(),$ct-home-web)}"/>
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="cmd-path" value="{$config/bc:config/bc:cmd/bc:path/text()}"/>
            <set-attribute name="cmd-file" value="{$config/bc:config/bc:cmd/bc:filename/text()}"/>
            <set-attribute name="group" value="{$params[1]}"/>
            <set-attribute name="fileset" value="{$params[2]}"/>
            <set-attribute name="format" value="{if ($params[4]='xml') then 'xml' else 'report'}"/>
        </forward>
        { if ($params[4]!='xml') then
            <view>
                <forward servlet="XSLTServlet">
                    <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                    <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                    <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                    <set-attribute name="xslt.path" value="/$group/step/$step/"/>
                    <set-attribute name="xslt.group" value="{$params[1]}"/>
                    <set-attribute name="xslt.step" value="{$params[2]}"/>
                    <set-attribute name="xslt.filename" value="{$params[3]}.{$params[4]}"/>
                    <!--
                    <set-attribute name="xslt.output.media-type" value="text/html"/>
                    <set-attribute name="xslt.output.method" value="xhtml"/>
                    -->  
                    <set-attribute name="xslt.output.indent" value="no"/>
                </forward>
            </view>
        else
            ()
        }
	</dispatch>	

(: RUNSET Handling :)
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/runset/(overview)\.html')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/runset/(overview)\.html'), 2)
	return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/runset/runset_{$params[2]}.xql">
            <set-attribute name="uri" value="{substring-before(request:get-url(),$ct-home-web)}"/>
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="cmd-path" value="{$config/bc:config/bc:cmd/bc:path/text()}"/>
            <set-attribute name="cmd-file" value="{$config/bc:config/bc:cmd/bc:filename/text()}"/>
            <set-attribute name="group" value="{$params[1]}"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/$group/runset/"/>
                <set-attribute name="xslt.group" value="{$params[1]}"/>
                <set-attribute name="xslt.filename" value="{$params[2]}.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
    </dispatch>
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/runset/([a-zA-Z][a-zA-Z0-9_-]+)/runset_(.+)\.zip$')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/runset/([a-zA-Z][a-zA-Z0-9_-]+)/runset_(.+)\.zip$'), 2)
	return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/runset/runset_download.xql">
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="group" value="{$params[1]}"/>
            <set-attribute name="runset" value="{$params[2]}"/>
            <set-attribute name="filename-pattern" value="{$config/bc:config/bc:set/bc:filename-pattern/text()}"/>            
        </forward>
    </dispatch>
else if (matches($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/runset/([a-zA-Z][a-zA-Z0-9_-]+)/(run)\.html')) then
	let $params := subsequence(text:groups($exist:path, '^/([a-zA-Z][a-zA-Z0-9_-]+)/runset/([a-zA-Z][a-zA-Z0-9_-]+)/(run)\.html'), 2)
	return
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/runset/runset_{$params[3]}.xql">
            <set-attribute name="uri" value="{substring-before(request:get-url(),$ct-home-web)}"/>
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
            <set-attribute name="ct-home-db" value="{$ct-home-db}"/>
            <set-attribute name="ct-home-data" value="{$ct-home-data}"/>
            <set-attribute name="cmd-path" value="{$config/bc:config/bc:cmd/bc:path/text()}"/>
            <set-attribute name="cmd-file" value="{$config/bc:config/bc:cmd/bc:filename/text()}"/>
            <set-attribute name="group" value="{$params[1]}"/>
            <set-attribute name="runset" value="{$params[2]}"/>
            <set-attribute name="format" value="{if ($params[3]='xml') then 'xml' else 'report'}"/>
        </forward>
        <view>
            <forward servlet="XSLTServlet">
                <set-attribute name="xslt.stylesheet" value="{concat($exist:root, $exist:controller, '/frame.xsl')}"/>
                <set-attribute name="xslt.ct-home-web" value="{$ct-home-web}"/>
                <set-attribute name="xslt.ct-home-db" value="{$ct-home-db}"/>
                <set-attribute name="xslt.path" value="/$group/runset/$runset/"/>
                <set-attribute name="xslt.group" value="{$params[1]}"/>
                <set-attribute name="xslt.runset" value="{$params[2]}"/>
                <set-attribute name="xslt.filename" value="{$params[3]}.html"/>
                <set-attribute name="xslt.output.indent" value="no"/>
            </forward>
        </view>
    </dispatch>
else if (matches($exist:path, '^/base/.*')) then
	<ignore xmlns="http://exist.sourceforge.net/NS/exist">
	    <cache-control cache="yes"/>
	</ignore>
else
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{substring-after($ct-home-db,'/db/apps')}/not_found.xql">
            <set-attribute name="ct-home-web" value="{$ct-home-web}"/>
        </forward>
    </dispatch>
