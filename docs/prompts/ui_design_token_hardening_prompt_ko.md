# UI Design Token Hardening Prompt

다음 기준으로 UI 레이어의 하드코딩을 줄이고 공통 토큰 계층을 강화하라.

## 목표
- spacing, padding, inset, motion duration 같은 반복 숫자를 공통 토큰으로 이동한다.
- 화면 간 레이아웃 일관성을 높이고 유지보수 비용을 낮춘다.
- theme 와 screen/widget 레벨에서 같은 숫자가 중복되지 않게 정리한다.

## 필수 규칙
- 매직넘버 금지
- 하드코딩 금지
- 공통 토큰은 `core/theme` 아래에 둔다
- 신규/수정 함수에는 목적 설명 주석 유지
- 기존 UI 동작과 테스트는 깨지지 않아야 한다

## 우선순위
1. `ThemeData` 공통 padding/margin/chip/input/button spacing
2. 홈, 온보딩, 체크인, 결과 화면
3. 공통 위젯(`flow_header_card`, `likert_question_card`)
4. 이후 map/safety/modules 로 확장

## 검증
- `dart format`
- `flutter analyze`
- 관련 위젯 테스트
- 가능하면 전체 `flutter test`
