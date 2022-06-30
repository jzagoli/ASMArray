.section .data
    vet: .long 19,9,198,4,5,6,7,8,31,301
    strmin: .string "Minimo valore inserito = %d\n"
.section .text
    .global main

main:
    
	.type min, @function
    movl $10, %ecx # ultimo indice vettore
    leal vet, %esi #carico in esi l'indirizzo del vettore
    movl (%esi), %eax # inizialmente metto in min il primo el del vettore
    ciclo:
        cmpl (%esi), %eax # confronto el del vettore con min
        jle avanti # se min è minore o uguale non faccio niente
        movl (%esi), %eax # se min è maggiore aggiorno min
        avanti:
            addl $4, %esi # incremento puntatore ad elemento vettore
            loop ciclo
    # al termine di questa funzione il minimo si trova in eax
	ret