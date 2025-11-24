import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_ai_testing/data/services/model/expense_model.dart';
import 'package:firebase_ai_testing/utils/result.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseAiService {
  @PostConstruct()
  void init() {
    _model =
        FirebaseAI.googleAI(
          appCheck: FirebaseAppCheck.instance,
          useLimitedUseAppCheckTokens: true,
        ).generativeModel(
          model: 'gemini-2.5-flash',
          systemInstruction: Content.text(
            '''
                Você é um assistente de despesas pessoais. 
                Você recebera fotos de recibos e extratos bancários e devera extrair as seguintes informações:
                - Nome do Estabelecimento
                - Data da Compra (Ex: "2005-11-23")
                - Valor da Compra (Ex: 100.5)
                - Categoria da Despesa (Ex: Alimentação, Transporte, Saúde, Lazer, Educação, Moradia, Outros)
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
        "Colete os dados da despesa conforme orientação dada previamente.",
      );
      final image = await File(file).readAsBytes();
      final imagePart = InlineDataPart('image/jpeg', image);
      final response = await _model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

      if (response.text?.isEmpty ?? false) {
        return Result.error(
          Exception('Erro ao analisar imagem'),
        );
      }
      log(response.text!);
      final expenseModel = ExpenseModel.fromJson(jsonDecode(response.text!));
      return Result.ok(expenseModel);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
