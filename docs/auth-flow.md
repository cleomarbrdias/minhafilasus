# Auth Flow — MinhaFila Saúde

## Objetivo
Descrever a estratégia de autenticação do cidadão e do painel administrativo nas diferentes fases do projeto.

---

## Fase atual
### App do cidadão
- autenticação mockada;
- entrada simulada por gov.br;
- foco em experiência, fluxo e navegação.

### Painel administrativo
- autenticação local administrativa;
- usuário e senha controlados pela base de homologação.

---

## Fase intermediária
### Cidadão
- backend passa a emitir token real;
- login mock continua possível em homologação;
- estrutura preparada para gov.br real.

### Admin
- autenticação via endpoint dedicado;
- perfis administrativos distintos.

---

## Fase futura
### Cidadão
- integração real com gov.br;
- validação de identidade;
- consumo seguro da API.

### Admin
- autenticação institucional;
- perfis gerenciados;
- trilha de auditoria completa.

---

## Tokens
Sugestão:
- JWT curto
- refresh token opcional em fase posterior

---

## Endpoints iniciais
- POST `/api/v1/auth/login-mock`
- GET `/api/v1/me`
- POST `/api/v1/admin/auth/login`

---

## Perfis
- citizen
- analyst
- manager
- admin

---

## Regras mínimas
- cidadão não acessa endpoints admin;
- admin não acessa dados fora do escopo autorizado;
- todas as ações relevantes devem ser auditáveis.
