import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/features/instruments/application/instrument_questionnaire_catalog.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';

void main() {
  test('catalog only exposes supported module instruments', () {
    expect(
      InstrumentQuestionnaireCatalog.supportedInstruments(),
      containsAll(<ScreeningInstrument>[
        ScreeningInstrument.hadsD,
        ScreeningInstrument.cesD,
        ScreeningInstrument.bdi2,
      ]),
    );
    expect(
      InstrumentQuestionnaireCatalog.lookup(ScreeningInstrument.phq2),
      isNull,
    );
    expect(
      InstrumentQuestionnaireCatalog.lookup(ScreeningInstrument.phq9),
      isNull,
    );
  });

  test('catalog scoring delegates preserve selected instrument', () {
    final hads = InstrumentQuestionnaireCatalog.lookup(ScreeningInstrument.hadsD)!;
    final cesd = InstrumentQuestionnaireCatalog.lookup(ScreeningInstrument.cesD)!;
    final bdi = InstrumentQuestionnaireCatalog.lookup(ScreeningInstrument.bdi2)!;

    expect(
      hads.score(List<int>.filled(7, 0)).instrument,
      ScreeningInstrument.hadsD,
    );
    expect(
      cesd.score(List<int>.filled(10, 0)).instrument,
      ScreeningInstrument.cesD,
    );
    expect(
      bdi.score(List<int>.filled(21, 0)).instrument,
      ScreeningInstrument.bdi2,
    );
  });
}
