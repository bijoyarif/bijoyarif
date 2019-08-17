prog(E) --> cMethods(E).

cMethods(cMethod(M):Ms) --> cMethod(M), cMethods(Ms).
cMethods(cMethod(null)) --> [].

cMethod(method(Head,Body)) --> mHead(Head),['{'],mBody(Body),['}'].

mHead(mHead(S,D,X,arg(Y))) --> scope(S),dynamic(D),term15(X),['('],mArg(Y),[')'].

scope(private) --> [private].
scope(public) --> [public].
scope(null) --> [].

dynamic(static) --> [static].
dynamic(not) --> [].

mArg(Y) --> expression(Y).
mArg(null) --> [].

mBody(mBody(Body)) --> c_block(Body).
mBody(mBody(null)) --> [].

c_block(E) --> ['{'],['}'],c_block_expr(T),({E=T};(c_block(T1),{E=(T:T1)})).
c_block(E) --> ['{'],loop_block(T1),['}'],c_block_expr(T,T1),({E=T};(c_block(T2),{E=(T:T2)})).
c_block(E) --> loop_block(E).
c_block_expr(block(T),T) --> [].
c_block_expr(block(null)) --> [].

loop_block(E) --> loopblock(T),({E=T};(c_block(T1),{E=(T:T1)})).

loopblock(loop(for(T1,T2))) --> [for],fargs(T1),fbody(T2).
loopblock(loop(while(T1,T2))) --> [while],wargs(T1),wbody(T2).
loopblock(loop(dw(T1,T2))) --> [do],dwbody(T1),[while],dwargs(T2),[;].
loopblock(E) --> cond_block(E).
fargs(fargs(T1,T2,T3)) --> ['('],larg(T1),[;],larg(T2),[;],larg(T3),[')'].
fbody(fbody(T)) --> c_block(T).
wargs(wargs(T)) --> ['('],larg(T),[')'].
wbody(wbody(T)) --> c_block(T).
dwargs(dwargs(T)) --> ['('],larg(T),[')'].
dwbody(dwbody(T)) --> c_block(T).
larg(T) --> term1(T).
larg(null) --> [].

cond_block(E) --> condblock(T),({E=T};(c_block(T1),{E=(T:T1)})).

condblock(cond(E)) --> condition(E).
condblock(E) --> expression(E).

condition(E) --> cond(T),({E=T};(cond_ex(T1),{E=(T:T1)})).
%condition(if(T1,T2)) --> [if],ifargs(T1),ifbody(T2).
condition(sc(T1,T2)) --> [switch],scargs(T1),['{'],scbody(T2),['}'].
condition(tc(T1,T2)) --> [try],tcbody(T1),tcargs(T2).

cond(if(T1,T2)) --> [if],ifargs(T1),ifbody(T2).
%cond_ex(E) --> condex(T),({E=T};(cond_ex(T1),{E=(T:T1)})). 
%condex(elseif(T1,T2)) --> [else],[if],elseifargs(T1),elseifbody(T2). 
cond_ex(else(T)) --> [else],elsebody(T).

ifargs(ifargs(T)) --> ['('],cargs(T),[')'].
ifbody(ifbody(T)) --> c_block(T).
elsebody(elsebody(T)) --> c_block(T).
%elseifargs(elseifargs(T)) --> ['('],cargs(T),[')'].
%elseifbody(elseifbody(T)) --> c_block(T).
scargs(scargs(T)) --> ['('],cargs(T),[')'].
scbody(E) --> case(T),({E=T};(scbody(T1),{E=T:T1})).
scbody(null) --> [].
case(case(T1,T2)) --> [case],caseargs(T1),[:],casebody(T2).
case(case(default,T)) --> [default],[:],casebody(T).
tcbody(tcbody(T)) --> c_block(T).
tcbody(null) --> [].
tcargs(tcargs(T1,T2)) --> [catch],catchs(T1),finally(T2).
catchs(catchs(T1,T2)) --> catchargs(T1),catchbody(T2).
catchargs(catchargs(T)) --> cargs(T).
catchbody(catchbody(T)) --> c_block(T).
finally(finally(T)) --> [finally],c_block(T).
finally(null) --> []. 
caseargs(caseargs(T)) --> cargs(T).
casebody(casebody(T)) --> c_block(T).
cargs(T) --> term1(T).
cargs(null) --> [].

expression(E) --> term1(T),(([;],ex_expr(E,T));
                           ([;],c_block(T1),ex_expr(E,T,T1));
                           ([,],expression(T1),arg_expr(E,T,T1))).
expression(E) --> term1(E).
ex_expr(expr(T):T1,T,T1) --> [].
ex_expr(expr(T),T) --> [].
arg_expr(T:T1,T,T1) --> [].

term1(E) --> term2(T),  ({E=T};
                        ([=],right_assoc(E,T,asign));
                        (['+='],right_assoc(E,T,add_asign));
                        (['-='],right_assoc(E,T,sub_asign));
                        (['*='],right_assoc(E,T,mult_asign));
                        (['/='],right_assoc(E,T,div_asign));
                        (['%='],right_assoc(E,T,mod_asign))).

term2(T) --> term3(T).

term3(E) --> term4(T), ({E=T};
                       (['||'],left_assoc(E,T,or))).

term4(E) --> term5(T),  ({E=T};
                        (['&&'],left_assoc(E,T,and))).

term5(E) --> term6(T),  ({E=T};
                        (['|'],left_assoc(E,T,b_inc_or))).

term6(E) --> term7(T),  ({E=T};
                        ([^],left_assoc(E,T,b_exc_or))).

term7(E) --> term8(T),   ({E=T};
                         ([&],left_assoc(E,T,b_and))).

term8(E) --> term9(T),   ({E=T};
                         ([==],left_assoc(E,T,equal));
                         (['!='],left_assoc(E,T,n_equal))).

term9(E) --> term10(T),  ({E=T};
                         ([<],left_assoc(E,T,lt));
                         ([<=],left_assoc(E,T,le));
                         ([>],left_assoc(E,T,gt));
                         ([>=],!,left_assoc(E,T,ge))).

term10(E) --> term11(T),  ({E=T};
                          ([<<],left_assoc(E,T,b_l_shift));
                          ([>>],left_assoc(E,T,b_r_shift));
                          ([>>>],left_assoc(E,T,b_r0_shift))).

term11(E) --> term12(T),  ({E=T};
                          ([+],left_assoc(E,T,add));
                          ([-],left_assoc(E,T,sub))).

term12(E) --> term13(T),  ({E=T};
                          ([*],left_assoc(E,T,mult));
                          ([/],left_assoc(E,T,divi));
                          (['%'],left_assoc(E,T,modu))).

term13(T) --> term14(T).
term13(E) --> [++],right_assoc(E,u_pre_inc).
term13(E) --> [--],right_assoc(E,u_pre_dec).
term13(E) --> [+],right_assoc(E,u_plus).
term13(E) --> [-],right_assoc(E,u_minus).
term13(E) --> [!],right_assoc(E,u_neg).
term13(E) --> [~],right_assoc(E,u_com).

term14(E) --> term15(T),  ({E=T};
                          ([++],left_assoc(E,T,u_post_inc));
                          ([--],left_assoc(E,T,u_post_dec))).

term15(T) --> ['('],term1(T),[')'].

term15(int(Int)) --> [Int],{integer(Int) }.
term15(E) --> [Id],{is_id(Id)},id_expr(T,Id),({E=T};
                                             (body(X),body_expr(E,T,X))).
term15(E) --> [X],{key(X)},key_expr(T,X),term1(Y),key_ex_expr(E,T,Y).
term15(E) --> [X],{key(X)},key_expr(E,X).
id_expr(id(Id),Id) --> [].
body(function(X)) --> ['('],args(X),[')'].
body(array(X)) --> ['['],args(X),[']'].
body_expr(T:X,T,X) --> [].
key_expr(key(X),X) --> [].
key_ex_expr(T:Y,T,Y) --> [].
args(X) --> expression(X).
args(null) --> []. 
is_id(Id) :- not(key(Id)), not(integer(Id)), not(operator(Id)), not(reserve(Id)).

key(void).
key(byte).
key(short).
key(int).
key(long).
key(float).
key(double).
key(char).
key('String').
key(boolean).
key(new).
key(return).
key(public).
key(private).
key(static).

reserve(else).
reserve(if).

operator(;).
operator(++).
operator(--).
operator(=).

right_assoc(asign(T,T1),T,asign) --> term1(T1).
right_assoc(add_asign(T,T1),T,add_asign) --> term1(T1).
right_assoc(mult_asign(T,T1),T,mult_asign) --> term1(T1).
right_assoc(div_asign(T,T1),T,div_asign) --> term1(T1).
right_assoc(mod_asign(T,T1),T,mod_asign) --> term1(T1).

right_assoc(u_pre_inc(T),u_pre_inc) --> term13(T).
right_assoc(u_pre_dec(T),u_pre_dec) --> term13(T).
right_assoc(u_plus(T),u_plus) --> term13(T).
right_assoc(u_minus(T),u_minus) --> term13(T).
right_assoc(u_neg(T),u_neg) --> term13(T).
right_assoc(u_com(T),u_com) --> term13(T).

left_assoc(E,E).

left_assoc(or(T,T1),T,or) --> term4(T1).

left_assoc(and(T,T1),T,and) --> term5(T1).

left_assoc(b_inc_or(T,T1),T,b_inc_or) --> term6(T1).

left_assoc(b_exc_or(T,T1),T,b_exc_or) --> term7(T1).

left_assoc(b_and(T,T1),T,b_and) --> term8(T1).

left_assoc(equal(T,T1),T,equal) --> term9(T1).

left_assoc(n_equal(T,T1),T,n_equal) --> term9(T1).

left_assoc(lt(T,T1),T,lt) --> term10(T1).
left_assoc(le(T,T1),T,le) --> term10(T1).
left_assoc(gt(T,T1),T,gt) --> term10(T1).
left_assoc(ge(T,T1),T,ge) --> term10(T1).

left_assoc(b_l_shift(T,T1),T,b_l_shift) --> term11(T1).
left_assoc(b_r_shift(T,T1),T,b_r_shift) --> term11(T1).
left_assoc(b_r0_shift(T,T1),T,b_r0_shift) --> term11(T1).

left_assoc(add(T,T1),T,add) --> term12(T1).
left_assoc(sub(T,T1),T,sub) --> term12(T1).

left_assoc(mult(T,T1),T,mult) --> term13(T1).
left_assoc(divi(T,T1),T,divi) --> term13(T1).
left_assoc(modu(T,T1),T,modu) --> term13(T1).

left_assoc(u_post_inc(T),T,u_post_inc) --> [].
left_assoc(u_post_dec(T),T,u_post_dec) --> [].

left_assoc(E,T,or) --> term4(T1),['||'],left_assoc(E,or(T,T1),or).

left_assoc(E,T,and) --> term5(T1),['&&'],left_assoc(E,or(T,T1),and).

left_assoc(E,T,b_inc_or) --> term6(T1),['|'],left_assoc(E,b_inc_or(T,T1),b_inc_or). 

left_assoc(E,T,b_exc_or) --> term7(T1),[^],left_assoc(E,b_exc_or(T,T1),b_exc_or).

left_assoc(E,T,b_and) --> term8(T1),[&],left_assoc(E,b_and(T,T1),b_and).

left_assoc(E,T,equal) --> term9(T1),(([==],left_assoc(E,equal(T,T1),equal));   
                                    (['!='],left_assoc(E,equal(T,T1),n_equal))).
left_assoc(E,T,n_equal) --> term9(T1),((['!='],left_assoc(E,n_equal(T,T1),n_equal));
                                      ([==],left_assoc(E,n_equal(T,T1),equal))).  

left_assoc(E,T,lt) --> term10(T1),(([<],left_assoc(E,lt(T,T1),lt)); 
                                  ([<=],left_assoc(E,lt(T,T1),le));
                                  ([>],left_assoc(E,lt(T,T1),gt));
                                  ([>=],left_assoc(E,lt(T,T1),ge))).
left_assoc(E,T,le) --> term10(T1),(([<],left_assoc(E,le(T,T1),lt)); 
                                  ([<=],left_assoc(E,le(T,T1),le));
                                  ([>],left_assoc(E,le(T,T1),gt));
                                  ([>=],left_assoc(E,le(T,T1),ge))).
left_assoc(E,T,gt) --> term10(T1),(([<],left_assoc(E,gt(T,T1),lt)); 
                                  ([<=],left_assoc(E,gt(T,T1),le));
                                  ([>],left_assoc(E,gt(T,T1),gt));
                                  ([>=],left_assoc(E,gt(T,T1),ge))).
left_assoc(E,T,ge) --> term10(T1),(([<],left_assoc(E,ge(T,T1),lt)); 
                                  ([<=],left_assoc(E,ge(T,T1),le));
                                  ([>],left_assoc(E,lge(T,T1),gt));
                                  ([>=],left_assoc(E,ge(T,T1),ge))).

left_assoc(E,T,b_l_shift) --> term11(T1),(([<<],left_assoc(E,b_l_shift(T,T1),b_l_shift));
                                         ([>>],left_assoc(E,b_l_shift(T,T1),b_r_shift));
                                         ([>>>],left_assoc(E,b_l_shift(T,T1),b_r0_shift))).
left_assoc(E,T,b_r_shift) --> term11(T1),(([<<],left_assoc(E,b_r_shift(T,T1),b_l_shift));
                                         ([>>],left_assoc(E,b_r_shift(T,T1),b_r_shift));
                                         ([>>>],left_assoc(E,b_r_shift(T,T1),b_r0_shift))).
left_assoc(E,T,b_r0_shift) --> term11(T1),(([<<],left_assoc(E,b_r0_shift(T,T1),b_l_shift));
                                          ([>>],left_assoc(E,b_r0_shift(T,T1),b_r_shift));
                                          ([>>>],left_assoc(E,b_r0_shift(T,T1),b_r0_shift))).

left_assoc(E,T,add) --> term12(T1),(([+],left_assoc(E,add(T,T1),add));
                                   ([-],left_assoc(E,add(T,T1),sub))).
left_assoc(E,T,sub) --> term12(T1),(([+],left_assoc(E,sub(T,T1),add));
                                   ([-],left_assoc(E,sub(T,T1),sub))).

left_assoc(E,T,mult) --> term13(T1),(([*],left_assoc(E,mult(T,T1),mult));
                                    ([/],left_assoc(E,mult(T,T1),divi));
                                    (['%'],left_assoc(E,mult(T,T1),modu))).
left_assoc(E,T,divi) --> term13(T1),(([*],left_assoc(E,divi(T,T1),mult));
                                   ([/],left_assoc(E,divi(T,T1),divi));
                                   (['%'],left_assoc(E,divi(T,T1),modu))).
left_assoc(E,T,modu) --> term13(T1),(([*],left_assoc(E,modu(T,T1),mult));
                                   ([/],left_assoc(E,modu(T,T1),divi));
                                   (['%'],left_assoc(E,modu(T,T1),modu))).

left_assoc(E,T,u_post_inc) --> [++],left_assoc(E,u_post_inc(T),u_post_inc).
left_assoc(E,T,u_post_inc) --> [--],left_assoc(E,u_post_inc(T),u_post_dec).
left_assoc(E,T,u_post_dec) --> [++],left_assoc(E,u_post_dec(T),u_post_inc).
left_assoc(E,T,u_post_dec) --> [--],left_assoc(E,u_post_dec(T),u_post_dec).

