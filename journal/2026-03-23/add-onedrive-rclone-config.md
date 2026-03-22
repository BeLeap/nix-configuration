`config/recipe/onedrive/default.nix`에 Home Manager `programs.rclone` 설정을 추가했다.

- `rclone`을 활성화했다.
- `onedrive`라는 이름의 remote를 선언했다.
- remote의 기본 backend 타입은 `onedrive`로 설정했다.

현재 추가한 범위는 remote 선언까지다. 실제 사용을 위해서는 OneDrive 인증 정보(`token`, 필요 시 `drive_id`, `drive_type`, `client_id`, `client_secret`)를 후속으로 연결해야 한다.
