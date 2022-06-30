.data
    vet: .long 19,9,198,4,5,6,7,8,31,0
    strstampavetinv: .string "Valori inseriti:\n"
    strval: .string "Valore %i: %i\n"
.text
    .global main

main:
    pushl $strstampavetinv #stampo il messaggio di questa funzione
    call printf
    addl $4, %esp #resetto esp
    movl $10, %ecx # contatore per numero di cicli
    leal vet, %esi # carico in esi l'indirizzo di vet
    addl $36, %esi #vado direttamente in fondo al vettore
    
    ciclo:
        pushl %ecx          # purtroppo printf e scanf modificano il valore di ecx, sballando il ciclo. sono quindi costretto a metterlo sullo stack e a recuperarlo più tardi se voglio usare l'istruzione loop.
        pushl (%esi)        # metto sullo stack il valore del vettore come parametro della printf
        pushl %ecx          # metto ecx di nuovo sullo stack perchè mi serve come parametro della printf
        pushl $strval       # metto la stringa sullo stack come parametro di printf
        call printf         # richiamo printf
        addl $12, %esp      # resetto esp
        popl %ecx           # recupero il valore corretto di ecx
        subl $4, %esi       # torno indietro di una posizione
        loop ciclo          # fine del ciclo


movl $1, %eax # uscita dal programma
int $0x80
