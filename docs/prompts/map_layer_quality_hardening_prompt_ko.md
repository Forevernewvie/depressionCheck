# Map Layer Quality Hardening Prompt

다음 기준으로 지도/클리닉 조회 계층을 개선하라.

## 목표
- 네트워크 조회, 쿼리 생성, 응답 파싱, 도메인 변환 책임을 분리한다.
- 테스트 가능하고 유지보수 가능한 구조로 바꾼다.
- 하드코딩된 쿼리 문자열, 숫자, 실패 코드, 기본값을 설정/정책 객체로 이동한다.
- 네트워크 실패와 파싱 실패를 구분해 typed failure 로 반환한다.
- 성능 병목 가능성을 분석하고 불필요한 문자열/컬렉션 연산을 줄인다.

## 필수 규칙
- SOLID 준수
- 모든 신규/수정 함수에 목적 설명 주석 추가
- DI 가능한 구조
- 로그는 민감 정보 없이 구조화
- 테스트 최소 2개 이상 추가

## 실행 범위
- `OverpassClinicRepository`
- Overpass query builder
- Overpass payload parser
- 관련 테스트

## 검증
- `flutter analyze`
- 관련 map 테스트
- 가능하면 전체 `flutter test`
