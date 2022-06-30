.data
    vet: .long 19,9,198,4,5,6,7,8,31,0
    strstampavet: .string "Valori inseriti:\n"
    strval: .string "Valore %i: %i\n"
.text
    .global main

main:
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


movl $1, %eax # uscita dal programma
int $0x80
