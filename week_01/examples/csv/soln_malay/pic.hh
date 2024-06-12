#include<bits/stdc++.h>
using namespace std;

struct CSV;
struct Header;
struct DataRow;

struct CSV {
    Header* header;
    vector<DataRow*>* rows;

    void print(std::ostream &os) const;
};

struct Header {
    vector<string*>* head_entries;
    Header(vector<string*>*);

    void print(std::ostream &os) const;
};

enum DataType {
    DATA_INT,
    DATA_FLOAT,
    DATA_STRING,
    DATA_TRUE,
    DATA_FALSE,
    DATA_NULL,
};

struct DataRow {
    vector<pair<DataType,void*>*>* row_data;
    DataRow(vector<pair<DataType,void*>*>*);

    void print(std::ostream &os) const;
};
