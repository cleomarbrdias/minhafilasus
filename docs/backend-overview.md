# Backend Overview — MinhaFila Saúde

## Objetivo
Este documento descreve a proposta de backend REST real para o projeto **MinhaFila Saúde**, permitindo evoluir do cenário mockado atual para uma arquitetura com persistência real, fluxo de validação e integração futura com sistemas institucionais.

---

## Papel do backend na solução
O backend é a camada central da aplicação e deve atuar como intermediário entre:
- o **app Flutter do cidadão**;
- o **painel administrativo da SES**;
- a **base de dados de homologação**;
- futuras integrações com **gov.br**, **SES**, notificações e storage institucional.

---

## Responsabilidades principais
O backend deve ser responsável por:

### 1. Autenticação e sessão
- autenticação mockada na fase inicial;
- preparação da estrutura para integração real com gov.br;
- emissão e validação de tokens;
- controle de sessão do usuário cidadão e do usuário administrativo.

### 2. Gestão da fila
- consultar solicitações do cidadão;
- retornar posição, status e estimativa;
- registrar histórico de movimentações;
- devolver notificações vinculadas ao usuário.

### 3. Fluxo de validação
- registrar solicitação de “já realizei”;
- receber e relacionar evidências;
- alterar status para “em validação”;
- permitir aprovação ou rejeição via painel administrativo;
- devolver atualização ao app.

### 4. Painel administrativo
- listar validações pendentes;
- consultar detalhe da solicitação;
- exibir comprovantes enviados;
- aprovar, rejeitar ou registrar observações;
- registrar auditoria básica.

### 5. Persistência e rastreabilidade
- armazenar dados estruturados;
- manter histórico;
- registrar eventos relevantes;
- preparar trilha de auditoria.

---

## Arquitetura proposta

### Componentes
- **App Flutter**: interface do cidadão
- **Painel Web Admin**: interface da equipe da SES
- **Backend REST**: regras de negócio e exposição da API
- **Banco PostgreSQL**: persistência principal
- **Storage de arquivos**: armazenamento de anexos
- **Serviços futuros**: gov.br, SES, notificações, auditoria institucional

---

## Estilo arquitetural
A recomendação para esta fase é usar um **monólito modular**, pois:
- reduz complexidade operacional;
- é suficiente para o escopo do TCC/MVP;
- facilita testes e demonstração;
- ainda permite crescimento posterior.

### Módulos sugeridos
- auth
- users
- queue
- notifications
- validations
- attachments
- admin
- audit

---

## Stack sugerida

### Backend
Duas opções principais:

#### Opção 1 — Java + Spring Boot
Mais forte para contexto institucional e arquitetural.

#### Opção 2 — Node.js + NestJS
Mais ágil para implementação rápida.

### Banco
- PostgreSQL

### Storage
- MinIO ou Amazon S3
- em MVP, pode ser iniciado com storage local controlado

### Painel administrativo
- aplicação web
- preferência por React / Next.js ou Angular

---

## Estratégia para o TCC
Para o TCC, a recomendação é:

### Implementar de forma real
- backend REST
- base homologada
- fluxo de validação
- retorno do status ao app
- painel administrativo simples

### Manter como evolução futura
- gov.br real
- SES real
- push notifications reais
- IA analítica
- storage institucional definitivo

---

## Fluxo ponta a ponta esperado
1. cidadão acessa o app;
2. consulta a fila via backend;
3. informa que já realizou o procedimento;
4. envia evidência;
5. backend registra validação pendente;
6. painel administrativo lista pendência;
7. analista aprova ou rejeita;
8. backend atualiza status;
9. app volta a exibir novo status e notificação.

---

## Critérios de sucesso para esta fase
- app deixa de depender exclusivamente de mocks;
- dados passam a existir em banco real;
- fluxo de validação pode ser demonstrado ponta a ponta;
- painel administrativo consegue atuar sobre a solicitação;
- atualização retorna ao app do cidadão.

---

## Próximos passos técnicos
1. definir stack final;
2. criar modelo de dados;
3. criar endpoints REST mínimos;
4. criar base homologada;
5. integrar app Flutter;
6. construir painel administrativo simples;
7. validar fluxo completo.
