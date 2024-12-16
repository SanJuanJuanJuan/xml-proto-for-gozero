## xml-proto-for-gozero
English | [简体中文](README.md)

## Introduction
In my previous work in game development, the team's development habit was to use XML to configure the front-end and back-end protocols, then automatically generate `proto` files and `erlang` code using a tool.  
This approach has the following benefits:
1. The `xml` file serves both as a protocol configuration file and as protocol documentation, making it easier for front-end and back-end teams to communicate.
2. Developers designing and reading the protocol do not need to worry about `proto` syntax.
3. The script automatically generates the files, reducing the possibility of human error.

Now, after leaving that job, I am working with the Go-Zero framework for RPC development, where I encountered Protobuf.  
Therefore, I adopted a similar approach, using `xml` to configure the protocol and then using a tool to generate `protobuf` files, which makes RPC development with the `go-zero` framework more convenient.

## Script Functionality
This script parses all `*Pb.xml` files in the project directory and converts them into `*.proto` files.  
You can refer to the format of the XML files and the generated Proto files in the example directory.  
[XML example](example/recommendPb.xml)  
[Proto example](example/recommend.proto)

## Project Structure
- example: Example XML files and generated Proto files
- pkg:
    - xml
        - style.xsl: A style file for easier visualization of the XML file in browsers (developed with Chinese, you can modify the style as needed)
- xml-proto-for-gozero.py: The script for generating the Proto files

## Installation and Usage
1. Make sure Python is installed, and the version is Python 3.x.
2. Clone the project and navigate to the project directory:
   ```bash
   git clone <https://github.com/SanJuanJuanJuan/xml-proto-for-gozero.git>
   cd xml-proto-for-gozero

## Notes
1. To visualize the XML file, it is recommended to use the Chrome browser and add the `--allow-file-access-from-files` flag to the shortcut.
    - This is because modern browsers block loading local files (using the `file://` protocol) as stylesheets, especially for cross-path references.
