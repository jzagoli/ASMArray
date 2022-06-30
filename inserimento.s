.section .data
  strstartup: .string "Inserimento dei 10 interi che compongono il vettore...\n" # stringa stampata all'avvio del programma
  strinsnum: .string "Inserisci l'intero in posizione %i:" # stringa stampata prima dell'inserimento di ogni numero
  strformint: .string "%i" # formato inserimento intero

.section .bss
  vet: .fill 10,4,0

.section .text
  .global main

main:
  
  pushl $strstartup   # stampo a video la stringa di benvenuto
  call printf
  addl $4, %esp       # fine

  movl $10, %ecx      # contatore che serve per il loop
  leal vet, %esi      # carico l'indirizzo del vettore in esi
  
  ciclo:              # ripeto l'inserimento dei numeri 10 volte
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
    loop ciclo          # fine del ciclo

movl $1, %eax       # uscita dal programma
int $0x80

