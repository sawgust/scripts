# Vulnerability Scanning Script

## Descrição

Este repositório contém um script desenvolvido para realizar escaneamentos de vulnerabilidades em múltiplos IPs, gerar relatórios em formato XML e convertê-los para HTML utilizando `nmap` e `xsltproc`. O script permite a escolha de diferentes tipos de escaneamento, sistema operacional, serviços e diretórios de saída para os relatórios gerados.

## Funcionalidades

- Escaneamento de múltiplos IPs
- Geração de relatórios em formato XML e conversão para HTML
- Opções de escaneamento:
  - Completo
  - Simples
  - Avançado
- Escolha do sistema operacional a ser escaneado:
  - Windows
  - Linux
  - Todos
- Escolha de serviços a serem escaneados:
  - Web
  - Email
  - SMB
  - Todos
- Possibilidade de salvar os relatórios em um diretório específico

## Requisitos

Para rodar este script, é necessário ter as seguintes ferramentas instaladas:

- **Nmap**: Ferramenta para escaneamento de rede.
- **xsltproc**: Ferramenta para converter arquivos XML para HTML.

Você pode instalar essas ferramentas utilizando os seguintes comandos:

```bash
sudo apt-get install nmap xsltproc
![image](https://github.com/user-attachments/assets/5a4eea97-e263-4e59-96e0-073f032e01b6)
![image](https://github.com/user-attachments/assets/b58423b4-6d44-4843-8ab0-8407dc76400e)


