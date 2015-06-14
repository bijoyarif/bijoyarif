# bijoyarif
CaT_simulator

The initiative of CaT simulator came while I was working on MS in Computer Science in thesis equivalent project to develop a grammar-based white box testing tool. Initially, I have plan to make a tool which can do full-fledged of white box testing. I have written my proposal on mutants based software testing tool using B-prolog. Eventually, I gave up my idea to use B-prolog in fear of I could not finish my work in a timely manner, but that was the one of biggest mistakes in my software development career so far.  I believe if I would use B-prolog then I could finish much earlier. Somehow  I have been compelled to use SWI-prolog which is much familiar to me and it took much longer to finish the whole project, only thing I could deserve is a deep sigh.             

Motivated by the work of Bjarne Stroustrop's simulator on developing C++ while working in Bell lab to incorporate B with Simula, a well-established object oriented programming language.

All the modules in simulator are written using the standard first order logic clause or definite clause grammar. I have written a module for generating the control flow of execution. I believe there is some buffer overflow problems in the code, otherwise all other modules are well written, thoroughly checked and can simulate the syntactical and semantic constructs. The structure of my simulator is given below:

(i) scanner ---> final_scanner.pl, {DCG}
(ii) parser ---> parser.pl,{DCG}
(iii) controlflow ---> controlflow.pl, {DCG}

The modules given below are associated with the project of grammar-based white box testing. They can convert the semantic constructs to grammar. It  is like a reverse process of conventional simulator or compiler; because the initiative of work is based on making a bridge between Mid-Low level abstraction of computer languages.        

During my MS years in UNO, I have faced intentional and unintentional trespassing in my project, hence, I could not guarantee that my simulator is bug-free and you have to use it at your own risk.
