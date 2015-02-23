<!-- 
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
(c) 2010-2014 by InterSecurity GmbH & Co. KG, Germany
========================================================================
@Author: Eduard Huber
@Version: 1.0
======================================================================== 
-->
<p:declare-step type="bc:doc" name="document" 
    xmlns:bc="http://checker.bintellix.de/" 
    xmlns:er="http://compare.intersecurity.net/error-report/" 
    xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" 
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:p="http://www.w3.org/ns/xproc" 
    xmlns:cs="http://checker.bintellix.de/checkset/" 
    version="1.0">
    <p:input port="source" primary="true"/>
    <p:output port="result" sequence="true" primary="true"/>
    
    <p:option name="type" required="true"/>
    <p:option name="debug" required="true"/>
    <p:option name="unwrapSOAP" select="false()"/>
    
    <p:documentation>Load Document</p:documentation>    
    <p:choose name="LoadDocument">
        <p:when test="/cs:step/cs:checkset/cs:*[local-name()=$type]/cs:connections/cs:connection[@enabled and @type='FILE']">
            <p:documentation>SOAP Request</p:documentation>
            <p:choose>
                <p:when test="starts-with(/cs:step/cs:checkset/cs:*[local-name()=$type]/cs:connections/cs:connection/cs:file/cs:url/text(), 'http')">
                    <p:template>
                        <p:with-param name="url" select="/cs:step/cs:checkset/cs:*[local-name()=string($type)]/cs:connections/cs:connection/cs:file/cs:url/text()"/> <!-- replace '\' with '/'  and ' ' with '%20' -->
                        <p:input port="template">
                            <p:inline>
                                <c:request method="GET" href="{replace(replace($url,'&amp;amp;','&amp;'),'(.+://)(.*:.*@)(.*)','$1$3')}" auth-method="BASIC" username="{replace($url,'.+//(.+):(.+)@.*','$1')}" password="{replace($url,'.+//(.+):(.+)@.*','$2')}"/>
                            </p:inline>
                        </p:input>
                        <p:input port="source">
                            <p:pipe port="source" step="document"/>
                        </p:input>
                        <p:input port="parameters">
                            <p:empty/>
                        </p:input>
                    </p:template>
                    <p:http-request omit-xml-declaration="false" encoding="UTF-8"/>                    
                </p:when>
                <p:otherwise>
                    <p:load>
                        <p:with-option name="href" select="/cs:step/cs:checkset/cs:*[local-name()=$type]/cs:connections/cs:connection/cs:file/cs:url/text()"/>
                    </p:load>
                </p:otherwise>
            </p:choose>
        </p:when>            
        <p:when test="/cs:step/cs:checkset/cs:*[local-name()=$type]/cs:connections/cs:connection[@enabled and @type='SOAP']">
            <p:documentation>SOAP Request</p:documentation>
            <p:xslt>
                <p:with-param name="Type" select="$type"/>
                <p:input port="stylesheet">
                    <p:inline>
                        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs" version="2.0">
                            <xsl:param name="Type" required="yes"/>
                            <xsl:template match="/">
                                <p:document>
                                    &lt;c:request method="POST" href="<xsl:value-of select="/cs:step/cs:checkset/cs:*[local-name()=$Type]/cs:connections/cs:connection/cs:soap/cs:url/text()"/>" xmlns:c="http://www.w3.org/ns/xproc-step"&gt;
                                    &lt;c:header name="SOAPAction" value="<xsl:value-of select="/cs:step/cs:checkset/cs:*[local-name()=$Type]/cs:connections/cs:connection/cs:soap/cs:action/text()"/>"/&gt;
                                    &lt;c:body content-type="text/xml"&gt;
                                    <xsl:choose>
                                        <xsl:when test="/cs:step/cs:checkset/cs:*[local-name()=$Type]/cs:connections/cs:connection/cs:soap/cs:request/@type='XML'">
                                            <xsl:value-of select="/cs:step/cs:checkset/cs:*[local-name()=$Type]/cs:connections/cs:connection/cs:soap/cs:request/cs:data/text()"/>
                                        </xsl:when>
                                        <xsl:when test="/cs:step/cs:checkset/cs:*[local-name()=$Type]/cs:connections/cs:connection/cs:soap/cs:request/@type='HTTP'">
                                            &lt;request/&gt;
                                        </xsl:when>
                                    </xsl:choose>
                                    &lt;/c:body&gt;
                                    &lt;/c:request&gt;
                                </p:document>
                            </xsl:template>
                        </xsl:stylesheet>
                    </p:inline>
                </p:input>
            </p:xslt>
            <p:string-replace match="//text()" replace="replace(., '&lt;\?xml.*\?&gt;', '')"/>
            <p:unescape-markup name="soap-request-xml"/>
            <p:choose>
                <p:xpath-context>
                    <p:pipe port="source" step="document"/>
                </p:xpath-context>
                <p:when test="/cs:step/cs:checkset/cs:*[local-name()=$type]/cs:connections/cs:connection/cs:soap/cs:request/@type='HTTP'">
                    <p:load name="soap-body">
                        <p:with-option name="href" select="/cs:step/cs:checkset/cs:*[local-name()=$type]/cs:connections/cs:connection/cs:soap/cs:request/cs:url/text()">
                            <p:pipe port="source" step="document"/>
                        </p:with-option>                
                    </p:load>
                    <p:replace match="//request">
                        <p:input port="source">
                            <p:pipe port="result" step="soap-request-xml"/>
                        </p:input>
                        <p:input port="replacement">
                            <p:pipe port="result" step="soap-body"/>
                        </p:input>
                    </p:replace>
                    <p:unwrap match="p:document" name="soap-request"/>
                    <p:choose>
                        <p:when test="$debug != 0">
                            <p:store>
                                <p:with-option name="href" select="concat('../work/checkset_document_soap-request_', $type, '.xml')"/>
                            </p:store>
                        </p:when>
                        <p:otherwise>
                            <p:sink name="discarding-debugging-output"/>
                        </p:otherwise>
                    </p:choose>                    
                    <p:http-request omit-xml-declaration="false" encoding="UTF-8">
                        <p:input port="source">
                            <p:pipe port="result" step="soap-request"/>
                        </p:input>
                    </p:http-request>
                </p:when>
                <p:otherwise>
                    <p:unwrap match="p:document" name="soap-request"/>
                    <p:choose>
                        <p:when test="$debug != 0">
                            <p:store>
                                <p:with-option name="href" select="concat('../work/checkset_document_soap-request_', $type, '.xml')"/>
                            </p:store>
                        </p:when>
                        <p:otherwise>
                            <p:sink name="discarding-debugging-output"/>
                        </p:otherwise>
                    </p:choose>                    
                    <p:http-request omit-xml-declaration="false" encoding="UTF-8">
                        <p:input port="source">
                            <p:pipe port="result" step="soap-request"/>
                        </p:input>
                    </p:http-request>            
                </p:otherwise>
            </p:choose>           
        </p:when>
        <p:when test="/cs:step/cs:checkset/cs:*[local-name()=$type]/cs:connections/cs:connection[@enabled and @type='REST' and cs:rest/cs:type='GET']">
            <p:documentation>REST Request</p:documentation>
            <p:xslt>
                <p:with-param name="Type" select="$type"/>
                <p:input port="stylesheet">
                    <p:inline>
                        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs" version="2.0">
                            <xsl:param name="Type" required="yes"/>
                            <xsl:template match="/">
                                <p:document>
                                    &lt;c:request method="GET" href="<xsl:value-of select="replace(/cs:step/cs:checkset/cs:*[local-name()=$Type]/cs:connections/cs:connection/cs:rest/cs:url/text(),'&amp;','&amp;amp;')"/>" xmlns:c="http://www.w3.org/ns/xproc-step"&gt;
                                    &lt;/c:request&gt;
                                </p:document>
                            </xsl:template>
                        </xsl:stylesheet>
                    </p:inline>
                </p:input>
            </p:xslt>
            <p:string-replace match="//text()" replace="replace(., '&lt;\?xml.*\?&gt;', '')"/>
            <p:unescape-markup/>
            <p:unwrap match="p:document"/>
            <p:http-request omit-xml-declaration="false" encoding="UTF-8"/>            
        </p:when>      
        <p:when test="/cs:step/cs:checkset/cs:*[local-name()=$type]/cs:connections/cs:connection[@enabled and @type='REST' and cs:rest/cs:type='POST']">
            <p:documentation>REST Request</p:documentation>
            <p:xslt>
                <p:with-param name="Type" select="$type"/>
                <p:input port="stylesheet">
                    <p:inline>
                        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs" version="2.0">
                            <xsl:param name="Type" required="yes"/>
                            <xsl:template match="/">
                                <p:document>
                                    &lt;c:request method="POST" href="<xsl:value-of select="/cs:step/cs:checkset/cs:*[local-name()=$Type]/cs:connections/cs:connection/cs:rest/cs:url/text()"/>" xmlns:c="http://www.w3.org/ns/xproc-step"&gt;
                                    &lt;c:body content-type="text/xml"&gt;
                                    <xsl:choose>
                                        <xsl:when test="/cs:step/cs:checkset/cs:*[local-name()=$Type]/cs:connections/cs:connection/cs:rest/cs:request/@type='XML'">
                                            <xsl:value-of select="/cs:step/cs:checkset/cs:*[local-name()=$Type]/cs:connections/cs:connection/cs:rest/cs:request/cs:data/text()"/>
                                        </xsl:when>
                                        <xsl:when test="/cs:step/cs:checkset/cs:*[local-name()=$Type]/cs:connections/cs:connection/cs:rest/cs:request/@type='HTTP'">
                                             &lt;request/&gt;
                                        </xsl:when>
                                        <xsl:otherwise></xsl:otherwise>
                                    </xsl:choose>                                   
                                    &lt;/c:body&gt;
                                    &lt;/c:request&gt;
                                </p:document>
                            </xsl:template>
                        </xsl:stylesheet>
                    </p:inline>
                </p:input>
            </p:xslt>
            <p:string-replace match="//text()" replace="replace(., '&lt;\?xml.*\?&gt;', '')"/>
            <p:unescape-markup name="rest-request-xml"/>
            <p:choose>
                <p:xpath-context>
                    <p:pipe port="source" step="document"/>
                </p:xpath-context>
                <p:when test="/cs:step/cs:checkset/cs:*[local-name()=$type]/cs:connections/cs:connection/cs:rest/cs:request/@type='HTTP'">
                    <p:load name="rest-body">
                        <p:with-option name="href" select="/cs:step/cs:checkset/cs:*[local-name()=$Type]/cs:connections/cs:connection/cs:rest/cs:request/cs:url/text()">
                            <p:pipe port="source" step="document"/>
                        </p:with-option>                
                    </p:load>
                    <p:replace match="//request">
                        <p:input port="source">
                            <p:pipe port="result" step="rest-request-xml"/>
                        </p:input>
                        <p:input port="replacement">
                            <p:pipe port="result" step="rest-body"/>
                        </p:input>
                    </p:replace>
                    <p:unwrap match="p:document" name="rest-request"/>
                    <p:choose>
                        <p:when test="$debug != 0">
                            <p:store>
                                <p:with-option name="href" select="concat('../work/checkset_document_rest-request_', $type, '.xml')"/>
                            </p:store>
                        </p:when>
                        <p:otherwise>
                            <p:sink name="discarding-debugging-output"/>
                        </p:otherwise>
                    </p:choose>                    
                    <p:http-request omit-xml-declaration="false" encoding="UTF-8">
                        <p:input port="source">
                            <p:pipe port="result" step="rest-request"/>
                        </p:input>
                    </p:http-request>
                </p:when>
                <p:otherwise>
                    <p:unwrap match="p:document" name="rest-request"/>
                    <p:choose>
                        <p:when test="$debug != 0">
                            <p:store>
                                <p:with-option name="href" select="concat('../work/checkset_document_rest-request_', $type, '.xml')"/>
                            </p:store>
                        </p:when>
                        <p:otherwise>
                            <p:sink name="discarding-debugging-output"/>
                        </p:otherwise>
                    </p:choose>                    
                    <p:http-request omit-xml-declaration="false" encoding="UTF-8">
                        <p:input port="source">
                            <p:pipe port="result" step="rest-request"/>
                        </p:input>
                    </p:http-request>            
                </p:otherwise>
            </p:choose>
        </p:when>      
        <p:when test="/cs:step/cs:checkset/cs:*[local-name()=$type]/cs:connections/cs:connection[@enabled and @type='XML']">
            <p:documentation>XML Template</p:documentation>
            <p:xslt>
                <p:with-param name="Type" select="$type"/>
                <p:input port="stylesheet">
                    <p:inline>
                        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs" version="2.0">
                            <xsl:param name="Type" required="yes"/>
                            <xsl:template match="/">
                                <p:document>
                                    <xsl:value-of select="/cs:step/cs:checkset/cs:*[local-name()=$Type]/cs:document/cs:data/text()"/>
                                </p:document>
                            </xsl:template>
                        </xsl:stylesheet>
                    </p:inline>
                </p:input>
            </p:xslt>
            <p:string-replace match="//text()" replace="replace(., '&lt;\?xml.*\?&gt;', '')"/>
            <p:unescape-markup/>
            <p:unwrap match="p:document"/>
        </p:when>
        <p:otherwise>
            <p:template>
                <p:with-param name="type" select="$type"/>
                <p:with-param name="enabled" select="/cs:step/cs:checkset/cs:*[local-name()=$type]/cs:connections/cs:connection/@enabled"/>
                <p:with-param name="kind" select="/cs:step/cs:checkset/cs:*[local-name()=$type]/cs:connections/cs:connection/@type"/>
                <p:with-param name="file" select="//*"/>
                <p:input port="template">
                    <p:inline>
                        <error>Input has to be enabled (here:{$enabled}) and the type has to be FILE, XML, SOAP or REST (here:{$kind}) to be given for '{$type}'. File: {$file}</error>        
                    </p:inline>                
                </p:input>
            </p:template>
        </p:otherwise>
    </p:choose>
    
    <p:choose>
        <p:when test="$unwrapSOAP">
            <p:delete match="soap:Envelope/soap:Header"/>
            <p:unwrap match="soap:Envelope/soap:Body"/>
            <p:unwrap match="soap:Envelope"/> 
        </p:when>
        <p:otherwise>
            <p:identity/> 
        </p:otherwise>
    </p:choose>
    <p:identity name="Current"/> 
    
    <p:choose>
        <p:when test="$debug != 0">
            <p:store>
                <p:with-option name="href" select="concat('../work/checkset_document_', $type, '.xml')"/>
            </p:store>
        </p:when>
        <p:otherwise>
            <p:sink name="discarding-debugging-output"/>
        </p:otherwise>
    </p:choose>
    
    <p:identity>
        <p:input port="source">
            <p:pipe port="result" step="Current"/>
        </p:input>
    </p:identity>
    
</p:declare-step>