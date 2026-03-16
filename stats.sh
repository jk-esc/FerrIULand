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


    # Validar argumentos primeiro
    for arg in "$@"; do
        if [[ ! "$arg" =~ ^[1-4]$ ]]; then
            so_error S4.1
            exit 1
        fi
    done

    # Verificar se os ficheiros existem
    if ! [[ -f "materiais.txt" && -f "vendas.txt" ]]; then
        so_error S4.1
        exit 1
    fi

    # Verificar permissões de leitura
    if ! [[ -r "materiais.txt" && -r "vendas.txt" ]]; then
        so_error S4.1
        exit 1
    fi

    so_success S4.1
    so_debug ">"
}

##/**
## * @brief  s4_2_1_Stat_Preco Ler a descrição da tarefa S4.2.1 no enunciado
## */

# apresetar o nome do material com o preço mais alto 

s4_2_1_Stat_Preco () {
    so_debug "<"

    local material=$(awk -F';' '{ print $1";"$2 }' materiais.txt | sort -t';' -k2 -nr | head -1 | cut -d';' -f1)
    local limite=$(awk -F';' -v mat="$material" '$1 == mat { print $3 }' materiais.txt)
    echo "<h2>Stats1:</h2>"
    if [[ -z "$limite" ]]; then
        echo "A bitcoin da sucata é: <b>$material</b>, sem limite diário."
    else
        echo "A bitcoin da sucata é: <b>$material</b>, com limite diário de: <b>${limite}kg</b>."
    fi


    so_debug ">"
}

##/**
## * @brief  s4_2_2_Stat_Top3 Ler a descrição da tarefa S4.2.2 no enunciado
## */
s4_2_2_Stat_Top3 () {
    so_debug "<"

    local mes_atual=$(date +%Y-%m)
    echo "<h2>Stats2:</h2>"
    echo "<ul>"
    local counter=1
    while IFS=';' read -r kg material; do
        echo "<li>Top material $counter: <b>$material</b>, com <b>${kg}kg</b> transacionados.</li>"
        ((counter++))
    done < <(awk -F';' -v mes="$mes_atual" 'substr($4,1,7)==mes { kg[$2]+=$3 } END { for(m in kg) print kg[m]";"m }' vendas.txt | sort -t';' -k1 -nr | head -3)
    echo "</ul>"

    so_debug ">"
}

##/**
## * @brief  s4_2_3_Stat_Rei_Sucata Ler a descrição da tarefa S4.2.3 no enunciado
## */
s4_2_3_Stat_Rei_Sucata () {
    so_debug "<"
    
    # Extrair o mês anterior (formato YYYY-MM)
    # Se estamos em 2026-03, queremos 2026-02
    local mes_anterior=$(date -d "1 month ago" +%Y-%m)
    
    # Processar vendas e calcular stats por vendedor
    local rei=$(cat vendas.txt | awk -F';' -v mes="$mes_anterior" '
    # Verificar se a venda é do mês anterior
    substr($4, 1, 7) == mes {
        vendedor = $1
        material = $2
        kg = $3
        
        # Procurar preço do material em materiais.txt
        while ((getline line < "materiais.txt") > 0) {
            split(line, f, ";")
            if (f[1] == material) {
                preco = f[2]
                break
            }
        }
        close("materiais.txt")
        
        # Acumular dinheiro e kg por vendedor
        dinheiro[vendedor] += kg * preco
        kg_total[vendedor] += kg
    }
    END {
        # Encontrar vendedor com melhor razão (mais dinheiro por kg)
        melhor_razao = 0
        melhor_vendedor = ""
        
        for (v in dinheiro) {
            razao = dinheiro[v] / kg_total[v]
            if (razao > melhor_razao) {
                melhor_razao = razao
                melhor_vendedor = v
            }
        }
        print melhor_vendedor
    }')
    
    local mes_apresentacao=$(date -d "1 month ago" +%Y-%m)
    
    echo "<h2>Stats3:</h2>"
    echo "O rei das sucatas do mês de <b>$mes_apresentacao</b> é: <b>$rei</b>."
    
    so_debug ">"
}

##/**
## * @brief  s4_2_4_Stat_TopVendedores Ler a descrição da tarefa S4.2.4 no enunciado
## */
s4_2_4_Stat_TopVendedores () {
    so_debug "<"

    local ano_corrente=$(date +%Y)
    echo "<h2>Stats4:</h2>"
    echo "<ul>"
    local counter=1
    while IFS=';' read -r num_vendas vendedor; do
        echo "<li>Top vendedor $counter: <b>$vendedor</b>, com <b>$num_vendas</b> vendas.</li>"
        ((counter++))
    done < <(awk -F';' -v ano="$ano_corrente" 'substr($4,1,4)==ano { vendas[$1]++ } END { for(v in vendas) print vendas[v]";"v }' vendas.txt | sort -t';' -k1 -nr | head -3)
    echo "</ul>"

    so_debug ">"
}

##/**
## * @brief  s4_3_1_Processamento Ler a descrição da tarefa S4.3.1 no enunciado
## */
s4_3_1_Processamento () {
    so_debug "<"

    local data_hora=$(date '+%Y-%m-%d %H:%M:%S')

    printf '<html><head><meta charset="UTF-8"><title>FerrIULândia: Estatísticas</title></head>\n<body><h1>Lista atualizada em %s</h1>\n' "$data_hora" > stats.html

    if [[ $# -eq 0 ]]; then
        s4_2_1_Stat_Preco >> stats.html
        s4_2_2_Stat_Top3 >> stats.html
        s4_2_3_Stat_Rei_Sucata >> stats.html
        s4_2_4_Stat_TopVendedores >> stats.html
    else
        for arg in "$@"; do
            case $arg in
                1) s4_2_1_Stat_Preco >> stats.html ;;
                2) s4_2_2_Stat_Top3 >> stats.html ;;
                3) s4_2_3_Stat_Rei_Sucata >> stats.html ;;
                4) s4_2_4_Stat_TopVendedores >> stats.html ;;
            esac
        done
    fi

    printf '</body></html>\n' >> stats.html

    so_success S4.3
    so_debug ">"
}

main () {
    so_debug "<"

       # Validar ficheiros e parâmetros
    s4_1_Validacoes "$@"
    
    # Gerar o ficheiro stats.html com todas as estatísticas
    s4_3_1_Processamento "$@"

    so_debug ">"
}
main "$@"
