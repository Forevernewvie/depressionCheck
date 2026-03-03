# 웹 호스팅/접근 가이드 (초보자용)

이 문서는 `depressionCheck` Flutter 앱을 **Firebase Hosting**으로 배포하고, 사용자가 링크로 접근하도록 설정하는 절차를 설명합니다.

> 안전 고지: 이 앱은 진단 도구가 아니라 선별(screening) 도구입니다.

## 1) 최종 접속 주소

Firebase Hosting 기본 주소는 아래 2개입니다.

- https://mentalvibe.web.app
- https://mentalvibe.firebaseapp.com

둘 중 아무 주소나 공유해도 됩니다.

## 2) 1회 초기 준비 (로컬 PC)

### 2-1. Firebase CLI 설치

```bash
npm install -g firebase-tools
firebase --version
```

### 2-2. Firebase 로그인

```bash
firebase login
```

브라우저가 열리면 Google 계정으로 로그인하고 허용합니다.

### 2-3. 프로젝트 연결 확인

저장소 루트에서 아래 파일을 확인합니다.

- `.firebaserc` (기본 프로젝트 `mentalvibe`)
- `firebase.json` (Flutter SPA rewrite 설정)

## 3) 로컬에서 배포하기 (수동)

```bash
cd /Users/jaebinchoi/Desktop/depressionCheck_repo
flutter pub get
flutter build web --release --dart-define=FIREBASE_PROJECT_ID=mentalvibe
firebase deploy --only hosting --project mentalvibe
```

배포 완료 후 콘솔에 `Hosting URL`이 표시됩니다.

## 4) GitHub Actions로 배포하기 (선택)

레포지토리 `Settings > Secrets and variables > Actions`에서 아래 값을 등록합니다.

- `FIREBASE_PROJECT_ID`: `mentalvibe`
- `FIREBASE_TOKEN`: `firebase login:ci`로 발급한 토큰

토큰 발급:

```bash
firebase login:ci
```

출력된 토큰은 **한 번만 복사**해서 GitHub Secrets에 저장합니다.

## 5) GitHub 레포지토리 연동 시 자주 나는 오류 해결

오류 예시:

- `The provided authorization cannot be used with this repository.`
- `For which GitHub repository would you like to set up a GitHub workflow?`

해결 순서:

1. 아래 GitHub 앱 권한 페이지를 열고 Firebase CLI 권한을 허용합니다.
   - https://github.com/settings/connections/applications/89cf50f02ac6aaed3484
2. Organization 접근 권한이 필요한 경우 해당 org를 체크합니다.
3. 레포 입력 시 정확히 `Forevernewvie/depressionCheck` 형식으로 입력합니다.

## 6) 접근성 좋은 링크 운영 방법

### 6-1. 짧고 기억하기 쉬운 경로

Flutter `GoRouter` 경로 기준으로 아래 링크를 바로 안내할 수 있습니다.

- `https://mentalvibe.web.app/` (홈)
- `https://mentalvibe.web.app/settings` (설정)
- `https://mentalvibe.web.app/check-in` (데일리 체크인)

> 실제 경로는 `lib/core/config/app_routes.dart` 기준으로 운영하세요.

### 6-2. UTM 링크로 유입 채널 추적

예시:

- `https://mentalvibe.web.app/?utm_source=instagram&utm_medium=social&utm_campaign=launch_ko`

### 6-3. QR 코드 공유

1. 주소를 준비합니다. (예: `https://mentalvibe.web.app/`)
2. QR 생성 사이트(예: QRCode Monkey)에 붙여넣고 이미지 생성
3. 온보딩 안내물/포스터/SNS에 삽입

## 7) 커스텀 도메인 연결 (선택)

1. Firebase Console > Hosting > `Add custom domain`
2. 원하는 도메인 입력
3. 안내된 DNS 레코드(CNAME/A/TXT)를 도메인 관리 사이트에 등록
4. SSL 인증서 발급이 완료되면 실사용 가능

## 8) 배포 체크리스트

- [ ] `flutter analyze` 통과
- [ ] `flutter test` 통과
- [ ] `flutter build web --release` 통과
- [ ] `firebase deploy --only hosting` 성공
- [ ] 배포 URL 접속 확인
- [ ] 주요 화면(온보딩/선별/결과/지도) 정상 동작 확인

## 9) 빠른 실행 스크립트

환경변수 기반 자동 배포 스크립트:

- `scripts/deploy_web_firebase.sh`

실행 예시:

```bash
cd /Users/jaebinchoi/Desktop/depressionCheck_repo
export FIREBASE_PROJECT_ID=mentalvibe
export FIREBASE_TOKEN=YOUR_TOKEN
./scripts/deploy_web_firebase.sh
```
