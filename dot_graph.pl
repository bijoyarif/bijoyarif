dot(File,E,E1) :- open(File,write,Stream),
           dot_start(Start),
           dot_initial(E,String1),
           string_concat(Start,String1,String2),
           dot_control(E1,String3),
           string_concat(String2,String3,String4),
           dot_end(End),
           string_concat(String4,End,String),
           write(Stream,String),
           close(Stream).

dot_start(Start) :- Start = 'digraph G {\n'.
dot_end(End) :- End = '}'.
dot_initial(null,'').
dot_initial(T,String) :- initial(T,String).
dot_initial(T1:T2,String) :- dot_initial(T1,String1),
                             dot_initial(T2,String2),
                             string_concat(String1,String2,String).
initial(def(X,Y,S),String) :- shape(Y,Y1),
                             string_concat(X,' ',String1),
                             string_concat(String1,'[label="',String2),
			     getNodeLabel(S, SLabel),
                             string_concat(String2,SLabel,String3),
                             string_concat(String3,'";',String4),
                             string_concat(String4,'shape=',String7),
                             string_concat(String7,Y1,String8),
                             string_concat(String8,'];\n',String).


%getNodeLabel(S, SLabel)
getNodeLabel(Node, SLabel) :-
     swritef(SLabel, '%t', [Node]).



shape(oval,oval).
shape(parallelogram,parallelogram).
shape(rectangle,box).
%shape(diamond(yes/no),diamond).
shape(diamond,diamond).
shape(point,point).

dot_control(null,'').
dot_control(T,String) :- control(T,String).
dot_control(T1:T2,String) :- dot_control(T1,String1),
                             dot_control(T2,String2),
                             string_concat(String1,String2,String). 
control(trans(X,Y,Z),String) :- string_concat(Y,' -> ',String1),
                             string_concat(String1,Z,String2),
                             string_concat(String2,' [label="',String3),
                             string_concat(String3,X,String4),
                             string_concat(String4,'"];\n',String).
control(trans([],_),'').  
control(trans([X|L],Y),String) :- member(X,[X|L]), string_concat(X,' -> ',String1),
                             string_concat(String1,Y,String2),
                             string_concat(String2,';\n',String3),
                             control(trans(L,Y),String4),
                             string_concat(String3,String4,String). 
 
control(trans(X,Y),String) :- string_concat(X,' -> ',String1),
                             string_concat(String1,Y,String2),
                             string_concat(String2,';\n',String).

                             

