#!/usr/bin/env bash
set -u

# Identifica o usuário original
if [[ -n "${SUDO_USER:-}" ]]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    USER_HOME="$HOME"
fi

# Valida a pasta Home
if [[ -z "$USER_HOME" || ! -d "$USER_HOME" ]]; then
    echo "Erro: não foi possível identificar a pasta Home do usuário."
    exit 1
fi

OUTPUT="$USER_HOME/swordfish.txt"

echo "Usuário: ${SUDO_USER:-$(id -un)}"
echo "Arquivo de saída: $OUTPUT"
echo "Procurando arquivos .log no sistema..."

# Cria o arquivo com permissões restritas
umask 077
: > "$OUTPUT" || {
    echo "Erro: não foi possível criar $OUTPUT"
    exit 1
}

{
    echo "Lista de arquivos .log encontrados"
    echo "Data: $(date)"
    echo "========================================"
} >> "$OUTPUT"

# Busca os arquivos .log em todo o sistema
find / \
    -type d \( -path /proc -o -path /sys -o -path /dev \) -prune -o \
    -type f -name "*.log" -print \
    2>/dev/null >> "$OUTPUT"

# Devolve a propriedade do arquivo ao usuário original
if [[ -n "${SUDO_USER:-}" ]]; then
    chown "$SUDO_USER" "$OUTPUT"
fi

echo "Busca concluída."
echo "Arquivo criado em: $OUTPUT"
echo "Quantidade encontrada: $(grep -cE '^/' "$OUTPUT")"
