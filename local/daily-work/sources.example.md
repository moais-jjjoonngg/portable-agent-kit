# 업무 기록 수집 대상

복사해서 사용: `cp local/daily-work/sources.example.md local/daily-work/sources.md`.
원격 주소는 저장소 식별에만 쓰며 자격 증명은 적지 않는다. 기기별 절대 경로는 `local/daily-work/paths.local.json`(git 제외)에 둔다.

- auto_commit: false   # true면 저녁 정리 후 기록 파일만 커밋·push

## 작업 저장소 (필수)

| 이름 | 원격 식별자 | 수집 범위 |
| --- | --- | --- |
| my-app | https://github.com/<owner>/my-app.git | 커밋·진행 상황·PR·검증 결과·지침/스킬 변경 |

## 이슈 트래커 (선택)

- 종류: 없음 / Jira / Linear / GitHub Issues
- 접근 방법: 연결된 MCP 또는 CLI 이름
- 범위: 담당·상태 변경·댓글·작업 로그, 로컬 작업에서 발견한 티켓 키

## 캘린더 (선택)

- 종류: 없음 / Google Calendar 등
- 접근 방법: 연결된 MCP 이름
- 범위: 기본 캘린더와 관련 공유 캘린더. 공유 일정이라고 모두 개인 참석으로 보지 않는다.

## 작업공간 도구 (선택)

- worktree 관리자 등 관련 worktree를 찾는 데 쓰는 도구와 사용할 스킬 이름

## 기타 규칙

- 저장소별로 추가로 지킬 규칙(예: 커밋 메시지 규칙 확인 위치)
