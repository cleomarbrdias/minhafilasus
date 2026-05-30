# Roadmap — MinhaFila Saúde

## Objetivo
Este documento organiza a evolução do projeto **MinhaFila Saúde** em fases, considerando entregas técnicas, acessibilidade, usabilidade e integração futura.

---

## Situação atual do projeto

O projeto já possui uma base funcional com:
- login mockado com estrutura para gov.br;
- dashboard com posição na fila;
- histórico e notificações;
- fluxo de confirmação e validação de procedimento;
- captura de foto e seleção de PDF;
- áudio em múltiplas telas;
- onboarding de acessibilidade;
- persistência local das preferências;
- alto contraste;
- modo daltônico;
- ajuste global de fonte;
- suporte inicial a Libras no onboarding.

---

## Fase 1 — MVP acadêmico funcional
### Status
Concluída em grande parte.

### Entregas
- estrutura do app em Flutter;
- navegação principal;
- gerenciamento de estado;
- dashboard;
- histórico;
- notificações;
- fluxo de confirmação;
- upload de evidência;
- áudio da fila;
- áudio do histórico;
- áudio das notificações;
- ajustes de acessibilidade;
- persistência local;
- onboarding de acessibilidade.

---

## Fase 2 — Refinamento de acessibilidade
### Status
Em andamento.

### Objetivos
Melhorar estabilidade, consistência e cobertura dos recursos acessíveis.

### Entregas previstas
- refinamento da velocidade do TTS;
- revisão de textos falados;
- consolidação do fluxo de Libras;
- melhoria das mensagens orientativas;
- testes com diferentes tamanhos de fonte;
- revisão de estados visuais em todas as telas.

### Critério de conclusão
Recursos acessíveis funcionando com previsibilidade e clareza na jornada principal.

---

## Fase 3 — Libras e assistência visual ampliada
### Objetivos
Evoluir o suporte inicial a Libras para uma experiência mais robusta.

### Entregas previstas
- melhorar a experiência atual de boas-vindas em Libras;
- definir modelo final:
  - vídeo local,
  - link externo,
  - ou avatar interno;
- adicionar explicações em Libras por recurso;
- expandir para telas de ajuda e orientação.

### Observação
Essa fase depende de decisão de produto sobre formato final de entrega.

---

## Fase 4 — Robustez funcional e documentação
### Objetivos
Melhorar a sustentabilidade do projeto e sua adoção futura.

### Entregas previstas
- documentação técnica mais completa;
- padronização de componentes;
- fortalecimento dos testes;
- melhoria de mensagens de erro;
- revisão de tratamento de estados vazios e falhas;
- organização da pasta `docs`.

### Documentos previstos
- arquitetura.md
- acessibilidade.md
- fluxo-negocio.md
- roadmap.md
- manutenção.md
- integração.md

---

## Fase 5 — Integração institucional
### Objetivos
Preparar o projeto para sair do mock e se aproximar de um cenário real.

### Entregas previstas
- autenticação real com gov.br;
- API backend intermediária;
- integração com sistemas da SES;
- persistência estruturada no backend;
- fila e validação reais;
- notificações vinculadas ao servidor.

### Dependências
- backend institucional;
- ambiente seguro;
- alinhamento com SES;
- governança de dados.

---

## Fase 6 — Auditoria e governança
### Objetivos
Aumentar confiabilidade, rastreabilidade e valor institucional do sistema.

### Entregas previstas
- trilha de auditoria para ações críticas;
- histórico de acesso;
- validação institucional formal;
- registro de envio e análise de comprovantes;
- indicadores administrativos.

---

## Fase 7 — Evolução da experiência do cidadão
### Objetivos
Aprimorar a jornada do usuário final.

### Entregas previstas
- ajuda contextual;
- explicações mais simples;
- melhoria na estimativa textual;
- onboarding mais inteligente;
- conteúdos multimídia orientativos;
- suporte ampliado a múltiplos procedimentos.

---

## Fase 8 — Escala e produto
### Objetivos
Transformar a prova de conceito em base para produto governamental evolutivo.

### Entregas previstas
- suporte a múltiplas secretarias;
- parametrização por órgão;
- configuração por ambiente;
- monitoramento operacional;
- relatórios gerenciais;
- evolução para ecossistema multi-institucional.

---

## Prioridades imediatas

### Curto prazo
- consolidar onboarding de acessibilidade;
- estabilizar TTS;
- decidir fluxo definitivo de Libras;
- revisar UI/UX acessível;
- atualizar documentação.

### Médio prazo
- melhorar testes;
- ampliar cobertura de ajuda e acessibilidade;
- fortalecer arquitetura documental;
- iniciar camada de integração real.

### Longo prazo
- backend completo;
- autenticação gov.br real;
- validação institucional real;
- escala para produção.

---

## Critérios de priorização

As próximas entregas devem seguir esta ordem:
1. impacto no usuário;
2. estabilidade do fluxo principal;
3. acessibilidade e inclusão;
4. clareza para apresentação acadêmica;
5. custo de implementação;
6. facilidade de manutenção.

---

## Conclusão
O roadmap do MinhaFila Saúde está estruturado para permitir evolução gradual, mantendo o equilíbrio entre:
- valor acadêmico;
- viabilidade técnica;
- acessibilidade;
- experiência do cidadão;
- e preparação para cenários institucionais futuros.
