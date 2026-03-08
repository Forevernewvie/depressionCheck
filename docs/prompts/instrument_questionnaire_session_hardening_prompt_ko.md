# Instrument Questionnaire Session Hardening Prompt

## 목표
- `InstrumentQuestionnaireScreen`에서 답안 상태와 제출 검증을 분리한다.
- 화면은 렌더링과 라우팅에 집중하고, 설문 세션 상태는 테스트 가능한 controller로 이동한다.

## 필수 제약
- SOLID, 객체지향, 테스트 가능 구조를 유지한다.
- 모든 신규 함수에 목적 주석을 추가한다.
- 하드코딩과 중복 로직을 늘리지 않는다.
- 로깅은 기존 `AppLogger`를 사용하고 민감한 문항 원문/답안 원문은 로그에 남기지 않는다.

## 구현 지침
1. `InstrumentQuestionnaireState`를 만든다.
2. `StateNotifier` 기반 세션 controller를 만든다.
3. 답안 변경, 완료 여부 판단, 제출 시 score 계산 진입을 controller로 이동한다.
4. 화면은 provider state를 읽고 성공 시 라우팅, 실패 시 snackbar만 처리한다.
5. controller 단위 테스트를 추가한다.

## 검증
- `flutter analyze`
- `flutter test`
