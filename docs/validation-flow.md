# Validation Flow — MinhaFila Saúde

## Objetivo
Descrever o fluxo de validação quando o cidadão informa que já realizou o procedimento.

---

## Etapas

### 1. Ação do cidadão
No app, o usuário toca em:
- “Sim, já realizei”

### 2. Criação da solicitação
O backend registra uma `validation_request` com status:
- `PENDING_REVIEW`

### 3. Envio do anexo
O usuário envia:
- foto
ou
- PDF

### 4. Atualização do app
O app passa a exibir:
- “Em validação”

### 5. Triagem administrativa
O analista acessa o painel:
- visualiza a solicitação;
- abre o anexo;
- aprova ou rejeita.

### 6. Resultado
Se aprovado:
- a solicitação muda para status validado;
- o cidadão recebe nova notificação.

Se rejeitado:
- a solicitação volta ao fluxo adequado;
- o cidadão recebe feedback.

---

## Estados sugeridos

### No app
- Na fila
- Em validação
- Validado
- Validação rejeitada

### No backend
- `PENDING_REVIEW`
- `APPROVED`
- `REJECTED`

---

## Regras
- o cidadão não altera a fila de forma definitiva sozinho;
- toda ação administrativa deve gerar auditoria;
- o backend é a única fonte de verdade do status.
