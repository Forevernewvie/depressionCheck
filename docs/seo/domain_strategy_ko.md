# 도메인/캐노니컬 전략 (PHASE 1)

## 현재 결정
- `PRIMARY_DOMAIN` 환경변수가 비어 있으므로, 임시 캐노니컬 도메인은 `https://mentalvibe.web.app/`로 고정합니다.
- `www`/apex 리디렉션 전략은 실제 도메인 구매 후 적용합니다.

## ACTION REQUIRED: 도메인 구매
아래 후보 중 1개를 구매한 뒤 `PRIMARY_DOMAIN`으로 설정하세요.

| 후보 | 브랜드 적합도 | ko/en 가독성 | 오타 위험 | 길이 |
|---|---|---|---|---|
| mindcheck.app | 높음 | 높음 | 낮음 | 짧음 |
| mindcheck.kr | 높음 | 높음 | 낮음 | 짧음 |
| mindcheckhealth.com | 중간 | 높음 | 중간 | 김 |
| vibemind.app | 중간 | 중간 | 중간 | 짧음 |
| mentalvibe.app | 높음 | 중간 | 중간 | 중간 |
| safemindcheck.com | 중간 | 중간 | 중간 | 김 |
| screeningmind.com | 중간 | 중간 | 중간 | 중간 |
| mindscreen.app | 높음 | 중간 | 중간 | 짧음 |
| moodscreening.app | 중간 | 중간 | 중간 | 중간 |
| checkmind.co | 중간 | 중간 | 높음 | 짧음 |

## 도메인 연결 후 목표 정책
1. HTTPS only
2. 단일 canonical host (apex 또는 www 중 1개)
3. non-canonical host는 301 리디렉션
4. 캐노니컬/OG URL/사이트맵 URL을 커스텀 도메인으로 일괄 치환

## Firebase Console 클릭 순서 (도메인 구매 후)
1. Firebase Console > Hosting > `Add custom domain`
2. 도메인 입력 (예: `mindcheck.app`)
3. DNS 레코드 발급값 확인
4. 도메인 구매처 DNS 관리 화면에서 레코드 등록
5. Firebase에서 SSL 발급 완료 대기
6. `mindcheck.app` 및 `www.mindcheck.app` 접속/리디렉션 확인

## 검증 명령어
```bash
curl -I https://mentalvibe.web.app/
# 도메인 연결 후
curl -I https://<PRIMARY_DOMAIN>/
curl -I https://www.<PRIMARY_DOMAIN>/
```
