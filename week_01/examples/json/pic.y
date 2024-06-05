%{
    #include "pic.hh"
    #include <iostream>
    #include <string>
    using namespace std;

    extern "C" void yyerror(const char *s);
    extern int yylex(void);

    JSONvalue root;
%}

%union {
    string *str;
    int ival;
    float fval;
    JSONvalue *jval;
    JSONarray *jarr;
    JSONObject *jobj;
    pair<string*, JSONvalue*> *pairp;
    vector<pair<string, JSONvalue>> *pairsp; 
    vector<JSONvalue> *objectsp;
}

%token TRUE_CONST FALSE_CONST NULL_CONST LCB RCB LSB RSB COMMA COLON INT_CONST FLT_CONST STR_CONST
%type <str> STR_CONST
%type <ival> INT_CONST
%type <fval> FLT_CONST
%type <jval> value
%type <jarr> array
%type <jobj> object
%type <pairp> pair
%type <pairsp> pairs
%type <objectsp> objects

%start program

%%
/* GRAMMAR */

program
    : array   { root.object_type = 1; root.arr_value = $1; }
    | object  { root.object_type = 0; root.obj_value = $1; }
;

array
    : LSB objects RSB  { $$ = new JSONarray(); $$->elements = std::move(*$2); delete $2; }
    | LSB RSB          { $$ = new JSONarray(); }
;

objects
    : objects COMMA value  { $1->push_back(*$3); delete $3; $$ = $1; }
    | value                { $$ = new vector<JSONvalue>(); $$->push_back(*$1); delete $1; }
;

object
    : LCB pairs RCB  { $$ = new JSONObject(); $$->members = std::move(*$2); delete $2; }
    | LCB RCB        { $$ = new JSONObject(); }
;

pairs
    : pairs COMMA pair  { $1->push_back(std::make_pair(*$3->first, *$3->second)); delete $3; $$ = $1; }
    | pair              { $$ = new std::vector<std::pair<std::string, JSONvalue>>(); $$->push_back(std::make_pair(*$1->first, *$1->second)); delete $1; }
;

pair
    : STR_CONST COLON value  { $$ = new std::pair<std::string*, JSONvalue*>(new std::string(*$1), $3); delete $1; }
;

value
    : object          { $$ = new JSONvalue(); $$->object_type = 0; $$->obj_value = $1; }
    | array           { $$ = new JSONvalue(); $$->object_type = 1; $$->arr_value = $1; }
    | STR_CONST       { $$ = new JSONvalue(); $$->object_type = 2; $$->str_value = new std::string(*$1); delete $1; }
    | INT_CONST       { $$ = new JSONvalue(); $$->object_type = 3; $$->int_value = $1; }
    | FLT_CONST       { $$ = new JSONvalue(); $$->object_type = 4; $$->float_value = $1; }
    | TRUE_CONST      { $$ = new JSONvalue(); $$->object_type = 5; }
    | FALSE_CONST     { $$ = new JSONvalue(); $$->object_type = 6; }
    | NULL_CONST      { $$ = new JSONvalue(); $$->object_type = 7; }
;

%%

/* ADDITIONAL C CODE */

int main() {
    yyparse();
    // Add code to handle the parsed JSON stored in `root`
    // For example, you can print the JSON structure here
    return 0;
}

void yyerror(const char *s) {
    cerr << "Error: " << s << endl;
}
