#!/bin/bash
# SO_HIDE_DEBUG=1                   ## Uncomment this line to hide all @DEBUG statements
# SO_HIDE_COLOURS=1                 ## Uncomment this line to disable all escape colouring
. so_utils.sh                       ## This is required to activate the macros so_success, so_error, and so_debug

#####################################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2025/2026, Enunciado Versão 1
##
## Aluno: Nº: 124575      Nome: Luiz da Silva
## Nome do Módulo: regista_venda.sh
## Descrição/Explicação do Módulo:
##
##
#####################################################################################

##/**
## * @brief  s2_1_ValidaArgumentos Ler a descrição da tarefa S2.1 no enunciado
## */
s2_1_ValidaArgumentos () {
    so_debug "<"

    global file="vendas.txt"
    global nome=$1
    global material=$2
    global pesokg=$3
    global date=$(date '+%Y-%m-%dT%H:%M')
    global hoje=$(date '+%Y-%m-%d')

    if [[ $# -ne 3 ]]; then 
        so_error S2.1 "Os argumentos não são exatamente 3"
        return
    fi

    if ! [[ "$pesokg" =~ '[0-9]' &&  "$pesokg" -gt 0 ]]; then 
        so_error S2.1 "O preço por kg não é um inteiro, ou se for não é maior que 0"
        return 
    fi

    so_success S2.1 
    so_debug ">"
}

##/**
## * @brief  s2_2_ValidaVenda Ler a descrição da tarefa S2.2 no enunciado
## */
s2_2_ValidaVenda () {
    so_debug "<"
    
    if [[ ! -f "$file" ]]; then
        so_error S2.2 
        touch vendas.txt 
    elif [[ ! -r "$file" || ! -w "$file" ]]; then
        so_error S2.2 "Não tem permissões"
        return 
    fi 

    if [[ $(awk -F';' '{ print $2 }' vendas.txt) != *"$material"* ]]; then
        so_error S2.2 "o material não existe na bd" 
    fi

    limite=$(awk -F';' '{ print $3 }' materiais.txt)
    total_hoje=$(grep -i ";$material;" "$file" | grep "$hoje" | awk -F';' '{ sum += $3 } END { print sum+0 }' )
    novo_total=$((total_hoje + pesokg))

    if [[ "$novo_total" -gt "$limite" ]]; then 
        maximo=$((limite - total_hoje))
        so_error S2.2 "limites e cenas"
        return
    fi

    global prim_nome=$(echo "$nome" | awk '{ print $1 }')
    global ult_nome=$(echo "$nome" | awk '{ print $NF }')
    global nome_completo="$prim_nome $ult_nome"

    if ! cat /etc/passwd | awk -F':' '{ print $5 }' | grep -qx "$nome_completo"; then 
        so_error S2.2 "O vendedor '$nome_completo' não é um utilizador válido do sistema" 
        return
    fi

    so_success S2.2 
    so_debug ">"
}

##/**
## * @brief  s2_3_AdicionaVenda Ler a descrição da tarefa S2.3 no enunciado
## */
s2_3_AdicionaVenda () {
    so_debug "<"

    linha="$nome_completo;$material;$pesokg;$date"
    if echo "$linha" >> "$file"; then
        so_success S2.3
    else
        so_error S2.3 "Erro ao adicionar venda ao ficheiro vendas.txt"
        return
    fi

    so_debug ">"
}

main () {
    so_debug "<"

    s2_1_ValidaArgumentos "$@"
    s2_2_ValidaVenda
    s2_3_AdicionaVenda


    so_debug ">"
}
main