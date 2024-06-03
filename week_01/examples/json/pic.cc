#include "pic.hh"

void print_value(const shared_ptr<Value>& val, int indent = 0) {
    if (!val) return;

    string indent_str(indent, ' ');
    switch (val->type) {
        case OBJECT:
            cout << indent_str << "{\n";
            for (const auto& pair : *val->object_val) {
                cout << indent_str << "  \"" << pair.first << "\": ";
                print_value(pair.second, indent + 2);
            }
            cout << indent_str << "}\n";
            break;
        case ARRAY:
            cout << indent_str << "[\n";
            for (const auto& item : *val->array_val) {
                print_value(item, indent + 2);
            }
            cout << indent_str << "]\n";
            break;
        case STRING:
            cout << indent_str << "\"" << *val->string_val << "\"\n";
            break;
        case INT:
            cout << indent_str << val->int_val << "\n";
            break;
        case FLOAT:
            cout << indent_str << val->float_val << "\n";
            break;
        case BOOL:
            cout << indent_str << (val->bool_val ? "true" : "false") << "\n";
            break;
        case NIL:
            cout << indent_str << "null\n";
            break;
    }
}
