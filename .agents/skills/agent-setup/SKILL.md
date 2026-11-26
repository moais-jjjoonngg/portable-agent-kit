---
name: agent-setup
description: portable-agent-kit을 처음 등록할 때 사용한다. 사용자가 키트 git URL과 함께 "셋팅 시작"이라고 하거나 키트 저장소에서 "셋팅 시작"만 입력하면, 키트를 clone해 개인 private 저장소를 만들고 현재 기기의 AI 설정을 수집해 push한다. 처음 설정 등록, 내 환경 저장소 만들기 요청에 사용한다.
---

# 셋팅 시작 (agent-setup)

사용자 입력은 `<git URL> 셋팅 시작` 또는 `셋팅 시작`이다. 질문은 꼭 필요한 것만 한 번에 모아서 하고, 나머지는 기본값으로 진행한다. 외부에 영향을 주는 단계(저장소 생성, push, 사용자 설정 변경)는 실행 직전에 한 번에 묶어 승인을 받는다.

## 1. 저장소 준비

- 현재 디렉터리가 키트 저장소(루트에 `AGENTS.md`, `core/`, `.agents/skills/agent-setup/` 존재)이면 그대로 쓴다.
- 아니면 URL을 `~/<저장소 이름>`에 clone한다. 그 경로가 이미 있으면, 같은 remote의 clone일 때만 재사용하고 아니면 다른 경로를 묻는다. clone한 뒤에는 그 저장소의 `AGENTS.md`와 이 스킬을 다시 읽고 이어서 진행한다.
- URL이 이미 사용자의 개인 인스턴스(`local/.gitignore`가 없음)라면 등록이 끝난 상태다. 이 기기에 설정을 적용하는 `시작` 흐름(`env-apply`)으로 넘어간다.

## 2. 한 번에 확인할 것

아래를 한 메시지로 묻고, 답이 없으면 괄호 안 기본값을 쓴다.

1. 개인 private 저장소 이름 (`agent-env`)
2. 응답 언어와 시간대 (한국어, 시스템 시간대)
3. daily-work 모듈(일일 업무 기록) 사용 여부 (사용 안 함)

`gh auth status`로 GitHub CLI 로그인을 확인한다. `gh`가 없거나 로그인되지 않았으면 웹에서 빈 private 저장소를 만들어 URL을 알려 달라고 안내한다.

## 3. 개인 인스턴스 만들기

1. `git remote rename origin upstream`을 실행한다. 히스토리를 유지해야 키트 업데이트를 받을 수 있다.
2. `local/.gitignore`를 삭제하고, 답변으로 `local/profile.md`를 만든다(`local/profile.example.md` 형식).
3. daily-work 모듈을 쓰면 `scripts/link-skills.sh --module daily-work`를 실행하고, `local/daily-work/sources.example.md`를 `sources.md`로 복사한다. 작업 저장소 목록은 사용자에게 받아 채운다.

## 4. 설정 수집

`env-capture` 절차로 `local/environment.yaml`을 만든다. 전역 지침과 개인 스킬을 `local/`로 가져올지는 수집 결과를 보여주면서 한 번에 묻는다. 비밀값은 기록하지 않는다.

## 5. 저장과 마무리

아래를 한 번에 보여주고 승인을 받는다.

- 만들 private 저장소 이름
- 커밋할 파일 목록
- 커밋 메시지

승인되면 다음을 실행한다.

```bash
gh repo create <이름> --private --source . --remote origin --push
```

push 전에 저장소가 private인지 확인한다.

마지막으로 다른 기기에서 쓸 한 줄을 알려준다.

> 다른 기기에서는 에이전트에게 `<개인 저장소 URL> 시작`이라고 입력하세요.
