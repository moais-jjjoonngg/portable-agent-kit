# local/ — 사용자 소유 영역

키트 업데이트(upstream)는 이 디렉터리의 예시 파일(`*.example.*`, `README.md`, `.gitignore`)만 바꾼다.

| 파일 | 용도 |
| --- | --- |
| `profile.md` | 언어·시간대·커밋 규칙 등 개인 정책 |
| `instructions/global.md` | 모든 에이전트에 연결할 전역 지침 원본 |
| `skills/<이름>/SKILL.md` | 기기 간 옮길 개인 스킬 원본 |
| `environment.yaml` | 환경 manifest (`core/manifest.md`) |

공개 키트에서는 `local/.gitignore`가 실제 파일을 제외하고 `*.example.*`만 추적한다.
**개인 인스턴스는 private 저장소로 만들고 `local/.gitignore`를 삭제**해야 설정이 기기 간에 동기화된다.
