%:- set_prolog_stack(global, limit(100 000 000 000)).
%:- set_prolog_stack(trail,  limit(20 000 000 000)).
%:- set_prolog_stack(local,  limit(2 000 000 000)).


% component loading
?- ['final_scanner.pl'].
?- ['java_mini_parser.pl'].
?- ['java_flow.pl'].

?- ['java_processor.pl'].
?- ['java_grammar.pl'].
?- ['dot_graph.pl'].

% -----------------------------------------------------------------------------------------


generic_test(SourceFilename,GrammarFilename1,DotFilename2,Output1,Output2,Program_AST,E,Input_Tokens) :-
                                          
                         readfile(SourceFilename,Input_Tokens),

                         prog(Program_AST,Input_Tokens,[]),
                         controlflow(Program_AST,Output2,Output1),
                         preprocessor(Output1,E),
                         grammar(GrammarFilename1,E),
                        dot(DotFilename2,E,Output2).
% -----------------------------------------------------------------------------------------

 
