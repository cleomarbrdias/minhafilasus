# Database Model — MinhaFila Saúde

## Objetivo
Este documento descreve o modelo de dados inicial do backend do **MinhaFila Saúde** para uso em ambiente de homologação.

---

## Estratégia
O banco deve ser simples, relacional e suficiente para:
- autenticação mockada;
- múltiplas filas por usuário;
- histórico;
- notificações;
- fluxo de validação;
- anexos;
- ações administrativas;
- auditoria básica.

Banco sugerido:
- PostgreSQL

---

## Entidades principais

### 1. users
Representa cidadãos e usuários administrativos.

Campos sugeridos:
- id
- full_name
- cpf
- email
- password_hash (para admin ou mock local)
- role (`citizen`, `analyst`, `manager`, `admin`)
- created_at
- updated_at
- active

---

### 2. queue_requests
Representa cada solicitação em fila.

Campos sugeridos:
- id
- user_id
- procedure_name
- procedure_code
- location_name
- regulation_unit
- position
- status
- wait_estimate_days
- priority_label
- last_updated_at
- created_at
- updated_at

Relacionamento:
- N para 1 com users

---

### 3. queue_history
Histórico de eventos da solicitação.

Campos sugeridos:
- id
- queue_request_id
- type
- title
- description
- occurred_at
- created_at

Relacionamento:
- N para 1 com queue_requests

---

### 4. notifications
Notificações do usuário.

Campos sugeridos:
- id
- user_id
- title
- description
- type
- is_read
- sent_at
- created_at

Relacionamento:
- N para 1 com users

---

### 5. validation_requests
Solicitações de validação enviadas pelo cidadão.

Campos sugeridos:
- id
- queue_request_id
- declared_action
- status
- citizen_comment
- analyst_comment
- submitted_at
- reviewed_at
- reviewed_by
- created_at
- updated_at

Relacionamentos:
- 1 para 1 ou N para 1 com queue_requests
- reviewed_by referencia users

---

### 6. validation_attachments
Anexos enviados na validação.

Campos sugeridos:
- id
- validation_request_id
- file_name
- original_name
- mime_type
- storage_path
- file_size
- attachment_type
- uploaded_at

Relacionamento:
- N para 1 com validation_requests

---

### 7. audit_logs
Registra eventos relevantes da aplicação.

Campos sugeridos:
- id
- actor_user_id
- actor_role
- action
- entity_type
- entity_id
- description
- created_at
- metadata_json

Relacionamentos:
- opcional com users

---

## Modelo relacional simplificado

### users
- 1:N queue_requests
- 1:N notifications
- 1:N audit_logs

### queue_requests
- 1:N queue_history
- 1:N validation_requests

### validation_requests
- 1:N validation_attachments

---

## Exemplo de DDL inicial

```sql
create table users (
  id uuid primary key,
  full_name varchar(150) not null,
  cpf varchar(11) not null unique,
  email varchar(150),
  password_hash varchar(255),
  role varchar(30) not null,
  active boolean not null default true,
  created_at timestamp not null,
  updated_at timestamp not null
);

create table queue_requests (
  id uuid primary key,
  user_id uuid not null references users(id),
  procedure_name varchar(200) not null,
  procedure_code varchar(50),
  location_name varchar(200) not null,
  regulation_unit varchar(200),
  position integer not null,
  status varchar(50) not null,
  wait_estimate_days integer,
  priority_label varchar(100),
  last_updated_at timestamp not null,
  created_at timestamp not null,
  updated_at timestamp not null
);

create table queue_history (
  id uuid primary key,
  queue_request_id uuid not null references queue_requests(id),
  type varchar(50) not null,
  title varchar(150) not null,
  description text not null,
  occurred_at timestamp not null,
  created_at timestamp not null
);

create table notifications (
  id uuid primary key,
  user_id uuid not null references users(id),
  title varchar(150) not null,
  description text not null,
  type varchar(50) not null,
  is_read boolean not null default false,
  sent_at timestamp not null,
  created_at timestamp not null
);

create table validation_requests (
  id uuid primary key,
  queue_request_id uuid not null references queue_requests(id),
  declared_action varchar(50) not null,
  status varchar(50) not null,
  citizen_comment text,
  analyst_comment text,
  submitted_at timestamp not null,
  reviewed_at timestamp,
  reviewed_by uuid references users(id),
  created_at timestamp not null,
  updated_at timestamp not null
);

create table validation_attachments (
  id uuid primary key,
  validation_request_id uuid not null references validation_requests(id),
  file_name varchar(200) not null,
  original_name varchar(200) not null,
  mime_type varchar(100) not null,
  storage_path varchar(300) not null,
  file_size bigint,
  attachment_type varchar(30) not null,
  uploaded_at timestamp not null
);

create table audit_logs (
  id uuid primary key,
  actor_user_id uuid references users(id),
  actor_role varchar(30),
  action varchar(100) not null,
  entity_type varchar(100) not null,
  entity_id uuid not null,
  description text,
  metadata_json jsonb,
  created_at timestamp not null
);
```

---

## Dados iniciais sugeridos para homologação
- 2 a 3 usuários cidadãos
- 1 analista
- 1 gestor
- filas em estados diferentes
- ao menos 1 solicitação com validação pendente
- notificações simuladas
- histórico com múltiplos registros

---

## Evoluções futuras
- tabela de unidades de saúde
- tabela de procedimentos padronizados
- tabela de perfis e permissões
- storage externo com chave de referência
- versionamento de auditoria
- notificações push
