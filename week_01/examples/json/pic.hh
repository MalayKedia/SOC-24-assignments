#include <map>
#include <cstdio>
#include <iostream>
#include <string>
#include <vector>
#include <memory>

using namespace std;

enum ValueType { OBJECT, ARRAY, STRING, INT, FLOAT, BOOL, NIL };

struct Value {
    ValueType type;
    union {
        map<string, shared_ptr<Value>> *object_val;
        vector<shared_ptr<Value>> *array_val;
        string *string_val;
        int int_val;
        double float_val;
        bool bool_val;
    };

    Value(ValueType t) : type(t) {
        switch (t) {
            case OBJECT: object_val = new map<string, shared_ptr<Value>>(); break;
            case ARRAY: array_val = new vector<shared_ptr<Value>>(); break;
            case STRING: string_val = new string(); break;
            default: break;
        }
    }

    ~Value() {
        switch (type) {
            case OBJECT: delete object_val; break;
            case ARRAY: delete array_val; break;
            case STRING: delete string_val; break;
            default: break;
        }
    }
};
