<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- 模板匹配根元素 rpc -->
    <xsl:template match="/rpc">
        <html>
            <head>
                <title>RPC 接口文档</title>
                <style>
                    body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 20px; }
                    h1 { color: #2c3e50; text-align: center; }
                    .type, .method { background-color: #ffffff; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
                    .type h2, .method h3 { color: #2980b9; }
                    .desc { font-size: 0.9em; color: #7f8c8d; }
                    table { width: 100%; border-collapse: collapse; margin-top: 10px; }
                    th, td { padding: 8px 12px; border: 1px solid #ddd; text-align: left; }
                    th { background-color: #f1c40f; color: white; }
                    tr:nth-child(even) { background-color: #ecf0f1; }
                    .section-header { font-size: 1.2em; font-weight: bold; margin-top: 20px; }
                </style>
            </head>
            <body>
                <h1>RPC 接口文档</h1>
                <xsl:apply-templates select="type"/>
                <xsl:apply-templates select="serv"/>
            </body>
        </html>
    </xsl:template>

    <!-- 模板匹配type元素 -->
    <xsl:template match="type">
        <div class="type">
            <h2><xsl:value-of select="@name"/> - <xsl:value-of select="@desc"/></h2>
            <div class="desc">描述：<xsl:value-of select="@desc"/></div>
            <table>
                <thead>
                    <tr>
                        <th>字段名</th>
                        <th>类型</th>
                        <th>描述</th>
                        <th>是否循环</th> <!-- 新增列 -->
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="field">
                        <tr>
                            <td><xsl:value-of select="@name"/></td>
                            <td><xsl:value-of select="@type"/></td>
                            <td><xsl:value-of select="@desc"/></td>
                            <td>否</td> <!-- 标记非循环 -->
                        </tr>
                    </xsl:for-each>
                    <xsl:for-each select="loop">
                        <tr>
                            <td><xsl:value-of select="@name"/></td>
                            <td><xsl:value-of select="@type"/></td>
                            <td><xsl:value-of select="@desc"/></td>
                            <td>是</td> <!-- 标记为循环 -->
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </div>
    </xsl:template>

    <!-- 模板匹配serv元素 -->
    <xsl:template match="serv">
        <div class="serv">
            <h2 class="section-header">服务：<xsl:value-of select="@name"/></h2>
            <xsl:for-each select="method">
                <div class="method">
                    <h3>方法：<xsl:value-of select="@name"/> - <xsl:value-of select="@desc"/></h3>

                    <!-- 请求部分 -->
                    <div class="loop">
                        <strong>请求参数：</strong>
                        <table>
                            <thead>
                                <tr>
                                    <th>字段名</th>
                                    <th>类型</th>
                                    <th>描述</th>
                                    <th>是否循环</th> <!-- 新增列 -->
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="req/loop">
                                    <tr>
                                        <td><xsl:value-of select="@name"/></td>
                                        <td><xsl:value-of select="@type"/></td>
                                        <td><xsl:value-of select="@desc"/></td>
                                        <td>是</td> <!-- 标记为循环 -->
                                    </tr>
                                </xsl:for-each>
                                <xsl:for-each select="req/field">
                                    <tr>
                                        <td><xsl:value-of select="@name"/></td>
                                        <td><xsl:value-of select="@type"/></td>
                                        <td><xsl:value-of select="@desc"/></td>
                                        <td>否</td> <!-- 标记非循环 -->
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>

                    <!-- 响应部分 -->
                    <div class="loop">
                        <strong>响应参数：</strong>
                        <table>
                            <thead>
                                <tr>
                                    <th>字段名</th>
                                    <th>类型</th>
                                    <th>描述</th>
                                    <th>是否循环</th> <!-- 新增列 -->
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="resp/loop">
                                    <tr>
                                        <td><xsl:value-of select="@name"/></td>
                                        <td><xsl:value-of select="@type"/></td>
                                        <td><xsl:value-of select="@desc"/></td>
                                        <td>是</td> <!-- 标记为循环 -->
                                    </tr>
                                </xsl:for-each>
                                <xsl:for-each select="resp/field">
                                    <tr>
                                        <td><xsl:value-of select="@name"/></td>
                                        <td><xsl:value-of select="@type"/></td>
                                        <td><xsl:value-of select="@desc"/></td>
                                        <td>否</td> <!-- 标记非循环 -->
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>

</xsl:stylesheet>
