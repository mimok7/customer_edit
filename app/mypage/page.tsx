'use client';
import React, { useState, useEffect, useCallback, useMemo } from 'react';
import { useRouter } from 'next/navigation';
import PageWrapper from '../../components/PageWrapper';
import SectionBox from '../../components/SectionBox';
import Link from 'next/link';
import supabase from '@/lib/supabase';
import { clearCachedUser } from '@/lib/authCache';
import { clearAuthCache } from '@/hooks/useAuth';
import { clearInvalidSession, isInvalidRefreshTokenError } from '@/lib/authRecovery';
import { useLoadingTimeout } from '@/hooks/useLoadingTimeout';
import { getAuthUserSafe } from '@/lib/authSafe';

export default function MyPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [userProfile, setUserProfile] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  // 안전 타임아웃: 10초 이상 로딩 중이면 강제 해제
  useLoadingTimeout(loading, setLoading, 10000);

  useEffect(() => {
    let mounted = true;

    const loadUserInfo = async () => {
      try {
        setLoading(true);

        const { user, error: userError, timedOut } = await getAuthUserSafe({ timeoutMs: 8000, retries: 1 });

        if (!mounted) return;

        if (timedOut) {
          alert('세션 확인이 지연되었습니다. 다시 로그인해 주세요.');
          router.push('/login');
          return;
        }

        if (userError || !user) {
          if (userError && isInvalidRefreshTokenError(userError)) {
            await clearInvalidSession();
          }
          console.warn('⚠️ 로그인되지 않음, /login으로 리디렉션');
          router.push('/login');
          return;
        }

        // 사용자 프로필 정보 조회 (최소 필드만)
        const { data: profile } = await supabase
          .from('users')
          .select('name')
          .eq('id', user.id)
          .maybeSingle();

        if (!mounted) return;

        setUser(user);
        setUserProfile(profile);

      } catch (error) {
        if (isInvalidRefreshTokenError(error)) {
          await clearInvalidSession();
          if (mounted) router.push('/login');
          return;
        }
        console.error('사용자 정보 로드 실패:', error);
      } finally {
        if (mounted) setLoading(false);
      }
    };

    loadUserInfo();

    return () => { mounted = false; };
  }, []); // ✅ [] 의존성 - 최초 1회만 (router 의존성 금지)

  const getSessionUser = useCallback(async () => {
    const { data, error } = await supabase.auth.getUser();
    return { user: data?.user || null, error };
  }, []);

  const handleCompleteNotification = useCallback(() => {
    // 알림 기능이 제거되었습니다
  }, []);

  const getUserDisplayName = useCallback(() => {
    if (userProfile?.name) return userProfile.name;
    if (user?.email) {
      return user.email.split('@')[0];
    }
    return '고객';
  }, [userProfile, user]);

  const handleLogout = useCallback(async () => {
    try {
      clearCachedUser();
      clearAuthCache();
      const { error } = await supabase.auth.signOut();
      if (error) {
        console.error('로그아웃 오류:', error);
        alert('로그아웃 중 오류가 발생했습니다.');
        return;
      }
      alert('로그아웃되었습니다.');
      router.push('/login');
    } catch (error) {
      console.error('로그아웃 처리 실패:', error);
      alert('로그아웃 처리에 실패했습니다.');
    }
  }, [router]);

  const quickActions = useMemo(() => [
    { icon: '🎯', label: '예약하기', href: '/mypage/direct-booking' },
    { icon: '📋', label: '예약내역', href: '/mypage/reservations/list' },
    { icon: '📍', label: '장소 추가', href: '/mypage/location-updates' },
    { icon: '📄', label: '예약확인서', href: '/mypage/confirmations' },
    { icon: '👤', label: '내 정보', href: '/mypage/profile' },
  ], []);

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <PageWrapper title={`🌟 ${getUserDisplayName()}님 즐거운 하루 되세요 ^^`}>
      <div className="mb-6 flex justify-end items-center gap-3">
        <button
          onClick={handleLogout}
          className="flex items-center gap-2 px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors text-sm font-medium shadow-sm"
        >
          🚪 로그아웃
        </button>
      </div>

      {/* 알림 기능 숨김 */}

      <SectionBox title="원하는 서비스를 선택하세요">
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          {quickActions.map((action, index) => {
            return (
              <Link key={index} href={action.href} className="group">
                <div className="bg-white border border-gray-200 rounded-lg p-6 text-center hover:border-blue-500 hover:shadow-md transition-all duration-200">
                  <div className="text-4xl mb-3 transform group-hover:scale-110 transition-transform duration-200">
                    {action.icon}
                  </div>
                  <div className="text-sm font-medium text-gray-900 group-hover:text-blue-600 transition-colors">
                    {action.label}
                  </div>
                </div>
              </Link>
            );
          })}
        </div>
      </SectionBox>
    </PageWrapper>
  );
}
