# Accessibility Guidelines

Este documento descreve as melhorias de acessibilidade implementadas no aplicativo.

## Componentes com Acessibilidade

### 1. LoadingIndicator
- **Semantic Label**: "Carregando"
- **Uso**: Informa leitores de tela sobre o estado de carregamento

### 2. ErrorView
- **Semantic Labels**: 
  - Container: "Erro: [mensagem]"
  - Ícone: "Ícone de erro"
  - Botão: "Tentar novamente"
- **Uso**: Fornece contexto completo sobre erros e opções de recuperação

### 3. EmptyStateView
- **Semantic Label**: "Estado vazio: [mensagem]"
- **ExcludeSemantics**: Ícone decorativo excluído da árvore semântica
- **Uso**: Comunica claramente estados vazios sem redundância

### 4. ShimmerLoading
- **Animação suave**: Efeito shimmer para indicar carregamento
- **Uso**: Melhora percepção de performance durante carregamento

### 5. AnimatedListItem
- **Animações suaves**: Fade-in e slide-up para itens de lista
- **Staggered animation**: Animação escalonada baseada no índice
- **Uso**: Melhora experiência visual sem afetar acessibilidade

## Diretrizes de Implementação

### Semantic Labels
Sempre adicione labels semânticos para elementos interativos:

```dart
Semantics(
  label: 'Descrição clara da ação',
  button: true, // Para botões
  child: Widget(),
)
```

### ExcludeSemantics
Use para elementos puramente decorativos:

```dart
ExcludeSemantics(
  child: Icon(Icons.decorative),
)
```

### Contraste de Cores
- Tema usa Material 3 com `ColorScheme.fromSeed`
- Garante contraste mínimo WCAG AA (4.5:1 para texto normal)
- Cores de erro, sucesso e aviso seguem padrões de acessibilidade

### Tamanho de Toque
- Botões têm padding mínimo de 48x48dp
- Áreas de toque adequadas para todos os elementos interativos

### Escalabilidade de Texto
- Todos os textos usam `Theme.of(context).textTheme`
- Suporta escalabilidade do sistema operacional
- Testado com tamanhos de fonte grandes

## Testes de Acessibilidade

### Checklist
- [ ] Todos os botões têm labels semânticos
- [ ] Ícones decorativos estão excluídos da árvore semântica
- [ ] Estados de loading são anunciados
- [ ] Mensagens de erro são claras e acionáveis
- [ ] Contraste de cores atende WCAG AA
- [ ] Tamanhos de toque são adequados (mínimo 48x48dp)
- [ ] Texto escala corretamente

### Ferramentas de Teste
1. **Flutter DevTools**: Inspetor de acessibilidade
2. **TalkBack (Android)**: Leitor de tela nativo
3. **VoiceOver (iOS)**: Leitor de tela nativo
4. **Contrast Checker**: Verificação de contraste de cores

## Recursos Adicionais
- [Flutter Accessibility Guide](https://docs.flutter.dev/development/accessibility-and-localization/accessibility)
- [Material Design Accessibility](https://m3.material.io/foundations/accessible-design/overview)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
