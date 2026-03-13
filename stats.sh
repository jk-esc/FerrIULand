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
## * @brief  s4_1_Validacoes Ler a descrição da tarefa S4.1 no enunciado
## */
s4_1_Validacoes () {
    so_debug "<"

    global fileMat="materiais.txt"
    global fileVendas="vendas.txt" 
    stat1=$1
    stat2=$2
    stat3=$3 
    stat4=$4

    if ! [[ -f "$fileMat" || -f "$fileVendas" ]]; then 
        so_error S4.1 "Ficheiros não existem" 
    fi

    if ! [[ -r "$fileMat" || -r "$fileVendas" ]]; then 
        so_error S4.1 "Ficheiros não têm permissões de leitura"
    fi

    if [[ ! "$opcao" =~ ^[0-4]$ ]]; then
        so_error S5.2.1 
        return 
    fi 

    if [[ $# -eq 0 ]]; then 
        s4_2_1_Stat_Preco
        s4_2_2_Stat_Top3
        s4_2_3_Stat_Rei_Sucata
        s4_2_4_Stat_TopVendedores
    else 
        for args in $@; do
            case $args in 
                1) 
                    s4_2_1_Stat_Preco
                    ;;
                2) 
                    s4_2_2_Stat_Top3
                    ;;
                3)
                    s4_2_3_Stat_Rei_Sucata
                    ;;
                4) 
                    s4_2_4_Stat_TopVendedores
                    ;;
            esac
        done
    fi

    so_debug ">"
}

##/**
## * @brief  s4_2_1_Stat_Preco Ler a descrição da tarefa S4.2.1 no enunciado
## */

# apresetar o nome do material com o preço mais alto 
# mandar para o "null": 2>/dev/null;
s4_2_1_Stat_Preco () {
    so_debug "<"

    glboal maisVendas=$(cat vendas.txt | awk -F';' '{ print $2, $3 }' | sort -k2 -nr |  head -1 | awk '{ print $1 }')
    #global prodMaisVend=$(cat vendas.txt | awk -F';' '{ print $2 }' | grep -qx "$maisVendas")
    global LimiteD=$(cat materiais.txt | awk -F';' -v mat="$maisVendas" '$2 == mat { print $3 }')

    if [[ -z "$limiteD" ]]; then 
        echo "<h2>Stats1:</h2>"
        echo "A bitcoin da sucata é: <b><"$maisVendas"l></b>, sem limite diário."
    else 
        echo "<h2>Stats1:</h2>"
        echo "A bitcoin da sucata é: <b><"$maisVendas"l></b>, com limite diário de: <b><"$LimiteD">kg</b>."
    fi


    so_debug ">"
}

##/**
## * @brief  s4_2_2_Stat_Top3 Ler a descrição da tarefa S4.2.2 no enunciado
## */
s4_2_2_Stat_Top3 () {
    so_debug "<"

    echo "<h2>Stats2:</h2>"
    echo "<p>Top 3 materiais mais vendidos:</p>"
    echo "<ul>"

    local -a top3=( $(cat vendas.txt | awk -F';' '{ print $2";"$3 }' | sort -t';' -k2 -nr | head -3) )

    local counter=1
    for item in "${top3[@]}"; do
        material=$(echo "$item" | cut -d';' -f1)
        quantidade=$(echo "$item" | cut -d';' -f2)
        echo "<li>Top material $counter: <b>$material</b> com <b>$quantidade kg</b> vendidos</li>"
        ((counter++))
    done

    echo "</ul>"

    so_debug ">"
}

##/**
## * @brief  s4_2_3_Stat_Rei_Sucata Ler a descrição da tarefa S4.2.3 no enunciado
## */
s4_2_3_Stat_Rei_Sucata () {
    so_debug "<"

    ##// Substituir este comentário pelo código a ser implementado pelo aluno

    so_debug ">"
}

##/**
## * @brief  s4_2_4_Stat_TopVendedores Ler a descrição da tarefa S4.2.4 no enunciado
## */
s4_2_4_Stat_TopVendedores () {
    so_debug "<"d

    ##// Substituir este comentário pelo código a ser implementado pelo aluno

    so_debug ">"
}

##/**
## * @brief  s4_3_1_Processamento Ler a descrição da tarefa S4.3.1 no enunciado
## */
s4_3_1_Processamento () {
    so_debug "<"

    ##// Substituir este comentário pelo código a ser implementado pelo aluno

    so_debug ">"
}

main () {
    so_debug "<"

    ##// Substituir este comentário pelo código a ser implementado pelo aluno

    so_debug ">"
}
main
