# Descriere implementare Tema 2 IOCLA

## Task 1 - Simple cipher
&nbsp;&nbsp;&nbsp;&nbsp;In cadrul acestui task, shiftez intr-un loop caracterele din string-ul
menit sa fie criptat, verific daca acel caracter se afla in range-ul A-Z si,
in cazul in care nu este, ajung la label-ul decval unde scad cu 'Z' si adun
cu 'A'-1, conservand practic pasii suplimentari ce sar de 'Z'.

## Task 2 - Processes
&nbsp;&nbsp;&nbsp;&nbsp;Pentru prima cerinta, am implementat o sortare de tip bubble in care
sortez mai intai dupa prioritati, dupa timp sau dupa PID, in functie
de egalitatile pe le obtin in timpul comparatiilor.

&nbsp;&nbsp;&nbsp;&nbsp;Pentru a doua cerinta, realizez o structura avg ce va contine catul
si restul dupa impartirea timpului la numarul de procese cu aceeasi prioritate.
Ma folosesc de cei 2 vectori prio_result si time_result, in primul stocand nr
de procese cu aceeasi prioritate - 1 ca pozitia din vector, iar in al doilea
stocand timpul respectiv procesului. In final trec rezultatele in structura.

## Task 3 - Enigma Machine
&nbsp;&nbsp;&nbsp;&nbsp;Pentru prima cerinta, ma folosesc de un vector auxiliar rotate_data
unde salvez rezultatul in urma rotirii rotorului ales cu cei x pasi. Mai 
intai, calculez noua pozitie a literei, verific daca aceasta pozitie este
in range-ul 0-25 si o aduc in range-ul respectiv scazand sau adunand cu 26,
apoi, in final, trec vectorul auxiliar pe linia unde am executat rotirea.
Acest proces este realizat de 2 ori, o data pentru fiecare linie din rotor.

&nbsp;&nbsp;&nbsp;&nbsp;Pentru a doua cerinta, ma folosesc de un vector encrypt_data ce contine 
pozitiile liniilor din matricea config pe care le voi folosi in criptarea 
literei, in ordinea in care acestea sunt parcurse in circuit. De asemenea,
folosesc si un vector rotate_next_data unde trec daca un rotor va fi sau nu
rotit. Verific de la bun inceput daca cheia pe care am primit-o are vreo
valoare care se afla si in notch-uri, pentru a stii cati rotori rotesc la
prima rotire. Pentru fiecare litera, rotesc mai intai rotorii ce pot fi 
rotiti, incrementez cheia si verific ce rotori vor fi rotiti la urmatoarea 
rotire folosindu-ma de cheie si de notches. Dupa incrementari, verific
daca ceea ce am in cheie este in range-ul A-Z, iar dupa ceea pornesc
cautarea literei criptate. Practic, ma uit pe linia din encrypt_data
si caut valoarea pe care o am de criptat, mut in locul acestei valori
valoarea intermediara care se afla pe aceeasi coloana ca locul unde am
gasit litera ce trebuie criptata si continui procesul pana ajung la
forma criptata a literei.

## Task 4 - Checkers
&nbsp;&nbsp;&nbsp;&nbsp;Pentru acest task, ma folosesc de 3 array-uri:
1) neigh unde setez cu 0 ce vecini nu pot vizita
2) movex ce-mi indica cat de mult ar trebui sa ma misc pe linie pentru
a ajunge pe aceeasi linie cu pozitia indicata de neigh
3) movey ce-mi indica cat de mult ar trebui sa ma misc pe coloana pentru
a ajunge pe aceeasi coloana cu pozitia indicata de neigh.

&nbsp;&nbsp;&nbsp;&nbsp;Verific inainte de a trece 1 in matrice daca dama se afla pe prima
sau ultima linie si pe prima sau ultima coloana si, in functie de aceste
informatii, setez 1 in matrice.

## Task Bonus
&nbsp;&nbsp;&nbsp;&nbsp;Pentru acest task, folosesc 4 array-uri, 3 dintre ele fiind explicate
la Task 4. Al patrulea array tine minte pozitiile absolute indicate de neigh.

&nbsp;&nbsp;&nbsp;&nbsp;Ca si la task-ul 4, verific unde ma pot duce, iar dupa aceea, calculez
pozitiile absolute si verific dupa aceea daca aceste pozitii sunt mai mari
decat jumatate din size-ul matricei (adica se afla in primul numar). Dupa
ce obtin aceste detalii, fie scad cu 32 pozitia (daca pozitia > 32), fie o 
las la fel, iar dupa aceea shiftez la stanga valoarea 1 cu un numar de pasi 
egal cu pozitia absoluta si adun acest rezultat la numarul din vectorul board.
