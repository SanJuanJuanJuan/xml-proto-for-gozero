
## xml-proto-for-gozero
[English](README-en.md) | 简体中文

## 前言
在我之前从事游戏开发的时候，团队的开发习惯是使用xml配置前后端协议，然后使用工具自动生成`proto`文件和`erlang`代码  
这样做有以下几点好处:
1. `xml`文件既是协议配置文件，又是协议文档，方便前后端沟通。
2. 设计和阅读协议的开发人员无须关心`proto`的语法。
3. 由脚本自动生成，减少人工出错的可能性。

现在，我已经离职了，并在使用go-zero框架进行rpc开发时，又接触到了protobuf。  
因此，我使用类似的方式，通过`xml`配置协议，然后使用工具生成`protobuf`文件，从而利用`go-zero`框架更方便地进行`rpc`开发。

## 脚本功能
实现将项目中所有路径下的`*Pb.xml`文件解析成`*.proto`文件。  
`xml`文件和生成的`proto`文件格式可自行参考example目录下的文件。  
[xml示例](example/recommendPb.xml)  
[proto示例](example/recommend.proto)

## 项目结构
- example: 示例xml文件与生成的proto文件
- pkg:
  - xml
    - style.xsl: 使用浏览器阅读xml文件方便可视化的样式文件(基于中文开发，可自行修改样式)
- xml-proto-for-gozero.py: 生成脚本

## 安装与使用
1. 确保 Python 已安装，且版本为 Python 3.x。
2. 克隆项目并进入项目目录：
   ```bash
   git clone https://github.com/SanJuanJuanJuan/xml-proto-for-gozero.git
   cd xml-proto-for-gozero
   ```
3. 将项目中的`xml-proto-for-gozero.py`文件复制到你的项目中；
4. 在项目目录中执行以下命令：
   ```bash
   python xml-proto-for-gozero.py
   ```
   脚本将会自动解析项目中所有路径下的`*Pb.xml`文件，并原地生成对应的`*.proto`文件。

## 注意
1. 想要可视化打开xml文件，推荐使用chrome 浏览器，并在快捷方式中添加`--allow-file-access-from-files`参数
   - 因为现代浏览器禁止从本地文件（file:// 协议）加载其他本地文件作为样式表，尤其是跨路径引用。

