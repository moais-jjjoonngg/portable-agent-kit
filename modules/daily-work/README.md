# daily-work 모듈 (선택)

여러 기기를 오가며 일할 때 하루 업무를 근거 기반으로 기록하고, 다음 기기에서 이어서 작업할 수 있도록 인수인계를 남기는 선택 모듈이다.

| 스킬 | 언제 | 하는 일 |
| --- | --- | --- |
| `daily-work-resume` | 아침, 기기 이동 직후 | 최근 인수인계를 읽고 저장소를 안전하게 동기화한 뒤, 오늘 일정과 우선 작업을 `resume.md`에 기록 |
| `daily-work-record` | 저녁, 중간 정리 | Git(필수)과 이슈 트래커·캘린더(선택)를 근거로 `daily.md`와 `handoff.md`를 작성 |

## 켜기

1. 개인 private 인스턴스에서 수집 대상을 정한다.
   ```bash
   cp local/daily-work/sources.example.md local/daily-work/sources.md
   ```
2. 스킬을 등록한다. `.agents/skills/`에 모듈 스킬 링크가 생기고, Claude는 `.claude/skills`를 통해 함께 인식한다.
   ```bash
   scripts/link-skills.sh --module daily-work
   ```
3. 기록 저장소에서 에이전트에게 `시작`(아침) 또는 `정리`(저녁)라고만 입력한다. "업무 시작하자", "오늘 업무 정리하자"처럼 풀어서 요청해도 된다.

## 기록 구조

```
records/YYYY-MM-DD/
  resume.md    # 아침 시작 기록 (추가만)
  daily.md     # 업무·시간·결과·회의·이슈·지침 변경
  handoff.md   # 다음 기기에서 재개할 상태
  instructions.sha256   # Git 밖 지침·스킬의 해시 기준선 (내용은 저장하지 않음)
```

형식은 `templates/`를 따른다. 날짜 경계와 시간대는 `local/profile.md`를 따른다.

## 원칙

- 근거 없는 업무, 소요시간, 참석, 완료를 만들지 않는다. 확인/추정/미확인을 구분하고 누락된 소스를 적는다.
- 원본 코드, API 응답, 대화를 복사하지 않는다. URL, 전체 커밋 SHA, 상대 경로로 연결한다.
- 기록은 코드 백업이 아니다. 미커밋·미push 변경은 요약만으로 복원할 수 없다.
- 이슈 트래커와 캘린더는 읽기만 한다. 작업 대상 저장소를 커밋·push하지 않는다.
- 업무 기록에는 개인 일정과 업무 정보가 들어가므로 **기록 저장소는 반드시 private**으로 둔다.
