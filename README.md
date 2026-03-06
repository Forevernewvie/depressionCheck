# depressionCheck

우울 관련 상태를 **선별(screening)** 하기 위한 Flutter 기반 모바일 앱입니다.  
이 프로젝트는 의료 **진단** 도구가 아니며, 단계형 선별과 안전 중심 안내를 제공합니다.

## 1. 프로젝트 개요

- 앱 성격: 우울 관련 선별 MVP (진단 아님)
- 기본 흐름: `PHQ-2 -> PHQ-9 -> 결과 -> (중등도/고위험) 주변 기관 지도 안내`
- 대상 연령 문구(앱 내): 13-49세
- 주요 추가 기능:
  - 데일리 체크인 + 주간 추세
  - 개인 세이프티 플랜 + 신뢰 연락처 원탭 액션
- 기본 저장 방식: Isar 기반 local-first

## 2. 안전 고지

- 본 앱은 의료적 진단을 제공하지 않습니다. 선별 결과는 참고 정보입니다.
- 자해 관련 응답 또는 고위험 신호가 있으면 응급/위기 도움 경로를 우선 제시합니다.
- 응급 상황에서는 앱 내 안내보다 즉시 지역 응급 체계 이용이 우선입니다.
- 기본 긴급 번호 설정값:
  - 응급: `911`
  - 위기 상담: `988`

## 3. 주요 기능 요약

| 영역 | 내용 | 코드 근거 |
|---|---|---|
| 선별 흐름 | PHQ-2 결과에 따라 PHQ-9 자동 연계 | `lib/features/screening/presentation/phq2_screen.dart`, `phq9_screen.dart` |
| 결과 안내 | 점수/등급(정상·경도·중등도·고위험) + 다음 행동 제시 | `lib/features/results/presentation/result_screen.dart` |
| 고위험 대응 | 응급/위기 전화, 주변 기관 이동 CTA | `result_screen.dart`, `safety_plan_screen.dart`, `map_screen.dart` |
| 지도 안내 | 위치 권한/네트워크 상태별 처리 + fallback | `lib/features/map/application/*`, `lib/features/map/data/*` |
| 데일리 체크인 | 기분/에너지/메모 저장, 7일 추세 표시 | `lib/features/checkin/*` |
| 세이프티 플랜 | 위험 신호/대처/안전 이유/응급 단계 저장 | `lib/features/safety/*` |
| 신뢰 연락처 | 추가/삭제/대표 지정/원탭 전화 | `safety_plan_screen.dart`, `safety_controller.dart` |
| 설정 | 라이트/다크, 한국어/영어, 시스템 우선순위 처리 | `lib/features/settings/presentation/settings_screen.dart`, `lib/core/settings/*` |
| 광고(비임계 화면) | 홈/모듈 화면 하단 배너(정책 토글 가능) | `lib/core/ads/*`, `lib/infrastructure/ads/*` |

## 4. 사용자 흐름

1. 스플래시에서 온보딩 완료 여부를 확인합니다.
2. 온보딩 미완료 시 온보딩 후 홈으로 이동합니다.
3. 홈에서 PHQ-2(1단계)를 시작합니다.
4. PHQ-2 점수 기준(3점 이상) 충족 시 PHQ-9(2단계)로 이동합니다.
5. 결과 화면에서 등급 및 권장 행동을 확인합니다.
6. 중등도 또는 고위험이면 주변 기관 지도 화면으로 이동할 수 있습니다.
7. 별도 도구로 데일리 체크인/세이프티 플랜을 사용합니다.

## 5. 기술 스택

| 구분 | 사용 기술 |
|---|---|
| Framework | Flutter |
| Language | Dart (`sdk: ^3.11.0`) |
| 상태관리 | Riverpod (`flutter_riverpod`) |
| 라우팅 | `go_router` |
| 로컬 DB | Isar (`isar`, `isar_flutter_libs`) |
| 지도 | `flutter_map`, `latlong2` |
| 네트워크 | `http` |
| 위치 권한 | `geolocator` |
| 외부 액션 | `url_launcher` |
| 로컬라이제이션 | `flutter_localizations`, `intl`, ARB |
| 광고 | `google_mobile_ads` |
| 품질 | `flutter_lints`, `flutter analyze`, `flutter test` |

## 6. 아키텍처

### 계층 구조

- `presentation`: 화면/위젯
- `application`: 상태 모델, 유스케이스 조합, 컨트롤러
- `domain`: 엔티티/규칙/검증
- `data`: 저장소 인터페이스
- `infrastructure`: Isar/네트워크/광고/외부 액션 구현

### Riverpod 상태관리

- `Provider`, `StateNotifierProvider` 기반 DI + 상태 관리
- 주요 상태 컨트롤러:
  - `settingsControllerProvider`
  - `onboardingControllerProvider`
  - `checkInControllerProvider`
  - `safetyControllerProvider`

### Isar 영속성

`main.dart`에서 아래 스키마를 열고 DI로 주입합니다.

- `AppPreferenceSchema`
- `DailyCheckInRecordSchema`
- `SafetyPlanRecordSchema`
- `TrustedContactRecordSchema`

## 7. 디렉터리 구조

```text
.
├── .github/workflows
│   └── flutter_ci.yml
├── docs
│   └── prompts
├── lib
│   ├── app
│   ├── core
│   │   ├── ads
│   │   ├── config
│   │   ├── errors
│   │   ├── logging
│   │   ├── network
│   │   ├── platform
│   │   ├── result
│   │   ├── security
│   │   ├── settings
│   │   └── theme
│   ├── features
│   │   ├── checkin
│   │   ├── clinician
│   │   ├── common
│   │   ├── home
│   │   ├── instruments
│   │   ├── map
│   │   ├── onboarding
│   │   ├── results
│   │   ├── safety
│   │   ├── screening
│   │   └── settings
│   ├── infrastructure
│   │   └── ads
│   ├── l10n
│   └── main.dart
├── test
│   ├── fakes
│   ├── features
│   ├── screening_logic_test.dart
│   └── widget_test.dart
├── pubspec.yaml
└── analysis_options.yaml
```

## 8. 시작하기

### 개발 환경

- Flutter SDK 설치
- Dart SDK `^3.11.0` 호환
- Android Studio 또는 Xcode

### 설치

```bash
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

### 에뮬레이터 실행 스크립트(옵션)

```bash
bash run_emulator_flutter_flow.sh
```

## 9. 환경변수(`--dart-define`) 정리

아래 키는 실제 코드(`lib/core/config/app_env.dart`, `lib/core/config/ad_config.dart`) 기준입니다.

| Key | 기본값 | 설명 |
|---|---|---|
| `APP_NAME` | `Mind Check` | 앱 제목 |
| `OVERPASS_ENDPOINT` | `https://overpass-api.de/api/interpreter` | 기관 조회 API |
| `OSM_TILE_URL_TEMPLATE` | `https://tile.openstreetmap.org/{z}/{x}/{y}.png` | 지도 타일 URL |
| `MAP_USER_AGENT_PACKAGE` | `com.example.vibemental_app` | 지도 요청 User-Agent |
| `CLINIC_SEARCH_TIMEOUT_MS` | `18000` | 지도 조회 타임아웃(ms) |
| `CLINIC_SEARCH_MAX_ATTEMPTS` | `3` | 지도 조회 재시도 횟수 |
| `CLINIC_SEARCH_BASE_BACKOFF_MS` | `400` | 재시도 백오프(ms) |
| `CLINIC_SEARCH_RADIUS_METERS` | `5000` | 기본 검색 반경(m) |
| `CLINIC_SEARCH_MAX_RESULTS` | `12` | 최대 결과 수 |
| `EMERGENCY_PHONE` | `911` | 응급 전화번호 |
| `CRISIS_PHONE` | `988` | 위기 상담 전화번호 |
| `ENABLE_REMOTE_CLINIC_LOOKUP` | `true` | 원격 기관 조회 사용 여부 |
| `ADMOB_APP_ID` | `ca-app-pub-` | AdMob 앱 ID |
| `ADMOB_BANNER_AD_UNIT_ID` | `ca-app-pub-` | 배너 광고 유닛 ID |
| `ADS_ENABLED` | `true` | 광고 전체 on/off |
| `ADS_HOME_BANNER_ENABLED` | `true` | 홈 배너 on/off |
| `ADS_MODULES_BANNER_ENABLED` | `true` | 모듈 배너 on/off |

실행 예시:

```bash
flutter run \
  --dart-define=APP_NAME="Mind Check KR" \
  --dart-define=EMERGENCY_PHONE=119 \
  --dart-define=CRISIS_PHONE=1393 \
  --dart-define=ADS_ENABLED=false
```

## 10. 테스트/품질 점검 명령어

```bash
dart format .
flutter analyze
flutter test
```

## 11. 로컬라이제이션/테마 가이드

- 지원 언어: `en`, `ko`
- ARB 파일:
  - `lib/l10n/app_en.arb`
  - `lib/l10n/app_ko.arb`
- 생성 파일:
  - `lib/l10n/app_localizations*.dart`
- 테마:
  - `lib/core/theme/app_theme.dart`
  - `ThemeMode.system | light | dark`
- 언어 우선순위:
  - 사용자 수동 선택 우선
  - 시스템 모드일 때 `ko`면 한국어, 그 외 영어

## 12. 데이터/개인정보 처리 메모 (local-first)

- Isar 로컬 DB에 사용자 설정/체크인/세이프티 플랜/신뢰 연락처를 저장합니다.
- 지도는 기본적으로 외부 API(Overpass) 조회를 사용하며, 실패 시 fallback 데이터를 사용합니다.
- 전화/길찾기 액션은 플랫폼 외부 앱 실행(`url_launcher`)을 사용합니다.
- 로깅은 구조화되어 있으나 민감정보 직접 로깅을 피하도록 설계되어 있습니다.
- TODO: 보존 기간/사용자 삭제 정책 문서화를 추가하세요.

## 13. Git Flow 협업 규칙

현재 원격 브랜치 구성과 CI 트리거 기준으로 다음 규칙을 사용합니다.

- 장기 브랜치:
  - `main`: 릴리스
  - `develop`: 통합
- 작업 브랜치:
  - `feature/*`: 기능
  - `bugfix/*`: 버그
  - `chore/*`: 유지보수/문서
  - `codex/*`: 자동화 작업 브랜치
- PR 규칙:
  - 기능/수정/문서는 `develop` 대상으로 PR
  - 릴리스는 `develop -> main` PR
  - `main` 직접 푸시 금지

## 14. 로드맵

### MVP 범위 (현재 코드 기준)

- PHQ-2/PHQ-9 단계형 선별
- 결과 등급/안전 안내/지도 연계
- 데일리 체크인 + 주간 추세
- 세이프티 플랜 + 신뢰 연락처 원탭
- ko/en + light/dark
- Isar local-first 저장
- CI(포맷/분석/테스트) 파이프라인

### Next 범위

- TODO: 선택형 계정 동기화(백엔드 연동 포인트) 문서화
- TODO: 데이터 백업/복구 UX 추가
- TODO: 개인정보 고지/삭제 플로우 강화

## 15. 라이선스

이 프로젝트는 [MIT License](./LICENSE)를 따릅니다.
