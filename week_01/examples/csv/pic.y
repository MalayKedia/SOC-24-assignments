%{
    #include "pic.cc"
    using namespace std;

    extern "C" void yyerror(const char *s);
    extern int yylex(void);

    CSV csv_main;
%}

%union {
    int int_val;          // Integer value
    float flt_val;        // Float value
    string* str_ptr;      // Pointer to a string
    pair<DataType,void*>* data_pair_ptr;  // Pointer to a pair containing a DataType and a void pointer
    vector<pair<DataType,void*>*>* pair_vector_ptr;  // Pointer to a vector of pairs
    DataRow* row_ptr;     // Pointer to a DataRow object
    vector<DataRow*>* row_vector_ptr;  // Pointer to a vector of DataRow objects
    vector<string*>* str_vector_ptr;  // Pointer to a vector of strings
    Header* header_ptr;  // Pointer to a Header object
}

%token TRUE_CONST FALSE_CONST NULL_CONST COMMA ENDOFLINE INT_CONST FLT_CONST STR_CONST HSTRING

%type <int_val> INT_CONST
%type <flt_val> FLT_CONST
%type <str_ptr> STR_CONST
%type <data_pair_ptr> entry
%type <pair_vector_ptr> entries
%type <row_ptr> row
%type <row_vector_ptr> rows

%type <str_ptr> HSTRING
%type <str_ptr> head_entry
%type <str_vector_ptr> head_entries
%type <header_ptr> header

%start csv
%%

/* GRAMMAR */

csv
    : header rows           { csv_main.header = $1 ; csv_main.rows = $2 ;}
    | header                { csv_main.header = $1 ; csv_main.rows = new vector<DataRow*>(); }
;

header
    : head_entries ENDOFLINE        {$$ = new Header($1); }
;

head_entries
    : head_entries COMMA head_entry    { $$ = $1; $$->push_back($3); }
    | head_entry                       { $$ = new vector<string*>(); $$->push_back($1); }
;

head_entry
    : HSTRING               { $$ = $1; }
;

rows
    : rows row              { $$ = $1; $1->push_back($2); }
    | row                   { $$ = new vector<DataRow*>(); $$->push_back($1); }
;

row
    : entries ENDOFLINE     { $$ = new DataRow($1); }
;

entries
    : entries COMMA entry   { $$ = $1; $1->push_back($3); }
    | entry                 { $$ = new vector<pair<DataType,void*>*>(); $$->push_back($1); }
;

entry
    : INT_CONST             { $$ = new pair<DataType,void*> (DATA_INT, new int($1)); }
    | FLT_CONST             { $$ = new pair<DataType,void*> (DATA_FLOAT, new float($1)); }
    | STR_CONST             { $$ = new pair<DataType,void*> (DATA_STRING, $1); }
    | TRUE_CONST            { $$ = new pair<DataType,void*> (DATA_TRUE, NULL); }
    | FALSE_CONST           { $$ = new pair<DataType,void*> (DATA_FALSE, NULL); }
    | NULL_CONST            { $$ = new pair<DataType,void*> (DATA_NULL, NULL); }
;
%%

/* ADDITIONAL C CODE */

int main() {  
    yyparse();
    
    csv_main.print(cout);

    return 0;
}

void yyerror(const char *s) {
    cerr << "Error: " << s << endl;
}
