%DOMASNA 1 TIJANA ATANASOVSKA (196014)
%Pobrzo prebaruvanje na zadacaite -> crtl+F Zadaca broj
%Dokolku nekoja od zadacite ne go dava odgovorot, izvrsete ja posebno vo nova Prolog okolina. (poradi isti iminja na predikati, moze da nastane problem)

%Zadaca 1 
neparen(X):-Y is X/2, float(Y).
dolzina([],0).
dolzina([Glava|Opaska],X):-dolzina(Opaska,Y),X is Y+1.

dodadi([],L, L).
dodadi([X|O],L,[X|NL]) :- dodadi(O,L,NL).

prevrti([],[]).
prevrti([X|L1],L2):-prevrti(L1,L),dodadi(L,[X],L2).
check(L1):-dolzina(L1,X),neparen(X).
neparen_palindrom(L1):-check(L1),prevrti(L1,Z),not(Z\=L1).



%Zadaca 2
dolzina([],0).
dolzina([X|L1], N):-dolzina(L1,M), N is M+1.

podlista(L1,L2):-nadvoresen(L1,L2).

nadvoresen([X|L1],[X|L2]):-vnatresen(L1,L2).
nadvoresen([X|L1],L2):-nadvoresen(L1,L2).

vnatresen(L1,[]).
vnatresen([X|L1],[X|L2]):-vnatresen(L1,L2).

zemi_podlista_N(Lista,Podlista,N):-podlista(Lista, Podlista),
    						dolzina(Podlista,Len), N==Len.

kolku_pati(Lista,Podlista,N):-findall(_,podlista(Lista,Podlista),Pati), 
    						dolzina(Pati,N).

%Cut za da ne vrakja false posle najdenoto resenie.
maksimum([X|L],M):-maks(L,X,M),!.
maks([X|L],T,M):-X>T, maks(L,X,M).
maks([X|L],T,M):-X=<T, maks(L,T,M).
maks([],T,T).

lista_kolku_pati(L,N,Kolku):-findall(Podlista, zemi_podlista_N(L,Podlista,N), Podlisti_N), 
    						member(PodlistaTemp, Podlisti_N), 
    						kolku_pati(L,PodlistaTemp, Kolku).

naj_podniza(L,N,Result):-findall(Kolku,lista_kolku_pati(L,N,Kolku),Collection_Kolku),
    maksimum(Collection_Kolku, Max),
    findall(Podlista,zemi_podlista_N(L,Podlista,N),Collection_Podlisti),
    member(Result,Collection_Podlisti),
    kolku_pati(L,Result,Pati),Pati==Max,!.




%Zadaca 3
dolzina([],0).
dolzina([_|Opaska],N):-dolzina(Opaska, X), N is X+1.

%proverka dali vtoriot element vo listata e pogolem od prviot
vtoriot_e_pogolem([X,Y|_]):-X<Y.

zig(L):-vtoriot_e_pogolem(L).

% Ignoriraj go prviot element i proveri dali vtoriot e pomal od prviot so pomos na negacija

zag([_|L]):-not(vtoriot_e_pogolem(L)).

%otstrani gi prviot i vtoriot element od listata
ostatok_lista([_,_|L],L).


%Ako ima ostanato eden element vrati true.
zig_zag([_]).
%Ako listata ima samo 2 elementi, treba da se provere samo ZIG
zig_zag(L):-dolzina(L,N),N is 2,zig(L).


%Rekurziven povik! Koga listata ima povekje od 2 elementi 
% se proveruva ZIG za prviot i vtoriot element,
% a potoa ZAG za vtoriot i tretiot element. 
%Togas se brisat prviot i vtoriot el, a tretiot ne bidejki potreben e za da se proveri
% ZIG megju nego i cetvrtiot element. Se pravi rekurziven povik za ostanatite elementi.
%Osnovniot slucaj na zig_zag e koga vo listata ima ostanato eden element, togas nema povekje proverki.
%Stom do tamu bile ispolneti uslovite i ima ostanato samo 1 element znaci uslovite se celosno zadovoleni,
% pa nazad niz povicite vrakjame samo true.
%Drugiot osnoven slucaj e koga listata ima samo 2 elementi, pa se proveru samo ZIG.
zig_zag(L):-zig(L), zag(L), ostatok_lista(L,L1), zig_zag(L1).
 
proveri(L):-dolzina(L,X),X>=2,zig_zag(L),!.




%Zadaca 4
dodadi_zad4([],L, L).
dodadi_zad4([X|O],L,[X|NL]) :- dodadi_zad4(O,L,NL).

permutacija_X(Lista,Element,Permutation):-dodadi_zad4(X,Y,Lista),
    									dodadi_zad4(X,[Element],L1),
    									dodadi_zad4(L1,Y,Permutation).

permutacija([X],[X]).
permutacija([Head|Tail],Res):-permutacija(Tail,Res2),permutacija_X(Res2,Head,L), append(L,[],Res).


permutacii(Input,Output):-findall(Res,permutacija(Input,Res),Output).

%faktoriel(1,1):-!.
%faktoriel(N,Out):-S is N-1,faktoriel(S,M),Out is (M*N).
%permutacii(Input,Output):-findall(Res,permutacija(Input,Res),Output),
 %   length(Input, InpLen),length(Output,OutLen),
  %  faktoriel(InpLen,FaktRes),FaktRes==OutLen.



%Zadaca 5
%SOBIRANJE
% fakt(Sobirok1, Sobirok2, Prethodno, Zapishi, Pamti)
fakt(1,1,0,0,1).
fakt(1,1,1,1,1).
fakt(1,0,0,1,0).
fakt(1,0,1,0,1).
fakt(0,1,0,1,0).
fakt(0,1,1,0,1).
fakt(0,0,0,0,0).
fakt(0,0,1,1,0).

%Predikat potreben za implementacija na predikatot Prevrti
dodadi_zad5([],L, L).
dodadi_zad5([X|O],L,[X|NL]) :- dodadi_zad5(O,L,NL).
%Predikat potreben za da se prevrti listata vo obraten redosled
prevrti([],[]).
prevrti([X|L1],L2):-prevrti(L1,L),dodadi_zad5(L,[X],L2).


sobiranje_helper([],L2,0,L2).
sobiranje_helper(L1,[],0,L1).
sobiranje_helper([],[],1,[1]).
sobiranje_helper([Head1|Tail1],[],1,[Zapishi|SubResult]):-
    fakt(Head1,1,0,Zapishi,Pamti),sobiranje_helper(Tail1,[],Pamti,SubResult).

sobiranje_helper([],[Head2|Tail2],1,[Zapishi|SubResult]):-
    fakt(Head2,1,0,Zapishi,Pamti),sobiranje_helper([],Tail2,Pamti,SubResult).

sobiranje_helper([Head1|Tail1], [Head2|Tail2], Prethodno,[Zapishi|SubResult])
				:-fakt(Head1,Head2,Prethodno,Zapishi,Pamti),
    			sobiranje_helper(Tail1,Tail2,Pamti,SubResult).
    			
    
%Cut operator za da ne vrakja false.    
sobiranje(L1,L2,Result):-prevrti(L1,P1),prevrti(L2,P2),
    					sobiranje_helper(P1,P2,0,ResultReversed),
    					prevrti(ResultReversed,Result),!.



%ODZEMANJE
%odzemanje A-B <=>A+two_complement(B)<=>A+(inverse(B)+1)

inverse(1,0).
inverse(0,1).

invert_binary([],[]).
invert_binary([Head|Tail],[Inverted|Result]):-inverse(Head,Inverted),invert_binary(Tail,Result).

two_complement(L1,Result):-invert_binary(L1,P1),prevrti(P1,R1),sobiranje_helper(R1,[1],0,ResultReversed),prevrti(ResultReversed,Result).

popolni_nuli(L1,0,L1):-!.
popolni_nuli(L1,N,[0|Result]):-M is N-1,popolni_nuli(L1,M,Result).

otstrani_nuli([1|Tail],[1|Tail]).
otstrani_nuli([Head|Tail],Result):-Head=0,otstrani_nuli(Tail,Result).

odzemanje(L1,L2,Result):-length(L1,N1),length(L2,N2),Subs is N1-N2,
    					popolni_nuli(L2,Subs,L22),two_complement(L22,InvertedL2),
    					sobiranje(L1,InvertedL2,[_|ResultWithZeros]),
    					otstrani_nuli(ResultWithZeros,Result),!.


%MNOZENJE

shift_desno([X],[X,0]).
shift_desno([X|L],[X|Res]):-shift_desno(L,Res),!.

mnozenje_helper(Mnozenik, SubResult, [], SubResult).

mnozenje_helper(Mnozenik, SubResult, [X|OstatokMnozitel], Result):-
    						X==0,shift_desno(Mnozenik,ShiftMnozenik),
    						mnozenje_helper(ShiftMnozenik,SubResult,OstatokMnozitel,Result).

 mnozenje_helper(Mnozenik, SubResult, [X|OstatokMnozitel],Result):-
    						X==1,shift_desno(Mnozenik,ShiftMnozenik),
    						sobiranje(Mnozenik,SubResult,PodRezultat),
    						mnozenje_helper(ShiftMnozenik,PodRezultat,OstatokMnozitel,Result).   
    
mnozenje(Mnozenik, Mnozitel,Result):-prevrti(Mnozitel, PrevrtenMnozitel),
    							mnozenje_helper(Mnozenik,[0],PrevrtenMnozitel,Result),!. 



%DELENJE
delenje_helper(L1,L2,1):-L1==L2.
delenje_helper(L1,L2,Times):-odzemanje(L1,L2,Result),
    						delenje_helper(Result,L2,SubTimes), Times is SubTimes+1.

%Cut operator za da ne prodolzi nazad kon delenjeto ednas koga ke go zavrsi do kraj.
delenje(L1,L2,Result):-delenje_helper(L1,L2,Dekaden),!, 
    dekaden_vo_binaren(Dekaden, PrevrtenBinaren), prevrti(PrevrtenBinaren, Result).

% za da pretvorime dekaden vo binaren, treba brojot da se deli so 2 dodeka ne stigneme do ostatok 0
%cut operator za da ne prodolzi so rekurzijata pri vrakanje nazad, ednas koga ke ja izvrsi so kraj
dekaden_vo_binaren(0, []):-!.
dekaden_vo_binaren(Dekaden, [0|L]):- 0 is mod(Dekaden,2),OstatokDek is div(Dekaden,2),
    								dekaden_vo_binaren(OstatokDek,L).
dekaden_vo_binaren(Dekaden, [1|L]):-1 is mod(Dekaden,2),OstatokDek is div(Dekaden,2),
    								dekaden_vo_binaren(OstatokDek,L).





%Zadaca 6
% Za site pozicii vo redicite da se povika zemi_prvi koja ke vrakja lista so prvite el
% od site redici. I se taka, dodeka ima elementi vo redicite.

%Zemi go prviot element od redicata i vrati go vo X, ostanatite elementi vrati gi vo OstatokRedica

% Od sekoja redica prvite elementi dodadi gi vo Result, a ostatocite od redicite vrati gi kako nova matrica OstatokMatrica
zemi_prv([X|OstatokRedica],X,OstatokRedica).
zemi_prvi([],[],[]).
zemi_prvi([Redica|SubMatrix],NovaRedica,OstatokMatrica):-
    				zemi_prv(Redica,Prv,OstatokRedica),
    				zemi_prvi(SubMatrix,Prvi,OstatokRedici),
    				append([Prv],Prvi,NovaRedica),
    				append([OstatokRedica],OstatokRedici,OstatokMatrica).
% Uslovot za stopiranje e prvata redica da nema povekje elementi -> implicira site redici se isprazneti.

% Prvite elementi od site redici gi zemame so predikatot zemi_prvi i gi smestuvame vo NovaRedica, a ostatokot od matrica vo OstatokMAtrica
% Postapkata ja povtoruvame rekurzivno za site redici vo matricata dodeka imaat elementi.
% Na vrakjanje nazad novo-kreiranata redica (kolona od starata matrica) se dodava so drugite transponirani koloni vo rezultantna lista T.
% T e lista od listi <=> MATRICA T
transpose([[]|_],[]).
transpose(M,T):-zemi_prvi(M,NovaRedica,OstatokMatrica),
    			transpose(OstatokMatrica,T1),
    			append([NovaRedica],T1,T).


% Mnozenje na dve redici (ili kolona so redica, zavisno sto ke se dade na vlez)
% Pomnozi soodvetnite elementi na redicite
mnozi_elementi([],[],[]).
mnozi_elementi([E1|R1],[E2|R2],Pomnozeni):- Mnozitel is E1*E2, 
    										mnozi_elementi(R1,R2,SubResult),
    										append([Mnozitel],SubResult,Pomnozeni).

%Sobiranje na elementi vo lista
soberi_elementi([],0).
soberi_elementi([X|L],Result):-soberi_elementi(L,SubResult), Result is X+SubResult.

% glaven predikat za mnozenje na redici koj vo Result vrakja edinstven broj
mnozi_redici(R1,R2,Result):-mnozi_elementi(R1,R2,Pomnozeni),soberi_elementi(Pomnozeni,Result).

%mnozi_matrici([[]|_],[[]|_],[]).
mnozi_matrici(M1,M2,R):-member(RM1,M1),member(RM2,M2),mnozi_redici(RM1,RM2,R).

% Podelba na lista L vo podlisti so dolzina N -> kreiranje Matrica cii redici se so dolzina N
podeli_N_elements_helper(L,0,[],L).
podeli_N_elements_helper([E|L],N,[E|SubRes],R):-
    						M is N-1, 
    						podeli_N_elements_helper(L,M,SubRes,R).
    
podeli_N_elements([],_,[]).
podeli_N_elements(L,N,M):-podeli_N_elements_helper(L,N,SubRes,OstatokList),
    					podeli_N_elements(OstatokList,N,M1),
    					append([SubRes],M1,M).
   
% Bidejki mnozenje na matrici e mnozenje redica so kolona, nema potreba od kreiranje na transponirana matrica, bidejki kolonata vo transponiranata e redicata vo vleznata matrica M.
% 
% Ja vnesuvame dvapati istata matrica, pravime mnozenje na sekoja redica od prvata so sekoja redica od vtorata matrica (sto e isto so kolonata od transponiranata matrica).
% Mnozitelite gi sobirame vo edna lista so pomos na findall.
% Listata ja delime vo podlisti so dolzina N (broj na redici vo prvata matrica), poradi praviloto za mnozenje na matrici: (M1,N1)*(N1,M2)=(M1,M2)
mnozenje_matrici_pipeline(M1,M2,Result):-length(M1,N),RowsFirst is N,
    								findall(X,mnozi_matrici(M1,M2,X),Z),
    								podeli_N_elements(Z,RowsFirst,Result).
% 
presmetaj(M,R):-mnozenje_matrici_pipeline(M,M,R).




%ZADACA 7
%transform([[3,10],[2,4,6,33,1,8],[4,1,3,6],[3],[2,4,6,33,1,8],[7,12],[4,1,2,7],[6,7,9]],L).
%L=[[2,4,6,33,1,8],[4,1,3,6],[4,1,2,7],[6,7,9],[7,12],[3,10],[3]]

transform(L, Result):-prv_for(L,[],Result).

prv_for([],Pomosna,Pomosna).
%cut operator za da ne prodolzuva so rekurzijata ednas koga ke ja izvrsi do kraj!
prv_for([Head|L], Pomosna, Result):-vtor_for(Head,Pomosna,NovaPomosna)
    									,prv_for(L,NovaPomosna,Result),!.
    
vtor_for(ElementList,[],[ElementList]):-!.
vtor_for(ElementList, [Head|CurrPomosna],[ElementList, Head|CurrPomosna]):-
    length(ElementList, Len1),length(Head,Len2), Len1>Len2.

vtor_for(ElementList, [Head|CurrList],[Head|Res]):-length(ElementList, Len1),
    											length(Head,Len2), Len1<Len2, 
    											vtor_for(ElementList,CurrList,Res).
% Prvo se proveruva dali listite-elementi se isti stom dolzinite im se isti.
% Ovde ne mora da se stave logickata sporedba bidejki samo ako ne vazat prethodnite 
% 2 uslovi ke stigne do tuka, ama vo toj slucaj ke treba da se upotrebe cut operator za 
% da ne prodolzuva rekurzijata koga ke zavrse.
% Ako ne se povika povtorno vtor_for nema da se izbrisat i ostanatite elementi koi se isti
% so momentalniot.
vtor_for(ElementList, [Head|CurrList],Res):-length(ElementList, Len1),length(Head,Len2), 
    										Len1==Len2, ElementList==Head,
    										vtor_for(ElementList,CurrList,Res).

%Ako stigne do tuka znaci deka dolzinite im se isti, 
%no elementite razlicni, pa treba da se povika tretiot for ciklus
vtor_for(ElementList, [Head|CurrPomosna],Res):-tret_for(ElementList,Head,Pogolema,Pomala),
    									append([Pogolema,Pomala],CurrPomosna,Res).

%tret_for(ElementLista1, ElementLista2, Pogolema, Pomala)
tret_for([H1|L1],[H2|L2],[H1|L1],[H2|L2]):-H1>H2.
tret_for([H1|L1],[H2|L2],[H2|L2],[H1|L1]):-H1<H2.
% Ne e vazno dali H1 ili H2 ke go zalepam na ostanatiot del od sporedbata bidejki 
% se istiot element
tret_for([H1|L1],[H2|L2],[H1|Pogolema],[H1|Pomala]):-tret_for(L1,L2,Pogolema,Pomala).

    

%ZADACA 8
e_lista([]).
e_lista([_|_]).

clen_nivo2(X,[X|_]).
clen_nivo2(X,[Y|O]):- not(e_lista(Y)),!,clen_nivo2(X,O).
clen_nivo2(X,[Y|O]):-clen_nivo2(X,Y);clen_nivo2(X,O).

prazna([]).

%Base case e posleden bidejki ke bide ispolnet za bilo koja neprazna lsita.
%istata funkcija ako se povika najdi_prv(1,[[],[[1],2]],T), so zadadena vrednost za Prv,
%ja vrakja listata so izbrisan toj element, AKO E NA PRVA POZICIJA!
najdi_prv(Prv,[G|O],Result):-e_lista(G),najdi_prv(Prv,G,Temp),append([Temp],O,Result).
najdi_prv(Prv,[G|O],Result):-prazna(G),najdi_prv(Prv,O,Temp),append([G],Temp,Result).
najdi_prv(Prv,[Prv|O],O).

brisi_sekoe_vtoro_rec(Element,[],FlagIn,FlagIn,[]).

brisi_sekoe_vtoro_rec(Element,[G|O],FlagIn,FlagOut,R):-e_lista(G), not(clen_nivo2(Element,G)),
    brisi_sekoe_vtoro_rec(Element,O,FlagIn,FlagOut,R1),append([G],[R1],R).

brisi_sekoe_vtoro_rec(Element,[G|O],FlagIn,FlagOut,R):-e_lista(G), clen_nivo2(Element,G),
    brisi_sekoe_vtoro_rec(Element,G,FlagIn,FlagOutG,R1),
    brisi_sekoe_vtoro_rec(Element,O,FlagOutG,FlagOut,R2),
    append(R1,R2,R).

brisi_sekoe_vtoro_rec(Element,[G|O],FlagIn,FlagOut,R):-not(e_lista(G)), Element==G,
    FlagIn==1,najdi_prv(_,[G|O],Deleted),
    brisi_sekoe_vtoro_rec(Element,Deleted,0,FlagOut,R).

brisi_sekoe_vtoro_rec(Element,[G|O],FlagIn,FlagOut,R):-not(e_lista(G)), Element==G,
    FlagIn==0,
    brisi_sekoe_vtoro_rec(Element,O,1,FlagOut,R1),
    (   (   not(prazna(R1)),append([G],[R1],R));(   prazna(R1),append([G],[],R))).

brisi_sekoe_vtoro_rec(Element,[G|O],FlagIn,FlagOut,R):-not(e_lista(G)), Element\=G,
    brisi_sekoe_vtoro_rec(Element,O,FlagIn,FlagOut,R1),
    (   (   not(prazna(R1)),append([G],R1,R));R is G).

helper([],L,_,L).

helper([G|O],L,Izminati,NovoIzminati,R):-not(e_lista(G)), not(member(G,Izminati)),
    brisi_sekoe_vtoro_rec(G,L,0,_,R1),
    append([G],Izminati,NovoIzminati),
    helper(O,R1,NovoIzminati,R).

helper([G|O],L,Izminati,NovoIzminati,R):-e_lista(G),helper(G,L,Izminati,NovoIzminati,R1),
    helper(O,R1,NovoIzminati,R).

brisi_sekoe_vtoro(L,R):-helper(L,L,[],_,R).


