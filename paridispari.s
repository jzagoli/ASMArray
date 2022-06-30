.section .data
    vet: .long 0,99999,0,-2345,0,0,0,0,0,0
    strpari: .string "Numero di valori pari inseriti: %i\n"
    strdispari: .string "Numero di valori dispari inseriti: %i\n"
    divisore: .long 2 # questo è il divisore con il quale controllo se il numero è pari o dispari

.section .text
    .global main

main:

    movl $10, %ecx # numero di cicli
    xorl %edi, %edi # azzero edi (ci metto i pari)
    xorl %ebx, %ebx # azzero ebx (ci metto i dispari)
    leal vet, %esi # carico in esi l'indirizzo di vet

    ciclo:
        mov (%esi) , %eax # sposto il valore del vettore in eax che viene usato per essere diviso per 2 dopo
        xorl %edx, %edx # azzero edx per la divisione (ad ogni ciclo)
        idivl (divisore)
        cmpl $0, %edx # controllo se il resto, salvato in edx, è zero
        je pari # salto a pari se il resto è zero
            incl %ebx # incremento i dispari
            jmp next # evito di incrementare i dispari
        pari:
            incl %edi # incremento i pari
        next:
        addl $4, %esi # incremento il puntatore del vettore
        loop ciclo

    pushl %edi # metto sullo stack il registro che contiene il contatore dei numeri pari
    pushl $strpari # metto sullo stack la stringa dei dispari
    call printf
    addl $8, %esp # resetto esp
    pushl %ebx # metto sullo stack il registro che contiene il contatore dei dispari
    pushl $strdispari #stringa dispari
    call printf
    addl $8, %esp #resetto esp


movl $1, %eax #fine
int $0x80
