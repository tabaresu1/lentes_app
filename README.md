Visão 360 - Guia de Lentes e Orçamento
Descrição do Projeto
O "Visão 360" é um aplicativo desenvolvido para tablets, com o objetivo principal de auxiliar vendedores de óticas a apresentar e explicar de forma interativa os diferentes tipos de lentes, tratamentos, espessuras e campos de visão para seus clientes. Além disso, o aplicativo permite a geração de orçamentos detalhados, incluindo a aplicação de códigos de desconto, e a partilha desses orçamentos em formato PDF.

Funcionalidades
Simulação de Tratamentos de Lentes: Permite visualizar o efeito de diversos tratamentos (antirreflexo, fotossensível, filtro de luz azul, etc.).

Análise de Espessura da Lente: Simula a espessura da lente com base na prescrição e no tipo de armação, ajudando o cliente a compreender as implicações estéticas.

Simulação de Campo de Visão: Demonstra as diferenças no campo de visão para lentes monofocais, bifocais e multifocais/progressivas, usando overlays visuais.

Geração de Orçamento:

Com base nas seleções de lentes e tratamentos, o aplicativo calcula e exibe as opções de orçamento.

Permite a entrada de códigos de desconto (acumulativos até um limite de 25%).

Códigos Válidos: VISAO5, OTICA7, LENTE6, CUIDAR8, OCULOS10, APP7, NOVO6, MAIS9, LEVE5, BRILHO10.

Estes códigos podem ser alterados, adicionados ou removidos conforme a necessidade da loja no arquivo desconto_service.dart.

Códigos Inválidos (para argumento de venda): GERENTE15, NOVO5, CUPOM7, OCULOS8, LENTES10, OTICA6, APP9, MAIS5, ONLINE7, CUIDAR6, FLASH10.

Estes códigos também podem ser alterados, adicionados ou removidos no arquivo desconto_service.dart para novas estratégias de venda.

Detecta e informa se um código de desconto já foi aplicado no mesmo orçamento.

Geração e Partilha de PDF: Cria um documento PDF profissional com todos os detalhes do orçamento (incluindo o valor original e o desconto aplicado) e permite a partilha via aplicações instaladas no tablet.

Entrada de Acréscimo (Código AC): Funcionalidade oculta (acessível via ícone de engrenagem) para aplicar um multiplicador de acréscimo aos preços, útil para ajustes de custo.

Interface Otimizada para Tablet: Design responsivo e amigável, com tratamento para evitar sobreposição de elementos pelo teclado virtual.

Tecnologias Utilizadas
Flutter: Framework principal para desenvolvimento multiplataforma.

Provider: Para gerenciamento de estado da aplicação.

pdf: Geração de documentos PDF.

printing: Funcionalidades de impressão e partilha de PDF.

path_provider: Para gerenciar caminhos de ficheiros temporários.

google_fonts (via pdf_google_fonts): Para garantir a consistência das fontes no PDF.

Configuração do Ambiente e Instalação
Para configurar o projeto e executá-lo localmente, siga os passos abaixo:

Pré-requisitos:

Instale o Flutter SDK (versão estável recomendada).

Configure o seu ambiente de desenvolvimento (VS Code, Android Studio) com os plugins Flutter e Dart.

Clonar o Repositório:

git clone https://github.com/tabaresu1/lentes_app
cd lentes_app

Instalar Dependências:
No diretório raiz do projeto, execute:

flutter pub get

Executar o Aplicativo:
Conecte um tablet (ou emulador/simulador de tablet) e execute:

flutter run

Ou, para construir uma versão para lançamento:

flutter build apk --release # Para Android
flutter build ipa --release # Para iOS

Como Usar
Navegação: Utilize o menu lateral esquerdo para alternar entre as seções: "Espessura", "Tratamentos", "Campo de Visão" e "Orçamento".

Cálculo de Indicação (Orçamento):

Na seção de "Orçamento", insira os dados da prescrição.

O aplicativo gerará as opções de lentes com base nas regras definidas.

Códigos de Desconto: Digite os códigos no campo "Código de Desconto" e clique em "Aplicar Desconto". Observe o feedback visual e a atualização dos preços.

Selecione a opção desejada e clique em "Confirmar e Adicionar ao Orçamento".

Gerar e Partilhar Orçamento:

Após confirmar o item do orçamento, você será direcionado para a tela de resumo.

Clique em "Gerar e Partilhar" para criar o PDF do orçamento e escolher uma opção de partilha (e-mail, WhatsApp, etc.).

Ajuste de Acréscimo (Função Administrativa):

No canto superior direito da tela principal, clique no ícone de engrenagem (⚙️) para abrir a caixa de diálogo "Inserir AC" e ajustar o multiplicador de acréscimo nos preços base.

Contribuição
Contribuições são bem-vindas! Se você tiver ideias para melhorias, novas funcionalidades ou detetar problemas, sinta-se à vontade para:

Abrir uma Issue.

Criar um Pull Request.

Ao contribuir, por favor, siga as boas práticas de desenvolvimento Flutter e o estilo de código existente.