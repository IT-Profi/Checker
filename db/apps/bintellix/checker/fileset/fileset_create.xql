xquery version "3.0";
declare namespace cs="http://checker.bintellix.de/checkset/";

let $ct-home-web := request:get-attribute('ct-home-web')
let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-attribute('group')

let $fileset-name := request:get-parameter('fileset-name','')
let $step-name := request:get-parameter('step-name','')
let $master-file-variable := request:get-parameter('master-file-variable','$master-file')
let $master-file-list := request:get-parameter('master-file-list','')
let $master-file-xpath := request:get-parameter('master-file-xpath','/c:directory/c:file/@name')
let $master-directory-xpath := request:get-parameter('master-directory-xpath','/c:directory/@xml:base')
let $current-file-variable := request:get-parameter('current-file-variable','$current-file')
let $current-file-list := request:get-parameter('current-file-list','')
let $current-file-xpath := request:get-parameter('current-file-xpath','/c:directory/c:file/@name')
let $current-directory-xpath := request:get-parameter('master-directory-xpath','/c:directory/@xml:base')
let $notes := request:get-parameter('notes','')

return 
<html xmlns="" xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events">
    <head>
        <xf:model schema="{$ct-home-web}/base/checker.xsd">
            <xf:instance xmlns="" id="fileset">
                <fileset>
                    <fileset-name>{$fileset-name}</fileset-name>
                    <step-name>{$step-name}</step-name>
                    <master-file-variable>{$master-file-variable}</master-file-variable>
					<master-file-list>{$master-file-list}</master-file-list>
					<master-directory-xpath>{$master-directory-xpath}</master-directory-xpath>
					<master-file-xpath>{$master-file-xpath}</master-file-xpath>
					<current-file-list>{$master-file-list}</current-file-list>
					<current-file-variable>{$current-file-variable}</current-file-variable>
					<current-directory-xpath>{$current-directory-xpath}</current-directory-xpath>
					<current-file-xpath>{$current-file-xpath}</current-file-xpath>
					<notes>{$notes}</notes>
                </fileset>
            </xf:instance>
            <xf:submission id="create" method="post" action="create_response.html" replace="all" instance="request">
				<xf:action ev:event="xforms-submit-error">
					<xf:message>An error occurred.
						<xf:output value="event('error-type')">
							<xf:label>Error type</xf:label>
						</xf:output>
						<xf:output value="event('resource-uri')">
							<xf:label>Resource URI</xf:label>
						</xf:output>
						<xf:output value="event('response-status-code')">
							<xf:label>Status Code</xf:label>
						</xf:output>
						<xf:output value="event('response-reason-phrase')">
							<xf:label>Reason</xf:label>
						</xf:output>
						<xf:output value="event('response-headers')">
							<xf:label>Headers</xf:label>
						</xf:output>
						<xf:output value="event('response-body')">
							<xf:label>Body</xf:label>
						</xf:output>
					</xf:message>
				</xf:action>
			</xf:submission>

			<xf:bind nodeset="instance('fileset')/fileset-name" type="cs:LimitedParameterIdentifierType" required="true()"/>
			<xf:bind nodeset="instance('fileset')/step-name" type="cs:LimitedParameterIdentifierType" required="true()"/>
			<xf:bind nodeset="instance('fileset')/master-file-variable" type="xs:string" required="true()" restriction="matches(.,'\$[A-Zab-z][A-Za-z0-9]{1-99}')"/>
			<xf:bind nodeset="instance('fileset')/master-file-list" type="xs:anyURI" required="true()"/>
			<xf:bind nodeset="instance('fileset')/master-directory-xpath" type="xs:string" required="true()"/>
			<xf:bind nodeset="instance('fileset')/master-file-xpath" type="xs:string" required="true()"/>
			<xf:bind nodeset="instance('fileset')/current-file-variable" type="xs:string" required="true()" restriction="matches(.,'\$[A-Zab-z][A-Za-z0-9]{1-99}')"/>
			<xf:bind nodeset="instance('fileset')/current-file-list" type="xs:anyURI" required="true()"/>
			<xf:bind nodeset="instance('fileset')/current-directory-xpath" type="xs:string" required="true()"/>
			<xf:bind nodeset="instance('fileset')/current-file-xpath" type="xs:string" required="true()"/>
			<xf:bind nodeset="instance('fileset')/notes" type="xs:string" required="false()" restriction="string-length(.) lt 1000"/>
        </xf:model>
    </head>
    <body>
        <xf:group appearance="full">
            <xf:label>New Fileset</xf:label>
            <xf:input ref="instance('fileset')/fileset-name">
                <xf:label>Fileset name:</xf:label>
                <xf:hint>The name of the new fileset</xf:hint>
                <xf:alert>Format has to be: [A-Za-z][A-Za-z0-9_-]{{1,99}}</xf:alert>            
            </xf:input>
            <xf:textarea ref="instance('fileset')/notes">
                <xf:label>Notes:</xf:label>
                    <xf:hint>Add a note for what this fileset is used for</xf:hint>
                    <xf:alert>Only up to 1000 characters allowed</xf:alert>                
            </xf:textarea>
        </xf:group>
        <xf:group appearance="full">
            <xf:label>Step used for Fileset</xf:label>
            <xf:input ref="instance('fileset')/step-name">
                <xf:label>Step name:</xf:label>
                <xf:hint>The name (case sensitive) of the Step which will be used</xf:hint>
                <xf:alert>Format has to be: [A-Za-z][A-Za-z0-9_-]{{1,99}}</xf:alert>            
            </xf:input>
        </xf:group>
        <xf:group appearance="full">
            <xf:label>Master files</xf:label>
            <xf:input ref="instance('fileset')/master-file-variable">
                <xf:label>Variable name:</xf:label>
                <xf:hint>Name of the variable used for each file (e.g. $master-file)</xf:hint>
                <xf:alert>Format has to be: $[A-Za-z][A-Za-z0-9_-]{{1,99}}</xf:alert>
            </xf:input>
            <br/>
            <xf:input ref="instance('fileset')/master-file-list">
                <xf:label>File-list URL:</xf:label>
                <xf:hint>Enter the URL where the file list can be found</xf:hint>
                <xf:alert>Invalid URL</xf:alert>
            </xf:input>
            <xf:input ref="instance('fileset')/master-directory-xpath">
                <xf:label>XPath to directory:</xf:label>
                <xf:hint>Enter the XPath, which element should be used as directory root of the file list</xf:hint>
                <xf:alert>Invalid XPath</xf:alert>                
            </xf:input>
            <xf:input ref="instance('fileset')/master-file-xpath">
                <xf:label>XPath to files:</xf:label>
                <xf:hint>Enter the XPath, which elements should be used as files of the file list</xf:hint>
                <xf:alert>Invalid XPath</xf:alert>                
            </xf:input>
        </xf:group>
        <xf:group appearance="full">
            <xf:label>Current files</xf:label>
            <xf:input ref="instance('fileset')/current-file-variable">
                <xf:label>Variable name:</xf:label>
                <xf:hint>Name of the variable used for each file (e.g. $master-file)</xf:hint>
                <xf:alert>Format has to be: $[A-Za-z][A-Za-z0-9_-]{{1,99}}</xf:alert>
            </xf:input>
            <br/>
            <xf:input ref="instance('fileset')/current-file-list">
                <xf:label>File list URL:</xf:label>
                <xf:hint>Enter the URL where the file list can be found</xf:hint>
                <xf:alert>Invalid URL</xf:alert>                
            </xf:input>
            <xf:input ref="instance('fileset')/current-directory-xpath">
                <xf:label>XPath to directory:</xf:label>
                <xf:hint>Enter the XPath, which element should be used as directory root of the file list</xf:hint>
                <xf:alert>Invalid XPath</xf:alert>                
            </xf:input>
            <xf:input ref="instance('fileset')/current-file-xpath">
                <xf:label>XPath to files:</xf:label>
                <xf:hint>Enter the XPath, which elements should be used as files of the file list</xf:hint>
                <xf:alert>Invalid XPath</xf:alert>                
            </xf:input>
        </xf:group>
        <xf:group>
            <xf:submit submission="create">
               <xf:label>Create Fileset</xf:label>
               <xf:alert>Unknown problem</xf:alert>
            </xf:submit>
        </xf:group>
    </body>
</html>