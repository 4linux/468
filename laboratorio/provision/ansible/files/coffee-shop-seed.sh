#!/bin/bash
# Script para popular usuários padrão na Coffee Shop
# Uso: ./coffee-shop-seed.sh [URL]

COFFEE_SHOP_URL="${1:-http://localhost:8080}"
MAX_RETRIES=30
RETRY_INTERVAL=2

echo "=== Coffee Shop User Seed Script ==="
echo "URL: $COFFEE_SHOP_URL"
echo ""

# Função para aguardar a aplicação estar pronta
wait_for_app() {
    echo "Aguardando Coffee Shop inicializar..."
    for i in $(seq 1 $MAX_RETRIES); do
        if curl -s -f "$COFFEE_SHOP_URL" > /dev/null 2>&1; then
            echo "✅ Coffee Shop está online!"
            return 0
        fi
        echo "Tentativa $i/$MAX_RETRIES - aguardando ${RETRY_INTERVAL}s..."
        sleep $RETRY_INTERVAL
    done
    echo "❌ Timeout: Coffee Shop não respondeu após ${MAX_RETRIES} tentativas"
    return 1
}

# Função para criar usuário
create_user() {
    local email="$1"
    local password="$2"
    local description="$3"

    echo -n "Criando usuário $description ($email)... "

    response=$(curl -X POST "$COFFEE_SHOP_URL/api/Users/" \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$email\",\"password\":\"$password\"}" \
        -s -w "\n%{http_code}")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)

    if [ "$http_code" = "201" ] || [ "$http_code" = "200" ]; then
        echo "✅ Criado com sucesso!"
        return 0
    else
        # Verificar se usuário já existe
        if echo "$body" | grep -q "already exists\|duplicate"; then
            echo "⚠️  Já existe"
            return 0
        else
            echo "❌ Erro (HTTP $http_code)"
            echo "   Response: $body"
            return 1
        fi
    fi
}

# Função principal
main() {
    # Aguardar aplicação estar pronta
    if ! wait_for_app; then
        exit 1
    fi

    echo ""
    echo "=== Criando usuários padrão ==="
    echo ""

    # Criar usuários padrão
    create_user "admin@juice-sh.op" "admin123" "Admin"
    create_user "jim@juice-sh.op" "ncc-1701" "Jim (Cliente)"

    echo ""
    echo "=== Seed concluído! ==="
    echo ""
    echo "Credenciais disponíveis:"
    echo "  • admin@juice-sh.op / admin123"
    echo "  • jim@juice-sh.op / ncc-1701"
    echo ""
}

main
