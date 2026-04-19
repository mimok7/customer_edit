"use client";
import React, { useState } from 'react';
import Image from 'next/image';
import { useRouter } from 'next/navigation';
import supabase from '@/lib/supabase';
import { upsertUserProfile } from '@/lib/userUtils';
import { clearCachedUser, setCachedUser } from '@/lib/authCache';

async function waitForSessionUser(userId: string, timeoutMs = 7000): Promise<boolean> {
  const started = Date.now();
  while (Date.now() - started < timeoutMs) {
    const { data } = await supabase.auth.getSession();
    if (data?.session?.user?.id === userId) return true;
    await new Promise(resolve => setTimeout(resolve, 250));
  }
  return false;
}

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    if (loading) return;
    setLoading(true);

    try {
      const { data, error } = await supabase.auth.signInWithPassword({ email, password });

      if (error) {
        // 계정이 없는 경우 회원가입 페이지로 이동
        if (error.message.includes('Invalid login credentials') ||
          error.message.includes('Email not confirmed') ||
          error.message.includes('User not found')) {
          alert('계정이 존재하지 않습니다. 회원가입 페이지로 이동합니다.');
          router.push('/signup');
          return;
        }

        // 다른 오류는 기존 방식으로 처리
        alert('❌ 로그인 실패: ' + error.message);
        setLoading(false);
        return;
      }

      const user = data.user;
      if (!user) {
        alert('로그인에 실패했습니다.');
        setLoading(false);
        return;
      }

      console.log('✅ 로그인 성공:', user.id, user.email);

      // 세션 지연 시 /mypage에서 다시 로그인 루프가 생길 수 있어 세션 동기화 완료를 먼저 보장
      const sessionReady = await waitForSessionUser(user.id);
      if (!sessionReady) {
        clearCachedUser();
        alert('세션 동기화가 지연되고 있습니다. 잠시 후 다시 로그인해 주세요.');
        return;
      }

      // 프로필 확인하여 적절한 페이지로 리디렉션
      const { data: profile } = await supabase
        .from('users')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

      // 세션 캐시 저장
      setCachedUser(user);

      // 프로필이 없으면 백그라운드에서 생성
      if (!profile) {
        console.log('ℹ️  프로필 없음, 백그라운드에서 생성');
        upsertUserProfile(user.id, user.email || '', {
          name: user.user_metadata?.display_name || user.email?.split('@')[0] || '사용자',
          role: 'guest',
        }).catch(err => console.error('프로필 생성 오류:', err));
      }

      // 바로 mypage로 이동
      router.replace('/mypage');

    } catch (error) {
      console.error('로그인 처리 오류:', error);
      alert('로그인 처리 중 오류가 발생했습니다.');
    } finally {
      // 어떤 분기든 버튼 잠금 해제 보장
      setLoading(false);
    }
  };

  const performSiteDataClear = async () => {
    try {
      await fetch('/api/clear-site-data', { method: 'POST', cache: 'no-store' });
      clearCachedUser();
      try { await supabase.auth.signOut({ scope: 'local' }); } catch { }
      try { localStorage.clear(); } catch { }
      try { sessionStorage.clear(); } catch { }

      // IndexedDB/Cache/ServiceWorker 정리
      try {
        if ('indexedDB' in window && indexedDB.databases) {
          const dbs = await indexedDB.databases();
          await Promise.all((dbs || []).map((db) => {
            if (!db.name) return Promise.resolve();
            return new Promise<void>((resolve) => {
              const req = indexedDB.deleteDatabase(db.name as string);
              req.onsuccess = () => resolve();
              req.onerror = () => resolve();
              req.onblocked = () => resolve();
            });
          }));
        }
      } catch { }
      try {
        if ('caches' in window) {
          const keys = await caches.keys();
          await Promise.all(keys.map((k) => caches.delete(k)));
        }
      } catch { }
      try {
        if ('serviceWorker' in navigator) {
          const regs = await navigator.serviceWorker.getRegistrations();
          await Promise.all(regs.map((reg) => reg.unregister()));
        }
      } catch { }

      alert('초기화가 완료되었습니다. 페이지를 다시 로드합니다.');
      window.location.href = '/';
    } catch (err) {
      console.error('사이트 데이터 초기화 오류:', err);
      alert('초기화 중 오류가 발생했습니다. 다시 시도해주세요.');
    }
  };

  const handleClearSiteData = async () => {
    const ok = window.confirm(
      'stayhalong 관련 쿠키/세션/저장소를 초기화합니다.\n진행하시겠습니까?'
    );
    if (!ok) return;

    await performSiteDataClear();
  };

  return (
    <div className="max-w-sm mx-auto mt-12 p-4 bg-white shadow rounded">
      <div className="flex justify-start mb-4">
        <Image src="/logo-full.png" alt="스테이하롱 전체 로고" width={320} height={80} unoptimized />
      </div>
      <h2 className="text-2xl font-bold mb-6 text-left">🔐 예약 신청/확인</h2>
      <form onSubmit={handleLogin} className="space-y-4">
        <input
          type="email"
          placeholder="이메일"
          className="w-full border p-2 rounded"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />
        <p className="text-sm text-gray-500 mt-1">
          견적 신청시 입력하신 이메일과 비밀번호를 입력해주세요.
        </p>
        <input
          type="password"
          placeholder="비밀번호"
          className="w-full border p-2 rounded"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />
        <p className="text-sm text-gray-500 mt-1">비밀번호는 6자 이상 입력해주세요.</p>
        <button
          type="submit"
          className="bg-blue-500 text-white w-full py-2 rounded hover:bg-blue-600 transition disabled:opacity-50"
          disabled={loading}
        >
          {loading ? '처리 중...' : '예약 신청/확인'}
        </button>
      </form>

      <div className="mt-4 text-left">
        <p className="text-sm text-gray-600">
          계정이 없으신가요?{' '}
          <button
            onClick={() => router.push('/signup')}
            className="text-blue-500 hover:text-blue-700 underline"
          >
            신규예약
          </button>
        </p>
      </div>

      <div className="mt-6 pt-4 border-t border-gray-200">
        <button
          type="button"
          onClick={handleClearSiteData}
          className="w-full py-2 rounded bg-gray-100 text-gray-700 hover:bg-gray-200 transition text-sm"
        >
          stayhalong 데이터 초기화 (쿠키/세션/캐시)
        </button>
      </div>
    </div>
  );
}
