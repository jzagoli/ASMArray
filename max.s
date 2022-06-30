.section .data
    vet: .long 19,9,198,4,5,6,7,8,31,301
    strmax: .string "Massimo valore inserito = %d\n"
.section .text
    .global main

main:

	.type max, @function
    movl $10, %ecx # ultimo indice vettore
    leal vet, %esi #carico in esi l'indirizzo del vettore
    movl (%esi), %eax # inizialmente metto in max il primo el del vettore
    ciclo:
        cmpl (%esi), %eax # confronto el del vettore con max
        jge avanti # se max è maggiore non faccio niente
        movl (%esi), %eax # se max minore aggiorno max
        avanti:
            addl $4, %esi # incremento puntatore ad elemento vettore
            loop ciclo
    # al termine di questa funzione il massimo si trova in eax
	ret