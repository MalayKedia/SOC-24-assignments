#include "pic.hh"

struct JSONvalue;

struct JSONObject {
    vector<pair<string, JSONvalue>> members;
};

struct JSONarray {
    vector<JSONvalue> elements;
};

struct JSONvalue {
    int object_type;
    // 0: object, 1: array, 2: string, 3: int, 4: float, 5: true, 6: false, 7: null
    union {
        JSONObject* obj_value;
        JSONarray* arr_value;
        string* str_value;
        int int_value;
        float float_value;
    };

    JSONvalue() : object_type(7) {} // Default to null

    JSONvalue(const JSONvalue& other) {
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

    JSONvalue& operator=(const JSONvalue& other) {
        if (this == &other) return *this;
        clear();
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

    ~JSONvalue() {
        clear();
    }

    void clear() {
        switch (object_type) {
            case 0: delete obj_value; break;
            case 1: delete arr_value; break;
            case 2: delete str_value; break;
        }
        object_type = 7; // Set to null
    }
};
