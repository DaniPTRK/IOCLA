Descriere implementare
    Intai de toate, initializez cateva variabile, precum si 3 vectori diferiti
de senzori a, b si c. Vectorii a si b sunt folositi pentru a alcatui vectorul
final c, vector care va avea senzorii pusi dupa prioritatea lor - mai intai
senzorii de tip PMU, iar, apoi, senzorii de tip tire. Astfel, in vectorul
a salvez senzorii de tip tire, iar in vectorul b salvez senzorii de tip 
PMU ca dupa aceea sa realizez o concatenare a vectorului b cu a si sa trec
acest rezultat in vectorul final de senzori c. Acest vector final va fi
folosit pe tot parcursul programului.
    Tot in timpul initializarilor, realizez si vectorul de operatii 
void* oper[](void*), pe care il obtin folosindu-ma de un vector de void*
numit aux. Ma folosesc de acest auxiliar pentru a obtine operatiile prin
functia get_operations(), functie pe care am trecut-o in header-ul 
operations.h folosindu-ma de operations.c. Trec, dupa aceea, operatiile
din auxiliar in vectorul de functii propriu-zis.
    Dupa ce realizez un vector de stringuri cu toate cele 4 comenzi - 
comenzi[4][8] si dupa ce citesc toate informatiile din fisierul binar,
folosindu-ma si de functia adaugare_operatii() pentru a trece operatiile
fiecarui senzor in vectorul de senzori, pornesc citirea si executarea comenzilor 
primite in stdin, comenzi ce sunt trecute in vectorul de char-uri comanda.
    Fiecare comanda este codificata dupa pozitia ei in comenzi[4][8].
Pentru 0, avem print si se va realiza functia printing(), pentru 1
avem analyze si se va realiza functia analyzing(), iar pentru 3 avem
clear si se va realiza functia cleaning(). Pentru exit, se iese
din loop-ul care asteapta input de la tastatura si se dezaloca memorie.
    In printing() se realizeaza o printare in functie de sensor_type, daca
indexul primit este in range. Afisarea este in conformitate cu sablonul
dat in cerinta.
    In analyzing() sunt realizate operatiile asupra senzorului desemnat de
index, daca indexul primit este in range.
    In cleaning() se verifica, dupa sensor_type, daca informatiile primite in
fisierul binar se afla intre parametrii dati iar, in cazul contrar, senzorul
este sters din vectorul de senzori.