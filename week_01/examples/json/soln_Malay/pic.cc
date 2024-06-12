#include "pic.hh"

#ifndef JSON_DEFS
#define JSON_DEFS

    JSONvalue::JSONvalue() : object_type(7) {} // Default to null

    JSONvalue::JSONvalue(const JSONvalue& other) {
        object_type = other.object_type;
        switch (object_type) {
            case 0: obj_value = new JSONObject(*other.obj_value); break;
            case 1: arr_value = new JSONarray(*other.arr_value); break;
            case 2: str_value = new string(*other.str_value); break;
            case 3: int_value = other.int_value; break;
            case 4: float_value = other.float_value; break;
            case 5: // true
            case 6: // false
            case 7: // null
                break;
        }
    }

    JSONvalue& JSONvalue::operator=(const JSONvalue& other) {
        if (this == &other) return *this;

        switch (object_type) {
            case 0: delete obj_value; break;
            case 1: delete arr_value; break;
            case 2: delete str_value; break;
            default: break;
        }
        object_type = other.object_type;
        switch (object_type) {
            case 0: obj_value = new JSONObject(*other.obj_value); break;
            case 1: arr_value = new JSONarray(*other.arr_value); break;
            case 2: str_value = new string(*other.str_value); break;
            case 3: int_value = other.int_value; break;
            case 4: float_value = other.float_value; break;
            case 5: // true
            case 6: // false
            case 7: // null
                break;
        }
        return *this;
    }

    JSONvalue::~JSONvalue() {
        switch (object_type) {
            case 0: delete obj_value; break;
            case 1: delete arr_value; break;
            case 2: delete str_value; break;
            default: break;
        }
    }

    void JSONvalue::print(std::ostream &os) const {
        switch (object_type) {
            case 0:
                obj_value->print(os);
                break;
            case 1:
                arr_value->print(os);
                break;
            case 2:
                os << "\"" << *str_value << "\"";
                break;
            case 3:
                os << int_value;
                break;
            case 4:
                os << float_value;
                break;
            case 5:
                os << "true";
                break;
            case 6:
                os << "false";
                break;
            case 7:
                os << "null";
                break;
        }
    }

    void JSONarray::print(std::ostream &os) const {
        os << "[";
        for (int i = 0; i < elements.size(); i++) {
            if (i > 0) os << ", ";
            elements[i]->print(os);
        }
        os << "]";
    }

    void JSONObject::print(std::ostream &os) const {
        os << "{";
        for (auto it = members.begin(); it != members.end(); it++) {
            if (it != members.begin()) os << ", ";
            os << "\"" << it->first << "\": ";
            it->second->print(os);
        }
        os << "}";
    }
#endif