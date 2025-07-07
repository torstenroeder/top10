<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:output method="xhtml" indent="yes" omit-xml-declaration="yes"/>
	
	<xsl:template match="/">
		<xsl:result-document href="top10-result.html">
			<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;&#xa;</xsl:text>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:result-document>
	</xsl:template>
	

	<xsl:variable name="months1to4" select="tokenize('01 02 03 04',' ')"/>
	<xsl:variable name="months1to12" select="tokenize('01 02 03 04 05 06 07 08 09 10 11 12',' ')"/>
	<xsl:variable name="months4to12" select="tokenize('04 05 06 07 08 09 10 11 12',' ')"/>

	<xsl:variable name="yyyy-mm">
		<xsl:for-each select="$months4to12">
			<xsl:text> 1991-</xsl:text>
			<xsl:value-of select="current()"/>
		</xsl:for-each>
		<xsl:for-each select="$months1to12">
			<xsl:text> 1992-</xsl:text>
			<xsl:value-of select="current()"/>
		</xsl:for-each>
		<xsl:for-each select="$months1to4">
			<xsl:text> 1993-</xsl:text>
			<xsl:value-of select="current()"/>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="monthsNames" select="tokenize('A M J J A S O N D J F M A M J J A S O N D J F M A',' ')"/>

	<xsl:template match="html/body/div[@class = 'content']"
		xpath-default-namespace="http://www.w3.org/1999/xhtml" exclude-result-prefixes="tei">
		<xsl:variable name="data" select="document('top10-data.xml')"/>
		<div>
			<xsl:for-each select="$data//sourceDesc/listBibl[@type = 'games']/bibl" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
				<xsl:if test="not(date) or empty(date)">
					<br/>
					<xsl:text>missing date: </xsl:text>
					<xsl:value-of select="current()"/>
				</xsl:if>
				<xsl:if test="not(publisher) or empty(publisher)">
					<br/>
					<xsl:text>missing publisher: </xsl:text>
					<xsl:value-of select="current()"/>
				</xsl:if>
				<xsl:if test="not(ptr) or ptr[not(@target)]">
					<br/>
					<xsl:text>missing link: </xsl:text>
					<xsl:value-of select="current()"/>
				</xsl:if>
			</xsl:for-each>
		</div>
		<div class="titles">
			<table>
				<caption>Computer Games Top Ten April 1991 - April 1993</caption>
				<thead>
					<th colspan="2">Game</th>
					<th>ASM Sales Charts</th>
					<th>Game On Reader Rankings</th>
					<th>64'er Reader Rankings</th>
					<th/>
				</thead>
				<thead class="months">
					<th colspan="2">Rank / Title / Publisher / Year</th>
					<th><xsl:for-each select="$monthsNames">
						<span>
							<xsl:if test="position()=10 or position()=22"><xsl:attribute name="class" select="'alternate'"/></xsl:if>
							<xsl:value-of select="current()"/>
						</span>
					</xsl:for-each></th>
					<th><xsl:for-each select="$monthsNames">
						<span>
							<xsl:if test="position()=10 or position()=22"><xsl:attribute name="class" select="'alternate'"/></xsl:if>
							<xsl:value-of select="current()"/>
						</span>
					</xsl:for-each></th>
					<th><xsl:for-each select="$monthsNames">
						<span>
							<xsl:if test="position()=10 or position()=22"><xsl:attribute name="class" select="'alternate'"/></xsl:if>
							<xsl:value-of select="current()"/>
						</span>
					</xsl:for-each></th>
					<th/>
				</thead>
				<xsl:for-each select="$data//sourceDesc/listBibl[@type = 'games']/bibl" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
					<!-- sort by cumulative ranking of all sources -->
					<xsl:sort select="count(//item[@ana = concat('#', current()/@xml:id)])" order="descending"/>
					<xsl:variable name="titleRef" select="concat('#', current()/@xml:id)"/>
					<xsl:variable name="totalRankings" select="count(//list/item[@ana = $titleRef])"/>
					<xsl:variable name="cumulativeRank" select="-sum(//list/item[@ana = $titleRef]/@n)+11*$totalRankings"/>
					<xsl:if test="$cumulativeRank gt 0">
						<tr>
							<td class="position">
								<xsl:value-of select="position()"/>
								<xsl:text>.</xsl:text>
							</td>
							<td class="title">
								<a href="{ptr[1]/@target}" target="_blank"><xsl:value-of select="title"/></a>
								<xsl:if test="@ana='#compilation'">
									<span class="compilation">*</span>
								</xsl:if>
								<xsl:text> </xsl:text>
								<span class="published">
									<xsl:value-of select="publisher"/>
									<xsl:text> </xsl:text>
									<xsl:value-of select="date"/>
									<xsl:if test="not(publisher)">###</xsl:if>
								</span>
							</td>
							<td class="rankings">
								<xsl:for-each select="tokenize($yyyy-mm,' ')">
									<xsl:variable name="rank" select="$data/id('asm-hitline')/list[@n=current()]/item[@ana = $titleRef]/@n"/>
									<span class="rank{$rank}" title="{current()}"><xsl:value-of select="$rank"/></span>
								</xsl:for-each>
							</td>
							<td class="rankings">
								<xsl:for-each select="tokenize($yyyy-mm,' ')">
									<xsl:variable name="rank" select="$data/id('game-on-lesercharts')/list[@n=current()]/item[@ana = $titleRef]/@n"/>
									<span class="rank{$rank}" title="{current()}"><xsl:value-of select="$rank"/></span>
								</xsl:for-each>
							</td>
							<td class="rankings">
								<xsl:for-each select="tokenize($yyyy-mm,' ')">
									<xsl:variable name="rank" select="$data/id('magazin-64er-hitparade')/list[@n=current()]/item[@ana = $titleRef]/@n"/>
									<span class="rank{$rank}" title="{current()}"><xsl:value-of select="$rank"/></span>
								</xsl:for-each>
							</td>
							<td class="position">
								<xsl:value-of select="$totalRankings"/>
								<xsl:text> (</xsl:text>
								<xsl:value-of select="$cumulativeRank"/>
								<xsl:text>)</xsl:text>
							</td>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
