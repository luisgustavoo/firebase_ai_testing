import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_ai_testing/data/services/firebase_ai_service/models/ai_extracted_expense.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:injectable/injectable.dart';

/// Callback type for providing categories to the AI
/// This allows the repository layer to inject category data
typedef CategoryProvider = Future<List<String>> Function();

/// Callback type for providing recent transactions to the AI
/// This allows the repository layer to inject transaction data for financial insights
typedef TransactionProvider = Future<List<Map<String, dynamic>>> Function();

/// Service that wraps Firebase Gemini AI API for financial assistance.
/// This is a stateless service that only handles AI communication.
/// According to Flutter architecture guidelines, services wrap external APIs
/// and expose Future/Stream objects. They should not call repositories.
@lazySingleton
class FirebaseAiService {
  FirebaseAiService();

  late final GenerativeModel _model;

  /// Provider function that returns available categories
  /// Set by repository layer to provide category data to AI
  CategoryProvider? categoryProvider;

  /// Provider function that returns recent transactions
  /// Set by repository layer to provide transaction history to AI
  TransactionProvider? transactionProvider;

  @postConstruct
  void init() {
    _model =
        FirebaseAI.googleAI(
          appCheck: FirebaseAppCheck.instance,
          useLimitedUseAppCheckTokens: true,
        ).generativeModel(
          // model: 'gemini-2.0-flash-exp',
          model: 'gemini-2.5-flash-lite',
          tools: [
            Tool.functionDeclarations([
              FunctionDeclaration(
                'get_user_categories',
                'Obtém as categorias de despesas personalizadas do usuário. Use esta função para conhecer as categorias disponíveis e escolher a mais apropriada ao classificar uma transação.',
                parameters: {},
              ),
              FunctionDeclaration(
                'get_recent_transactions',
                'Obtém o histórico recente de transações do usuário. Use esta função para analisar padrões de gastos, identificar oportunidades de economia, ou fornecer insights financeiros personalizados.',
                parameters: {},
              ),
            ]),
          ],
          // generationConfig: GenerationConfig(
          //   responseMimeType: 'application/json',
          //   responseSchema: Schema.object(
          //     properties: {
          //       'amount': Schema.number(
          //         description: 'Valor total da transação (número decimal)',
          //         nullable: false,
          //       ),
          //       'transaction_type': Schema.enumString(
          //         description:
          //             'Tipo da transação - sempre "expense" para recibos',
          //         enumValues: ['expense', 'income'],
          //         nullable: false,
          //       ),
          //       'payment_type': Schema.enumString(
          //         description: 'Método de pagamento usado',
          //         enumValues: ['credit_card', 'debit_card', 'pix', 'money'],
          //         nullable: false,
          //       ),
          //       'transaction_date': Schema.string(
          //         description: 'Data da transação no formato ISO (YYYY-MM-DD)',
          //         nullable: false,
          //       ),
          //       'category_id': Schema.string(
          //         description: 'ID da categoria (apenas o ID, não a descrição)',
          //         nullable: false,
          //       ),
          //       'description': Schema.string(
          //         description:
          //             'Descrição da transação (nome do estabelecimento)',
          //         nullable: false,
          //       ),
          //     },
          //   ),
          // ),
          systemInstruction: Content.text(
            '''
              Você é um assistente financeiro pessoal inteligente especializado em gestão de despesas.

              ## Suas Capacidades:

              ### 1. Extração de Dados de Recibos
              Quando receber uma imagem de recibo ou nota fiscal, extraia os seguintes dados:

              - **amount**: Valor total da transação (número decimal, ex: 150.50)
              - **transaction_type**: Tipo da transação - SEMPRE "expense" para recibos
              - **payment_type**: Método de pagamento usado:
                - "credit_card" para Cartão de Crédito
                - "debit_card" para Cartão de Débito  
                - "pix" para Pix
                - "money" para Dinheiro
              - **transaction_date**: Data da transação no formato ISO (YYYY-MM-DD)
              - **category_id**: ID da categoria (use get_user_categories para ver as opções no formato "id:descrição" e extraia apenas o ID)
              - **description**: Descrição da transação (nome do estabelecimento/loja)

              ### 2. Análise Financeira e Insights
              Quando solicitado, você pode:
              - Analisar padrões de gastos usando get_recent_transactions
              - Identificar categorias com maior gasto
              - Sugerir oportunidades de economia
              - Alertar sobre gastos incomuns ou excessivos
              - Fornecer resumos financeiros personalizados


              ## Formato de Resposta para Extração:

              Sempre retorne os dados extraídos no seguinte formato JSON (sem marcadores de código):

              {
                "amount": 150.50,
                "transaction_type": "expense",
                "payment_type": "credit_card",
                "transaction_date": "2024-01-15",
                "category_id": "id-da-categoria",
                "description": "Nome do Estabelecimento"
              }
              OBS: NUNCA inclua comentários ou texto adicional fora do JSON.


              ## Diretrizes Importantes:
              - Seja preciso na extração de valores e datas
              - transactionType SEMPRE deve ser "expense" para recibos
              - paymentType deve ser exatamente: "credit_card", "debit_card", "pix", ou "money"
              - transactionDate deve estar no formato ISO (YYYY-MM-DD)
              - Use get_user_categories para obter as categorias (formato "id:descrição")
              - categoryId deve ser apenas o ID (parte antes dos ":"), não a descrição
              - Se não conseguir identificar algum campo, use null
              - Para análises financeiras, seja claro, objetivo e útil
    ''',
          ),
        );
  }

  /// Analyze receipt image and extract expense data using AI
  /// Returns Result with AiExtractedExpense containing extracted data
  ///
  /// The AI may call get_user_categories during analysis.
  /// Categories are provided via the categoryProvider callback set by repository.
  Future<Result<AiExtractedExpense>> analyzeReceiptImage(
    String imagePath,
  ) async {
    try {
      const prompt = TextPart(
        'Analise esta imagem de recibo e extraia os dados da despesa no formato JSON especificado. '
        'Primeiro, busque as categorias disponíveis do usuário usando get_user_categories para classificar corretamente a transação. '
        'Identifique: valor total, data, estabelecimento, forma de pagamento e categoria mais apropriada.',
      );

      final image = await File(imagePath).readAsBytes();
      final imagePart = InlineDataPart('image/jpeg', image);

      var response = await _model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

      // Handle AI function calls
      if (response.functionCalls.isNotEmpty) {
        final functionCall = response.functionCalls.first;
        log('AI requested function: ${functionCall.name}');

        Map<String, Object?> functionResponse;

        // Execute requested function
        switch (functionCall.name) {
          case 'get_user_categories':
            final categories = await _getCategoriesForAi();
            functionResponse = {'categories': categories};
          case 'get_recent_transactions':
            final transactions = await _getTransactionsForAi();
            functionResponse = {'transactions': transactions};
          default:
            log('Unknown function call: ${functionCall.name}');
            functionResponse = {'error': 'Unknown function'};
        }

        // Send function result back to AI
        response = await _model.generateContent([
          Content.multi([prompt, imagePart]),
          response.candidates.first.content,
          Content.functionResponse(functionCall.name, functionResponse),
        ]);
      }

      // Parse AI response
      if (response.text?.isEmpty ?? true) {
        return Result.error(
          Exception('Erro ao analisar imagem: resposta vazia da IA'),
        );
      }

      log('AI response: ${response.text}');

      // Clean and parse JSON response
      final cleanedJson = response.text!
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final extractedExpense = AiExtractedExpense.fromJson(
        jsonDecode(cleanedJson) as Map<String, dynamic>,
      );

      return Result.ok(extractedExpense);
    } on FormatException catch (e) {
      log('JSON parse error: $e');
      return Result.error(
        Exception('Erro ao processar resposta da IA: formato inválido'),
      );
    } on FileSystemException catch (e) {
      log('File error: $e');
      return Result.error(
        Exception('Erro ao ler arquivo de imagem: ${e.message}'),
      );
    } on Exception catch (e) {
      log('AI service error: $e');
      return Result.error(Exception('Erro ao analisar imagem: $e'));
    }
  }

  /// Get categories from provider for AI function calling
  /// Returns empty list if provider is not set
  Future<List<String>> _getCategoriesForAi() async {
    if (categoryProvider == null) {
      log('Warning: categoryProvider not set, returning empty list');
      return [];
    }

    try {
      return await categoryProvider!();
    } on Exception catch (e) {
      log('Error getting categories from provider: $e');
      return [];
    }
  }

  /// Get transactions from provider for AI function calling
  /// Returns empty list if provider is not set
  Future<List<Map<String, dynamic>>> _getTransactionsForAi() async {
    if (transactionProvider == null) {
      log('Warning: transactionProvider not set, returning empty list');
      return [];
    }

    try {
      return await transactionProvider!();
    } on Exception catch (e) {
      log('Error getting transactions from provider: $e');
      return [];
    }
  }
}
