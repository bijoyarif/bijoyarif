preprocessor(E,E1) :- prp(E,E1).

prp(null,null).

prp(T1:T2,E) :- prp(T1,E1), prp(T2,E2), E = E1:E2.
prp(def(X,Y),E) :- E = def(X,Y).
prp(def(X,parallelogram,T),E) :- ps(T,E1), 
                                string_concat('arg(',E1,String1),
                                string_concat(String1,')',String),
                                E = def(X,parallelogram,String). 
prp(def(X,Y,T),E) :- p(T,E1), E = def(X,Y,E1).
prp(def(X,Y,T1):T2,E) :- p(T1,E1), prp(T2,E2), E = def(X,Y,E1):E2.

ps(T1:T2,E):- p(T1,E1), ps(T2,E2), string_concat(E1,E2,E),!.
ps(T,E) :- p(T,E).

p(start,start).
p(end,end).
p(E,E) :- E = start_if; E = end_if; E = start_for; E = end_for; 
            E = start_while; E = end_while; E = start_dowhile; E = end_dowhile;
            E = start_else; E = end_else; E = start_elseif; E = end_elseif;
            E = start_cond; E = end_cond. 
p(int(X),E) :- E = X.
p(id(X),E) :- E = X.
p(id(X):array(Y),E) :- p(Y,E1), string_concat(X,'[',C1),
                string_concat(C1,E1,C2), string_concat(C2,']',E),!.
p(key(X):T,E) :- X = return, p(T,E1), string_concat('return(',E1,C),
                 string_concat(C,')',E).
p(key(X):T,E) :- (X = int; X = void; X = float; X = 'String';
                X = short; X = byte; X = long; X = double; X = char; X = boolean),  
                p(T,E1),
                string_concat('def(',E1,C), 
                string_concat(C,':',C1),
                string_concat(C1,X,C2),
                string_concat(C2,')',E).
p(T1:T2,E) :- p(T1,E1), p(T2,E2), string_concat(E1,'\n',E3), string_concat(E3,E2,E).

p(asign(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('assign(',E1,C),
                      string_concat(C,',',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(add_asign(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond (',E1,C), 
                      string_concat(C,',+=,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(sub_asign(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',-=,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(mult_asign(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',*=,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(div_asign(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',/=,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(mod_asign(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',%=,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(or(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',||,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(and(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',&&,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(b_inc_or(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',|,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(b_exc_or(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',^,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(b_and(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',&,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(equal(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',==,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(n_equal(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',!=,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(lt(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',<,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(le(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',<=,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(gt(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',>,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(ge(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',>=,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(b_l_shift(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',<<,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(b_r_shift(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',>>,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(b_r0_shift(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',>>>,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(add(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',+,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(sub(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',-,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(mult(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',*,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(divi(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',/,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(modu(T1,T2),E) :- p(T1,E1), p(T2,E2),
                      string_concat('relcond(',E1,C), 
                      string_concat(C,',%,',C1),
                      string_concat(C1,E2,C2),
                      string_concat(C2,')',E).

p(u_pre_inc(T),E) :- p(T,E1),
                        string_concat('relcond(','++,',C),
                        string_concat(C,E1,C2),
                        string_concat(C2,')',E).

p(u_pre_dec(T),E) :- p(T,E1),
                        string_concat('relcond(','--,',C),
                        string_concat(C,E1,C2),
                        string_concat(C2,')',E).

p(u_plus(T),E) :- p(T,E1),
                        string_concat('relcond(','+,',C),
                        string_concat(C,E1,C2),
                        string_concat(C2,')',E).

p(u_minus(T),E) :- p(T,E1),
                        string_concat('relcond(','-,',C),
                        string_concat(C,E1,C2),
                        string_concat(C2,')',E).

p(u_com(T),E) :- p(T,E1),
                        string_concat('relcond(','~,',C),
                        string_concat(C,E1,C2),
                        string_concat(C2,')',E).

p(u_post_inc(T),E) :- p(T,E1),
                        string_concat('relcond(',E1,C),
                        string_concat(C,',++)',E).

p(u_post_dec(T),E) :- p(T,E1),
                        string_concat('relcond(',E1,C),
                        string_concat(C,',--)',E).



















