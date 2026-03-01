# depressionCheck

우울 관련 상태를 **자가 선별(screening)** 할 수 있도록 설계된 Flutter 기반 모바일 앱입니다.  
이 프로젝트는 의료 진단이 아닌, 단계형 선별과 안전 중심 안내를 목표로 합니다.

## 1) 프로젝트 개요

- 앱 성격: 우울 관련 선별 MVP (진단 아님)
- 대상 플랫폼: Flutter (Android/iOS, desktop/web 폴더 포함)
- 기본 흐름: `PHQ-2 -> PHQ-9 -> 결과 -> (중등도/고위험) 지도 기반 기관 안내`
- 추가 기능:
  - 데일리 체크인 + 최근 7일 추세
  - 개인 세이프티 플랜 + 신뢰 연락처 원탭 액션

## 2) 안전 고지 (Safety Disclaimer)

- 본 앱은 의료적 진단 도구가 아니라 **선별 도구**입니다.
- 고위험 신호(예: 자해 관련 응답)가 감지되면 즉시 안전 안내와 도움 요청 경로를 우선 노출합니다.
- 응급 상황에서는 앱 사용보다 지역 응급전화/의료기관 연락이 우선입니다.

## 3) 주요 기능

| 영역 | 기능 | 구현 상태 |
|---|---|---|
| 선별 | PHQ-2 1차 선별 후 기준 초과 시 PHQ-9로 단계 상승 | 구현 완료 |
| 결과 | 정상/경도/중등도/고위험 레벨 표시 + 다음 단계 가이드 | 구현 완료 |
| 안전 | 고위험 시 응급/위기 전화 CTA + 주변 기관 탐색 | 구현 완료 |
| 지도 | 위치 권한/네트워크 상태에 따른 실시간 조회 + fallback 목록 | 구현 완료 |
| 체크인 | 기분/에너지/메모 일일 기록 + 주간 평균/추세 표시 | 구현 완료 |
| 세이프티 플랜 | 경고 신호/대처 전략/안전 이유/응급 단계 저장 | 구현 완료 |
| 신뢰 연락처 | 연락처 등록, 대표 연락처 지정, 원탭 전화 | 구현 완료 |
| 설정 | 한국어/영어 + 라이트/다크 + 시스템 연동 | 구현 완료 |

## 4) 사용자 흐름

1. 스플래시/온보딩 진입
2. 홈에서 1차 선별(PHQ-2) 시작
3. PHQ-2 점수 기준 충족 시 PHQ-9 진행
4. 결과 화면에서 점수/레벨/다음 행동 안내 확인
5. 중등도 또는 고위험이면 주변 기관 화면으로 이동 가능
6. 별도 웰빙 도구로 데일리 체크인 및 세이프티 플랜 사용

## 5) 기술 스택

- Framework: Flutter
- Language: Dart (`sdk: ^3.11.0`)
- State Management: Riverpod (`flutter_riverpod`)
- Navigation: `go_router`
- Local DB: Isar (`isar`, `isar_flutter_libs`)
- Map: `flutter_map`, `latlong2`
- Network/Location: `http`, `geolocator`
- External Action: `url_launcher`
- Localization: `flutter_localizations`, `intl`, ARB 기반 생성 코드

## 6) 아키텍처

### 계층 구조

- `presentation`: 화면/위젯
- `application`: 상태 관리, 유스케이스 오케스트레이션
- `domain`: 비즈니스 규칙/모델/검증
- `data`: 저장소 인터페이스
- `infrastructure`: 외부 I/O 구현(Isar, HTTP, 플랫폼 액션)

### 상태관리

- Riverpod `Provider`, `StateNotifierProvider` 기반
- 설정/체크인/세이프티/지도 로딩 상태를 각 컨트롤러에서 관리

### 영속성

- Isar 로컬 퍼시스턴스 사용
- 현재 등록 스키마:
  - `AppPreference`
  - `DailyCheckInRecord`
  - `SafetyPlanRecord`
  - `TrustedContactRecord`

## 7) 디렉터리 구조

```text
.
├── lib
│   ├── app
│   ├── core
│   │   ├── config
│   │   ├── logging
│   │   ├── network
│   │   ├── platform
│   │   ├── security
│   │   ├── settings
│   │   └── theme
│   ├── features
│   │   ├── screening
│   │   ├── results
│   │   ├── map
│   │   ├── checkin
│   │   ├── safety
│   │   ├── onboarding
│   │   └── settings
│   ├── l10n
│   └── main.dart
├── test
│   ├── features
│   │   ├── checkin
│   │   ├── map
│   │   └── safety
│   └── *.dart
├── docs/prompts
├── pubspec.yaml
└── analysis_options.yaml
```

## 8) 시작하기

### 사전 준비

- Flutter SDK 설치
- Dart SDK `^3.11.0` 호환 환경
- Android Studio / Xcode 등 플랫폼 툴체인

### 설치

```bash
cd depressionCheck
flutter pub get
```

### 코드 생성(필요 시)

```bash
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
```

### 실행

```bash
flutter run
```

### 스크립트 실행 (옵션)

```bash
bash run_emulator_flutter_flow.sh
```

> 기본값은 스크립트 위치(저장소 루트)이며, 필요 시 `WORKDIR` 환경변수로 재정의할 수 있습니다.

## 9) 환경변수(`--dart-define`) 정리

`lib/core/config/app_env.dart` 기준 실제 키만 정리했습니다.

| Key | 기본값 | 용도 |
|---|---|---|
| `APP_NAME` | `Mind Check` | 앱 타이틀 |
| `OVERPASS_ENDPOINT` | `https://overpass-api.de/api/interpreter` | 기관 조회 API 엔드포인트 |
| `OSM_TILE_URL_TEMPLATE` | `https://tile.openstreetmap.org/{z}/{x}/{y}.png` | 지도 타일 URL |
| `MAP_USER_AGENT_PACKAGE` | `com.example.vibemental_app` | 타일 요청 User-Agent |
| `CLINIC_SEARCH_TIMEOUT_MS` | `18000` | 기관 조회 타임아웃(ms) |
| `CLINIC_SEARCH_MAX_ATTEMPTS` | `3` | 재시도 횟수 |
| `CLINIC_SEARCH_BASE_BACKOFF_MS` | `400` | 백오프 기본 지연(ms) |
| `CLINIC_SEARCH_RADIUS_METERS` | `5000` | 기본 검색 반경(m) |
| `CLINIC_SEARCH_MAX_RESULTS` | `12` | 최대 결과 수 |
| `EMERGENCY_PHONE` | `911` | 응급 전화번호 |
| `CRISIS_PHONE` | `988` | 위기 상담 번호 |
| `ENABLE_REMOTE_CLINIC_LOOKUP` | `true` | 원격 기관 조회 on/off |

예시:

```bash
flutter run \
  --dart-define=APP_NAME="Mind Check KR" \
  --dart-define=EMERGENCY_PHONE=119 \
  --dart-define=CRISIS_PHONE=1393 \
  --dart-define=ENABLE_REMOTE_CLINIC_LOOKUP=true
```

## 10) 테스트/품질 점검

```bash
dart format lib test
flutter analyze
flutter test
```

현재 테스트는 선별 로직, 지도 fallback, 체크인/세이프티 UI 경로, 설정/온보딩 흐름을 포함합니다.

## 11) 로컬라이제이션/테마 가이드

- 언어 리소스: `lib/l10n/app_ko.arb`, `lib/l10n/app_en.arb`
- 생성 코드: `lib/l10n/app_localizations*.dart`
- 테마: `lib/core/theme/app_theme.dart`
- 의미 색상(응급/위험 등): `lib/core/theme/app_semantic_colors.dart`
- 언어 우선순위:
  - 사용자 수동 설정 우선
  - 시스템 언어 사용 시 `ko`가 아니면 `en`으로 해석

## 12) 데이터/개인정보 메모 (Local-first)

- 기본 저장소는 Isar 로컬 DB이며 서버 연동 없이 동작 가능합니다.
- 로컬 저장 대상(코드 기준):
  - 앱 설정(테마/언어/온보딩)
  - 데일리 체크인
  - 세이프티 플랜
  - 신뢰 연락처
- 지도 조회 시 원격 API(Overpass)와 위치 권한을 사용할 수 있습니다.
- TODO: 로컬 DB 암호화/보존기간/삭제 정책 문서화 강화.

## 13) Git Flow 협업 규칙

- 장기 브랜치:
  - `main`: 배포 브랜치
  - `develop`: 통합 브랜치
- 작업 브랜치:
  - `feature/*`: 기능
  - `bugfix/*`: 버그 수정
  - `chore/*`: 문서/정리/유지보수
- 원칙:
  - `main` 직접 푸시 금지
  - PR 대상은 우선 `develop`
  - 릴리즈 시 `develop -> main` PR로 반영

## 14) 로드맵

### MVP (현재 코드 기준)

- PHQ-2/PHQ-9 단계형 선별
- 결과/위험도 안내 + 고위험 안전 경로
- 지도 기반 기관 탐색(fallback 포함)
- 데일리 체크인/주간 추세
- 세이프티 플랜/신뢰 연락처
- 다국어/다크모드, 로컬 퍼시스턴스

### 다음 단계 (Next)

- TODO: 백엔드 동기화 옵션(선택형)
- TODO: 데이터 백업/복구 정책
- TODO: 운영용 모니터링/릴리즈 파이프라인 문서화

## 15) 라이선스

이 프로젝트는 [MIT License](./LICENSE)를 따릅니다.
