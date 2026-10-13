#!/usr/bin/env bash

set -u

# Arquivo de saída na pasta Home do usuário
OUTPUT="$HOME/swordfish.txt"

echo "Procurando arquivos .log no sistema..."

# Cria ou limpa o arquivo de saída
: > "$OUTPUT" || {
    echo "Erro: não foi possível criar $OUTPUT"
    exit 1
}

# Data da coleta
{
    echo "Lista de arquivos .log encontrados"
    echo "Data: $(date)"
    echo "========================================"
} >> "$OUTPUT"

# Procura arquivos .log a partir da raiz do sistema
find / -type f -name "*.log" \
    -not -path "/proc/*" \
    -not -path "/sys/*" \
    -not -path "/dev/*" \
    -print 2>/dev/null >> "$OUTPUT"

echo "Busca concluída."
echo "Arquivo gerado: $OUTPUT"
echo "Quantidade encontrada: $(grep -cE '^/' "$OUTPUT")"
