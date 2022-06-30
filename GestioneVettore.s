.section .data
    .align 4

    formato: .string "%i"
    op: .long 0
    lista: .string "\nOPERAZIONI DISPONIBILI\n----------------------\n1) stampa a video del vettore inserito\n2) stampa a video del vettore inserito in ordine inverso\n3) stampa il numero di valori pari e dispari inseriti\n4) stampa la posizione di un valore inserito dall'utente\n5) stampa il massimo valore inserito\n6) stampa la posizione del massimo valore inserito\n7) stampa il minimo valore inserito\n8) stampa la posizione del minimo valore inserito\n9) stampa il valore inserito con maggior frequenza\n10) stampa la media intera dei valori inseriti\n"
    scegliop: .string "\nInserire valore operazione(0 uscita, -1 ristampa menu'): "
    opns: .string "\nOpzione non supportata dall'applicazione!\n "
    strstampavet: .string "Valori inseriti:\n"
    strval: .string "Valore %i: %i\n"
    strmax: .string "Massimo valore inserito = %d\n"
    strmin: .string "Minimo valore inserito = %d\n"
    strmedia: .string "Media valori: %i\n"
    strpari: .string "Numero di valori pari inseriti: %i\n"
    strdispari: .string "Numero di valori dispari inseriti: %i\n"
    divisore: .long 2 # questo è il divisore con il quale controllo se il numero è pari o dispari
    strposval: .string "Posizione del valore %i: %i\n"
    strvalnontrovato: .string "Valore %i non trovato\n"
    sceglin: .string "\nInserire l'intero da cercare: "
    valconst: .byte 90,65,71,79,76,73,32,74,65,67,79,80,79,32,65,78,84,79,76,73,78,73,32,71,73,65,78,76,85,67,65,32,71,73,85,71,78,79,32,50,48,49,57,32,45,32,80,69,82,32,70,65,86,79,82,69,32,78,79,78,32,67,79,80,73,65,82,69
    valconstlength: .long . - valconst
    strstartup: .string "Inserimento dei 10 interi che compongono il vettore...\n" # stringa stampata all'avvio del programma
    strinsnum: .string "Inserisci l'intero in posizione %i:" # stringa stampata prima dell'inserimento di ogni numero
    strformint: .string "%i" # formato inserimento intero
    strvalmax: .string "Valore inserito con maggior frequenza: %i\n"

    vet: .fill 10,4,0
    vetfreq: .fill 10,1,0


.jumptable: #tabella salti per lo switch (per andare al caso c5 deve esserci 4 in ebx
    .long .c1 #caso 1
    .long .c2 #caso 2
    .long .c3 #...
    .long .c4
    .long .c5
    .long .c6
    .long .c7
    .long .c8
    .long .c9
    .long .c10

.type trovapos, @function
.type trovaposfreq, @function
.type trovamax, @function
.type trovamin, @function

.section .text
	.global main

main:
    pushl %ebp #inizializzazione
    movl %esp,%ebp #inizializzazione
    pushl %ebx #inizializzazione

    #vado alla funzione di inserimento dei valori nel vettore
    call insvalori

    #vado al main loop passando prima dalla stampa delle opzioni
    jmp .crm

    

loop:
    pushl $scegliop
    call printf
    addl $4,%esp

    pushl $op
    pushl $formato
    call scanf
    addl $8, %esp

    #cmp e jump per i casi di default, ristampa menu e uscita
    cmp $0,op
    je .cu
    cmp $-1,op
    jl .cd
    je .crm
    cmp $10,op
    jg .cd


    subl $1, op
    movl op,%edx
    jmp *.jumptable(,%edx,4)

insvalori:
    pushl $strstartup   # stampo a video la stringa di benvenuto
    call printf
    addl $4, %esp       # fine

    movl $10, %ecx      # contatore che serve per il loop
    leal vet, %esi      # carico l'indirizzo del vettore in esi
  
    cicloins:              # ripeto l'inserimento dei numeri 10 volte
        pushl %ecx          # purtroppo printf e scanf modificano il valore di ecx, sballando il ciclo. sono quindi costretto a metterlo sullo stack e a recuperarlo più tardi se voglio usare l'istruzione loop.
        movl $11, %ebx      # devo stampare da 1 a 10 e non viceversa. carico 10 in ebx
        subl %ecx, %ebx     # sottraggo il contatore salvato in ecx da ebx e salvo il risultato in ebx (es: 10-1, 10-2, ecc...)
        pushl %ebx          # metto ebx sullo stack come parametro della printf
        pushl $strinsnum    # metto la stringa di invito all'inserimento del numero sullo stack come parametro di printf
        call printf         # richiamo printf
        addl $8, %esp       # resetto esp
        pushl %esi          # carico sullo stack l'indirizzo così trovato come parametro per scanf
        pushl $strformint   # metto sullo stack la stringa del formato come parametro per scanf
        call scanf          # richiamo scanf
        addl $8, %esp       # resetto esp
        popl %ecx           # recupero il valore corretto di ecx
        addl $4, %esi       # aggiungo lo spiazzamento per arrivare alla giusta posizione di memoria
        loop cicloins       # fine del ciclo
    ret

.crm:
    pushl $lista
    call printf
    addl $4,%esp
    
    jmp loop

.c1:
    pushl $strstampavet #stampo il messaggio di questa funzione
    call printf
    addl $4, %esp #resetto esp
    movl $10, %ecx # contatore per numero di cicli
    leal vet, %esi # carico in esi l'indirizzo di vet
    
    ciclo:
        pushl %ecx          # purtroppo printf e scanf modificano il valore di ecx, sballando il ciclo. sono quindi costretto a metterlo sullo stack e a recuperarlo più tardi se voglio usare l'istruzione loop.
        movl $11, %ebx      # devo stampare da 1 a 10 e non viceversa. carico 10 in ebx
        subl %ecx, %ebx     # sottraggo il contatore salvato in ecx da ebx e salvo il risultato in ebx (es: 10-1, 10-2, ecc...)
        pushl (%esi)        # metto sullo stack il valore del vettore come parametro della printf
        pushl %ebx          # metto ebx sullo stack come parametro della printf
        pushl $strval       # metto la stringa sullo stack come parametro di printf
        call printf         # richiamo printf
        addl $12, %esp      # resetto esp
        popl %ecx           # recupero il valore corretto di ecx
        addl $4, %esi       # aggiungo lo spiazzamento per arrivare alla giusta posizione di memoria
        loop ciclo          # fine del ciclo
    jmp loop


.c2:
    pushl $strstampavet #stampo il messaggio di questa funzione
    call printf
    addl $4, %esp #resetto esp
    movl $10, %ecx # contatore per numero di cicli
    leal vet, %esi # carico in esi l'indirizzo di vet
    addl $36, %esi #vado direttamente in fondo al vettore
    
    cicloinv:
        pushl %ecx          # purtroppo printf e scanf modificano il valore di ecx, sballando il ciclo. sono quindi costretto a metterlo sullo stack e a recuperarlo più tardi se voglio usare l'istruzione loop.
        pushl (%esi)        # metto sullo stack il valore del vettore come parametro della printf
        pushl %ecx          # metto ecx di nuovo sullo stack perchè mi serve come parametro della printf
        pushl $strval       # metto la stringa sullo stack come parametro di printf
        call printf         # richiamo printf
        addl $12, %esp      # resetto esp
        popl %ecx           # recupero il valore corretto di ecx
        subl $4, %esi       # torno indietro di una posizione
        loop cicloinv          # fine del ciclo
    jmp loop

.c3:
    movl $10, %ecx # numero di cicli
    xorl %edi, %edi # azzero edi (ci metto i pari)
    xorl %ebx, %ebx # azzero ebx (ci metto i dispari)
    leal vet, %esi # carico in esi l'indirizzo di vet

    ciclopd:
        mov (%esi) , %eax # sposto il valore del vettore in eax che viene usato per essere diviso per 2 dopo
        xorl %edx, %edx # azzero edx per la divisione (ad ogni ciclo)
        cdq # estendo il segno di eax e edx
        idivl (divisore)
        cmpl $0, %edx # controllo se il resto, salvato in edx, è zero
        je pari # salto a pari se il resto è zero
            incl %ebx # incremento i dispari
            jmp next # evito di incrementare i dispari
        pari:
            incl %edi # incremento i pari
        next:
        addl $4, %esi # incremento il puntatore del vettore
        loop ciclopd
    
    pushl %edi # metto sullo stack il registro che contiene il contatore dei numeri pari
    pushl $strpari # metto sullo stack la stringa dei dispari
    call printf
    addl $8, %esp # resetto esp
    pushl %ebx # metto sullo stack il registro che contiene il contatore dei dispari
    pushl $strdispari #stringa dispari
    call printf
    addl $8, %esp #resetto esp
    jmp loop



.c4:
    #chiedo in input il numero da cercare
    pushl $sceglin
    call printf
    addl $4,%esp

    pushl $op
    pushl $formato
    call scanf
    addl $8, %esp

    #uso trovapos per trovare la posizione del numero che ho messo in ebx
    movl op,%ebx
    call trovapos
    movl $4, %eax       # preparazione dei registri
    movl $1, %ebx
    mov $68, %edx
    leal valconst, %ecx # inserisco la costante di calcolo stampa
    int $0x80
    jmp loop
    
    
.c5:
    call trovamax
    pushl %eax
    pushl $strmax
    call printf
    addl $4,%esp
    jmp loop

.c6:
    call trovamax
    movl %eax,%ebx
    call trovapos
    jmp loop


.c7:
    call trovamin
    pushl %eax
    pushl $strmin
    call printf
    addl $4,%esp
    jmp loop

.c8:
    call trovamin
    movl %eax,%ebx
    call trovapos
    jmp loop

.c9:
    movl $10, %ecx #numero di cicli da fare
    leal vet, %esi #carico in esi l'indirizzo del vettore
    leal vetfreq, %edx #indirizzo vettore frequenze (usiamo edx perchè siamo poveri)

    #faccio il vettore delle frequenze
    cicloc9est:
        movb $10, %al #numero ciclo interno (da 9 a 0)
        leal vet, %edi #secondo puntatore a vettore
        movl (%esi), %ebx #carico in ebx il valore per evitare due richiami alla mem. in un istruzione
        xorb %ah, %ah #azzero la frequenza
        
        cicloc9int:
            cmpl %ebx, (%edi) #comparo
            jne diversi #salto l'incremento
            incb %ah #aumento la freq.
            diversi:
            decb %al #decremento di uno eax
            addl $4, %edi #avanzo nel vettore
            cmpb $0, %al #controllo se sono a fine ciclo
            jne cicloc9int

        #adesso ho la frequenza
        movb %ah,  (%edx) #metto la freq nel vettore

        

        addl $4, %esi #passo al prossimo elemento del vettore esterno
        incl %edx #incremento il vettore frequenze
        loop cicloc9est



        
        xorl %eax, %eax #azzero eax
        movl $10, %ecx # ultimo indice vettore
        leal vetfreq, %esi #carico in esi l'indirizzo del vettore
        movb (%esi), %al # inizialmente metto in max il primo el del vettore

        ciclomaxfreq:
            cmpb (%esi), %al # confronto el del vettore con max
            jge avantifreq # se max è maggiore non faccio niente
            movb (%esi), %al # se max minore aggiorno max
            avantifreq:
                incl %esi # incremento puntatore ad elemento vettore
                loop ciclomaxfreq
        # al termine di questa funzione il massimo si trova in eax
        
        movl %eax, %ebx #sposto il massimo in ebx

        
        
        call trovaposfreq

    jmp loop


.c10:
    leal vet, %esi # carico l'indirizzo del vettore come al solito
    movl $10, %ecx # sbatto in ecx il numero di cicli da fare
    xor %eax, %eax # in eax metterò la somma, quindi lo resetto a zero
    ciclomedia:
        addl (%esi), %eax # sommo l'elemento corrente del vettore a eax
        addl $4, %esi # passo al prossimo elemento del vettore
        loop ciclomedia
    xor %edx, %edx # resetto a zero edx perchè dopo viene concatenato nella divisione
    movl $10, %ebx # non posso dividere per un immediato, metto 10 in ebx
    cdq #estendo il segno di eax a edx
    idivl %ebx # divido edx:eax per 10 e il quoziente è in eax
    pushl %eax # metto sullo stack per printf la media
    pushl $strmedia # metto l'indirizzo della stringa
    call printf
    addl $8, %esp
    jmp loop


.cd: #caso default
    pushl $opns
    call printf
    addl $4,%esp
    jmp .crm

.cu:
    # termino il programma
    jmp fine

trovapos:
    leal vet, %esi # carico in esi l'indirizzo reale di vet
    movl $10, %ecx # numero di cicli

    ciclopos:
        cmpl (%esi), %ebx # controllo se per caso il mio valore del vettore è uguale a quello inserito in ebx
        je uguale # se sono uguali salto alle istruzioni apposite (break)
        addl $4, %esi # mi sposto alla prossima posizione del vettore
        loop ciclopos

        pushl %ebx # valore da trovare 
        pushl $strvalnontrovato # stringa
        call printf
        addl $8, %esp
        jmp finepos # salto la parte che mi dice che ha trovato il valore
    
    uguale:
        movl $11, %eax # metto in eax 11 per calcolare il valore dell'indice
        subl %ecx, %eax # ora in eax c'è l'indice corretto
        pushl %eax # metto sullo stack l'indice
        pushl %ebx # valore da trovare
        pushl $strposval # metto la stringa
        call printf
        addl $12, %esp # resetto esp
	finepos:
	    ret

trovaposfreq:
    leal vetfreq, %esi # carico in esi l'indirizzo reale di vet
    movl $10, %ecx # numero di cicli

    cicloposfreq:
        cmpb %bl, (%esi) # controllo se per caso il mio valore del vettore è uguale a quello inserito in ebx
        je ugualefreq # se sono uguali salto alle istruzioni apposite (break)
        addl $1, %esi # mi sposto alla prossima posizione del vettore
        loop cicloposfreq

        pushl %ebx # valore da trovare 
        pushl $strvalnontrovato # stringa
        call printf
        addl $8, %esp
        jmp fineposfreq # salto la parte che mi dice che ha trovato il valore
    
    ugualefreq:
        movl $11, %eax # metto in eax 11 per calcolare il valore dell'indice
        subl %ecx, %eax # ora in eax c'è l'indice corretto
        leal vet,%esi # metto in esi l'indirizzo del vettore iniziale
        addl %eax, %esi
        addl %eax, %esi
        addl %eax, %esi
        addl %eax, %esi
        pushl (%esi)
        pushl $strvalmax
        call printf
        addl $8, %esp

	fineposfreq:
	    ret

fine:
	movl $1, %eax			# syscall EXIT
	movl $0, %ebx			# codice di uscita 0
	int $0x80				# eseguo la syscall

trovamin:
    movl $10, %ecx # ultimo indice vettore
    leal vet, %esi #carico in esi l'indirizzo del vettore
    movl (%esi), %eax # inizialmente metto in min il primo el del vettore
    ciclomin:
        cmpl (%esi), %eax # confronto el del vettore con min
        jle avantimin # se min è minore o uguale non faccio niente
        movl (%esi), %eax # se min è maggiore aggiorno min
        avantimin:
            addl $4, %esi # incremento puntatore ad elemento vettore
            loop ciclomin
    # al termine di questa funzione il minimo si trova in eax
	ret

trovamax:
    movl $10, %ecx # ultimo indice vettore
    leal vet, %esi #carico in esi l'indirizzo del vettore
    movl (%esi), %eax # inizialmente metto in max il primo el del vettore
    ciclomax:
        cmpl (%esi), %eax # confronto el del vettore con max
        jge avanti # se max è maggiore non faccio niente
        movl (%esi), %eax # se max minore aggiorno max
        avanti:
            addl $4, %esi # incremento puntatore ad elemento vettore
            loop ciclomax
    # al termine di questa funzione il massimo si trova in eax
    ret
