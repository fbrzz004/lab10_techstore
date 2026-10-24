import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techstore_app/main.dart';

void main() {
  testWidgets('La pantalla de login se muestra al iniciar', (tester) async {
    await tester.pumpWidget(const TechStoreApp());
    await tester.pumpAndSettle();

    expect(find.text('TechStore S.A.C.'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('El botón Ingresar permanece disponible', (tester) async {
    await tester.pumpWidget(const TechStoreApp());
    await tester.pumpAndSettle();

    final boton = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(boton.onPressed, isNotNull);
  });
}
