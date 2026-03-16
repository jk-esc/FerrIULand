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

#

##/**
## * @brief  s3_1_Manutencao Ler a descrição da tarefa S3.1 no enunciado
## */
s3_1_Manutencao () {
    so_debug "<"
    fileMat="materiais.txt"
    fileVendas="vendas.txt"
    hoje=$(date '+%Y-%m-%d')

    # Verificar materiais.txt
    if ! [[ -f "$fileMat" ]]; then
        so_error S3.1
        exit 1
    fi
    if ! [[ -r "$fileMat" && -w "$fileMat" ]]; then
        so_error S3.1
        exit 1
    fi

    # vendas.txt é opcional — se não existir, não há nada a fazer
    if [[ -f "$fileVendas" ]]; then
        if ! [[ -r "$fileVendas" ]]; then
            so_error S3.1
            exit 1
        fi
    fi

    so_success S3.1

    # Lógica de manutenção: para cada material com limite definido,
    # verificar se o total vendido hoje excede o limite e atualizar
    if [[ -f "$fileVendas" ]]; then
        awk -F';' -v OFS=';' -v hoje="$hoje" '
            NR==FNR {
                # Ler vendas do dia para cada material
                split($4, dt, "T")
                if (dt[1] == hoje) vendas[$2] += $3
                next
            }
            {
                # Processar materiais
                if (NF == 3 && ($1 in vendas) && vendas[$1] >= $3) {
                    $3 = $3 + 100
                }
                print
            }
        ' "$fileVendas" "$fileMat" > /tmp/mat_tmp && mv /tmp/mat_tmp "$fileMat"
    fi

    so_debug ">"
}

main () {
    so_debug "<"

    s3_1_Manutencao

    so_debug ">"
}
main
## S3.2. Invocação do script:
## • Altere o ficheiro cron.def fornecido, por forma a configurar o seu sistema para que o Script: manutencao.sh  seja executado todos os dias de segunda-feira a sábado (incluindo feriados), quando tiver passado um minuto da meia-noite (às 0h01). Nos comentários no início do ficheiro cron.def, explique a configuração realizada, e indique qual é o comando Shell associado a essa configuração que vai ser utilizado para despoletar essa configuração.
## • O ficheiro cron.def alterado deverá ser submetido para avaliação juntamente com os outros Shell scripts
## • Não deverá ser acrescentado nenhum código neste ficheiro manutencao.sh para responder a esta alínea, todas as respostas deverão ser realizadas no ficheiro cron.def.
