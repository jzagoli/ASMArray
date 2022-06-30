# ASMArray
Project for computer architecture course. This software implements functions to manage an array of size ten in many ways.
The assembly software (GestioneVettore.s) implements the same functions present in the corresponding C software (gestioneVettore.c)

## Description (Italian)

### Funzionamento generale del programma
Il programma GestioneVettore.s implementa un’interfaccia testuale per operare su un vettore di interi di 
lunghezza predefinita, in maniera analoga al programma GestioneVettore.c.
Nello sviluppare questo programma Assembly, si è cercato di mantenere l’interfaccia quanto più possibile 
fedele all’originale: le stringhe di invito alle operazioni dell’utente sono le stesse in ogni parte del programma.
Anche le modalità di funzionamento sono le stesse.
Il programma implementa le seguenti funzionalità:
1. Interfaccia grafica testuale per interagire con il programma (stampa e ristampa delle operazioni 
disponibili, menu testuale continuo)
2. Inserimento del vettore
3. Uscita dal programma
4. Stampa a video del vettore inserito
5. Stampa a video del vettore inserito in ordine inverso
6. Stampa a video del numero di elementi pari e dispari nel vettore
7. Stampa a video della posizione di un valore inserito dall’utente nel vettore
8. Stampa a video del valore massimo del vettore
9. Stampa a video del valore minimo del vettore
10. Stampa a video della posizione del valore massimo del vettore
11. Stampa a video della posizione del valore minimo del vettore
12. Stampa a video del valore inserito con maggior frequenza
13. Stampa a video della media intera dei valori inseriti
All’avvio del programma viene richiesto di inserire gli interi che compongono il vettore. In seguito, è possibile 
operare sul vettore tramite la scelta di una delle funzionalità disponibili. È possibile effettuare un numero 
arbitrario di operazioni consecutive fino all’uscita dal programma.

### Variabili e registri utilizzati
Le variabili utilizzate nel programma sono state memorizzate nella sezione data.
I vettori sono due: 
- il primo, denominato “vet”, è il vettore che contiene i dati inseriti dall’utente. Questo vettore 
consiste in dieci spazi contigui della memoria centrale, ognuno di dimensione 4 byte (32 bit). È 
possibile riservare tale spazio con l’apposita direttiva fill.
- Il secondo, denominato “vetfreq”, è il vettore ausiliario al calcolo del numero più frequente. Il 
funzionamento di questa funzione verrà analizzato in seguito. Consiste in dieci spazi contigui in 
memoria di dimensione 1 byte e non 4 byte, dal momento che conterrà interi che vanno da 1 a 10. 
In questo modo la memoria non viene occupata inutilmente.

Le stringhe sono utilizzate per comporre l’interfaccia testuale del programma. Sono inoltre memorizzati 
alcuni altri dati: op, utilizzato per scegliere l’operazione da eseguire, e divisore, che viene utilizzato in 
seguito nella funzione che determina i numeri pari e dispari.
I registri che vengono utilizzati dal programma possono essere trovati nella prima dispensa di assembly.
Nonostante i registri abbiano un utilizzo standard, ad esempio EAX - accumulator register, EBX - base 
register etc., vengono utilizzati dal programma nelle varie funzioni con scopi differenti, che variano in base 
alle necessità correnti.

### Funzioni, passaggio e restituzione dei valori
Alcuni blocchi di codice che vengono utilizzati più volte nel programma sono stati scritti sottoforma di 
funzione, in particolare quelli che trovano la posizione di un numero, il massimo e il minimo.
Queste funzioni usano i registri della CPU per passare e restituire i valori. Ad esempio, la funzione trovapos
riceve come parametro il valore di cui deve trovare la posizione, e tale parametro deve essere posizionato 
nel registro EBX; oppure la funzione trovamax restituisce il valore massimo trovato nel registro EAX. 
Chiamando queste due funzioni una in seguito all’altra, è possibile trovare la posizione del valore massimo. 
Un approccio simile è stato utilizzato in altre parti del programma per evitare di riscrivere lo stesso codice.
Alcuni blocchi di codice, nonostante siano simili per funzionalità, sono stati riscritti perché 
operano su dati differenti (si veda ad esempio trovapos e trovaposfreq, dove la prima opera su un 
vettore e la seconda su un altro).

### Descrizione dell’implementazione delle funzionalità
In questa sezione viene descritta l’implementazione delle varie funzioni del programma. Si tenga conto che 
quasi tutte le funzioni sono state implementate allo stesso modo del programma GestioneVettore.c.
Il codice sorgente è stato adeguatamente commentato, se è necessario approfondire il funzionamento di 
alcune parti del codice è possibile visionare tali commenti.
#### Inserimento del vettore
Questa funzione si occupa semplicemente di riempire gli spazi di memoria che erano già stati riservati 
tramite la direttiva fill con i dati inseriti dall’utente. All’interno di un ciclo che viene ripetuto 10 
volte, viene chiesto all’utente di inserire l’intero, che va nella prima posizione del vettore. Il puntatore 
al vettore viene incrementato di 4, passando così alla posizione successiva.
Dal momento che il registro utilizzato per il ciclo è ECX, e dal momento che le funzioni printf e 
scanf vanno a modificare tale registro, è necessario salvarlo nello stack prima di richiamare queste 
funzioni, e ripristinarlo prima dell’istruzione loop (pushl %ecx, popl %ecx).
#### Stampa a video del vettore e stampa a video del vettore inverso
Per stampare il vettore è necessario scorrerlo nel modo già descritto, e richiamare printf per ogni 
valore. Il valore di ECX viene preservato nel modo precedentemente descritto. In ogni ciclo viene 
anche calcolato l’indice corretto: dal momento che il ciclo va da 10 a 0, devo sottrarre a 11 il contatore 
del ciclo. Si faccia riferimento ai commenti per una spiegazione dettagliata.
Per la stampa del vettore inverso non ho bisogno di calcolare l’indice corretto, mi basta spostarmi al 
termine del vettore e indietreggiare di una posizione ad ogni ciclo sottraendo 4 all’indirizzo.
#### Massimo e minimo
Per trovare il massimo, inizialmente carico nel registro riservato al massimo (EAX) il primo elemento 
del vettore. Poi confronto ogni elemento del vettore col massimo: se è maggiore, l’elemento corrente 
viene spostato in EAX, altrimenti incremento la posizione del vettore. Al termine di questa funzione, 
il valore del massimo è in EAX, pronto per essere utilizzato in seguito. La funzione che trova il minimo 
è del tutto analoga.
#### Posizione di un elemento nel vettore
Questa funzione accetta un parametro, che è l’elemento da trovare, che deve essere caricato in EBX. 
Si scorre tutto il vettore, e si confronta ogni elemento con quello caricato in EBX. Se nessun elemento 
è uguale, viene avvisato l’utente che l’elemento non è presente nel vettore. Se un elemento è uguale,
si salta alla parte di codice dove viene calcolata la sua posizione (in base al contatore del ciclo, come 
descritto in precedenza) e viene stampata.
#### Media intera del vettore
Innanzitutto, viene calcolata la somma totale passando tutti gli elementi del vettore e sommandoli 
ad EAX, che era stato precedentemente azzerato. Si noti che questo procedimento potrebbe causare 
un overflow se la somma totale non è rappresentabile in 32 bit.
Dopodiché, devo dividere la somma per 10: metto quindi 10 in EBX, dal momento che non posso 
dividere per un valore immediato. Resetto EDX che verrà concatenato a EBX nella divisione, e utilizzo 
il comando cdq:
Questa istruzione converte la DoubleWord con segno (32 bit) fornito in EAX nella QuadWord con 
segno (64 bit) lasciata in EDX:EAX (CDQ, Convert Double to Quad).
Perciò modifica il valore contenuto nel registro EDX, estendendo in esso il bit di segno del bit più 
significativo (segno) di EAX. Procedo ad una divisione con segno: la somma potrebbe essere negativa. 
Se la somma fosse negativa, e non avessi utilizzato cdq, il risultato sarebbe completamente 
sbagliato. Poi stampo il risultato.
#### Numero di elementi pari e dispari
Inizialmente resetto EBX e EDI, dove metterò rispettivamente il numero di elementi dispari e il 
numero di elementi pari.
Scorro poi tutto il vettore: per ogni elemento, resetto EDX e divido l’elemento per 2. Vado poi a 
comparare il resto della divisione (salvato in EDX) con 0, in caso affermativo il numero è pari e posso 
incrementare il registro relativo, altrimenti incremento i dispari.
Al termine del ciclo stampo il risultato. Si considera 0 un numero pari.
Posizione del massimo e del minimo
Per trovare la posizione del massimo riutilizzo la funzione per trovare il valore massimo, la quale 
inserisce il valore risultante in EAX. Sposto poi il contenuto di EAX in EBX e riutilizzo la funzione per 
trovare la posizione di un valore (in questo caso del valore massimo). Del tutto analogo è il procedimento 
per trovare la posizione del minimo.
#### Elemento più frequente nel vettore (there is a bug probably)
Per creare questa funzione abbiamo deciso di prendere un’altra strada rispetto a quella usata nel file 
GestioneVettore.c: innanzitutto creo un vettore vetfreq di lunghezza 10, il quale conterrà la 
frequenza dei valori del vettore vet (es: se vet contiene 4 volte il valore 2 e uno dei valori 2, per 
esempio, si trova nella posizione 8, in vetfreq sarà presente un 4 in posizione 8). Per fare questo 
scorro tutto il vettore vet (10 iterazioni) nel ciclo esterno utilizzando come puntatore il registro 
esi e, per ogni iterazione, scorro un’altra volta il vettore dall’inizio con un ciclo interno, utilizzando 
come puntatore il registro edi. Nel ciclo interno controllo se il valore puntato da esi (che sposto in 
EBX per limitazioni di Assembly) coincide con quello puntato da edi e, se è così, aumento di 1 la 
frequenza che si trova in AH. Una volta terminato il ciclo interno, ho la frequenza del valore puntato da 
esi in AH e la inserisco quindi in vetfreq alla medesima posizione puntata da esi in vet. Una volta 
ricavato vetfreq, riutilizzo la funzione per trovare il massimo (in questo caso modificata per riadattarla 
a vetfreq) tra le frequenze. Riutilizzo anche la funzione per trovare la posizione di un valore (in questo 
caso il massimo) e, infine, vado a prendere il valore in vet nella posizione appena ricavata, trovando così 
l’elemento più frequente.
Questo approccio utilizza più risorse dell’algoritmo originale, ma ha un’implementazione più 
semplice che non coinvolge lo stack.
#### Interfaccia testuale e scelta delle operazioni
Si effettua una call alla funzione dell’inserimento dei valori e poi una jump alla funzione della stampa 
del menù: questa stampa la stringa del menù con le varie opzioni chiamando printf e aggiornando 
esp e, infine, fa una jump a loop. Loop è il ciclo principale nel quale viene richiesto un valore tramite 
una scanf per scegliere quale operazione svolgere. Una volta inserito il valore, esso viene salvato 
nell’etichetta op. Vengono poi eseguiti una serie di compare e jump per decidere se saltare ai casi di 
ristampa menù (op=-1), uscita (op=0) o default/valore non supportato (op<-1 o op>10). Altrimenti 
viene decrementato di uno op e si fa una jump alla jump table, la quale reindirizzerà l’esecuzione 
esattamente alla funzione richiesta (spiegazione della jump table nella pagina delle scelte 
progettuali). Ogni funzione (tranne quella per uscire) ritorna sempre al main loop.

### Descrizione delle scelte progettuali effettuate
Una delle principali scelte progettuali effettuate è stata quella di utilizzare una jump table per reindirizzare 
l’esecuzione del programma alla funzione richiesta dall’utente che ha inserito il valore per scegliere 
l’operazione da eseguire sul vettore. La jump table è l’equivalente dello switch/case in C. Nel nostro caso 
però abbiamo tenuto solo i casi delle operazioni da 1 a 10, spostando all’esterno i casi di default, di ristampa 
menù e di uscita. Per accedere alla jump table basta inserire il valore di op in EDX moltiplicato per 4 e fare una 
jump alla jumptable con il valore appena trovato. Nella jump table, infatti tutti i casi (c1, c2, c3, …) sono altre jump 
con etichette che rimandano alle varie funzioni, tutte “distanziate” appunto di 4 bit (align 4).
Il programma riesce a gestire numeri interi con segno di dimensione massima 32 bit, che è la dimensione 
massima di un registro della CPU nell’architettura di riferimento.
