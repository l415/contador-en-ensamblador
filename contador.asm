
#para este código que es una versión similar al anterior lo que intento es poner una condición de salida
#al ingresar el numero 0 el programa llega al inicio de nuevo pidiendo el numero desde el cual va a ir el contador en reversa
#si se pone de nuevo cero el programa termina
#cualquier otro número continúa con la cuenta regresiva


.data
prompt:              .asciiz "Ingrese un número decimal entre 0 y 255 (0 para salir): "
result_prefix:       .asciiz "Los números en hexadecimal desde "
result_suffix:       .asciiz " hasta 00 son: "

.text
main:
    # Bucle principal
    loop_main:
        # Imprimir el prompt
        li $v0, 4
        la $a0, prompt
        syscall

        # Leer la entrada del usuario
        li $v0, 5
        syscall
        move $t0, $v0  # Guardar la entrada en $t0

        # Verificar si el usuario desea salir
        beqz $t0, exit_main

        # Verificar si la entrada está en el rango permitido (1-255)
        bgt $t0, 255, out_of_range
        blt $t0, 1, out_of_range

        # Imprimir el número ingresado por el usuario en hexadecimal
        li $v0, 34      # Cargar la llamada al servicio para imprimir un entero en hexadecimal
        move $a0, $t0   # Cargar el valor a imprimir
        syscall

        # Imprimir los números en hexadecimal desde el ingresado por el usuario hasta cero
        li $t1, 0       # Inicializar el contador en 0 (hexadecimal)

        loop_print:
            # Imprimir el número en hexadecimal
            li $v0, 34     # Cargar la llamada al servicio para imprimir un entero en hexadecimal
            move $a0, $t0  # Cargar el valor a imprimir (usar $t0 en lugar de $t1)
            syscall

            # Imprimir salto de línea
            li $v0, 4
            la $a0, newline
            syscall

            # Decrementar el contador
            sub $t0, $t0, 1

            # Verificar si hemos llegado a cero
            bgez $t0, continue_prompt  # Si no hemos llegado a cero, preguntar al usuario si desea continuar

            j loop_main  # Si hemos llegado a cero, volver al bucle principal

        continue_prompt:
            # Preguntar al usuario si quiere continuar
            li $v0, 4
            la $a0, continue_prompt_msg  # Cambiar la etiqueta a continue_prompt_msg
            syscall

            # Leer la respuesta del usuario
            li $v0, 5
            syscall
            move $t2, $v0  # Guardar la respuesta en $t2

            # Verificar si el usuario quiere continuar
            bnez $t2, loop_print  # Si la respuesta es diferente de cero, volver al bucle de impresión

            j loop_main  # Si la respuesta es cero, volver al bucle principal

    out_of_range:
        # Mostrar un mensaje si la entrada está fuera de rango
        li $v0, 4
        la $a0, out_of_range_msg
        syscall
        j main

    exit_main:
        j exit

    exit:
        li $v0, 10      # Salir del programa
        syscall

.data
out_of_range_msg:       .asciiz "Número fuera de rango. Ingrese un número entre 1 y 255 (0 para salir)."
newline:                .asciiz "\n"
continue_prompt_msg:    .asciiz "¿Desea continuar? (0 para salir, cualquier otro número para continuar): "
