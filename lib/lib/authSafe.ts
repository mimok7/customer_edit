import supabase from './supabase';

interface AuthUserSafeResult {
  user: any | null;
  error: Error | null;
  timedOut: boolean;
}

function createTimeoutError(timeoutMs: number): Error {
  return new Error(`AUTH_TIMEOUT_${timeoutMs}ms`);
}

async function withTimeout<T>(promise: Promise<T>, timeoutMs: number): Promise<T> {
  let timer: ReturnType<typeof setTimeout> | null = null;

  try {
    return await Promise.race<T>([
      promise,
      new Promise<T>((_, reject) => {
        timer = setTimeout(() => reject(createTimeoutError(timeoutMs)), timeoutMs);
      }),
    ]);
  } finally {
    if (timer) clearTimeout(timer);
  }
}

/**
 * Safe auth user fetch with timeout + retry.
 * Prevents indefinite loading when browser wakes after long idle.
 */
export async function getAuthUserSafe(options?: {
  timeoutMs?: number;
  retries?: number;
}): Promise<AuthUserSafeResult> {
  const timeoutMs = options?.timeoutMs ?? 8000;
  const retries = options?.retries ?? 1;

  for (let attempt = 0; attempt <= retries; attempt += 1) {
    try {
      const { data, error } = await withTimeout(supabase.auth.getUser(), timeoutMs);
      if (error) {
        return { user: null, error: error as Error, timedOut: false };
      }
      return { user: data?.user ?? null, error: null, timedOut: false };
    } catch (err: any) {
      const message = err?.message || '';
      const isTimeout = typeof message === 'string' && message.startsWith('AUTH_TIMEOUT_');

      if (!isTimeout) {
        return { user: null, error: err as Error, timedOut: false };
      }

      if (attempt === retries) {
        return { user: null, error: err as Error, timedOut: true };
      }
    }
  }

  return { user: null, error: createTimeoutError(timeoutMs), timedOut: true };
}
