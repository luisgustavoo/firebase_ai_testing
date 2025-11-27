import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_ai_testing/data/services/model/expense_model.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

@lazySingleton
class FirebaseAiService {
  static const String _mcpBaseUrl = 'http://192.168.0.159:8080';
  static const String _userId = '7fb3a4cb-3b1e-4b8d-a3dd-f41741c23a05';
  static const String _bearerToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI1YWZmY2FiNS0wODA2LTQxMDUtYTllOS01OWUwZTQyMTc2NDYiLCJlbWFpbCI6InRlc3RlQGV4YW1wbGUuY29tIiwiaWF0IjoxNzY0MjEwNzE4LCJleHAiOjE3NjQyOTcxMTh9.LlgfUqttybM6ZvXWIQM1oCrkUu8haP3T9jMJMaG6m1A';

  @PostConstruct()
  void init() {
    _model =
        FirebaseAI.googleAI(
          appCheck: FirebaseAppCheck.instance,
          useLimitedUseAppCheckTokens: true,
        ).generativeModel(
          model: 'gemini-2.5-flash',
          tools: [
            Tool.functionDeclarations([
              FunctionDeclaration(
                'get_user_categories',
                'Obtém as categorias de despesas cadastradas pelo usuário. Use esta função quando precisar saber quais categorias estão disponíveis para classificar uma despesa.',
                parameters: {
                  'userId': Schema(
                    SchemaType.string,
                    description: 'ID do usuário',
                    enumValues: [_userId],
                  ),
                },
              ),
            ]),
          ],
          systemInstruction: Content.text(
            '''
            Você é um assistente de despesas pessoais. 
            Você recebera fotos de recibos e extratos bancários e devera extrair as seguintes informações:
            - Nome do Estabelecimento
            - Data da Compra (Ex: "2005-11-23")
            - Valor da Compra (Ex: 100.5)
            - Categoria da Despesa - Use a função get_user_categories para obter as categorias disponíveis do usuário e escolha a mais apropriada
            - Método de Pagamento (Ex: Cartão de Crédito, Cartão de Débito, Dinheiro, Pix, Outros)
            Forneça as informações no seguinte formato:
            {
              "estabelecimento": "Nome do Estabelecimento",
              "data": "YYYY-MM-dd",
              "valor": "Valor da Compra",
              "categoria": "Categoria da Despesa",
              "metodoPagamento": "Método de Pagamento"
            }
            OBS: Não precisa adicionar a formatação ```json 
        ''',
          ),
        );
  }

  late final GenerativeModel _model;

  Future<Result<ExpenseModel>> sendImageToAi(String file) async {
    try {
      final prompt = TextPart(
        "Colete os dados da despesa conforme orientação dada previamente. Busque as categorias do usuário.",
      );

      final image = await File(file).readAsBytes();
      final imagePart = InlineDataPart('image/jpeg', image);

      var response = await _model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

      // Se a IA decidiu chamar uma função
      if (response.functionCalls.isNotEmpty) {
        final functionCall = response.functionCalls.first;
        log('IA chamou função: ${functionCall.name}');

        // Executa a função solicitada
        if (functionCall.name == 'get_user_categories') {
          final categoriesResult = await getUserCategories();

          Map<String, Object?> functionResponse;
          switch (categoriesResult) {
            case Ok():
              functionResponse = {'categories': categoriesResult.value};
            case Error():
              functionResponse = {'error': categoriesResult.error.toString()};
          }

          // Envia o resultado da função de volta para a IA
          response = await _model.generateContent([
            Content.multi([prompt, imagePart]),
            response.candidates.first.content,
            Content.functionResponse(functionCall.name, functionResponse),
          ]);
        }
      }

      if (response.text?.isEmpty ?? false) {
        return Result.error(
          Exception('Erro ao analisar imagem'),
        );
      }

      log(response.text!);
      final expenseModel = ExpenseModel.fromJson(
        jsonDecode(
          response.text!.replaceAll('```json', '').replaceAll('```', ''),
        ),
      );
      return Result.ok(expenseModel);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<String>>> getUserCategories() async {
    try {
      final uri = Uri.parse('$_mcpBaseUrl/api/users/categories').replace(
        queryParameters: {
          'userId': _userId,
        },
      );
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_bearerToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final categories = (data['categories'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        log('Categorias do usuário: $categories');
        return Result.ok(categories);
      } else {
        log(
          'Erro ao buscar categorias: ${response.statusCode} - ${response.body}',
        );
        return Result.error(
          Exception('Erro ao buscar categorias: ${response.statusCode}'),
        );
      }
    } on Exception catch (e) {
      log('Exceção ao buscar categorias: $e');
      return Result.error(e);
    }
  }
}
