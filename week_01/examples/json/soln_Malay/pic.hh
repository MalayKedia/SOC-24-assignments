#include<bits/stdc++.h>
using namespace std;

struct JSONvalue;
struct JSONarray;
struct JSONObject;

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

    JSONvalue();
    JSONvalue(const JSONvalue& other);
    JSONvalue& operator=(const JSONvalue& other);
    ~JSONvalue();

    void print(std::ostream &os) const;
};

struct JSONarray {
    vector<JSONvalue*> elements;

    void print(std::ostream &os) const;
};

struct JSONObject {
    map<string, JSONvalue*> members;

    void print(std::ostream &os) const;
};
