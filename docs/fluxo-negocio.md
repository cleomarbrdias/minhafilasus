# Fluxo de Negócio — MinhaFila Saúde

## Objetivo
Este documento descreve os principais fluxos de negócio do aplicativo **MinhaFila Saúde**, considerando a jornada do cidadão e a interação esperada com os processos da SES.

---

## Visão geral

O app foi concebido para permitir que o cidadão:
- acompanhe sua posição na fila do SUS;
- visualize histórico e notificações;
- informe se continua aguardando;
- informe se já realizou o procedimento;
- envie evidência para validação;
- personalize a experiência com recursos de acessibilidade.

---

## Fluxo 1 — Primeiro acesso ao aplicativo

### Etapas
1. usuário abre o aplicativo;
2. sistema verifica se o onboarding de acessibilidade já foi concluído;
3. se não foi concluído, apresenta a configuração inicial;
4. usuário escolhe recursos de acessibilidade ou mantém a configuração padrão;
5. sistema salva as preferências;
6. usuário segue para a tela de entrada/login.

### Resultado esperado
O app inicia já configurado de acordo com a necessidade inicial do usuário.

---

## Fluxo 2 — Login

### Cenário atual
Na versão atual do projeto, o login ocorre em modo mock para facilitar testes, apresentações e validação acadêmica.

### Etapas
1. usuário toca em “Entrar com gov.br”;
2. sistema executa autenticação simulada;
3. dados do usuário são carregados;
4. dashboard principal é exibido.

### Evolução futura
Em ambiente real, a autenticação deverá ocorrer por integração com gov.br.

---

## Fluxo 3 — Visualização da fila

### Etapas
1. dashboard é carregado;
2. sistema busca as solicitações ativas do usuário;
3. app exibe:
   - procedimento;
   - posição na fila;
   - estimativa de espera;
   - status;
   - última atualização;
4. usuário pode ouvir a posição por áudio.

### Regras
- a posição pode mudar conforme prioridade clínica e regulação;
- um usuário pode possuir mais de uma solicitação ativa;
- a interface pode destacar uma fila principal e outras filas secundárias.

---

## Fluxo 4 — Consulta ao histórico

### Etapas
1. usuário acessa a aba de histórico;
2. sistema lista eventos anteriores da solicitação;
3. usuário pode ler visualmente o conteúdo;
4. usuário pode ouvir cada item por áudio.

### Finalidade
Aumentar transparência e rastreabilidade das movimentações da fila.

---

## Fluxo 5 — Consulta às notificações

### Etapas
1. usuário acessa a aba de notificações;
2. sistema apresenta avisos do processo;
3. usuário pode tocar em cada item para compreender melhor;
4. usuário pode ouvir o conteúdo por áudio.

### Exemplos de notificações
- fila atualizada;
- validação iniciada;
- validação concluída;
- necessidade de ação do usuário.

---

## Fluxo 6 — Atualização do andamento da fila

### Etapas
1. usuário toca no card principal da fila;
2. sistema apresenta a tela de confirmação;
3. usuário escolhe:
   - “Não, continuo na fila”
   - “Sim, já realizei”

### Resultado
O app encaminha o usuário para o fluxo correspondente.

---

## Fluxo 7 — Usuário continua aguardando

### Etapas
1. usuário informa que continua na fila;
2. sistema mantém a solicitação ativa;
3. processo continua sem alteração de validação.

### Finalidade
Confirmar que a solicitação segue válida.

---

## Fluxo 8 — Usuário informa que já realizou o procedimento

### Etapas
1. usuário escolhe “Sim, já realizei”;
2. sistema abre a etapa de validação;
3. usuário envia uma evidência:
   - foto do laudo;
   - PDF;
4. sistema registra a solicitação de validação;
5. status muda para “Em validação”;
6. o usuário recebe feedback visual e informacional.

### Finalidade
Permitir atualização colaborativa da fila com governança institucional.

---

## Fluxo 9 — Validação institucional

### Etapas previstas
1. backend recebe o comprovante enviado;
2. informação é registrada com trilha de auditoria;
3. equipe da SES ou processo automatizado analisa a evidência;
4. solicitação é confirmada ou rejeitada;
5. sistema atualiza a fila;
6. usuário é notificado.

### Observação
Na versão atual, esse processo está representado de forma simulada.

---

## Fluxo 10 — Ajustes e personalização

### Etapas
1. usuário acessa a tela de ajustes;
2. visualiza dados de sessão;
3. altera preferências de acessibilidade;
4. sistema salva localmente as configurações;
5. futuras aberturas do app reaplicam essas preferências.

---

## Fluxo 11 — Acesso a Libras

### Etapa atual
No onboarding de acessibilidade, existe uma ação dedicada para abrir o conteúdo inicial em Libras.

### Evolução esperada
Expandir o suporte para outros fluxos de ajuda e orientação.

---

## Regras de negócio principais

### Regra 1 — Transparência da fila
O usuário deve conseguir visualizar sua posição e o status do processo de forma clara.

### Regra 2 — Atualização colaborativa com validação
A informação enviada pelo cidadão não altera diretamente a fila de forma definitiva sem validação institucional.

### Regra 3 — Acessibilidade transversal
Os recursos de acessibilidade devem estar presentes em toda a jornada principal, e não apenas em uma única tela.

### Regra 4 — Personalização persistente
Preferências de acessibilidade devem ser preservadas entre sessões sempre que possível.

### Regra 5 — Segurança e governança
Toda evolução real deve considerar autenticação segura, auditoria e proteção dos dados sensíveis.

---

## Conclusão
O fluxo de negócio do MinhaFila Saúde foi desenhado para equilibrar:
- transparência para o cidadão;
- simplicidade de uso;
- acessibilidade;
- atualização colaborativa da fila;
- e governança institucional da SES.
