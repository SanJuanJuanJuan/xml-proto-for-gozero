import os
import xml.etree.ElementTree as ET


def xml_type_to_proto_type(xml_type):
    """Map XML types to Proto types."""
    mapping = {
        "bool": "bool",
        "int8": "int32",  # Proto does not have int8, maps to int32
        "int16": "int32",  # Proto does not have int16, maps to int32
        "int32": "int32",
        "int64": "int64",
        "uint8": "int32",  # Proto does not have uint8, maps to int32
        "uint16": "int32",  # Proto does not have uint16, maps to int32
        "uint32": "uint32",
        "uint64": "uint64",
        "float32": "float",  # Proto uses 'float' for 32-bit float
        "float64": "double",  # Proto uses 'double' for 64-bit float
        "string": "string",
        "bytes": "bytes",
        "time": "google.protobuf.Timestamp",  # For time-related fields
    }
    return mapping.get(xml_type, "string")  # Default to string if type is unknown


def parse_type(type_element):
    """Generate Proto message for a type definition."""
    proto_lines = [f"message {type_element.get('name')} {{"]

    for idx, field in enumerate(type_element.findall("field"), start=1):
        field_type = xml_type_to_proto_type(field.get("type"))
        field_name = field.get("name")
        field_desc = field.get("desc", "")
        proto_lines.append(f"  {field_type} {field_name} = {idx}; // {field_desc}")

    proto_lines.append("}")
    return "\n".join(proto_lines)


def parse_method(method_element):
    """Generate Proto messages and RPC definition for a method."""
    rpc_name = method_element.get("name")
    req_message_name = f"{rpc_name}Req"
    resp_message_name = f"{rpc_name}Resp"

    # Generate request message
    req_proto_lines = [f"message {req_message_name} {{"]
    for idx, field in enumerate(method_element.find("req").findall("field"), start=1):
        req_proto_lines.append(f"  {xml_type_to_proto_type(field.get('type'))} {field.get('name')} = {idx}; // {field.get('desc', '')}")
    req_proto_lines.append("}")

    # Generate response message
    resp_proto_lines = [f"message {resp_message_name} {{"]
    idx = 1
    for loop in method_element.find("resp").findall("loop"):
        resp_proto_lines.append(f"  repeated {loop.get('type')} {loop.get('name')} = {idx}; // {loop.get('desc', '')}")
        idx += 1
    for field in method_element.find("resp").findall("field"):
        resp_proto_lines.append(f"  {xml_type_to_proto_type(field.get('type'))} {field.get('name')} = {idx}; // {field.get('desc', '')}")
        idx += 1
    resp_proto_lines.append("}")

    rpc_line = f"  rpc {rpc_name}({req_message_name}) returns ({resp_message_name}); // {method_element.get('desc', '')}"
    return "\n".join(req_proto_lines), "\n".join(resp_proto_lines), rpc_line


def xml_to_proto(xml_path):
    """Convert an XML file to Proto content."""
    tree = ET.parse(xml_path)
    root = tree.getroot()

    proto_lines = [
        "syntax = \"proto3\";",
        "option go_package = \"./pb\";",
        f"package {root.find('serv').get('name').lower()};",
        ""
    ]

    for type_element in root.findall("type"):
        proto_lines.append(parse_type(type_element))
        proto_lines.append("")

    service_element = root.find("serv")
    service_lines = [f"service {service_element.get('name')} {{"]

    for method_element in service_element.findall("method"):
        req_proto, resp_proto, rpc_line = parse_method(method_element)
        proto_lines.append(req_proto)
        proto_lines.append(resp_proto)
        service_lines.append(rpc_line)

    service_lines.append("}")
    proto_lines.extend(service_lines)

    return "\n".join(proto_lines)


def convert_all_xml_to_proto(root_dir):
    """Convert all *Pb.xml files to .proto files."""
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith("Pb.xml"):
                xml_path = os.path.join(dirpath, filename)
                proto_content = xml_to_proto(xml_path)
                proto_filename = filename.replace("Pb.xml", ".proto")
                proto_path = os.path.join(dirpath, proto_filename)

                with open(proto_path, "w", encoding="utf-8") as proto_file:
                    proto_file.write(proto_content)
                print(f"Converted: {xml_path} -> {proto_path}")


if __name__ == "__main__":
    project_root = os.getenv("PROJECT_ROOT", "./")  # Default to current directory
    convert_all_xml_to_proto(project_root)
