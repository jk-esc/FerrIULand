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

## Este script invoca os scripts restantes, não recebendo argumentos.
## Atenção: Não é suposto que volte a fazer nenhuma das funcionalidades dos scripts anteriores. O propósito aqui é simplesmente termos uma forma centralizada de invocar os restantes scripts.

##/**
## * @brief  s5_1_MostraMenu Ler a descrição da tarefa S5.1 no enunciado.
## *         Esta função preenche o valor da variável $opcao com a opção dada pelo utilizador
## */
s5_1_MostraMenu () {
    so_debug "<"

    echo "MENU:"
    echo "1: Regista material"
    echo "2: Regista venda"
    echo "3: Manutenção"
    echo "4: Estatísticas"
    echo "0: Sair"
    read -p "Opção: " opcao


    so_debug ">"
}

##/**
## * @brief  s5_2_1_ValidaOpcao Ler a descrição da tarefa S5.2.1 no enunciado
## */
s5_2_1_ValidaOpcao () {
    so_debug "<"

    if [[ ! "$opcao" =~ ^[0-4]$ ]]; then
        so_error S5.2.1 "$opcao"
        exit 1
    fi 

    so_success S5.2.1 "$opcao"
    so_debug ">"
}

##/**
## * @brief  s5_2_2_ProcessaOpcao Ler a descrição da tarefa S5.2.2 no enunciado
## */
s5_2_2_ProcessaOpcao () {
    so_debug "<"

    case $opcao in
        0)
            exit 0
            ;;
        1)
            s5_3_Opcao1
            ;;
        2)
            s5_4_Opcao2
            ;;
        3)
            s5_5_Opcao3
            ;;
        4)
            s5_6_Opcao4
            ;;
    esac

    so_debug ">"
}

##/**
## * @brief  s5_3_Opcao1 Ler a descrição da tarefa S5.3 no enunciado
## */
s5_3_Opcao1 () {
    so_debug "<"

    echo "Regista material:"
    read -p "Introduza o nome do material: " nome
    read -p "Introduza o preço: " preco
    read -p "Introduza o limite diário em kg [opcional] " limite

    if [[ -n "$limite" ]]; then          # só passa limite se não for vazio
        ./regista_material.sh "$nome" "$preco" "$limite"
    else
        ./regista_material.sh "$nome" "$preco"
    fi

    so_success S5.3
    so_debug ">"
}

##/**
## * @brief  s5_4_Opcao2 Ler a descrição da tarefa S5.3 no enunciado
## */
s5_4_Opcao2 () {
    so_debug "<"
    
    echo "Regista venda:"
    read -p "Introduza o nome do vendedor: " vendedor
    read -p "Introduza o nome do material: " material
    read -p "Introduza a quantidade em kg do material: " quantidade

    ./regista_venda.sh "$vendedor" "$material" "$quantidade"

    so_success S5.4
    so_debug ">"
}

##/**
## * @brief  s5_5_Opcao3 Ler a descrição da tarefa S5.3 no enunciado
## */
s5_5_Opcao3 () {
    so_debug "<"

    ./manutencao.sh
    so_success S5.5

    so_debug ">"
}

##/**
## * @brief  s5_6_Opcao4 Ler a descrição da tarefa S5.3 no enunciado
## */
s5_6_Opcao4 () {
    so_debug "<"

    echo "Estatísticas:"
    echo "1: nome do material com o preço mais alto"
    echo "2: top3 dos materiais com mais kg comercializados no mês atual"
    echo "3: nome do rei das sucatas do mês passado"
    echo "4: lista dos vendedores que realizaram maior número de vendas"
    echo "5: todas as estatísticas anteriores, na ordem numérica indicada"
    read -p "Indique quais as estatísticas a incluir, opções separadas por espaço: " estatisticas

    if [[ -z "$estatisticas" ]]; then
        so_error S5.6
    elif [[ " $estatisticas " =~ " 5 " ]]; then
        ./stats.sh
        so_success S5.6
    else
        ./stats.sh $estatisticas
        so_success S5.6
    fi

    so_debug ">"
}

main () {
    so_debug "<"

    while true; do
        s5_1_MostraMenu
        
        if ! s5_2_1_ValidaOpcao; then
            continue
        fi
        
        s5_2_2_ProcessaOpcao
    done

    so_debug ">"
}
main
