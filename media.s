.section .data
    vet: .long 19,9,198,4,5,6,7,8,-31,301
    strmedia: .string "Media valori: %i\n"
.section .text
    .global main

main:
    
    leal vet, %esi # carico l'indirizzo del vettore come al solito
    movl $10, %ecx # sbatto in ecx il numero di cicli da fare
    xor %eax, %eax # in eax metterò la somma, quindi lo resetto a zero
    ciclo:
        addl (%esi), %eax # sommo l'elemento corrente del vettore a eax
        addl $4, %esi # passo al prossimo elemento del vettore
        loop ciclo
    xor %edx, %edx # resetto a zero edx perchè dopo viene concatenato nella divisione
    movl $10, %ebx # non posso dividere per un immediato, metto 10 in ebx
    idivl %ebx # divido edx:eax per 10 e il quoziente è in eax
    pushl %eax # metto sullo stack per printf la media
    pushl $strmedia # metto l'indirizzo della stringa
    call printf
    addl $8, %esp


movl $1, %eax # uscita dal programma
int $0x80
