#include "pic.hh"

#ifndef JSON_DEFS
#define JSON_DEFS

Header::Header(vector<string*>* head_entries) {
    this->head_entries = head_entries;
}

DataRow::DataRow(vector<pair<DataType,void*>*>* row_data) {
    this->row_data = row_data;
}

void CSV::print(std::ostream &os) const {
    if (header==nullptr) return;
    header->print(os);
    if (rows == nullptr) return;
    for (auto row : *rows) {
        row->print(os);
    }
}

void Header::print(std::ostream &os) const {
    for (auto entry : *head_entries) {
        os << *entry;
        if (entry != head_entries->back()) {
            os << ",";
        }
    }
    os << std::endl;
}

void DataRow::print(std::ostream &os) const {
    for (auto data : *row_data) {
        switch (data->first) {
            case DATA_INT:
                os << *(int*)data->second ;
                break;
            case DATA_FLOAT:
                os << *(float*)data->second ;
                break;
            case DATA_STRING:
                os << *(string*)data->second ;
                break;
            case DATA_TRUE:
                os << "true";
                break;
            case DATA_FALSE:
                os << "false";
                break;
            case DATA_NULL:
                os << "null";
                break;
        }
        if (data != row_data->back()) {
            os << ",";
        }
    }
    os << std::endl;
}

#endif