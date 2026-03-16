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
## * @brief  s2_1_ValidaArgumentos Ler a descrição da tarefa S2.1 no enunciado
## */
file="vendas.txt"
date=""
hoje=""
pesokg=""
material=""
nome=""
nome_completo=""

s2_1_ValidaArgumentos () {
    so_debug "<"

    date=$(date '+%Y-%m-%dT%H:%M')
    hoje=$(date '+%Y-%m-%d')
 
    if [[ $# -ne 3 ]]; then
        so_error S2.1
        exit 1
    fi

    nome="$1"
    material="$2"
    pesokg="$3"

    # Nome não pode ser vazio
    if [[ -z "$nome" ]]; then
        so_error S2.1
        exit 1
    fi

    # Peso: inteiro positivo
    if ! [[ "$pesokg" =~ ^[0-9]+$ ]] || [[ "$pesokg" -le 0 ]]; then
        so_error S2.1
        exit 1
    fi

    so_success S2.1
    so_debug ">"
}

##/**
## * @brief  s2_2_ValidaVenda Ler a descrição da tarefa S2.2 no enunciado
## */
s2_2_ValidaVenda () {
    so_debug "<"

    # Se não existe, tentar criar
    if [[ ! -f "$file" ]]; then
        so_error S2.2
        touch "$file" 2>/dev/null
        # Se ainda não existe (não foi possível criar)
        if [[ ! -f "$file" ]]; then
            so_error S2.2
            exit 1
        fi
    fi

    # Verificar permissões de leitura e escrita
    if ! [[ -r "$file" && -w "$file" ]]; then
        so_error S2.2
        exit 1
    fi
 
    # Verificar se material existe em materiais.txt
    if [[ ! -f materiais.txt ]] || ! awk -F';' '{ print $1 }' materiais.txt 2>/dev/null | grep -qx "$material"; then
        so_error S2.2
        exit 1
    fi
 
    # Verificar limite diário (só se existir limite definido)
    limite=$(awk -F';' -v mat="$material" '$1==mat && NF==3 { print $3 }' materiais.txt 2>/dev/null)
    if [[ -n "$limite" ]]; then
        total_hoje=$(awk -F';' -v mat="$material" -v dia="$hoje" \ '$2==mat && substr($4,1,10)==dia { sum+=$3 } END { print sum+0 }' "$file" 2>/dev/null)
        novo_total=$((total_hoje + pesokg))
        if [[ "$novo_total" -gt "$limite" ]]; then
            so_error S2.2
            exit 1
        fi
    fi
 
    # Verificar se vendedor é utilizador válido (primeiro + último nome)
    prim_nome=$(echo "$nome" | awk '{ print $1 }')
    ult_nome=$(echo "$nome" | awk '{ print $NF }')
    nome_completo="$prim_nome $ult_nome"
 
    if ! awk -F':' '{
        split($5, a, ",")
        n = split(a[1], w, " ")
        if (n >= 2) print w[1] " " w[n]
        else print w[1]
    }' /etc/passwd 2>/dev/null | grep -qx "$nome_completo"; then
        so_error S2.2
        exit 1
    fi
 
    # Sucesso ao validar venda
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
        so_error S2.3
        exit 1
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
main "$@"
