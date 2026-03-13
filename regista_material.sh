#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº: 124575      Nome: Luiz da Silva
## Nome do Módulo: regista_material.sh
## Descrição/Explicação do Módulo:
##
##
#####################################################################################

##/**
## * @brief  s1_1_ValidaArgumentos Ler a descrição da tarefa S1.1 no enunciado
## */
s1_1_ValidaArgumentos () {
    so_debug "<"

    # ./regista_material.sh Ferro 1 1000 // OU: ./regista_material.sh Aluminio 2 (Todos para o materiais.txt)
    global material=$1
    global precoKg=$2
    global limiteD=$3

    if [[ $# -lt 2  ||  $# -gt 3 ]]; then
        so_error S1.1 "menos de 2 argumentos OU mais de 3"
        return
    fi

    if [[ ${#material} -lt 2 ]]; then 
        so_error S1.1 "o argumento de material tem menos de 2 caracteres" 
        return
    fi

    if ! [[ "$precoKg" =~ ^[0-9]+$  && "$precoKg" -gt 0 ]]; then 
        so_error S1.1 "o preço por kg não é um valor númerico positivo"
        return
    fi

    if [[ -n "$limiteD" ]]; then 
        if ! [[ "$limiteD" =~ ^[0-9]+$ && "$limiteD" -gt 0 ]]; then
            so_error S1.1 "0 limite diário não é um valor númerico positivo"
            return
        fi
    fi

    if [[ -n "$limiteD" ]]; then 
        echo "$material;$precoKg;$limiteD" >> materiais.txt
    else 
        echo "$material;$precoKg" >> materiais.txt
    fi

    so_success S1.1
    so_debug ">"
}

##/**
## * @brief  s1_2_ValidaMaterial Ler a descrição da tarefa S1.2 no enunciado
## */
s1_2_ValidaMaterial () {
    so_debug "<"

    global file="materiais.txt"
    if ! [[ -f "$file" ]]; then 
        echo "criar ficheiro: ${file}"
        touch materiais.txt
        so_error S1.2 
    elif ! [[ -r {$file} || -w {$file} ]]; then 
        so_error s1.2 "Não tem permissões de leitura ou de escritura"
        return
    fi 
    

    if [[ $(awk -F';' '{ print $1 }' materiais.txt) != *"$material"* ]]; then 
        so_error S1.2
        s1_3_AdicionaMaterial
    else 
        so_success S1.2 
        s1_4_ListaMaterial
        return
    fi

    so_debug ">"
}

##/**
## * @brief  s1_3_AdicionaMaterial Ler a descrição da tarefa S1.3 no enunciado
## */
s1_3_AdicionaMaterial () {
    so_debug "<"

    if [[ -n "$limiteD" ]]; then 
        if [[ -f "$file" ]]; then 
            so_error S1.3 "Ficheiro não existe"
        else 
            echo "$material;$precoKg;$limiteD" >> materiais.txt
        fi
    else 
        if [[ -f "$file" ]]; then 
            so_error S1.3 "Ficheiro não existe"
        else 
            echo "$material;$precoKg" >> materiais.txt
        fi
    fi

    so_success S1.3 
    so_debug ">"
}

##/**
## * @brief  s1_4_ListaMaterial Ler a descrição da tarefa S1.4 no enunciado
## */
s1_4_ListaMaterial () {
    so_debug "<"

    ##// Substituir este comentário pelo código a ser implementado pelo aluno
    if [[ -f "$file" ]]; then
        so_error S1.4 "Não exisite o ficheiro materiais.txt"
    else 
        cat materiais.txt | sort -n -k 2 >> materiais-ordenados-preco.txt
    fi 

    so_success S1.4
    so_debug ">"
}

main () {
    so_debug "<"

    ##// Substituir este comentário pelo código a ser implementado pelo aluno

    so_debug ">"
}
main