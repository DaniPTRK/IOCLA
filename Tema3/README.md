# Descriere implementare Tema 3 IOCLA

## Task 1 - Reversing vowels
&nbsp;&nbsp;&nbsp;&nbsp;In cadrul acestui task, trec printr-un loop de doua ori in care, prima
data, pushez vocalele pe care le gasesc pe stiva, iar, a doua oara, le dau
pop in pozitia unde gasesc o vocala in string-ul dat ca input, lucru ce-mi
garanteaza inversarea vocalelor in string. Pentru a implementa aceasta metoda,
ma folosesc de functia strchr prin care caut, folosindu-ma de un vector auxiliar
de vocale, vowels, cea mai apropiata vocala de capatul string-ului dat ca input.
In cazul in care gasesc vocala, pushez vocala si updatez string-ul, trecand
adresa sa de inceput la adresa unde am gasit vocala. In cazul in care nu gasesc
nicio vocala, ies din loopul de cautare al vocalelor si verific in ce stagiu ma
aflu (adica daca dau push vocalelor sau pop). Astfel, eficientizez intr-o
oarecare masura procesul de obtinere al vocalelor si de trecere prin string.

## Task 2 - PWD
&nbsp;&nbsp;&nbsp;&nbsp;Pentru acest task, m-am folosit de 3 functii din C, anume strrchr, strcmp
si strcat. Initial, verific folosind strcmp daca in input am un cuvant special,
cuvant special inseamnand ".." sau ".". In cazul in care nu am un cuvant 
special, adaug slash si numele directorului folosind strcat. In cazul in care 
am ".", nu concatenez nimic si trec mai departe prin vectorul de cuvinte. In
cazul in care am "..", ma folosesc de strrchr pentru a obtine ultima instanta
a lui "/" din string-ul de output si trec pe acea pozitie valoarea 0, adica
string terminator. Daca strrchr imi returneaza NULL, adica 0, nu schimb
nimic, intrucat inseamna ca nu avem unde sa ne mai intoarcem. In final,
adaug "/" pentru a realiza complet path-ul.

## Task 3 - Sortare de cuvinte
&nbsp;&nbsp;&nbsp;&nbsp;Pentru acest task, ma folosesc de un vector de char-uri numit delim in care
tin minte delimitatorii ce-i voi folosi la primul subpunct al exercitiului,
obtinand cuvintele din textul oferit ca input, si 2 auxiliare val_a si val_b
pe care le folosesc in realiza functiei de comparare din cadrul qsort-ului.

&nbsp;&nbsp;&nbsp;&nbsp;Mai intai, pentru a obtine cuvintele, ma folosesc de functia strtok pentru
a delimita cuvintele intre ele si a le trece, pe rand, in vectorul de cuvinte.

&nbsp;&nbsp;&nbsp;&nbsp;Apoi, pentru a sorta cuvintele, ma folosesc de functia qsort pe care o
apelez folosind ca functie de comparare functia compare_func unde compar
mai intai lungimile string-urilor folosind functia strlen, iar apoi, in 
cazul egalitatii, compar lexicografic folosind functia strcmp. Pentru a salva
outputurile functiilor si pentru a conserva informatia aflata in registre,
folosesc 2 variabile auxiliare in care salvez eax-ul obtinut in urma apelarii
functiilor, variabile ce ma vor ajuta in obtinerea valorii returnate de catre
functia de cautare.

## Task 4 - Binary Tree
&nbsp;&nbsp;&nbsp;&nbsp;In cadrul acestui task, in cadrul fiecarui exercitiu, realizez structura
unui nod din arbore intr-un "struc node".

&nbsp;&nbsp;&nbsp;&nbsp;Pentru primul exercitiu, verific daca nodul pe care ma aflu are un fiu la
stanga, iar, daca acest lucru este adevarat, atunci reapelez functia pentru
fiul din dreapta si verific din nou daca nodul actual are un fiu sau nu in
stanga. In cazul in care nu are un fiu, trec valoarea nodului in vector si 
verific daca are un fiu in dreapta. In cazul in care are, reapelez functia
pentru fiul sau, daca nu, ies din functie. Practic, realizez astfel o 
parcurgere SRD recursiva.

&nbsp;&nbsp;&nbsp;&nbsp;Pentru al doilea exercitiu, folosesc aceeasi metoda, doar ca, de data
aceasta, inainte de a trece valoarea pe care o am in vector, verific daca
aceasta respecta sau nu proprietatea de arbore binar de cautare, verificand
daca tatal nodului respectiv are o valoarea mai mare (nodul este in stanga)
sau o valoarea mai mica (nodul este in dreapta). In cazul nerespectarii
proprietatii, trec valoarea in vector.

&nbsp;&nbsp;&nbsp;&nbsp;Pentru al treilea exercitiu, folosesc aceeasi metoda de la exercitiul 2,
singura diferenta fiind aceea ca, in loc de a trece valoarea ce se afla pe
nod in vector, trec valoarea tatalui +1/-1, in functie de pozitia nodului
fata de tata.

## Bonus 1 - Intercalare x64
&nbsp;&nbsp;&nbsp;&nbsp;In cadrul acestui task, ma folosesc de registrele r8 si r9 pentru a tine
minte pozitia in care ma aflu in cei 2 vectori ce urmeaza sa fie intercalati.
Astfel, in cazul in care intr-unul dintre registre se afla o valoarea egala
cu n-ul dat, in vectorul rezultat trec doar valorile din celalalt vector supus
intercalarii. Pana a ajunge la n, insa, verific daca r8>r9. Daca este adevarat,
trec o valoarea din vectorul v2, daca nu, trec o valoare din vectorul v1.
Astfel, obtin vectorul final. 
