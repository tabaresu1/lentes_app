# ✨ Visão 360 - Guia de Lentes e Orçamento para Óticas ✨

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![GitHub last commit](https://img.shields.io/github/last-commit/tabaresu1/lentes_app?style=for-the-badge)](https://github.com/tabaresu1/lentes_app/commits/main)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

Um aplicativo interativo para tablets, projetado para auxiliar vendedores de óticas na apresentação e explicação de produtos ópticos aos clientes, além de facilitar a criação e partilha de orçamentos.

---

## 📋 Sumário

* [🎯 Descrição do Projeto](#-descrição-do-projeto)
* [🚀 Funcionalidades Principais](#-funcionalidades-principais)
    * [Visuais e Interativas](#visuais-e-interativas)
    * [Orçamento e Vendas](#orçamento-e-vendas)
    * [Ferramentas Administrativas e UX](#ferramentas-administrativas-e-ux)
* [🛠️ Tecnologias Utilizadas](#️-tecnologias-utilizadas)
* [⚙️ Configuração do Ambiente e Instalação](#️-configuração-do-ambiente-e-instalação)
* [📖 Como Usar o Aplicativo](#-como-usar-o-aplicativo)
* [🤝 Contribuição](#-contribuição)

---

## 🎯 Descrição do Projeto

O **Visão 360** é uma ferramenta indispensável para óticas modernas, proporcionando uma experiência de venda mais dinâmica e transparente. Com este aplicativo, os vendedores podem:

* Demonstrar visualmente os benefícios de diferentes **lentes, tratamentos e espessuras**.
* Simular o impacto das lentes no **campo de visão** do cliente.
* Gerar **orçamentos detalhados** de forma rápida.
* Aplicar **códigos de desconto** de forma estratégica.
* **Partilhar orçamentos** diretamente em PDF.

---

## 🚀 Funcionalidades Principais

### Visuais e Interativas

* ### Simulação de Tratamentos de Lentes 👓
    Visualize o efeito de tratamentos como antirreflexo, fotossensível, filtro de luz azul, entre outros.

* ### Análise de Espessura da Lente 📏
    Simule a espessura da lente com base na prescrição e no tipo de armação, ajudando o cliente a entender as implicações estéticas.

* ### Simulação de Campo de Visão 👁️
    Compare visualmente as diferenças no campo de visão para lentes monofocais, bifocais e multifocais/progressivas através de sobreposições.

### Orçamento e Vendas

* ### Geração de Orçamento Avançada 💰
    * **Cálculo Dinâmico:** Gere opções de lentes e tratamentos com base na prescrição.
    * **Códigos de Desconto (Acumulativos):**
        * **Válidos:** `VISAO5`, `OTICA7`, `LENTE6`, `CUIDAR8`, `OCULOS10`, `APP7`, `NOVO6`, `MAIS9`, `LEVE5`, `BRILHO10`.
            * *Estes códigos são configuráveis e podem ser ajustados, adicionados ou removidos no arquivo `lib/desconto_service.dart` para atender às necessidades promocionais da sua loja.*
        * **Inválidos (Estratégicos):** `GERENTE15`, `NOVO5`, `CUPOM7`, `OCULOS8`, `LENTES10`, `OTICA6`, `APP9`, `MAIS5`, `ONLINE7`, `CUIDAR6`, `FLASH10`.
            * *Esses códigos são projetados para "parecer" válidos, mas são negados pelo sistema, servindo como um ponto de partida para o vendedor argumentar e oferecer outras soluções. Eles também são configuráveis no arquivo `lib/desconto_service.dart`.*
    * **Controle de Uso:** O sistema impede a reaplicação do mesmo código de desconto no mesmo orçamento, com feedback visual claro.

* ### Geração e Partilha de PDF 📧
    * Crie documentos PDF profissionais com detalhes completos do orçamento (valor original, desconto aplicado e total final).
    * Partilhe facilmente o PDF através de e-mail, WhatsApp ou outras aplicações de partilha disponíveis no tablet.

### Ferramentas Administrativas e UX

* ### Ajuste de Acréscimo (Função Administrativa) ⚙️
    Uma funcionalidade oculta, acessível via ícone de engrenagem no canto superior direito, permite definir um multiplicador de acréscimo nos preços base do orçamento.

* ### Interface Otimizada para Tablet 📱
    Design responsivo e amigável, com tratamento adequado para evitar sobreposição de elementos pelo teclado virtual (`SingleChildScrollView`).

---

## 🛠️ Tecnologias Utilizadas

* **Flutter:** Framework líder para desenvolvimento de aplicações multiplataforma nativas.
* **Provider:** Solução robusta e escalável para gerenciamento de estado.
* **pdf:** Biblioteca para a criação e manipulação de documentos PDF.
* **printing:** Ferramenta para imprimir e partilhar PDFs diretamente do aplicativo.
* **path_provider:** Auxilia no gerenciamento de caminhos de ficheiros temporários no dispositivo.
* **google_fonts (via pdf_google_fonts):** Garante a consistência e qualidade das fontes tipográficas nos documentos PDF gerados.

---

## ⚙️ Configuração do Ambiente e Instalação

Para configurar e executar o **Visão 360** em seu ambiente de desenvolvimento, siga as instruções abaixo:

1.  ### Pré-requisitos:
    * Certifique-se de ter o [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado e configurado (versão estável recomendada).
    * Um editor de código configurado para Flutter (ex: VS Code com extensões Dart/Flutter, Android Studio).

2.  ### Clonar o Repositório:
    Abra seu terminal ou prompt de comando e execute:
    ```bash
    git clone [https://github.com/tabaresu1/lentes_app.git](https://github.com/tabaresu1/lentes_app.git)
    cd lentes_app
    ```

3.  ### Instalar Dependências:
    No diretório raiz do projeto, execute:
    ```bash
    flutter pub get
    ```

4.  ### Executar o Aplicativo:
    Conecte um tablet Android/iOS (ou inicie um emulador/simulador) e execute:
    ```bash
    flutter run
    ```
    Para construir uma versão de lançamento otimizada:
    ```bash
    flutter build apk --release # Para Android
    flutter build ipa --release # Para iOS
    ```

---

## 📖 Como Usar o Aplicativo

1.  ### Navegação:
    Utilize o menu lateral esquerdo para alternar entre as seções principais: "Espessura", "Tratamentos", "Campo de Visão" e "Orçamento".

2.  ### Cálculo de Indicação (Seção Orçamento):
    * Na seção "Orçamento", insira os dados de prescrição do cliente.
    * O aplicativo apresentará as opções de lentes e tratamentos recomendadas com base nas regras internas.
    * **Aplicar Descontos:** Digite um dos códigos de desconto no campo "Código de Desconto" e clique em "Aplicar Desconto". Observe o feedback visual na parte inferior da tela (verde para sucesso, laranja para código já aplicado, vermelho para inválido) e a atualização dos preços.
    * Selecione a opção de lente desejada e clique em "Confirmar e Adicionar ao Orçamento".

3.  ### Gerar e Partilhar Orçamento (Tela de Resumo):
    * Após adicionar o item ao orçamento, você será levado à tela de resumo.
    * Clique em **"Gerar e Partilhar"** para criar um PDF detalhado do orçamento. Uma janela de partilha nativa do tablet permitirá que você envie o documento por e-mail, WhatsApp, ou outras opções.

4.  ### Ajuste de Acréscimo (Função Administrativa):
    * No canto superior direito da tela principal do aplicativo, clique no **ícone de engrenagem (⚙️)**.
    * Insira o "Código AC" para definir um multiplicador de acréscimo nos preços base do orçamento (ex: 110 para 10% de acréscimo).

---

## 🤝 Contribuição

Sua contribuição é muito bem-vinda! Se você tiver ideias para melhorias, novas funcionalidades ou encontrar algum problema, por favor:

1.  Abra uma [**Issue**](https://github.com/tabaresu1/lentes_app/issues) detalhando sua sugestão ou o problema encontrado.
2.  Crie um [**Pull Request**](https://github.com/tabaresu1/lentes_app/pulls) com suas implementações, garantindo que o código siga as boas práticas de desenvolvimento Flutter e o estilo existente do projeto.

---