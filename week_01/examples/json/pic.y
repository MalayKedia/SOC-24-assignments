%{
    #include "pic.cc"
    extern "C" void yyerror(const char *s);
    extern int yylex(void);
    shared_ptr<Value> root;

    struct ValueWrapper {
        shared_ptr<Value> value;
    };
%}

%union {
    string *name;
    ValueWrapper val_wrapper;
    vector<pair<string, shared_ptr<Value>>> *object;
    vector<shared_ptr<Value>> *array;
}

%token TRUE_CONST FALSE_CONST NULL_CONST LCB RCB LSB RSB COMMA COLON INT_CONST FLT_CONST STR_CONST
%type <val_wrapper> program object pair value array
%type <object> pairs
%type <array> values
%type <name> STR_CONST INT_CONST FLT_CONST

%start program
%%

/* GRAMMAR */

program
    : object { root = $1.value; print_value(root); }
    | array { root = $1.value; print_value(root); }
    ;

object
    : LCB pairs RCB { $$ = ValueWrapper{make_shared<Value>(OBJECT)}; for (auto &p : *$2) (*$$.value->object_val)[p.first] = p.second; delete $2; }
    | LCB RCB { $$ = ValueWrapper{make_shared<Value>(OBJECT)}; }
    ;

pairs
    : pairs COMMA pair { $1->push_back($3); $$ = $1; }
    | pair { $$ = new vector<pair<string, shared_ptr<Value>>>(); $$->push_back($1); }
    ;

pair
    : STR_CONST COLON value { $$ = make_pair(*$1, $3.value); delete $1; }
    ;

array
    : LSB values RSB { $$ = ValueWrapper{make_shared<Value>(ARRAY)}; *$$.value->array_val = *$2; delete $2; }
    | LSB RSB { $$ = ValueWrapper{make_shared<Value>(ARRAY)}; }
    ;

values
    : values COMMA value { $1->push_back($3.value); $$ = $1; }
    | value { $$ = new vector<shared_ptr<Value>>(); $$->push_back($1.value); }
    ;

value
    : object { $$ = $1; }
    | array { $$ = $1; }
    | STR_CONST { $$ = ValueWrapper{make_shared<Value>(STRING)}; $$.value->string_val = $1; }
    | INT_CONST { $$ = ValueWrapper{make_shared<Value>(INT)}; $$.value->int_val = stoi(*$1); delete $1; }
    | FLT_CONST { $$ = ValueWrapper{make_shared<Value>(FLOAT)}; $$.value->float_val = stof(*$1); delete $1; }
    | TRUE_CONST { $$ = ValueWrapper{make_shared<Value>(BOOL)}; $$.value->bool_val = true; }
    | FALSE_CONST { $$ = ValueWrapper{make_shared<Value>(BOOL)}; $$.value->bool_val = false; }
    | NULL_CONST { $$ = ValueWrapper{make_shared<Value>(NIL)}; }
    ;

%%

/* ADDITIONAL C CODE */

int main(){
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    cerr << "Parse error: " << s << endl;
    exit(1);
}
