# Development Plan — MinhaFila Saúde

## Objetivo
Organizar o desenvolvimento da nova fase em etapas pequenas, demonstráveis e documentadas.

---

## Etapa 1 — Definição da stack
### Entregas
- backend escolhido;
- painel escolhido;
- estrutura de pastas definida.

### Saída documental
- backend-overview.md
- architecture decision note inicial

---

## Etapa 2 — Modelo de dados
### Entregas
- entidades definidas;
- DDL inicial;
- base homologada preparada.

### Saída documental
- database-model.md

---

## Etapa 3 — API REST inicial
### Entregas
- login mock;
- me;
- queue requests;
- history;
- notifications.

### Saída documental
- api-spec.md

---

## Etapa 4 — Fluxo de validação
### Entregas
- create validation request;
- upload attachment;
- status awaiting validation.

### Saída documental
- validation-flow.md

---

## Etapa 5 — Painel administrativo MVP
### Entregas
- login admin;
- lista de pendências;
- detalhe com anexo;
- aprovar/rejeitar.

### Saída documental
- admin-panel.md

---

## Etapa 6 — Integração do app Flutter
### Entregas
- substituição gradual dos repositórios mockados;
- consumo real da API;
- tratamento de erro;
- retorno do status atualizado.

### Saída documental
- integration-plan.md

---

## Etapa 7 — Refinamento e demonstração
### Entregas
- base homologada com dados de exemplo;
- roteiro de apresentação;
- fluxo ponta a ponta validado.

---

## Estratégia recomendada
Cada etapa deve ser:
- pequena;
- testável;
- documentada;
- demonstrável.
