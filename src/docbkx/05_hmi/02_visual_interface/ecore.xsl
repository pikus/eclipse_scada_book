<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://docbook.org/ns/docbook"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:ecore="http://www.eclipse.org/emf/2002/Ecore"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://docbook.org/ns/docbook http://docbook.org/xml/5.0/xsd/docbook.xsd"
    xmlns:ecdt="urn:ecore:data:type"
	>

  <xsl:template name="dataType">
   <xsl:choose>
    <xsl:when test="@eType='ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EInt'">integer</xsl:when>
    <xsl:when test="@eType='ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//ELong'">long</xsl:when>
    <xsl:when test="@eType='ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EFloat'">float</xsl:when>
    <xsl:when test="@eType='ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EDouble'">double</xsl:when>
    <xsl:when test="@eType='ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EBoolean'">boolean</xsl:when>
    <xsl:when test="@eType='ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EString'">string</xsl:when>
    <xsl:otherwise><xsl:value-of select="@eType"/></xsl:otherwise>
   </xsl:choose>
  </xsl:template>
	
  <xsl:template name="cardinality">
   <xsl:choose>
    <xsl:when test="@lowerBound='1' and @upperBound='-1'">[1..*]</xsl:when> 
    <xsl:when test="@upperBound='-1'">[0..*]</xsl:when>
    <xsl:when test="@lowerBound='1'">[1..1]</xsl:when>
   </xsl:choose>
  </xsl:template>
   
   <xsl:variable name="ecoreTypeMap" select="document('')/*/ecdt:map/*/*"/>
  
	<xsl:output indent="yes" encoding="UTF-8"/>
	
    <xsl:template match="eStructuralFeatures">
    <row>
      <entry><xsl:value-of select="@name"/></entry>
      <entry><xsl:call-template name="dataType"/></entry>
      <entry><xsl:call-template name="cardinality"/></entry>
      <entry><xsl:value-of select="@defaultValueLiteral"/></entry>
    </row>
    </xsl:template>
  
    <xsl:template match="eLiterals">
    <row>
      <entry><xsl:value-of select="@name"/></entry>
      <entry><xsl:value-of select="@value"/></entry>
      <entry></entry>
    </row>
    </xsl:template>
    
    <xsl:template name="supertypes">
      <xsl:if test="count(tokenize(@eSuperTypes,' '))>0">
        <para>The class has the following supertypes:
        <itemizedlist>
        <xsl:for-each select="tokenize(@eSuperTypes,' ')">
          <listitem><para><xsl:value-of select="."/></para></listitem>
        </xsl:for-each>
        </itemizedlist>
        </para>
      </xsl:if>
    </xsl:template>
  
    <xsl:template match="eClassifiers[@xsi:type='ecore:EEnum']">
    <section>
      <title><xsl:value-of select="@name"/></title>
      <para>
        <table>
	      <title>Literals of enum <xsl:value-of select="@name"/></title>
          <tgroup cols="3">
            <colspec />
            <colspec />
            <colspec />
            
            <thead>
              <row>
                <entry>Name</entry>
                <entry>Value</entry>
                <entry>Description</entry>
              </row>  
            </thead>
            
           <tbody>
            
            <xsl:apply-templates/>
            
           </tbody>
           </tgroup>
        </table>
      </para>
    </section>
    </xsl:template>
    
    <xsl:template match="eClassifiers[@xsi:type='ecore:EClass']">
    <section>
      <title><xsl:value-of select="@name"/></title>
      <xsl:if test="@abstract='true'">
      <para>This class is abstract.</para>
      </xsl:if>
      <xsl:if test="@interface='true'">
      <para>This class is an interface.</para>
      </xsl:if>
      <xsl:call-template name="supertypes"/>
      <para>
      </para>
      
      <xsl:if test="count(eStructuralFeatures)>0">
      <table>
        <title>Structural features of <xsl:value-of select="@name"/></title>
        <tgroup cols="4">
            <colspec />
            <colspec />
            <colspec />
            <thead>
              <row>
                <entry>Name</entry>
                <entry>Type</entry>
                <entry>Cardinality</entry>
                <entry>Default</entry>
              </row>
            </thead>
            
            <tbody>
        <xsl:apply-templates/>    
            </tbody>
        </tgroup>
      </table>
      </xsl:if>
    </section>
    </xsl:template>
  
	<xsl:template match="/">
	<section xmlns="http://docbook.org/ns/docbook" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xi="http://www.w3.org/2001/XInclude" 
	xsi:schemaLocation="http://docbook.org/ns/docbook http://docbook.org/xml/5.0/xsd/docbook.xsd">

	<title>Model definition – <xsl:value-of select="//@nsURI"/></title>
	
	<para>
	This section describes the model <constant><xsl:value-of select="//@nsURI"/></constant>.
	</para>
  
    <section>
      <title>Enums</title>
      <para>This section describes the enums of the model.</para>
      <xsl:apply-templates select="//eClassifiers[@xsi:type='ecore:EEnum']"/>
    </section>
  
    <section>
      <title>Classes</title>
      <para>This sections describes the classes of the model.</para>
      <xsl:apply-templates select="//eClassifiers[@xsi:type='ecore:EClass']"/>
    </section>
    
	
</section>
	</xsl:template>
	
</xsl:stylesheet>