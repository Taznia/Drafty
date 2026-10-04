import { env } from '../config/env.js';

export async function generateWithGemini(prompt) {
  if (!env.GEMINI_API_KEY) {
    const error = new Error('AI service is not configured.');
    error.statusCode = 503;
    error.code = 'AI_NOT_CONFIGURED';
    throw error;
  }

  const endpoint = `https://generativelanguage.googleapis.com/v1beta/models/${encodeURIComponent(env.GEMINI_MODEL)}:generateContent?key=${encodeURIComponent(env.GEMINI_API_KEY)}`;
  let response;
  for (let attempt = 1; attempt <= 2; attempt += 1) {
    response = await fetch(endpoint, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: { temperature: 0.4, maxOutputTokens: 1200 },
      }),
      signal: AbortSignal.timeout(30000),
    });

    if (response.ok || ![429, 503].includes(response.status) || attempt === 2) break;
    await new Promise((resolve) => setTimeout(resolve, 500 * attempt));
  }

  if (!response.ok) {
    const error = new Error('AI provider request failed.');
    error.statusCode = response.status === 429 ? 429 : response.status === 503 ? 503 : 502;
    error.code = response.status === 429 ? 'AI_RATE_LIMITED' : response.status === 503 ? 'AI_UNAVAILABLE' : 'AI_PROVIDER_ERROR';
    throw error;
  }

  const payload = await response.json();
  const text = payload.candidates?.[0]?.content?.parts?.map((part) => part.text ?? '').join('').trim();

  if (!text) {
    const error = new Error('AI provider returned no usable content.');
    error.statusCode = 502;
    error.code = 'AI_EMPTY_RESPONSE';
    throw error;
  }

  return text;
}