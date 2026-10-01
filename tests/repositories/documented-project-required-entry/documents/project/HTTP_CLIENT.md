# HTTP Client Policy

Durable policy for outbound HTTP calls made by this project.

## Timeout

- Request timeout: **8 seconds** per attempt. Do not raise it without an
  operations reason.

## Headers

- Send `Accept: application/json` on every request.
- Send `User-Agent: documented-project/<version>`.

## Base URLs

- `dev`: `http://localhost:8080`
- `prod`: configured via `APP_API_BASE` environment variable.
