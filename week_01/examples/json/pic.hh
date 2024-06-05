#include<bits/stdc++.h>
using namespace std;

// pic.hh

#include <vector>
#include <string>

struct JSONvalue;
struct JSONarray;
struct JSONObject;

struct JSONvalue {
    int object_type;
    union {
        JSONObject* obj_value;
        JSONarray* arr_value;
        std::string* str_value;
        int int_value;
        float float_value;
    };
};

struct JSONarray {
    std::vector<JSONvalue> elements;
};

struct JSONObject {
    std::vector<std::pair<std::string, JSONvalue>> members;
};