# Acessibilidade — MinhaFila Saúde

## Objetivo
Este documento descreve a estratégia de acessibilidade do aplicativo **MinhaFila Saúde**, com foco em inclusão digital, usabilidade e evolução gradual dos recursos acessíveis.

---

## Princípios adotados

A acessibilidade no app foi pensada como parte da experiência principal, e não como um recurso adicional isolado.

Princípios orientadores:
- linguagem simples e objetiva;
- suporte multimodal, com texto, áudio e recursos visuais;
- personalização da experiência conforme a necessidade do usuário;
- persistência das preferências de acessibilidade;
- evolução incremental, priorizando recursos de maior impacto.

---

## Recursos implementados

### 1. Áudio com TTS
O aplicativo utiliza leitura por voz para ampliar o acesso de usuários com dificuldade de leitura, baixa escolaridade ou limitação visual leve.

Atualmente, o áudio está presente em:
- posição atual da fila;
- histórico;
- notificações;
- onboarding inicial de acessibilidade.

### 2. Leitura automática opcional
O usuário pode ativar a leitura automática da posição ao abrir a tela principal.

### 3. Controle de velocidade da fala
A velocidade do TTS é configurável pelo usuário na tela de ajustes.

### 4. Alto contraste
O app possui modo de alto contraste para melhorar a distinção entre texto, fundo e componentes interativos.

### 5. Modo daltônico
Foi implementada uma paleta alternativa para melhorar a diferenciação entre estados visuais, badges e status da interface.

### 6. Ajuste global de fonte
O usuário pode aumentar ou reduzir o tamanho do texto com impacto global no app.

### 7. Persistência das preferências
As preferências de acessibilidade são salvas localmente para que a experiência seja restaurada nas próximas aberturas do aplicativo.

### 8. Onboarding inicial de acessibilidade
Na primeira abertura, o usuário pode escolher como deseja utilizar o aplicativo, configurando recursos como:
- alto contraste;
- modo daltônico;
- leitura automática;
- tamanho do texto.

### 9. Suporte inicial a Libras
No onboarding, foi iniciado o suporte a Libras por meio de um botão flutuante dedicado à abertura do conteúdo de boas-vindas.

---

## Preferências de acessibilidade salvas

Atualmente, o sistema persiste:
- leitura automática da posição da fila;
- velocidade da fala;
- alto contraste;
- modo daltônico;
- escala do texto;
- conclusão do onboarding inicial.

---

## Arquitetura dos recursos de acessibilidade

A acessibilidade foi organizada de forma centralizada.

### Controller principal
O estado é controlado por um `AccessibilityController`, responsável por:
- manter o estado atual;
- aplicar mudanças na interface;
- persistir preferências;
- restaurar preferências salvas.

### Serviço de persistência
O app utiliza um serviço dedicado para salvar e recuperar configurações locais de acessibilidade.

### Serviço de áudio
O recurso de voz é centralizado em um serviço específico de anúncio por áudio, desacoplado das telas.

---

## Fluxos acessíveis atuais

### Onboarding inicial
- apresentação das opções de acessibilidade;
- leitura por voz das instruções;
- leitura individual das opções;
- suporte inicial a Libras;
- gravação das preferências.

### Home
- anúncio da posição da fila;
- leitura opcional sob demanda;
- leitura automática configurável.

### Histórico
- leitura por voz em cada item do histórico.

### Notificações
- leitura por voz em cada notificação.

### Ajustes
- alteração de contraste;
- modo daltônico;
- tamanho do texto;
- velocidade da fala;
- leitura automática.

---

## Limitações atuais

Apesar da evolução já implementada, ainda existem pontos em amadurecimento:
- calibração da velocidade do TTS entre plataformas;
- definição final do melhor formato para Libras;
- ausência de avatar nativo em Libras dentro da interface;
- necessidade de ampliar testes com usuários reais;
- necessidade de revisão visual completa em todas as telas com fonte ampliada máxima.

---

## Evoluções previstas

### Curto prazo
- estabilização do TTS entre Android, iOS e Web;
- refinamento da leitura do onboarding;
- melhoria do fluxo de Libras.

### Médio prazo
- expansão do suporte a Libras para outras telas;
- painel de ajuda acessível com vídeos por tópico;
- melhoria das mensagens de erro e ajuda contextual.

### Longo prazo
- avatar em Libras incorporado à interface;
- perfis acessíveis mais completos;
- sincronização de preferências com backend.

---

## Diretriz de manutenção

Toda nova funcionalidade do app deve considerar, no mínimo:
- legibilidade visual;
- contraste;
- clareza textual;
- possibilidade de leitura por áudio;
- compatibilidade com escala de fonte;
- não dependência exclusiva de cor para comunicar estado.

---

## Conclusão
A acessibilidade do MinhaFila Saúde foi estruturada como um eixo central da solução. O projeto já conta com recursos concretos de inclusão e possui uma base técnica preparada para evoluções futuras, especialmente em Libras, personalização da interface e experiência assistida.
