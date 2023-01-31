% DOMASNA ZADACA 3 - TIJANA ATANASOVSKA (196014)
% DEL 1
licnost(mira).
licnost(teo).
licnost(bruno).
licnost(igor).

hrana(piza).
hrana(pita).
hrana(hamburger).
hrana(sendvic).

hobi(krstozbor).
hobi(pisuva).
hobi(cita).
hobi(fotografija).

boja(bela).
boja(crvena).
boja(sina).
boja(zolta).

e_zensko(mira).
e_masko(X):-not(e_zensko(X)).

%ima_maica(Ime,Boja)
ima_maica(Ime,bela):-e_zensko(Ime).
ima_maica(bruno,zolta).

%ima_hobi(Ime,Hobi)
ima_hobi(mira,krstozbor).
ima_hobi(igor,cita).

%jade(Ime,Hrana)
jade(mira,pita).
jade(teo,sendvic).

sedi(teo,0).
sedi(Ime,BrPozicija):-jade(Ime,pita), sedi(teo,PozTeo),
    BrPozicija is (   PozTeo+1), BrPozicija=<3.
sedi(Ime,BrPozicija):-jade(Ime,pita), sedi(teo,PozTeo),
    BrPozicija is (   PozTeo-1), BrPozicija>=0.

ima_maica(Ime,sina):-sedi(Ime,BrPozicija),e_zensko(Y),sedi(Y,PozicijaY),
    BrPozicija is (PozicijaY-1).


sedi_other(Ime,BrPozicija):-findall(L,licnost(L),LLicnost), 
   							member(BrPozicija,[0,1,2,3]), member(Ime,LLicnost),
    						not(sedi(Ime,_)), not(sedi(_,BrPozicija)).

jade_other(Ime,Hrana):-findall(L,licnost(L),LLicnost),findall(H,hrana(H),LHrana),
    					member(Ime,LLicnost),member(Hrana,LHrana),
    					not(jade(Ime,_)), not(jade(_,Hrana)).


ima_maica_other(Ime,Boja):-findall(L,licnost(L),LLicnost),findall(B,boja(B),LBoja),
    					   member(Ime,LLicnost),member(Boja,LBoja),
    					   not(ima_maica(Ime,_)),not(ima_maica(_,Boja)).

hobi_other(Ime,Hobi):-findall(L,licnost(L),LLicnost),findall(H,hobi(H),LHobi),
    				member(Ime,LLicnost),member(Hobi,LHobi),
    				not(ima_hobi(Ime,_)),not(ima_hobi(_,Hobi)).

sedi_all(Ime,Pozicija):-sedi(Ime,Pozicija);sedi_other(Ime,Pozicija).

jade_all(Ime,Hrana):-jade(Ime,Hrana);jade_other(Ime,Hrana).

hobi_all(Ime,Hobi):-ima_hobi(Ime,Hobi);hobi_other(Ime,Hobi).

maica_all(Ime,Boja):-ima_maica(Ime,Boja);ima_maica_other(Ime,Boja).

%DEL 2
reshenie_eden([BrPozicija,Ime,Hrana,Hobi,Boja]):-member(BrPozicija,[0,1,2,3]),
    sedi_all(Ime,BrPozicija),jade_all(Ime,Hrana),
    hobi_all(Ime,Hobi),maica_all(Ime,Boja).
    

po_pozicija(L,BrPozicija):-findall((BrPozicija,Ime,Hrana,Hobi,Boja),
                                   reshenie_eden([BrPozicija,Ime,Hrana,Hobi,Boja]),L).
    

kombinacii([M0,M1,M2,M3]):-po_pozicija(L0,0),po_pozicija(L1,1),po_pozicija(L2,2),po_pozicija(L3,3),
    member(M0,L0),member(M1,L1),member(M2,L2),member(M3,L3).

pozicija_bruno([H|T],PozBruno):-( Poz,Ime,_,_,_) = H,Ime==bruno,PozBruno is Poz.
pozicija_bruno([H|T],PozBruno):-( Poz,Ime,_,_,_) = H,Ime\=bruno,pozicija_bruno(T,PozBruno).

pozicija_piza([H|T],PozPiza):-( PozPiza,_,piza,_,_)=H,!.
pozicija_piza([H|T],PozPiza):-pozicija_piza(T,PozPiza).

pozicija_bela([H|T],PozBela):-( PozBela,_,_,_,bela)=H,!.
pozicija_bela([H|T],PozBela):-pozicija_bela(T,PozBela).


% Licnosta koja sedi pokraj onaa vo bela maica saka pica
pred1(L):-pozicija_bela(L,PozBela),pozicija_piza(L,PozPiza),
    (   (   PozPiza is (PozBela+1)) ; (   PozPiza is (PozBela-1))).

%Bruno sedi pokraj onoj sto jade pica
pred2(L):-pozicija_bruno(L,PozBruno),pozicija_piza(L,PozPiza),
    (   (   PozPiza is (PozBruno+1)) ; (   PozPiza is (PozBruno-1))).

%Onoj sto saka da pisuva, jade hamburger
pred3([H|T]):-( _,_,hamburger,pisuva,_) = H,!.  
pred3([H|T]):-( _,_,hamburger,_,_) = H,!,fail.
pred3([H|T]):-( _,_,_,pisuva,_) = H,!,fail.
pred3([H|T]):-pred3(T).  

resenie(K):-kombinacii(K),
  pred1(K),
    pred2(K),
    pred3(K).
