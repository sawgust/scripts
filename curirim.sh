#!/bin/bash

# Script de Escaneamento de Vulnerabilidades
# Criado por: Gustavo dos Santos
# Data de criação: 24 de março de 2025

# Exibindo ASCII GSAN
echo "                              ##                ##"
echo ""
echo "  ####    ##  ##   ######    ###     ######    ###     ##  ##"
echo " ##  ##   ##  ##    ##  ##    ##      ##  ##    ##     #######"
echo " ##       ##  ##    ##        ##      ##        ##     ## # ##"
echo " ##  ##   ##  ##    ##        ##      ##        ##     ##   ##"
echo "  ####     ######  ####      ####    ####      ####    ##   ##"

echo "Versão: 1.0"
echo "Descrição: Este script realiza escaneamento de vulnerabilidades em um alvo,"
echo "gera relatórios em formato XML com o Nmap e converte para HTML com o xsltproc."
echo "Permite ao usuário escolher o tipo de escaneamento, sistema operacional,"
echo "serviço e diretório de saída para os relatórios gerados."
echo ""

# Função para validar entradas
validar_entrada() {
    local input=$1
    local tipo=$2
    
    case $tipo in
        "numero")
            if ! [[ "$input" =~ ^[0-9]+$ ]]; then
                echo "Entrada inválida. Por favor, digite um número."
                return 1
            fi
            ;;
        "ip")
            if [[ ! "$input" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
                echo "IP inválido. Tente novamente."
                return 1
            fi
            ;;
        "nome_arquivo")
            if [[ ! "$input" =~ ^[A-Za-z0-9_-]+$ ]]; then
                echo "Nome de arquivo inválido. Use apenas letras, números, sublinhados e hifens."
                return 1
            fi
            ;;
        *)
            echo "Tipo de validação desconhecido"
            return 1
            ;;
    esac
    return 0
}

# Função para verificar dependências
verificar_dependencias() {
    comandos=("nmap" "xsltproc")
    for cmd in "${comandos[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "$cmd não encontrado. Por favor, instale a ferramenta antes de continuar."
            exit 1
        fi
    done
}

# Função para gerar o relatório
gerar_relatorio() {
    echo "Iniciando o escaneamento..."

    # Loop para escanear cada IP
    for ip in $ips; do
        echo "Escaneando $ip..."
        nmap -sS -sV -O -p- --script=vuln -oX "$diretorio/$ip.xml" "$ip"
        xsltproc "$diretorio/$ip.xml" -o "$diretorio/$ip.html"
        echo "Relatório gerado para $ip: $diretorio/$ip.html"
    done
}

# Função para escolher o tipo de escaneamento baseado no sistema
escolher_tipo_scan() {
    echo -e "\nEscolha o Tipo de Escaneamento:"
    echo "1) Scan Completo"
    echo "2) Scan Simples"
    echo "3) Scan Avançado"
    read -p "Escolha a opção (1/2/3): " tipo_scan
    case $tipo_scan in
        1)
            tipo_scan="completo"
            ;;
        2)
            tipo_scan="simples"
            ;;
        3)
            tipo_scan="avancado"
            ;;
        *)
            echo "Opção inválida. Realizando scan simples por padrão."
            tipo_scan="simples"
            ;;
    esac
}

# Função para escolher o sistema operacional
escolher_sistema() {
    echo -e "\nEscolha o Sistema Operacional:"
    echo "1) Windows"
    echo "2) Linux"
    echo "3) Todos"
    read -p "Escolha a opção (1/2/3): " sistema
    case $sistema in
        1)
            sistema="windows"
            ;;
        2)
            sistema="linux"
            ;;
        3)
            sistema="todos"
            ;;
        *)
            echo "Opção inválida. Considerando Todos como padrão."
            sistema="todos"
            ;;
    esac
}

# Função para escolher o tipo de serviço
escolher_servico() {
    echo -e "\nEscolha o Tipo de Serviço:"
    echo "1) Web"
    echo "2) Email"
    echo "3) SMB"
    echo "4) Todos"
    read -p "Escolha a opção (1/2/3/4): " servico
    case $servico in
        1)
            servico="web"
            ;;
        2)
            servico="email"
            ;;
        3)
            servico="smb"
            ;;
        4)
            servico="todos"
            ;;
        *)
            echo "Opção inválida. Considerando Web como padrão."
            servico="web"
            ;;
    esac
}

# Função para solicitar os IPs, nome de arquivos e diretório de saída
solicitar_informacoes() {
    echo -e "\nPor favor, informe as seguintes informações:"

    # Solicitar múltiplos IPs
    read -p "Digite os IPs dos alvos (separados por espaço): " ips
    # Validar cada IP individualmente
    for ip in $ips; do
        validar_entrada "$ip" "ip" || return 1
    done

    # Solicitar nome de arquivo XML
    read -p "Digite o nome do arquivo XML a ser gerado (sem extensão): " xml_file
    validar_entrada "$xml_file" "nome_arquivo" || solicitar_informacoes

    # Solicitar nome de arquivo HTML
    read -p "Digite o nome do arquivo HTML de saída (sem extensão): " html_file
    validar_entrada "$html_file" "nome_arquivo" || solicitar_informacoes
}

# Função para escolher o diretório de saída para os relatórios
escolher_diretorio() {
    echo -e "\nDigite o diretório onde deseja salvar os relatórios (pode ser absoluto ou relativo):"
    read -p "Diretório: " diretorio
    mkdir -p "$diretorio"  # Cria o diretório caso não exista
}

# Função principal
main() {
    # Verificando dependências
    verificar_dependencias

    # Solicitar informações do usuário
    solicitar_informacoes

    # Escolher o sistema operacional
    escolher_sistema

    # Escolher o tipo de serviço
    escolher_servico

    # Escolher o tipo de escaneamento
    escolher_tipo_scan

    # Escolher o diretório onde os arquivos serão salvos
    escolher_diretorio

    # Gerar o relatório
    gerar_relatorio
}

# Executando a função principal
main
