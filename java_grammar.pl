grammar(File,E) :- open(File,write,Stream),
                   start,
                   generate(E,String),
                   write(Stream,String),
                   close(Stream).

start :- retractall(value(_,_)),
         generate_index(0).

finalize(String) :- string_concat('CondStart ::= (\n','CondEnd ::= )\n',String1),
                    string_concat('IfStart ::= (\n','IfEnd ::= )\n',String2),
                    string_concat('ElseStart ::= (\n','ElseEnd ::= )\n',String3),
                    string_concat('WhileStart ::= (\n','WhileEnd ::= )\n',String4),
                    string_concat('ForStart ::= (\n','ForEnd ::= )\n',String8),
                    string_concat(String1,String2,String5),
                    string_concat(String5,String3,String6),
                    string_concat(String6,String4,String7),
                    string_concat(String7,String8,String).
  
generate_index(35) :- !.
generate_index(L) :- L1 is L + 1, 
                     concat_atom([i,L],L2),
                     assert(value(L2,0)),
                     generate_index(L1).

term_generator(Index,Name,String) :- retract(value(Index,L)),
                         concat_atom([Name,L],String),
                         assert(value(Index,L)).

term_generator(Index,Name,String,Index_num) :- retract(value(Index,L)),
                         concat_atom([Name,L],String),
                         Index_num is L + 1,
                         assert(value(Index,Index_num)).

rule_generator(L,L1,String) :- string_concat(L,' ',S1),
                        string_concat(S1,'::= ',S2),
                        string_concat(S2,L1,S3),
                        string_concat(S3,'\n',String).
  
rule_generator(L,L1,L2,String) :- string_concat(L,' ',S1),
                         string_concat(S1,'::= ',S2),
                         string_concat(S2,L2,S3),
                         string_concat(S3,' ; ',S4),
                         string_concat(S4,L1,S5),
                         string_concat(S5,'\n',String).

rule_generator(L,L1,L2,L3,String) :- string_concat(L,' ',S1),
                         string_concat(S1,'::= ',S2),
                         string_concat(S2,L1,S3),
                         string_concat(S3,' ; ',S4),
                         string_concat(S4,L2,S5),
                         string_concat(S5,' ; ',S6),
                         string_concat(S6,L3,S7),
                         string_concat(S7,'\n',String).

rule_generator(L,L1,L2,L3,L4,String) :- string_concat(L,' ',S1),
                         string_concat(S1,'::= ',S2),
                         string_concat(S2,L1,S3),
                         string_concat(S3,' ; ',S4),
                         string_concat(S4,L2,S5),
                         string_concat(S5,' ; ',S6),
                         string_concat(S6,L3,S7),
                         string_concat(S7,' ; ',S8),
                         string_concat(S8,L4,S9),
                         string_concat(S9,'\n',String).

rule_generator(L,L1,L2,L3,L4,L5,String) :- string_concat(L,' ',S1),
                         string_concat(S1,'::= ',S2),
                         string_concat(S2,L1,S3),
                         string_concat(S3,' ; ',S4),
                         string_concat(S4,L2,S5),
                         string_concat(S5,' ; ',S6),
                         string_concat(S6,L3,S7),
                         string_concat(S7,' ; ',S8),
                         string_concat(S8,L4,S9),
                         string_concat(S9,' ; ',S10),
                         string_concat(S10,L5,S11),
                         string_concat(S11,'\n',String).

for_primary_rule_generator(L,L1,String) :- term_generator(i0,'F',L1,_),
                                    term_generator(i1,'S',L2,_),
                                    asserta(value(forinitial,L2)),
                                    %rule_generator(L,L1,L2,String).
                                    string_concat(L,' ::= ',String1),
                                    string_concat(String1,L2,String2),
                                    string_concat(String2,' ; ',String3),
                                    string_concat(String3,L1,String4),
                                    string_concat(String4,'\n',String).

primary_rule_generator(L,L2,String) :- term_generator(i0,'F',L1),
                                    term_generator(i1,'S',L2,_),
                                    %rule_generator(L,L1,L2,String).
                                    string_concat(L,' ::= ',String1),
                                    string_concat(String1,L2,String2),
                                    string_concat(String2,' ; ',String3),
                                    string_concat(String3,L1,String4),
                                    string_concat(String4,'\n',String).

primary_rule_generator(L,L1,L2,String) :- term_generator(i0,'F',L1,_),
                                    term_generator(i1,'S',L2,_),
                                    %rule_generator(L,L1,L2,String).
                                    string_concat(L,' ::= ',String1),
                                    string_concat(String1,L2,String2),
                                    string_concat(String2,' ; ',String3),
                                    string_concat(String3,L1,String4), 
                                    string_concat(String4,'\n',String).
sub_rule_generator(I,N,L1,L,String) :-  term_generator(I,N,L2,_),
                         rule_generator(L,L2,String1),
                         rule_generator(L2,L1,String2),
                         string_concat(String1,String2,String).

generate(T1:T2,String) :-  term_generator(i0,'F',L,_),
                         generate2(T1,L,String1,M),
                         generate1(T2,M,String2,_),
                         string_concat(String1,String2,String).
 
generate1(T1:T2,L,String,_) :- generate2(T1,L,String1,M),
                           generate1(T2,M,String2,_),
                           string_concat(String1,String2,String).

generate1(T,L,String,M) :- generate2(T,L,String,M).

%generate1(def(_,rectangle,L1),L,String) :- sub_rule_generator(i3,'Assign',L1,L,String).
generate2(null,L,String,_) :- string_concat(L,' ',String1),
                         string_concat(String1,'::= ',String2),
                         string_concat(String2,'null ;\n',String3),
                         finalize(String4),
                         string_concat(String3,String4,String).
generate2(T1:T2,L,String,M) :- generate2(T1,L,String1,L1),
                           generate2(T2,L1,String2,M),
                           string_concat(String1,String2,String).
generate2(def(_,oval,start),L,String,M) :- primary_rule_generator(L,L2,String1),
                                      rule_generator(L2,start,String2),
                                      string_concat(String1,String2,String),
                                      term_generator(i0,'F',M,_).
generate2(def(_,oval,end),L,String,M) :- primary_rule_generator(L,L2,String1),
                                     rule_generator(L2,end,String2),
                                     string_concat(String1,String2,String),
                                     term_generator(i0,'F',M).
generate2(def(_,parallelogram,L1),L,String,M) :- atom_codes(A,L1),
                                                 primary_rule_generator(L,L2,String1),
                                                 sub_rule_generator(i2,'Def',A,L2,String2),
                                                 string_concat(String1,String2,String),
                                                 term_generator(i0,'F',M,_).
generate2(def(_,rectangle,L1),L,String,M) :- atom_codes(A,L1),
                                             primary_rule_generator(L,L2,String1),
                                             sub_rule_generator(i3,'Expr',A,L2,String2),
                                             string_concat(String1,String2,String),
                                             term_generator(i0,'F',M,_).
generate2(def(_,point,end_if),L,String,L1) :- retract(value(nif,L1)), 
                                           primary_rule_generator(L,L2,L3,String1),
                                           rule_generator(L3,'IfEnd',String2),
                                           rule_generator(L2,'CondEnd',String3),
                                           string_concat(String1,String2,String4),
                                           string_concat(String4,String3,String).
generate2(def(_,point,end_elseif),L,String,L1) :- retract(value(nelseif,L1)),
                                           rule_generator(L,'CondEnd','ElseIfEnd',String).
generate2(def(_,point,end_else),L,String,L1) :- primary_rule_generator(L,L1,L2,String1),
                                           rule_generator(L2,'ElseEnd',String2),
                                           string_concat(String1,String2,String).
generate2(def(_,point,end_cond),L,String,L1) :- retract(value(cond,L1)),
                                          rule_generator(L,'CondEnd',String).
generate2(def(_,point,end_while),L,String,L1) :- retract(value(nwhile,L1)),
                                           retract(value(while,L2)),
                                           rule_generator(L,L2,'WhileEnd',String).
generate2(def(_,point,end_for),L,String,L1) :- retract(value(nfor,L1)),
                                           retract(value(for,L2)),
                                           rule_generator(L,L2,'ForEnd',String).
generate2(def(_,point,start_cond),L,String,L1) :- primary_rule_generator(L,L2,L3,String1),
                                         asserta(value(cond,L2)),
                                         term_generator(i26,'Cond',L1,_),
                                         rule_generator(L3,L1,'CondStart',String2),
                                         string_concat(String1,String2,String).
                                         %string_concat(String3,'CondStart ::= (\n',String4),
                                         %string_concat(String4,'CondEnd ::= )\n',String). 
generate2(def(_,point,start_if),L,String,if) :-term_generator(i4,'If',L1,_),
                                          rule_generator(L,L1,String2),
                                          %rterm_generator(i5,'IfStart',L2),
                                          term_generator(i6,'IfCond',L3),
                                          term_generator(i7,'IfBody',L4),
                                          term_generator(i27,'ElseThen',L5,_),
                                          asserta(value(nif,L5)),
                                          term_generator(i9,'NIfCond',L6), 
                                          rule_generator(L1,'IfStart',L3,L4,String3),
                                          rule_generator(L1,L5,L6,String4),
                                          %string_concat(String1,String2,String5),
                                          string_concat(String2,String3,String6),
                                          string_concat(String6,String4,String).
                                          %string_concat(String7,'IfStart ::= if (\n',String8),
                                          %string_concat(String8 ,'IfEnd ::= )\n',String).

generate2(def(_,diamond,L1),if,String,L) :- atom_codes(A,L1),
                                          term_generator(i7,'IfBody',L,_), 
                                          term_generator(i6,'IfCond',L2,_),
                                          rule_generator(L2,A,String1),
                                          term_generator(i9,'NIfCond',L3,_),
                                          string_concat('relcond ( not , ',L2,String3),
                                          string_concat(String3,' )',String4),
                                          rule_generator(L3,String4,String2), 
                                          string_concat(String1,String2,String).

generate2(def(_,point,start_elseif),L,String,elseif) :-%primary_rule_generator(L,L8,L7,String1),
                                          %asserta(value(elseif,L8)), 
                                          term_generator(i10,'ElseIf',L1,_),
                                          rule_generator(L,L1,String2),
                                          %rterm_generator(i11,'ElseIfStart',L2),
                                          term_generator(i12,'ElseIfCond',L3),
                                          term_generator(i13,'ElseIfThen',L4),
                                          term_generator(i28,'NElseIf',L5,_),
                                          asserta(value(nelseif,L5)),
                                          term_generator(i15,'NElseIfCond',L6), 
                                          rule_generator(L1,'ElseIfStart',L3,L4,'ElseIfEnd',String3),
                                          rule_generator(L1,L5,L6,String4),
                                          %string_concat(String1,String2,String5),
                                          string_concat(String2,String3,String6),
                                          string_concat(String6,String4,String7),
                                          string_concat(String7,'ElseIfStart ::= else if (\n',String8),
                                          string_concat(String8 ,'ElseIfEnd ::= )\n',String).

generate2(def(_,diamond,L1),elseif,String,L) :- atom_codes(A,L1),
                                          term_generator(i13,'ElseIfThen',L,_), 
                                          term_generator(i12,'ElseIfCond',L2,_),
                                          rule_generator(L2,A,String1),
                                          term_generator(i15,'NElseIfCond',L3,_),
                                          string_concat('relcond ( not , ',L2,String3),
                                          string_concat(String3,' )',String4),
                                          rule_generator(L3,String4,String2), 
                                          string_concat(String1,String2,String).

generate2(def(_,point,start_else),L,String,L3) :-%primary_rule_generator(L,L8,L7,String1), 
                                          %asserta(value(else,L8)),
                                          term_generator(i16,'Else',L1,_),
                                          rule_generator(L,L1,String2),
                                          %rterm_generator(i17,'ElseStart',L2),
                                          term_generator(i18,'ElseBody',L3,_),
                                          %rterm_generator(i19,'ElseEnd',L4),
                                          rule_generator(L1,L3,'ElseStart',String3),
                                          %string_concat(String1,String2,String4),
                                          string_concat(String2,String3,String).
                                          %string_concat(String5,'ElseStart ::= else (\n',String6),
                                          %string_concat(String6 ,'ElseEnd ::= )\n',String).

generate2(def(_,diamond),L,'',L).

generate2(def(_,point,start_while),L,String,while) :- primary_rule_generator(L,L8,L7,String1),
                                          asserta(value(nwhile,L8)), 
                                          term_generator(i20,'While',L1,_),
                                          asserta(value(while,L1)),
                                          rule_generator(L7,L1,String2),
                                          %rterm_generator(i21,'WhileStart',L2),
                                          term_generator(i22,'WhileCond',L3),
                                          term_generator(i23,'WhileBody',L4),
                                          %rterm_generator(i24,'WhileEnd',L5),
                                          term_generator(i25,'NWhileCond',L6), 
                                          rule_generator(L1,'WhileStart',L3,L4,String3),
                                          rule_generator(L1,'WhileStart',L6,'WhileEnd',String4),
                                          string_concat(String1,String2,String5),
                                          string_concat(String5,String3,String6),
                                          string_concat(String6,String4,String).
                                          %string_concat(String7,'WhileStart ::= while (\n',String8),
                                          %string_concat(String8 ,'WhileEnd ::= )\n',String).

generate2(def(_,diamond,L1),while,String,L) :- atom_codes(A,L1),
                                          term_generator(i23,'WhileBody',L,_), 
                                          term_generator(i22,'WhileCond',L2,_),
                                          rule_generator(L2,A,String1),
                                          term_generator(i25,'NWhileCond',L3,_),
                                          string_concat('relcond ( not , ',L2,String3),
                                          string_concat(String3,' )',String4),
                                          rule_generator(L3,String4,String2), 
                                          string_concat(String1,String2,String).

generate2(def(_,point,start_for),L,String,for) :- for_primary_rule_generator(L,L8,String1),
                                         primary_rule_generator(L8,L9,L10,String2),
                                          asserta(value(nfor,L9)), 
                                          term_generator(i29,'For',L1,_),
                                          asserta(value(for,L1)),
                                          rule_generator(L10,L1,String3),
                                          %rterm_generator(i27,'ForStart',L2),
                                          term_generator(i30,'ForCond',L3),
                                          term_generator(i31,'ForBody',L4),
                                          %rterm_generator(i32,'ForEnd',L5),
                                          term_generator(i33,'NForCond',L6), 
                                          rule_generator(L1,'ForStart',L3,L4,String4),
                                          rule_generator(L1,'ForStart',L6,'ForEnd',String5),
                                          string_concat(String1,String2,String6),
                                          string_concat(String6,String3,String7),
                                          string_concat(String7,String4,String8),
                                          string_concat(String8,String5,String).
                                          %string_concat(String7,'WhileStart ::= while (\n',String8),
                                          %string_concat(String8 ,'WhileEnd ::= )\n',String).

generate2(def(_,rectangle,L1),for,String,for) :- atom_codes(A,L1),
                                             retract(value(forinitial,L2)),
                                             %term_generator(i1,'S',L,_),
                                             %primary_rule_generator(L,L2,String1),
                                             sub_rule_generator(i3,'Expr',A,L2,String).
                                             %string_concat(String1,String2,String).
                                             %term_generator(i0,'F',M,_).

generate2(def(_,diamond,L1),for,String,L) :- atom_codes(A,L1),
                                          term_generator(i31,'ForBody',L,_), 
                                          term_generator(i30,'ForCond',L2,_),
                                          rule_generator(L2,A,String1),
                                          term_generator(i33,'NForCond',L3,_),
                                          string_concat('relcond ( not , ',L2,String3),
                                          string_concat(String3,' )',String4),
                                          rule_generator(L3,String4,String2), 
                                          string_concat(String1,String2,String).
