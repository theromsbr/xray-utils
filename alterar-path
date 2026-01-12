#!/bin/bash

clear
echo "========================================================="
echo "  Configuração de XRay da Central da CDN @centraldacdn  "
echo "========================================================="
echo ""

echo "🔔 Atenção:"
echo "Este Script fará a alteração do path no json do XRay, insira o ID do backend que foi gerado ou escolhido por você na criação do Backend ID da Azion no painel:"
echo ""

read -p "Digite o seu Backend ID da Azion (ex: theroms, app400, etc...): " vaga

echo ""
echo "Alterando configuração do XRay..."
sed -i 's|"path": "[^"]*"|"path": "/'$vaga'/"|g' /usr/local/etc/xray/config.json

echo "Reiniciando o serviço XRay..."
systemctl restart xray

echo ""
echo "Configuração aplicada com sucesso!"
echo "  Novo path configurado: /$vaga/"
