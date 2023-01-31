% ZADACA 1
%lice(Sifra,Ime,Prezime,Pol,Data_raganje,Mesto_raganje,Mesto_ziveenje)
lice(1,petko,petkovski,m,datum(1,3,1950),kratovo,skopje).
lice(2,marija,petkovska,z,datum(30,5,1954),kumanovo,skopje).
lice(3,ljubica,petkovska,z,datum(29,11,1965),skopje,skopje).
lice(4,vasil,vasilev,m,datum(8,4,1954),bitola,bitola).
lice(5,elena,vasileva,z,datum(19,6,1958),resen,bitola).
lice(6,krste,krstev,m,datum(9,8,1948),veles,veles).
lice(7,biljana,krsteva,z,datum(13,8,1949),veles,veles).
lice(8,igor,krstev,m,datum(26,10,1971),veles,skopje).
lice(9,kristina,krsteva,z,datum(30,5,1974),kumanovo,skopje).
lice(10,julija,petrova,z,datum(30,5,1978),skopje,skopje).
lice(11,bosko,petkovski,m,datum(13,11,1981),skopje,skopje).
lice(12,gjorgji,vasilev,m,datum(15,7,1978),bitola,bitola).
lice(13,katerina,petkovska,z,datum(11,12,1979),bitola,skopje).
lice(14,petar,vasilev,m,datum(21,2,1982),skopje,skopje).
lice(15,andrej,krstev,m,datum(3,8,1998),skopje,skopje).
lice(16,martina,petkovska,z,datum(5,12,2005),skopje,skopje).

%familija(Sifra_tatko,Sifra_majka,Lista_sifri_deca)
familija(1,2,[9,10]).
familija(1,3,[11]).
familija(4,5,[12,13,14]).
familija(6,7,[8]).
familija(8,9,[15]).
familija(11,13,[16]).


% a) rodeni_razlicen_grad(Kolku)

dali_e_razlicen(GradDete, GradRoditel1, GradRoditel2):-
    GradDete\=GradRoditel1,GradDete\=GradRoditel2.

razlicni(_):-familija(R1,R2,Deca), member(Dete,Deca), lice(Dete,_,_,_,_,GradDete,_),
    lice(R1,_,_,_,_,GradRoditel1,_), lice(R2,_,_,_,_,GradRoditel2,_),
    dali_e_razlicen(GradDete,GradRoditel1,GradRoditel2).

rodeni_razlicen_grad(Kolku):-findall(_,razlicni(_),List),length(List,Kolku).

%Vo ova baranje ne treba da se filtiraat vrednostite na decata bidejki sekogas se unikatni 
%(ne moze dete so ID X da go ima vo dva zapisi, nitu da go ima povekjepati vo eden zapis).

% b) predci(Sifra,L)

roditeli(Sifra,R1,R2):-familija(R1,R2,Deca),member(Sifra,Deca).

ist_pol(Sifra1, Sifra2):-lice(Sifra1,_,_,Pol1,_,_,_),lice(Sifra2,_,_,Pol2,_,_,_),Pol1==Pol2.

najdi_predci(Sifra,[R1,R2|Result]):-roditeli(Sifra,R1,R2),
    najdi_predci(R1,Subresult1), najdi_predci(R2,Subresult2),!,
    append(Subresult1,Subresult2,Result).
najdi_predci(Sifra,[]).

rodendeni(Sifra, SifraPredok):-lice(Sifra,_,_,_,datum(Den1,Mesec1,_),_,_),
    lice(SifraPredok,_,_,_,datum(Den2,Mesec2,_),_,_),
    Meseci is abs(Mesec1-Mesec2),(Meseci is 0;Meseci is 1),
    (	(Mesec1==Mesec2,Denovi is abs(Den1-Den2));
    	(Mesec1>Mesec2, Denovi is ((30-Den2)+Den1));
    	(Mesec1<Mesec2, Denovi is ((30-Den1)+Den2)) ), Denovi=<7 .

% Za sekoj member za koj sto ke bidat ispolneti uslovite kje go vrate vo Predok. Gi akumulirame vo lista so findall.
predci_helper(Sifra,Predok):-najdi_predci(Sifra,Predci),member(Predok,Predci),
    						 ist_pol(Sifra,Predok),rodendeni(Sifra,Predok).

predci(Sifra,L):-findall(Prethodnik,predci_helper(Sifra,Prethodnik),L).

% ZADACA 2
telefon(111111,petko,petkovski,[povik(222222,250),povik(101010,125)]).
telefon(222222,marija,petkovska,[povik(111111,350),povik(151515,113),povik(171717,122)]).
telefon(333333,ljubica,petkovska,[povik(555555,150),povik(101010,105)]).
telefon(444444,vasil,vasilev,[povik(171717,750)]).
telefon(555555,elena,vasileva,[povik(333333,250),povik(101010,225)]).
telefon(666666,krste,krstev,[povik(888888,75),povik(111111,65),povik(141414,50),povik(161616,111)]).
telefon(777777,biljana,krsteva,[povik(141414,235)]).
telefon(888888,igor,krstev,[povik(121212,160),povik(101010,225)]).
telefon(999999,kristina,krsteva,[povik(666666,110),povik(111111,112),povik(222222,55)]).
telefon(101010,julija,petrova,[]).
telefon(121212,bosko,petkovski,[povik(444444,235)]).
telefon(131313,gjorgji,vasilev,[povik(141414,125),povik(777777,165)]).
telefon(141414,katerina,petkovska,[povik(777777,315),povik(131313,112)]).
telefon(151515,petar,vasilev,[]).
telefon(161616,andrej,krstev,[povik(666666,350),povik(111111,175),povik(222222,65),povik(101010,215)]).
telefon(171717,martina,petkovska,[povik(222222,150)]).
sms(111111,[222222,999999,101010]).
sms(444444,[333333,121212,161616]).
sms(111111,[777777]).
sms(666666,[888888]).
sms(444444,[555555,121212,131313,141414]).
sms(666666,[777777,888888]).
sms(888888,[999999,151515]).
sms(171717,[131313,161616]).

%A)
baral(Tel_broj,Baran_Tel):-telefon(Tel_broj,_,_,Povici),member(povik(Baran_Tel,_),Povici).

go_barale(Tel_broj,Povikuvac):-telefon(Povikuvac,_,_,Povici),member(povik(Tel_broj,_),Povici).

e_clen(Tel_Broj, Clen):-go_barale(Tel_Broj,Clen);baral(Tel_Broj,Clen).

vkupno_unikatni(Tel_broj,Vkupno):-setof(Clen,e_clen(Tel_broj,Clen),L),length(L,Vkupno).

najbroj(X,Y):-findall((T,Vkupno),vkupno_unikatni(T, Vkupno),L),maximum(L,(MaxTelBroj,_)),
    		telefon(MaxTelBroj,X,Y,_),!.

maximum([H|O],M):-max(O,H,M).
max([],M,M).
max([(B,G)|O],(B1,G1),M):-G>G1,max(O,(B,G),M).
max([(B,G)|O],(B1,G1),M):-(G<G1;G=G1),max(O,(B1,G1),M).

% B)
%Vtoriot povik e za vo slucaj prviot da vrate false, pa da se setira vrednosta na 0 so vtoriot povik.
%Cut operatorot e ako najde vrednost vo prviot povik, togas nema potreba da se povikuva vtoriot povik za setiranje na 0.
traenje_povik(X,Y,Traenje):-telefon(X,_,_,Povici),member(povik(Y,Traenje),Povici),!.
traenje_povik(X,Y,0).

dali_sms(X,Y):-sms(X,SMS), member(Y,SMS).

% sms nema potreba od vtor predikat za setiranje 0, bidejki findall vrakja [], pa len([])=0
traenje_sms(X,Y,Traenje):-findall(_,dali_sms(X,Y),L),length(L,Len),Traenje is (Len*100).

traenje(X,Y,Total):-telefon(Y,_,_,_),
    traenje_povik(X,Y,Traenje1),
    traenje_povik(Y,X,Traenje2),
    traenje_sms(X,Y,Traenje3),
    traenje_sms(Y,X,Traenje4),
    Total is (Traenje1+Traenje2+Traenje3+Traenje4).

% analyse - Predikat za dobar pregled na podatocite za vremetraenje so sekoj od broevite
analyse(X,L):-findall((Y,T),traenje(X,Y,T),L).

omilen(Broj,Omilen):-findall((X,T),traenje(Broj,X,T),L),maximum(L,(Omilen,_)),!.



% ZADACA 3
klient(1,petko,petkov,[usluga(a,b,50,datum(12,12,2015),23),usluga(c,a,50,datum(7,12,2015),34),usluga(c,f,40,datum(7,11,2015),23)]).
klient(2,vasil,vasilev,[usluga(a,e,50,datum(25,12,2015),12),usluga(c,g,40,datum(17,11,2015),56),usluga(g,d,50,datum(17,12,2015),45),usluga(e,a,40,datum(24,12,2015),34)]).
klient(3,krste,krstev,[usluga(c,b,60,datum(31,12,2015),56),usluga(e,f,60,datum(31,12,2015),34)]).
klient(4,petar,petrov,[usluga(a,f,50,datum(25,12,2015),23),usluga(f,d,50,datum(25,12,2015),34)]).
klient(5,ivan,ivanov,[usluga(d,g,50,datum(7,12,2015),56),usluga(g,e,40,datum(25,12,2015),34)]).
klient(6,jovan,jovanov,[usluga(c,f,50,datum(5,12,2015),12),usluga(f,d,50,datum(27,12,2015),45)]).
klient(7,ana,aneva,[usluga(e,d,50,datum(11,12,2015),12),usluga(d,g,50,datum(11,12,2015),12)]).
klient(8,lidija,lideva,[usluga(e,g,50,datum(29,12,2015),45),usluga(f,b,50,datum(29,12,2015),34)]).

rastojanie(a,b,4).
rastojanie(a,c,7).
rastojanie(b,c,5).
rastojanie(b,d,3).
rastojanie(c,d,4).
rastojanie(b,e,6).
rastojanie(c,e,2).
rastojanie(b,f,8).
rastojanie(e,f,5).
rastojanie(f,g,3).

% A) izbroj_lokacija(Lok,Br) -> kolku pati bila pocetna ili krajna
%cut = bidejki vtoriot predikat nema logicki uslov za proverka pa kje vleze vo nego i koga prvito e ispolnet pri rekurzivnoto prodolzuvanje na prolog
counter(Lok,0,[]):-!.
counter(Lok,Br,[usluga(Pocetna,Krajna,_,_,_)|L]):-(Pocetna==Lok;Krajna==Lok),counter(Lok,Br1,L),Br is Br1+1,!.
counter(Lok,Br,[usluga(Pocetna,Krajna,_,_,_)|L]):-counter(Lok,Br1,L),Br is Br1.

po_klient(Lok,Br):-klient(_,_,_,Uslugi), counter(Lok,Br,Uslugi).

izbroj_lokacija(Lok,Br):-findall(OdKlient,po_klient(Lok,OdKlient),L),sum_elementi(L,Br),!.

sum_elementi([X],X).
sum_elementi([X|L],Br):-sum_elementi(L,Br1), Br is X+Br1.



%B) najmnogu_kilometri(X,Y) - X=ime, Y=prezime za klientot koj ima pominato najmn kilometri so kompanijata

%vo bazata moze da ima informacija za rastojanie A->B ili za B->A. Toa se resava so OR.
%Se cuva lista na izminati rastojanija za da ne se vrakja po vekje izminat pat. Primer: (g,d)->resenie: (g,f,b,d) 
%Ama otkako kje go najde (g,f), posle kje bara (f,_) i pak kje se sovpadne so (f,g) i vleguva vo ciklus! Zatoa gi stavame dvete nasoki vo 
%lista na izminati patista i pred da se izmine pat se proveruva dali e vo listata.

presmetaj_rastojanie(Od,Do,_,Km):-(rastojanie(Od,Do,Km) ; rastojanie(Do,Od,Km)).
presmetaj_rastojanie(Od,Do,Pominati,Km):-
    					(rastojanie(Od,Preku,Km1);rastojanie(Preku,Od,Km1)),
    					not(member((Od,Preku),Pominati)),
    					append([(Od,Preku),(Preku,Od)],Pominati,NovoPominati),
    					presmetaj_rastojanie(Preku,Do,NovoPominati,Km2), Km is (Km1+Km2).


najkratko_rastojanie(A,B,MinKm):-findall(Km,presmetaj_rastojanie(A,B,[],Km),L) ,najdi_minimum(L,MinKm).

najdi_minimum([X|O],M) :- minimum(O,X,M),!.
minimum([X|O],Y,M) :- X>=Y, minimum(O,Y,M).
minimum([X|O],Y,M) :- X<Y, minimum(O,X,M).
minimum([ ],M,M).

%za sekoja usluga na klientot presmetaj kolku km e taa i potoa soberi gi site
kolku_klient([],0).
kolku_klient([usluga(Pocetna,Krajna,_,_,_) |Uslugi], Total):-najkratko_rastojanie(Pocetna,Krajna,Ras),
    														kolku_klient(Uslugi,SubTotal),Total is (SubTotal+Ras).

klienti(Id,Total):-klient(Id,_,_,Uslugi),kolku_klient(Uslugi,Total).

najmnogu_kilometri(Ime,Prezime):-findall((KlientId,TotalKM) , klienti(KlientId,TotalKM), L), maximum(L,(MaxKlientID,_))
    							,klient(MaxKlientID,Ime,Prezime,_),!.

maximum([H|O],M):-max(O,H,M).
max([],M,M).
max([(B,G)|O],(B1,G1),M):-G>G1,max(O,(B,G),M).
max([(B,G)|O],(B1,G1),M):-(G<G1;G=G1),max(O,(B1,G1),M).


%V) Za sekoj broj na taksi vozilo koe moze da se najde vo bazata na podatoci, da se zemat uslugite koi gi ima napraveno vo dekemvri,2015
% Da se presmeta kolku kilometri izminal za taa dadena usluga i da se pomnozi so cenata na uslugata.

najdi_broj_vozilo(Broj_Vozilo):-klient(_,_,_,Uslugi),member(usluga(_,_,_,_,Broj_Vozilo),Uslugi).
unikatni_broj_vozilo(L):-setof(Broj_Vozilo,najdi_broj_vozilo(Broj_Vozilo),L).

uslugi_dekemvri(Broj_Vozilo,Naplata):-klient(_,_,_,Uslugi),member(usluga(Od,Do,Cena,datum(_,12,2015),Broj_Vozilo),Uslugi),
    najkratko_rastojanie(Od,Do,Km), Naplata is (Km*Cena).

suma_uslugi_dekemvri(Broj_Vozilo,Suma):-findall(Naplata,uslugi_dekemvri(Broj_Vozilo,Naplata),L),sum_elementi(L,Suma),!.

unikatni_vozila_sumi(Broj_Vozilo,Suma):-unikatni_broj_vozilo(L),member(Broj_Vozilo,L),suma_uslugi_dekemvri(Broj_Vozilo,Suma).
najmnogu_zarabotil(MaxBrojVozilo):-findall((Broj_Vozilo,Suma),unikatni_vozila_sumi(Broj_Vozilo,Suma),L),maximum(L,(MaxBrojVozilo,_)),!.



