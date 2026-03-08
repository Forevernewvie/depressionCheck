# Map Presentation Controller Hardening Prompt

## 목표
- `MapScreen`에서 `loading/status/filter/settings recovery` 상태 전이를 분리한다.
- 위젯은 lifecycle 연결과 렌더링에 집중하고, 상태 변경은 테스트 가능한 controller로 이동한다.
- 사용자 가시 동작은 유지하고 구조적 품질만 높인다.

## 필수 제약
- 확장성과 유지보수성을 최우선으로 한다.
- SOLID 원칙과 객체지향 설계를 따른다.
- 테스트 가능한 구조로 작성한다.
- 모든 신규 함수에는 목적 설명 주석을 작성한다.
- 하드코딩, 매직넘버, 중복 로직을 늘리지 않는다.
- 로깅은 기존 `AppLogger` 구조를 재사용한다.
- 보안상 민감한 위치/주소 원문을 로그에 남기지 않는다.

## 이번 단계에서 해결할 문제
- `MapScreen`이 로딩, 권한 복구, 필터, 정렬, 콘텐츠 모드, 상태 메시지 결정을 동시에 가진다.
- 이 구조는 `SRP`와 테스트성을 약화시키고, lifecycle 복구 회귀를 위젯 테스트에만 의존하게 만든다.

## 스킬 근거
- `ui-ux-pro-max` UX 검색:
  - Empty state는 원인과 다음 행동을 함께 제시해야 한다.
  - Error/permission 상태는 시각적 텍스트만이 아니라 구조적으로 명확해야 한다.
- `ui-ux-pro-max` Flutter 스택 검색:
  - `Semantics`와 truthful state를 유지한다.
  - 하드코딩 대신 `ThemeData`/구조화된 상태 계층을 사용한다.

## 구현 지침
1. `MapViewState` 같은 불변 상태 모델을 만든다.
2. `MapViewController`를 `StateNotifier` 기반으로 만든다.
3. `loadNearby`, `primaryAction`, `settings recovery`, `filter/sort/content mode` 전이를 controller 메서드로 옮긴다.
4. `MapScreen`은 provider state를 구독하고 controller 메서드만 호출한다.
5. 상태 문구는 가능하면 raw string 저장 대신 `status enum + policy`로 계산한다.
6. controller 단위 테스트를 추가해 lifecycle recovery와 action branching을 검증한다.

## 검증
- `flutter analyze`
- `flutter test`
