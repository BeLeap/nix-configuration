`config/recipe/onedrive/default.nix`의 현재 설정은 Home Manager `programs.rclone.remotes.onedrive` 선언과 mount 정의까지만 포함한다.

- 실제 OneDrive 인증은 `rclone`의 OneDrive remote 설정값으로 연결해야 한다.
- `rclone` 공식 문서 기준 초기 설정은 브라우저 OAuth를 통해 `token`을 발급받는 방식이다.
- 필요 시 `client_id`, `client_secret`, `drive_id`, `drive_type`도 같이 remote 설정에 포함한다.
- 이 저장소는 `agenix`를 이미 사용하므로, OneDrive 토큰도 평문 Nix 값 대신 secret 파일로 주입하는 패턴이 적합하다.
- `builtins.readFile`로 secret을 읽어 Nix store에 넣는 방식은 피하는 것이 좋다.
