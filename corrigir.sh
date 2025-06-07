#!/bin/bash
# Script para corrigir usuários duplicados no Xray por t.me/theromss
CONFIG="/usr/local/etc/xray/config.json"
BACKUP="/usr/local/etc/xray/config_backup_$(date +%s).json"

if ! command -v jq &>/dev/null; then
  echo "O jq não está instalado. Instale com: apt install jq -y"
  exit 1
fi

if [ ! -f "$CONFIG" ]; then
  echo "Arquivo de configuração não encontrado em: $CONFIG"
  exit 1
fi

cp "$CONFIG" "$BACKUP"
echo "Backup criado em: $BACKUP"

jq '
  .inbounds |= map(
    if .protocol == "vless" and .settings.clients then
      .settings.clients |= (
        reduce .[] as $item (
          [];
          if (map(.email | ascii_downcase) | index($item.email | ascii_downcase)) == null then
            . + [$item]
          else
            .
          end
        )
      )
    else
      .
    end
  )
' "$BACKUP" > "$CONFIG"

DUPLICADOS=$(jq -r '
  .inbounds[]
  | select(.protocol == "vless")
  | .settings.clients[]
  | .email
' "$BACKUP" | awk '{print tolower($0)}' | sort | uniq -d)

if [ -n "$DUPLICADOS" ]; then
  echo "Usuários duplicados removidos:"
  echo "$DUPLICADOS"
else
  echo "Nenhum usuário duplicado encontrado (ignorando maiúsculas/minúsculas)."
fi

echo "Reiniciando o serviço Xray..."
systemctl restart xray

echo "Configuração atualizada. Xray reiniciado."
