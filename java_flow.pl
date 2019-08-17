controlflow(T,E,E1) :- cmethods(T,E,E1).

cmethods(cMethod(null),null,null).
cmethods(cMethod(T1):T2,E,E1) :- cMethod(T1,A,A1,Count),
                                  cmethods(T2,B,B1),
                                  E = A:B,
                                  E1 = A1:def(Count,oval,end):B1.

cMethod(method(Head,Body),E,E1,Count) :- mHeads(Head,A,A1,Count1),
                                        mBodys(Body,B,B1,Count1,Count),
                                        E = A:B,
                                        E1 = A1:B1.

mHeads(mHead(W,X,Y,arg(Z)),E,E1,Count) :- scope(W), dyn(X), name(Y), 
                                         argg(Z,A,A1,Count),
                                         E = trans(0,1):A,
                                         E1 = def(0,oval,start):A1.
                                         

scope(public).
scope(private).
scope(null).

dyn(static).
dyn(not).

name(_).

argg(Z,E,E1,2) :- E1 = def(1,parallelogram,Z),
                   E = trans(1,2).

mBodys(mBody(T),E,E1,Count,TC) :- process(T,E,E1,Count,TC).

process(null,E,E1,Count,TC) :- Count1 is Count + 1, 
                                    E1 = def(Count,rectangle,null),
                                    E = trans(Count,Count1),
                                    TC = Count.
process(T,E,E1,Count,TC) :- sequence(T,E,E1,Count,TC).

%sequence(end,trans(Count1,A,oval(end)),A,Count) :- Count1 is Count + 1.
%sequence(null,trans(Count1,A,rectangle(null)),A,Count) :- Count1 is Count + 1.
sequence(expr(T),E,E1,Count,TC) :- Count1 is Count + 1,
                                 E1 = def(Count,rectangle,T),
                                 E = trans(Count,Count1),
                                 TC = Count1.
sequence(expr(T1):T2,E,E1,Count,TC) :- Count1 is Count + 1,
                                     sequence(T2,A,A1,Count1,TC),
                                     E = trans(Count,Count1):A,
                                     E1 = def(Count,rectangle,T1):A1.

sequence(block(T),E,E1,Count,TC) :- sequence(T,E,E1,Count,TC).
sequence(loop(T),E,E1,Count,TC) :- loop(T,E,E1,Count,TC).
sequence(loop(T1):T2,E,E1,Count,TC) :- loop(T1,A,A1,Count,TC1),
                                        sequence(T2,B,B1,TC1,TC),
                                        E = A:B,
                                        E1 = A1:B1.
sequence(cond(T),E,E1,Count,TC) :- Count1 is Count + 1,
                                   cond(T,A,A1,Count1,TC1,[]),
                                   TC is TC1 + 1,
                                   E = trans(Count,Count1):A:
                                       trans(TC1,TC),
                                   E1 = def(Count,point,start_cond):A1:
                                        def(TC1,point,end_cond).
sequence(cond(T1):T2,E,E1,Count,TC) :- Count1 is Count + 1, 
                                        cond(T1,A,A1,Count1,TC1,[]),
                                        TC2 is TC1 + 1, 
                                        sequence(T2,B,B1,TC2,TC),
                                        E = trans(Count,Count1):A:
                                            trans(TC1,TC2):B,
                                        E1 = def(Count,point,start_cond):
                                             A1:def(TC1,point,end_cond):B1.
cond(T,E,E1,Count,TC,I1) :- condition(T,B,B1,Count,TC1,I1),
                            TC is TC1 + 1,
                            %TC2 is TC + 1, 
                            push(I2,I1,TC1),
                            pop(I2,X),
                            E = B:trans(X,TC),
                            %trans(TC,TC2),
                            E1 = B1.
cond(T1:T2,E,E1,Count,TC,I1) :- condition(T1,A,A1,Count,TC1,I1),
                                TC2 is TC1 + 1,
                                push(I2,I1,TC1),
                                cond(T2,B,B1,TC2,TC,I2),
                                E = A:B,
                                E1 = A1:B1. 
loop(for(fargs(T1,T2,T3),fbody(T4)),E,E1,Count,TC) :- Count1 is Count + 1,
                                          Count2 is Count1 + 1,
                                          Count3 is Count2 + 1,
                                          sequence(T4,B,B1,Count3,TC1),
                                          TC2 is TC1 + 1,
                                          TC is TC2 + 1,
                                          E = trans(Count,Count1):
                                              trans(Count1,Count2):
                                              trans(yes,Count2,Count3):
                                              trans(TC,Count2):
                                              trans(no,Count2,TC):
                                              B:trans(TC2,TC),
                                          E1 = def(Count,point,start_for):
                                               def(Count1,rectangle,T1):
                                               def(Count2,diamond,T2):
                                               B1:def(TC2,rectangle,T3):
                                               def(TC,point,end_for).
loop(while(wargs(T1),wbody(T2)),E,E1,Count,TC):- Count1 is Count + 1,
                                          Count2 is Count1 + 1,
                                          sequence(T2,B,B1,Count2,TC1),
                                          TC2 is TC1 + 1,
                                          TC is TC2 + 1,
                                          E = trans(Count,Count1):
                                              trans(yes,Count1,Count2):
                                              trans(TC2,Count1):
                                              trans(no,Count1,TC):
                                              B:trans(TC2,TC),
                                          E1 = def(Count,point,start_while):
                                               def(Count1,diamond,T1):
                                               B1:def(TC2,point,end_while).
loop(dw(dwbody(T1),dwargs(T2)),E,E1,Count,TC):- Count1 is Count + 1,
                                          Count2 is Count1 + 1, 
                                          sequence(T1,B,B1,Count2,TC1),
                                          TC2 is TC1 + 1,
                                          TC3 is TC2 + 1,
                                          TC is TC3 + 1,
                                          E = trans(Count,Count1):
                                              B:trans(yes,TC2,TC3):
                                              trans(TC3,Count1):
                                              trans(no,TC2,TC),
                                          E1 = def(Count1,point,start_dowhile):
                                               B1:def(TC2,diamond,T2):
                                               def(TC3,point,end_dowhile).
condition(if(ifargs(T1),ifbody(T2)),E,E1,Count,TC,_) :- Count1 is Count + 1,
                                   Count2 is Count1 + 1,
                                   sequence(T2,B,B1,Count2,TC),
                                   %TC is TC1 + 1,
                                   E = trans(Count,Count1):
                                       trans(yes,Count1,Count2):
                                       trans(no,Count1,TC):B,
                                   E1 = def(Count,point,start_if):
                                        def(Count1,diamond,T1):
                                        B1:def(TC,point,end_if).
condition(else(elsebody(T)),E,E1,Count,TC,_) :- Sub is Count - 1,
                                   Count1 is Count + 1,
                                   Count2 is Count1 + 1,
                                   sequence(T,B,B1,Count2,TC),
                                   E = trans(Sub,Count):
                                       trans(Count,Count1):
                                       trans(Count1,Count2):B,
                                   E1 = def(Count,point,start_else):
                                        def(Count1,diamond):
                                        B1:def(TC,point,end_else).
condition(elseif(elseifargs(T1),elseifbody(T2)),E,E1,Count,TC,_) :- Count1 is Count + 1,
                                   Count2 is Count1 + 1,
                                   sequence(T2,B,B1,Count2,TC1),
                                   TC is TC1 + 1,
                                   TC2 is TC + 1,
                                   E = trans(Count,Count1):
                                       trans(yes,Count1,Count2):
                                       trans(no,Count1,TC2):B,
                                   E1 = def(Count,point,start_elseif):
                                        def(Count1,diamond,T1):
                                        B1:def(TC,point,end_elseif).
condition(sc(scargs(T1),T2),E,E1,Count,TC) :-  Count1 is Count + 1, 
                                        case(T2,B,B1,Count1,TC,[],Count),
                                        E = trans(Count,Count1):B,
                                        E1 = def(Count,diamond,T1):B1.
case(case(default,casebody(T)),E,E1,Count,TC,I1,_) :- sequence(T,B,B1,Count,TC1),
                                                push(I2,I1,TC1),
                                                TC is TC1 + 1,
                                                pop(I2,X),
                                                E = B:trans(X,TC),
                                                E1 = B1.
case(case(caseargs(T1),casebody(T2)),E,E1,Count,TC,I1,_) :- Count1 is Count + 1,
                                                sequence(T2,B,B1,Count1,TC1),
                                                push(I2,I1,TC1),
                                                TC is TC1 + 1,
                                                pop(I2,X),
                                                E = trans(Count,Count1):
                                                    B:trans(X,TC),
                                                E1 = def(Count,rectangle,T1):B1.
case(case(caseargs(T1),casebody(T2)):T3,E,E1,Count,TC,I1,Flag) :- Count1 is Count + 1,
                                                sequence(T2,A,A1,Count1,TC1),
                                                push(I2,I1,TC1),
                                                TC2 is TC1 + 1,
                                                case(T3,B,B1,TC2,TC,I2,Flag),
                                                E = trans(Count,Count1):
                                                    A:trans(Flag,TC2):B,
                                                E1 = def(Count,rectangle,T1):A1:B1. 

pop([],[]).
pop([X|Xs],[X|Ys]) :- pop(Xs,Ys). 

push([X|Xs],Xs,X).