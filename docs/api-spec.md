# API Spec — MinhaFila Saúde

## Objetivo
Este documento define a primeira especificação da API REST do backend do **MinhaFila Saúde**.

---

## Convenções
- Base URL: `/api/v1`
- Formato: JSON
- Autenticação: Bearer Token
- Datas: ISO-8601
- Erros: objeto padrão com código, mensagem e detalhe opcional

### Estrutura de erro sugerida
```json
{
  "code": "VALIDATION_ERROR",
  "message": "Dados inválidos.",
  "details": "O campo procedureId é obrigatório."
}
```

---

## 1. Auth

### POST `/api/v1/auth/login-mock`
Autentica usuário em modo mock.

#### Request
```json
{
  "cpf": "12345678900"
}
```

#### Response
```json
{
  "token": "jwt-token",
  "user": {
    "id": "u-1",
    "fullName": "Maria Silva",
    "cpfMasked": "***.456.789-**",
    "role": "citizen"
  }
}
```

---

## 2. Me

### GET `/api/v1/me`
Retorna o usuário autenticado.

#### Response
```json
{
  "id": "u-1",
  "fullName": "Maria Silva",
  "cpfMasked": "***.456.789-**",
  "role": "citizen"
}
```

---

## 3. Queue Requests

### GET `/api/v1/queue-requests`
Lista as solicitações do cidadão.

#### Response
```json
[
  {
    "id": "qr-1",
    "procedureName": "Consulta em Cardiologia",
    "locationName": "Hospital Regional",
    "position": 54,
    "status": "IN_QUEUE",
    "statusLabel": "Na fila",
    "waitEstimateLabel": "1 mês e 15 dias",
    "lastUpdatedAt": "2026-06-10T14:30:00Z"
  }
]
```

### GET `/api/v1/queue-requests/{id}`
Retorna detalhe de uma solicitação.

---

## 4. Queue History

### GET `/api/v1/queue-requests/{id}/history`
Lista o histórico da solicitação.

#### Response
```json
[
  {
    "id": "h-1",
    "type": "progress",
    "title": "Posição atualizada",
    "description": "Sua posição foi atualizada pela regulação.",
    "occurredAt": "2026-06-08T12:00:00Z"
  }
]
```

---

## 5. Notifications

### GET `/api/v1/notifications`
Lista notificações do cidadão.

### PATCH `/api/v1/notifications/{id}/read`
Marca uma notificação como lida.

---

## 6. Validation Requests

### POST `/api/v1/validation-requests`
Cria solicitação de validação para uma fila.

#### Request
```json
{
  "queueRequestId": "qr-1",
  "declaredAction": "ALREADY_COMPLETED"
}
```

#### Response
```json
{
  "id": "vr-1",
  "status": "PENDING_REVIEW",
  "createdAt": "2026-06-10T15:00:00Z"
}
```

### GET `/api/v1/validation-requests/{id}`
Retorna detalhe da validação.

---

## 7. Attachments

### POST `/api/v1/validation-requests/{id}/attachments`
Recebe um anexo ligado à validação.

#### Formato
`multipart/form-data`

#### Campos
- `file`
- `type` = IMAGE | PDF

#### Response
```json
{
  "id": "att-1",
  "fileName": "laudo.pdf",
  "contentType": "application/pdf",
  "uploadedAt": "2026-06-10T15:05:00Z"
}
```

---

## 8. Admin — Login

### POST `/api/v1/admin/auth/login`
Autentica usuário administrativo.

---

## 9. Admin — Validation Queue

### GET `/api/v1/admin/validation-requests`
Lista validações pendentes ou filtradas.

#### Query params sugeridos
- `status`
- `page`
- `size`
- `userName`
- `procedureName`

### GET `/api/v1/admin/validation-requests/{id}`
Retorna detalhe da validação administrativa.

#### Response esperada
- dados do cidadão
- dados da solicitação
- anexos
- histórico
- observações
- status atual

### PATCH `/api/v1/admin/validation-requests/{id}/approve`
Aprova solicitação.

#### Request
```json
{
  "comment": "Comprovante validado."
}
```

### PATCH `/api/v1/admin/validation-requests/{id}/reject`
Rejeita solicitação.

#### Request
```json
{
  "comment": "Documento insuficiente."
}
```

---

## 10. Audit

### GET `/api/v1/admin/audit-logs`
Lista eventos de auditoria.

---

## Status sugeridos

### Queue Request
- `IN_QUEUE`
- `AWAITING_VALIDATION`
- `VALIDATED_COMPLETED`
- `REJECTED_VALIDATION`

### Validation Request
- `PENDING_REVIEW`
- `APPROVED`
- `REJECTED`

---

## Critério de MVP da API
Para a primeira entrega, os endpoints mínimos são:
- auth/login-mock
- me
- queue-requests
- queue-requests/{id}/history
- notifications
- validation-requests
- validation-requests/{id}/attachments
- admin/validation-requests
- admin/validation-requests/{id}/approve
- admin/validation-requests/{id}/reject
