# Cititor de ecran pentru calculatoarele HC-85 produse de ICE Felix
## Introducere
Un cititor de ecran este un progam folosit de persoanele nevăzătoare pentru a citi informația scrisa pe un ecran de calculator.
Acesta este un precursor la cititoarele de ecran, probabil primul din România.
A fost scris în 1995-11 - 1996-03 pe un HC-91 pentru Liceul pentru deficienți de vedere din Buzău.

Sunt 3 componente:
- sinteza de voce (TTS) care transforma textul în vorbire
- cititorul de ecran - screen-reader.asm
- programul de creat dicționarul pentru normalizare - construieste-dictionar.bas

## Asamblarea codului sursă
Instalarea programului de asamblare:
```
sudo apt install pasmo    # Ubuntu, Debian
```

Asamblarea propriuzisă. Comanda următoare va genera un fișier de tip bandă magnetică:
```
pasmo --tzx screen-reader.asm screen-reader.tzx
```

## Cum se construiește dicționarul?
Se ruleaza construieste-dictionar.bas
Se introduce caracterul dorit. De exemplu: "0", "{", "INPUT", "CHR$"
Se apasă ENTER și apoi se introduce pronunția. De exemplu: "zeeroo", "aacoladea deeskisea", "input", "cee hasch eer dollar"
Cand nu se mai dorește de introdus se screa orice șir de caractere la promptul `Cont?`

https://worldofspectrum.org/infoseek?q=speech
