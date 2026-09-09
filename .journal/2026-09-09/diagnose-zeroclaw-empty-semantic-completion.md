# Diagnose ZeroClaw empty semantic completions

## Outcome

- Confirmed the failure is a provider-request/protocol mismatch, not an Ollama connectivity or model-loading failure.
- ZeroClaw 0.8.5 is using Ollama through the OpenAI-compatible `/v1/chat/completions` path. The Qwen 3.5 model defaults to thinking there, but the request did not carry an Ollama-compatible thinking-disable control.
- With a long, tool-heavy Discord turn, Qwen spent a completion on reasoning and returned no visible `content` and no native tool calls. ZeroClaw correctly classified that as a semantic empty completion and retried it three times.

## Evidence

- `/Users/beleap/.zeroclaw/data/state/runtime-trace.jsonl`: iterations 1–9 returned one native tool call each; iteration 10 produced three `empty_response` failures. The final successful tool iteration had about 24,982 input tokens and 66 messages.
- The v0.8.5 provider factory routes the typed Ollama profile through `OpenAiCompatibleModelProvider` and normalizes the endpoint to `/v1`; the legacy `/api/chat` Ollama tuning path is not selected by this factory. Consequently the configured `think = false` and Ollama `num_predict` fields do not control this custom/compat request.
- A local capture proxy observed ZeroClaw requests containing `stream = false`, 50 tools, and no `think`, `enable_thinking`, or `reasoning_effort` field.
- Direct Ollama 0.32.13 probes with `qwen3.5:4b` and `max_tokens = 64` returned `finish_reason = "length"`, empty `content`, and a populated `reasoning` field when the request omitted `reasoning_effort`. Top-level `think = false`, `enable_thinking = false`, and `chat_template_kwargs.enable_thinking = false` did not change that `/v1` result.
- The same request with `reasoning_effort = "none"` returned `content = "OK"`, `finish_reason = "stop"`, and two completion tokens. A native-tool probe also returned a valid calculator tool call.
- A temporary ZeroClaw config using `provider_extra = { reasoning_effort = "none" }` reproduced both a successful one-shot answer and a calculator tool call plus follow-up through the captured `/v1` path.

## Change

- Added `provider_extra = { reasoning_effort = "none" }` to `config/recipe/zeroclaw/zeroclaw-config.toml`, preserving the existing `think = false` intent while supplying the control Ollama's OpenAI-compatible endpoint actually honors.
- No system activation or daemon restart was performed. The live daemon remains on the old generated configuration until activation.

## Validation

- Generated-template substitution was parsed successfully with Python `tomllib`.
- `nix build .#darwinConfigurations.beleap-macmini.system --no-link` passed.
- Temporary proxy-based ZeroClaw smoke tests passed for plain output and native calculator tool use.

## Limitation

- The new `provider_extra` is Ollama/Qwen-specific. If `beleap.services.zeroclaw.providerUrl` is changed to a strict non-Ollama endpoint, remove or conditionalize this extra field before activation.
