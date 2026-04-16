# minhafilasaude

Aplicativo Flutter focado em **transparência de filas do SUS**, com autenticação via **gov.br**, acompanhamento da posição na fila, histórico de movimentações e fluxo de confirmação de procedimento com envio de evidência para validação pela **SES**.

> Projeto desenvolvido como base para **TCC/MVP governamental**, priorizando usabilidade, transparência de informações, organização arquitetural e evolução futura para integração real com sistemas públicos de saúde.

## Visão geral

O **MinhaFila Saúde** foi concebido para permitir que o cidadão acompanhe, de forma simples e segura, a sua posição em filas de atendimento do SUS. Além disso, o sistema propõe um mecanismo colaborativo de atualização da fila, permitindo que o usuário informe quando já realizou determinado procedimento por outro canal, contribuindo para maior eficiência da gestão pública.

### Principais objetivos da solução

- aumentar a transparência das filas de atendimento;
- melhorar a experiência do cidadão no acompanhamento da solicitação;
- reduzir inconsistências na fila causadas por registros desatualizados;
- apoiar a SES com um fluxo digital de validação e atualização da fila;
- preparar uma base técnica robusta para evolução acadêmica e produtiva.

---

## Funcionalidades implementadas

- Tela de boas-vindas com acesso via **gov.br**
- Login configurável:
  - **modo mock** por padrão, para demonstração e testes
  - estrutura preparada para integração real com **gov.br**
- Dashboard principal com:
  - saudação personalizada
  - card da fila ativa
  - posição atual em destaque
  - estimativa de espera
  - barra de progresso
  - status da solicitação
- Fluxo de confirmação:
  - “Sim, já realizei”
  - “Não, continuo na fila”
- Fluxo de validação com anexo:
  - captura de foto do laudo
  - seleção de PDF
  - envio para validação
- Tela de status do processo
- Histórico de movimentações
- Central de notificações
- Tela de ajustes e informações do ambiente
- Testes básicos de domínio e widget
- Pipeline inicial de CI com GitHub Actions

---

## Demonstração do fluxo

### Login
Na versão atual, o projeto utiliza **autenticação mockada por padrão** para facilitar testes e apresentações. Ao tocar no botão **“Entrar com gov.br”**, o app realiza uma autenticação simulada e direciona o usuário ao dashboard.

### Dashboard
Após o login, o usuário visualiza:
- procedimento em fila;
- posição atual;
- estimativa de espera;
- progresso visual;
- histórico e notificações.

### Atualização da fila
Ao tocar no card principal, o cidadão pode:
- informar que **continua aguardando**;
- ou informar que **já realizou o procedimento**, anexando um documento comprobatório para validação.

### Validação
O sistema registra a solicitação e muda o status para **“Em validação pela SES”**, simulando o fluxo que futuramente será integrado ao backend institucional.

---

## Arquitetura da solução

A aplicação foi estruturada com foco em **escalabilidade, testabilidade e separação de responsabilidades**.

### App mobile
- **Flutter**
- **Dart**
- **Material Design 3**
- **Riverpod** para gerenciamento de estado e injeção de dependências
- **go_router** para navegação declarativa
- **Repository Pattern** para desacoplamento entre UI e fonte de dados

### Backend proposto
Embora esta entrega esteja focada no app Flutter, a arquitetura da solução considera um backend intermediário responsável por:
- validação da autenticação via gov.br;
- consumo seguro da API da SES;
- regras de negócio de fila;
- recebimento de anexos;
- auditoria;
- envio de notificações.

### Banco de dados e armazenamento
Na arquitetura proposta:
- **PostgreSQL** armazenaria os dados estruturados da aplicação;
- **MinIO** ou **Amazon S3** armazenariam os documentos enviados pelo usuário;
- o app não acessaria diretamente os sistemas da SES, mas consumiria uma API intermediária segura.

---

## Diagrama de arquitetura

```mermaid
flowchart TD
    A[Usuário] --> B[App Flutter]
    B --> C[API Backend]
    C --> D[Autenticação gov.br]
    C --> E[Integração SES]
    C --> F[(PostgreSQL)]
    C --> G[Storage de documentos]

Fluxo de dados
Diagrama incompatível.
Estrutura de pastas
lib/
  app/
    config/
    router/
    theme/
  core/
    extensions/
    services/
    widgets/
  features/
    auth/
      data/
      domain/
      presentation/
    home/
      data/
      domain/
      presentation/
docs/
test/
.github/
  workflows/
Padrões e decisões técnicas
Organização por feature

O projeto foi organizado por feature, facilitando manutenção, evolução e escalabilidade.

Separação por camadas

Cada feature foi dividida em:

data: fontes de dados e repositórios;
domain: contratos, modelos e regras de negócio;
presentation: telas, widgets e controladores.
Repositórios

Foi adotado o Repository Pattern para permitir alternância entre:

implementações mockadas;
integrações reais futuras com APIs externas.
Configuração por ambiente

A aplicação utiliza --dart-define para habilitar configurações de ambiente e integração.

Tecnologias utilizadas
Frontend
Flutter
Dart
Material Design 3
flutter_riverpod
go_router
image_picker
file_picker
intl
Qualidade e automação
flutter_lints
flutter_test
GitHub Actions
Integrações previstas
gov.br (OAuth 2.0 / OpenID Connect)
API intermediária da SES
armazenamento de anexos em S3/MinIO
Como executar o projeto
1. Instalar dependências
flutter pub get
2. Gerar diretórios nativos, se necessário

Caso o projeto tenha sido baixado sem as pastas padrão nativas:

flutter create . --platforms=android,ios
3. Executar o app
flutter run
Como funciona o login

Atualmente o projeto vem configurado em modo mock para facilitar demonstrações.

Modo padrão

Ao tocar em “Entrar com gov.br”, o app autentica usando o MockAuthRepository e entra automaticamente no dashboard.

Usuário de demonstração
Nome: Maria Silva
CPF: ***.456.789-**
Integração real com gov.br

A aplicação já está preparada para ativar a implementação real via dart-define.

Exemplo:

flutter run \
  --dart-define=APP_ENV=producao \
  --dart-define=GOVBR_CLIENT_ID=seu-client-id \
  --dart-define=GOVBR_REDIRECT_URI=br.gov.ses.minhafila://callback \
  --dart-define=GOVBR_ISSUER=https://sso.staging.acesso.gov.br
Variáveis de ambiente
Variável	Descrição
APP_ENV	Nome do ambiente de execução
API_BASE_URL	URL base da API futura da SES
GOVBR_CLIENT_ID	Client ID do Login Único
GOVBR_REDIRECT_URI	URI de retorno do aplicativo
GOVBR_ISSUER	Issuer OpenID Connect do gov.br
Como testar os principais fluxos
Fluxo 1 — Login
abrir o app;
tocar em Entrar com gov.br;
validar o redirecionamento para o dashboard.
Fluxo 2 — Continuar na fila
tocar no card da fila ativa;
selecionar “Não, continuo na fila”;
verificar atualização no histórico e nas notificações.
Fluxo 3 — Já realizei o procedimento
tocar no card da fila ativa;
selecionar “Sim, já realizei”;
anexar um PDF ou imagem;
enviar para validação;
verificar a tela de status.
Fluxo 4 — Validação de formulário
abrir a tela de envio;
tentar enviar sem anexo;
validar a mensagem de erro.
CI/CD

O projeto possui uma pipeline inicial com GitHub Actions para garantir qualidade mínima no ciclo de desenvolvimento.

Etapas automatizadas
instalação de dependências;
análise estática com flutter analyze;
execução de testes com flutter test.

Arquivo de workflow:

.github/workflows/flutter_ci.yml

Documentação adicional

Os documentos complementares do projeto estão disponíveis em docs/:

docs/arquitetura.md
docs/integracao_govbr.md
docs/integracao_ses.md
docs/contrato_api_exemplo.md
Limitações atuais

Esta versão é um protótipo funcional com foco em demonstração de fluxo e arquitetura.

Atualmente:

não há backend real integrado;
não há autenticação gov.br real habilitada por padrão;
não há integração real com a SES;
o processo de validação é simulado;
notificações push ainda não foram implementadas.
Próximos passos
integrar backend real para autenticação e consulta de fila;
substituir repositórios mockados por repositórios REST;
implementar persistência local/cache;
adicionar notificações push;
incluir trilha de auditoria;
criar painel administrativo web para analistas da SES;
evoluir estimativa de espera com base em dados históricos reais.
Roadmap
 Estrutura inicial do app Flutter
 Fluxo de autenticação mock
 Dashboard com fila ativa
 Fluxo de validação com anexo
 Histórico e notificações
 Pipeline básica de CI
 Backend REST real
 Integração gov.br homologada
 Integração SES
 Notificações push
 Painel administrativo
 Persistência offline
Boas práticas adotadas
organização por feature;
separação por camadas;
gerenciamento de estado desacoplado;
configuração por ambiente;
base preparada para testes;
fluxo de CI automatizado;
documentação complementar em pasta dedicada.
Contribuição

Sugestões e melhorias são bem-vindas.

Fluxo sugerido:

criar uma branch para a funcionalidade;
implementar a alteração;
executar análise e testes;
abrir um Pull Request com descrição objetiva.
Licença

Projeto acadêmico / educacional.

Defina aqui a licença que deseja utilizar, por exemplo:

MIT
Apache 2.0
uso acadêmico restrito
Autor

Cleomar Dias da Função
Transformação Digital no SUS / FIOCRUZ
Projeto de TCC — MinhaFila Saúde