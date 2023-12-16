.data
prompt:          .asciiz "Ingrese un número decimal entre 0 y 255: "
result_prefix:  .asciiz "Los números en hexadecimal desde "
result_suffix:  .asciiz " hasta 00 son: "

.text
main:
    # Imprimir el prompt
    li $v0, 4
    la $a0, prompt
    syscall

    # Leer la entrada del usuario
    li $v0, 5
    syscall
    move $t0, $v0  # Guardar la entrada en $t0

    # Verificar si la entrada está en el rango permitido (0-255)
    bgt $t0, 255, out_of_range
    blt $t0, 0, out_of_range

    # Imprimir el prefijo del resultado
    li $v0, 4
    la $a0, result_prefix
    syscall

    # Imprimir el número ingresado por el usuario en hexadecimal
    li $v0, 34      # Cargar la llamada al servicio para imprimir un entero en hexadecimal
    move $a0, $t0   # Cargar el valor a imprimir
    syscall

    # Imprimir el sufijo del resultado
    li $v0, 4
    la $a0, result_suffix
    syscall

    # Imprimir los números en hexadecimal desde el ingresado por el usuario hasta cero
    li $t1, 16      # Inicializar el contador en 16 (hexadecimal)

    loop:
        # Imprimir el número en hexadecimal
        li $v0, 34     # Cargar la llamada al servicio para imprimir un entero en hexadecimal
        move $a0, $t0  # Cargar el valor a imprimir
        syscall

        # Imprimir espacio para separar los números
        li $v0, 4
        la $a0, space
        syscall

        # Decrementar el contador
        sub $t0, $t0, 1

        # Verificar si hemos llegado a cero
        beqz $t0, exit_loop

        # Iterar nuevamente
        j loop

    exit_loop:
        j exit

out_of_range:
    # Mostrar un mensaje si la entrada está fuera de rango
    li $v0, 4
    la $a0, out_of_range_msg
    syscall
    j main

exit:
    li $v0, 10      # Salir del programa
    syscall

.data
out_of_range_msg: .asciiz "Número fuera de rango. Ingrese un número entre 0 y 255."
space:            .asciiz " "
