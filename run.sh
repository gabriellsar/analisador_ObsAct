#!/bin/bash

PASTA_SAIDAS="testes/saidas"
ARQ_CORE="core.c"

if [ ! -f "$ARQ_CORE" ]; then
    echo "❌ Erro: Arquivo '$ARQUIVO_CORE' não encontrado!"
    exit 1
fi

if ! ls testes/saidas/*.c &>/dev/null; then
    echo "Nenhum arquivo .c encontrado."
    echo "Você rodou 'make test' primeiro?"
    exit 0
fi

for arquivo_c in "$PASTA_SAIDAS"/*.c
do
  base_name=$(basename "$arquivo_c" .c)
  executavel="$PASTA_SAIDAS/exec/$base_name"
    echo ""
    echo "========================================"
    echo "Compilando: $arquivo_c"
   if gcc -I. -o "$executavel" "$ARQ_CORE" "$arquivo_c"; then
        echo -e "\e[32m✅ Sucesso na Compilação\e[0m"
        echo "--- Saída de '$base_name': ---"
        echo "" 
        "$executavel"
    else
        echo -e "\e[31m❌ Falha na Compilação\e[0m"
    fi
done
echo -e "\e[36m✅ Execução de saídas concluída.\e[0m"
