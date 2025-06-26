# ✨ Visão 360 - Guia de Lentes e Orçamento para Óticas ✨

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![GitHub last commit](https://img.shields.io/github/last-commit/tabaresu1/lentes_app?style=for-the-badge)](https://github.com/tabaresu1/lentes_app/commits/main)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

Um aplicativo interativo para tablets, projetado para auxiliar vendedores de óticas na apresentação de produtos ópticos, simulação visual e geração de orçamentos detalhados — **funcionando online e offline (ainda em teste)**.

---

## 📋 Sumário

- [🎯 Descrição do Projeto](#-descrição-do-projeto)
- [🚀 Funcionalidades Principais](#-funcionalidades-principais)
- [🛠️ Tecnologias Utilizadas](#️-tecnologias-utilizadas)
- [⚙️ Instalação e Execução](#️-instalação-e-execução)
- [📖 Como Usar](#-como-usar)
- [🤝 Contribuição](#-contribuição)

---

## 🎯 Descrição do Projeto

O **Visão 360** é uma ferramenta moderna para óticas, permitindo:

- Demonstração visual de diferentes lentes, tratamentos e espessuras.
- Simulação do campo de visão para cada tipo de lente.
- Geração de orçamentos detalhados, com aplicação de descontos e acréscimos.
- **(BETA) Funcionalidade offline:** orçamentos podem ser criados e salvos sem internet, sendo sincronizados automaticamente com o Firestore quando a conexão retornar.

---

## 🚀 Funcionalidades Principais

### 👓 Simulação Visual e Educativa

- **Tratamentos de Lentes:** Visualize efeitos de antirreflexo, fotossensível, filtro azul, etc.
- **Espessura da Lente:** Simule a espessura conforme prescrição e armação.
- **Campo de Visão:** Compare monofocal, bifocal e multifocal/progressiva.

### 💰 Orçamento e Vendas

- **Cálculo Dinâmico:** Opções de lentes e tratamentos geradas conforme a prescrição.
- **Códigos de Desconto:** 
  - Válidos e inválidos (para argumentação de vendas), configuráveis em `lib/desconto_service.dart`.
  - Controle visual de aplicação e bloqueio de códigos repetidos.
- **Acréscimo Administrativo:** Ajuste de preços via código especial.
- **Geração e Partilha de PDF:** Orçamento detalhado pronto para compartilhar por e-mail, WhatsApp, etc.

### 📶 Funcionalidade Offline (Ainda em testes)

- **Orçamentos Offline:** Todos os orçamentos são salvos localmente (Hive) mesmo sem internet.
- **Sincronização Automática:** Assim que a conexão retorna, orçamentos pendentes são enviados ao Firestore automaticamente.
- **Fluxo Completo Offline:** O usuário pode iniciar, finalizar e visualizar orçamentos sem conexão.

---

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework multiplataforma.
- **Provider**: Gerenciamento de estado.
- **Hive**: Armazenamento local offline.
- **cloud_firestore**: Sincronização e backup online.
- **connectivity_plus**: Detecção de conexão para sincronização automática.
- **pdf & printing**: Geração e partilha de PDFs.
- **path_provider**: Gerenciamento de arquivos temporários.
- **hive_flutter**: Integração Hive com Flutter.

---

## ⚙️ Instalação e Execução

1. **Pré-requisitos:**
   - [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado.
   - Editor de código (VS Code, Android Studio, etc).

2. **Clone o repositório:**
   ```bash
   git clone https://github.com/tabaresu1/lentes_app.git
   cd lentes_app
   ```

3. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

4. **Execute o aplicativo:**
   ```bash
   flutter run
   ```
   Para build de produção:
   ```bash
   flutter build apk --release   # Android
   flutter build ipa --release   # iOS
   ```

---

## 📖 Como Usar

1. **Navegação:** Use o menu lateral para acessar Espessura, Tratamentos, Campo de Visão e Orçamento.
2. **Orçamento:** 
   - Preencha a prescrição, selecione opções e aplique descontos.
   - Clique em "Confirmar Orçamento" para salvar (funciona offline).
   - Veja o resumo e gere/partilhe o PDF.
3. **Acréscimo Administrativo:** Clique no ícone de engrenagem para inserir o código de acréscimo.
4. **Offline:** Pode criar orçamentos sem internet. Eles serão sincronizados automaticamente quando a conexão voltar.

---

## 🤝 Contribuição

Contribuições são bem-vindas!  
Abra uma [Issue](https://github.com/tabaresu1/lentes_app/issues) ou envie um [Pull Request](https://github.com/tabaresu1/lentes_app/pulls) seguindo as boas práticas do Flutter.

---