# Admin Panel — MinhaFila Saúde

## Objetivo
Este documento descreve a proposta do painel administrativo da SES para o projeto **MinhaFila Saúde**.

---

## Escolha recomendada
Para a equipe da SES, a recomendação é construir um **painel web**, e não um app mobile.

### Motivos
- uso principal em desktop;
- atualização centralizada;
- melhor experiência para tabelas, filtros e validação;
- mais adequado para operação administrativa;
- menor dependência de instalação em máquinas internas.

---

## Perfis previstos

### 1. Analista
- visualizar solicitações pendentes;
- abrir anexos;
- aprovar ou rejeitar;
- registrar observações.

### 2. Gestor
- visualizar indicadores;
- consultar volume por status;
- acompanhar produtividade;
- consultar auditoria.

### 3. Administrador
- gerenciar usuários administrativos;
- visualizar logs;
- manter parâmetros do ambiente.

---

## Módulos do painel

### 1. Dashboard administrativo
Exibe visão consolidada:
- solicitações pendentes;
- aprovações do dia;
- rejeições do dia;
- total em validação;
- volume por unidade/procedimento.

### 2. Fila de validações
Tela principal de operação.

Funcionalidades:
- listar validações;
- filtrar por status;
- buscar por cidadão;
- buscar por procedimento;
- filtrar por período;
- ordenar por data de envio.

### 3. Detalhe da validação
Tela de análise da solicitação.

Deve exibir:
- dados do cidadão;
- dados da solicitação;
- status atual;
- histórico resumido;
- anexos enviados;
- botão aprovar;
- botão rejeitar;
- campo de observação.

### 4. Auditoria
Consulta dos eventos administrativos.

### 5. Gestão de usuários
Cadastro e manutenção de perfis administrativos.

---

## Fluxo principal da triagem

1. analista faz login;
2. acessa a fila de validações;
3. abre uma solicitação pendente;
4. visualiza comprovante;
5. lê observações, se houver;
6. aprova ou rejeita;
7. backend atualiza status;
8. app do cidadão passa a exibir o novo resultado.

---

## Telas mínimas para MVP

### Tela 1 — Login admin
- usuário
- senha
- botão entrar

### Tela 2 — Dashboard simples
- cards de quantidade
- atalho para validações pendentes

### Tela 3 — Lista de validações
- tabela
- filtros
- status
- data
- ação “abrir”

### Tela 4 — Detalhe da validação
- dados da solicitação
- preview do anexo
- aprovar
- rejeitar
- comentário

---

## Estrutura de componentes sugerida

### Layout
- sidebar esquerda
- header superior
- conteúdo principal
- tabela com filtros

### Componentes
- cards de indicador
- tabela paginada
- filtros
- drawer/sidebar
- modal de confirmação
- preview de PDF/imagem

---

## Requisitos de usabilidade
- foco em desktop;
- navegação simples;
- feedback claro de ação concluída;
- possibilidade de localizar rapidamente pendências;
- organização visual limpa;
- responsividade mínima para notebooks.

---

## Requisitos de segurança
- autenticação separada do cidadão;
- token próprio do painel;
- perfis de acesso;
- registro de ações administrativas;
- proteção de anexos;
- expiração de sessão.

---

## Stack sugerida
Painel web:
- React / Next.js
ou
- Angular

Integração:
- consumo da mesma API REST do backend principal

---

## Entregas recomendadas para o TCC
No escopo acadêmico, o painel pode ser simples, porém funcional.

### Implementar
- login admin
- listagem de pendências
- detalhe com anexo
- aprovar/rejeitar
- retorno ao app via backend

### Simular
- múltiplos perfis completos
- relatórios avançados
- dashboard gerencial sofisticado

---

## Valor acadêmico da entrega
A presença do painel administrativo fortalece o projeto porque demonstra:
- fluxo institucional;
- governança;
- viabilidade de triagem;
- integração entre cidadão e gestão pública;
- arquitetura ponta a ponta.
