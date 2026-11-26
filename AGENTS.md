# portable-agent-kit

여러 기기와 AI 에이전트(Claude Code, Codex, Gemini CLI)를 오가며 같은 AI 작업 환경을 유지하기 위한 키트다. 이 파일이 모든 에이전트의 단일 지침 원천이다.

## 구조

- `core/`: 키트가 소유하는 원칙·어댑터·manifest 명세. 사용자 인스턴스에서는 수정하지 않고 upstream 업데이트로 받는다.
- `local/`: 사용자 소유 영역. 개인 프로필, 전역 지침, 개인 스킬, 환경 manifest(`environment.yaml`)를 둔다. 공개 키트에는 `*.example.*`만 있다.
- `.agents/skills/`: 키트 스킬 원본. Codex·Gemini는 직접 읽고, Claude는 `.claude/skills` 링크로 읽는다.
- `scripts/`: 스킬 링크 생성(`link-skills.sh`)과 유출 검사(`check-leaks.sh`).
- `modules/`: 선택 모듈. `scripts/link-skills.sh --module <이름>`으로 켠 모듈의 스킬만 `.agents/skills/`에 링크된다. 켠 모듈은 `modules/<이름>/README.md`를 따른다.
- `records/`: daily-work 모듈을 켠 개인 인스턴스의 날짜별 업무 기록. 짧은 명령은 위의 표를 따른다.

## 짧은 명령

사용자가 아래처럼 입력하면 추가 설명을 요구하지 않고 해당 절차를 시작한다. URL이 함께 오면 그 저장소부터 준비한다.

| 입력 | 절차 |
| --- | --- |
| `<git URL> 셋팅 시작`, `셋팅 시작` | `.agents/skills/agent-setup/SKILL.md`: 처음 등록(개인 private 저장소 생성, 설정 수집, push) |
| `<git URL> 시작`, `시작` | `.agents/skills/env-apply/SKILL.md`로 설정을 동기화한다. daily-work 모듈이 켜져 있으면(`.agents/skills/daily-work-resume` 존재) 이어서 `daily-work-resume`을 실행한다. |
| `정리` | daily-work 모듈이 켜져 있으면 `daily-work-record`를 실행한다. |

## 스킬

- 처음 등록: `.agents/skills/agent-setup/SKILL.md`
- 기존 기기의 설정을 기록: `.agents/skills/env-capture/SKILL.md`
- 새 기기에 설정을 적용: `.agents/skills/env-apply/SKILL.md`
- 현재 상태 점검(읽기 전용): `.agents/skills/env-doctor/SKILL.md`

## 규칙

- 먼저 `core/principles.md`를 읽고 따른다. 에이전트별 경로와 명령은 `core/adapters/`를 기준으로 한다.
- 사용자 설정 파일(`~/.claude*`, `~/.codex/`, `~/.gemini/`, `~/.agents/`)은 변경 계획과 diff를 보여주고 승인받은 뒤에만 쓴다. 쓰기 전에 백업을 남긴다.
- 비밀값(토큰, API 키, 헤더 값, 비밀번호)은 저장소에 쓰지 않는다. 환경변수 이름만 기록한다.
- `local/profile.md`가 있으면 응답 언어·시간대·커밋 규칙 등 개인 정책을 그 파일에서 따른다. 없으면 한국어로 응답한다.
- 공개 저장소에 커밋하기 전 `scripts/check-leaks.sh`를 실행한다.
