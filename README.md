# MinhaFila Saúde

Aplicativo Flutter focado em **transparência de filas do SUS**, com autenticação via **gov.br**, acompanhamento da posição na fila, histórico de movimentações e fluxo de confirmação de procedimento com envio de evidência para validação pela **SES**.

> Projeto desenvolvido como base para **TCC/MVP governamental**, priorizando usabilidade, transparência de informações, organização arquitetural, acessibilidade e evolução futura para integração real com sistemas públicos de saúde.

---

## Visão geral

O **MinhaFila Saúde** foi concebido para permitir que o cidadão acompanhe, de forma simples, segura e acessível, a sua posição em filas de atendimento do SUS. Além disso, o sistema propõe um mecanismo colaborativo de atualização da fila, permitindo que o usuário informe quando já realizou determinado procedimento por outro canal, contribuindo para maior eficiência da gestão pública.

### Principais objetivos da solução

- aumentar a transparência das filas de atendimento;
- melhorar a experiência do cidadão no acompanhamento da solicitação;
- reduzir inconsistências na fila causadas por registros desatualizados;
- apoiar a SES com um fluxo digital de validação e atualização da fila;
- oferecer acessibilidade para usuários com dificuldade de leitura;
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
- Recurso de **acessibilidade por áudio**
- Leitura manual da posição na fila com botão **“Ouvir posição”**
- Opção de leitura automática ao abrir a tela principal
- Ajuste de velocidade da fala
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

### Acessibilidade por áudio
O aplicativo oferece suporte inicial a usuários com baixa alfabetização ou dificuldade de leitura. A posição na fila pode ser lida em voz alta por meio de:
- botão manual na tela principal;
- leitura automática configurável nas preferências do app.

---

## Arquitetura da solução

A aplicação foi estruturada com foco em **escalabilidade, testabilidade, acessibilidade e separação de responsabilidades**.

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