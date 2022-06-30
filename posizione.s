# cerca il valore in posizione passata come parametro in ebx
.section .data
    vet: .long 1,2,3,4,5,6,7,8,9,10
    strposval: .string "Posizione del valore %i: %i\n"
    strvalnontrovato: .string "Valore %i non trovato\n"
	
.section .text
    .global main

main:
	
	.type posizione, @function
    leal vet, %esi # carico in esi l'indirizzo reale di vet
    movl $10, %ecx # numero di cicli

    ciclo:
        cmpl (%esi), %ebx # controllo se per caso il mio valore del vettore è uguale a quello inserito in ebx
        je uguale # se sono uguali salto alle istruzioni apposite (break)
        addl $4, %esi # mi sposto alla prossima posizione del vettore
        loop ciclo

        pushl %ebx # valore da trovare 
        pushl $strvalnontrovato # stringa
        call printf
        addl $8, %esp
        jmp fine # salto la parte che mi dice che ha trovato il valore
    
    uguale:
        movl $11, %eax # metto in eax 11 per calcolare il valore dell'indice
        subl %ecx, %eax # ora in eax c'è l'indice corretto
        pushl %eax # metto sullo stack l'indice
        pushl %ebx # valore da trovare
        pushl $strposval # metto la stringa
        call printf
        addl $12, %esp # resetto esp
	fine:
	ret
