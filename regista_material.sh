#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº:     Nome:
## Nome do Módulo: menu.sh
## Descrição/Explicação do Módulo:
##
##
#####################################################################################

###/**
## * @brief  s1_1_ValidaArgumentos Ler a descrição da tarefa S1.1 no enunciado
## */

material=""
precoKg=""
limiteD=""
file="materiais.txt"

s1_1_ValidaArgumentos () {
    so_debug "<"

    # ./regista_material.sh Ferro 1 1000 // OU: ./regista_material.sh Aluminio 2 (Todos para o materiais.txt)
    material=$1
    precoKg=$2
    limiteD=$3

    if [[ $# -lt 2  ||  $# -gt 3 ]]; then
        so_error S1.1 
        exit 1 
    fi

    if [[ ${#material} -lt 2 ]]; then 
        so_error S1.1 
        exit 1 
    fi

    if ! [[ "$precoKg" =~ ^[0-9]+$  && "$precoKg" -gt 0 ]]; then 
        so_error S1.1 
        exit 1 
    fi

    if [[ $# -eq 3 ]]; then
      if ! [[ "$limiteD" =~ ^[0-9]+$ && "$limiteD" -gt 0 ]]; then
        so_error S1.1
        exit 1
      fi
    fi

    so_success S1.1
    so_debug ">"
}

##/**
## * @brief  s1_2_ValidaMaterial Ler a descrição da tarefa S1.2 no enunciado
## */
s1_2_ValidaMaterial () {
    so_debug "<"

    if [[ ! -f "$file" ]]; then
        so_error S1.2
        touch "$file" 2>/dev/null
        if [[ ! -f "$file" ]]; then
            so_error S1.2
            exit 1
        fi
    fi

    if ! [[ -r "$file" && -w "$file" ]]; then
        so_error S1.2
        exit 1
    fi

    if awk -F';' '{ print $1 }' "$file" | grep -qx "$material"; then
        so_success S1.2
        s1_4_ListaMaterial
    else
        so_error S1.2
        s1_3_AdicionaMaterial
    fi    

    so_debug ">"
}

##/**
## * @brief  s1_3_AdicionaMaterial Ler a descrição da tarefa S1.3 no enunciado
## */
s1_3_AdicionaMaterial () {
    so_debug "<"

    if [[ ! -f "$file" ]]; then
        so_error S1.3
        exit 1 
    fi

    if [[ -n "$limiteD" ]]; then
        echo "$material;$precoKg;$limiteD" >> "$file"
    else
        echo "$material;$precoKg" >> "$file"
    fi

    so_success S1.3
    s1_4_ListaMaterial
    so_debug ">"
}

##/**
## * @brief  s1_4_ListaMaterial Ler a descrição da tarefa S1.4 no enunciado
## */
s1_4_ListaMaterial () {
    so_debug "<"

    if [[ ! -f "$file" ]]; then
        so_error S1.4
        exit 1
    fi

    sort -t ';' -k2 -n "$file" > materiais-ordenados-preco.txt

    so_success S1.4
    so_debug ">"
}

main () {
    so_debug "<"

    s1_1_ValidaArgumentos "$@"
    s1_2_ValidaMaterial

    so_debug ">"
}
main
