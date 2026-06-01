<template>
  <div class="app-layout">
    <aside class="sidebar">
      <div class="sidebar-logo">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
          <rect width="24" height="24" rx="6" fill="#5e6ad2"/>
          <path d="M7 12L10.5 15.5L17 9" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        <span class="sidebar-logo-text">档案管理</span>
      </div>

      <nav class="sidebar-nav">
        <!-- 管理员菜单（默认兜底） -->
        <template v-if="userStore.isAdmin || (!userStore.isTeacher && !userStore.isStudent)">
          <div class="nav-section">
            <div class="nav-section-label">概览</div>
            <router-link to="/dashboard" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
              <span>仪表盘</span>
            </router-link>
          </div>
          <div class="nav-section">
            <div class="nav-section-label">学生</div>
            <router-link to="/students" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
              <span>学生管理</span>
            </router-link>
            <router-link to="/archives" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
              <span>档案管理</span>
            </router-link>
            <router-link to="/export-audit" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
              <span>导出审核</span>
            </router-link>
          </div>
          <div class="nav-section">
            <div class="nav-section-label">组织架构</div>
            <router-link to="/colleges" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
              <span>学院管理</span>
            </router-link>
            <router-link to="/majors" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
              <span>专业管理</span>
            </router-link>
            <router-link to="/classes" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
              <span>班级管理</span>
            </router-link>
          </div>
          <div class="nav-section">
            <div class="nav-section-label">系统</div>
            <router-link to="/users" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
              <span>用户管理</span>
            </router-link>
            <router-link to="/roles" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
              <span>角色管理</span>
            </router-link>
            <router-link to="/notifications" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
              <span>通知中心</span>
            </router-link>
            <router-link to="/notification-send" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
              <span>发布通知</span>
            </router-link>
            <router-link to="/operation-logs" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><line x1="10" y1="9" x2="8" y2="9"/></svg>
              <span>操作日志</span>
            </router-link>
            <router-link to="/archive-transfer" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>
              <span>档案去向</span>
            </router-link>
          </div>
        </template>

        <!-- 教师/辅导员菜单 -->
        <template v-else-if="userStore.isTeacher">
          <div class="nav-section">
            <div class="nav-section-label">工作台</div>
            <router-link to="/teacher/dashboard" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
              <span>工作台</span>
            </router-link>
          </div>
          <div class="nav-section">
            <div class="nav-section-label">管理</div>
            <router-link to="/teacher/students" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
              <span>学生管理</span>
            </router-link>
            <router-link to="/teacher/archives" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
              <span>档案审核</span>
            </router-link>
            <router-link to="/teacher/grades" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
              <span>成绩导入</span>
            </router-link>
            <router-link to="/teacher/awards" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="7"/><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"/></svg>
              <span>奖惩导入</span>
            </router-link>
            <router-link to="/teacher/export-audit" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
              <span>导出审核</span>
            </router-link>
            <router-link to="/teacher/archive-transfer" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>
              <span>档案去向</span>
            </router-link>
          </div>
          <div class="nav-section">
            <div class="nav-section-label">消息</div>
            <router-link to="/teacher/notification-send" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
              <span>发布通知</span>
            </router-link>
            <router-link to="/teacher/notifications" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
              <span>通知中心</span>
            </router-link>
          </div>
        </template>

        <!-- 学生菜单 -->
        <template v-else-if="userStore.isStudent">
          <div class="nav-section">
            <div class="nav-section-label">个人</div>
            <router-link to="/student/dashboard" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
              <span>我的主页</span>
            </router-link>
            <router-link to="/student/profile" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
              <span>个人信息</span>
            </router-link>
            <router-link to="/student/family" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
              <span>家庭信息</span>
            </router-link>
          </div>
          <div class="nav-section">
            <div class="nav-section-label">学业</div>
            <router-link to="/student/grades" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
              <span>成绩档案</span>
            </router-link>
            <router-link to="/student/awards" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="8" r="7"/><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"/></svg>
              <span>奖惩档案</span>
            </router-link>
            <router-link to="/student/transcript" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
              <span>成绩单</span>
            </router-link>
          </div>
          <div class="nav-section">
            <div class="nav-section-label">档案</div>
            <router-link to="/student/archive-apply" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="18" x2="12" y2="12"/><line x1="9" y1="15" x2="15" y2="15"/></svg>
              <span>档案申请</span>
            </router-link>
            <router-link to="/student/archive-upload" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
              <span>材料上传</span>
            </router-link>
            <router-link to="/student/archive-history" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
              <span>档案申请记录</span>
            </router-link>
            <router-link to="/student/export" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
              <span>档案导出</span>
            </router-link>
            <router-link to="/student/transfer" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>
              <span>调档函申请</span>
            </router-link>
          </div>
          <div class="nav-section">
            <div class="nav-section-label">消息</div>
            <router-link to="/student/notifications" class="nav-item" active-class="nav-item-active">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
              <span>通知中心</span>
            </router-link>
          </div>
        </template>
      </nav>

      <div class="sidebar-footer">
        <div class="user-info" v-if="userStore.userInfo">
          <div class="user-avatar">{{ userStore.userInfo.realName?.charAt(0) }}</div>
          <div class="user-detail">
            <span class="user-name">{{ userStore.userInfo.realName }}</span>
            <span class="user-account">{{ roleLabel }}</span>
          </div>
        </div>
        <button class="nav-item" @click="handleLogout">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
          <span>退出登录</span>
        </button>
      </div>
    </aside>

    <div class="main-area">
      <header class="app-header">
        <h1 class="page-title">{{ pageTitle }}</h1>
      </header>
      <main class="main-content">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '../stores/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const pageTitle = computed(() => (route.meta.title as string) || '仪表盘')

const roleLabel = computed(() => {
  if (userStore.isStudent) return '学生'
  if (userStore.isTeacher) return '教师'
  return '管理员'
})

function handleLogout() {
  userStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.app-layout {
  display: flex;
  min-height: 100vh;
}

/* ===== Sidebar ===== */
.sidebar {
  width: var(--sidebar-width);
  background: var(--bg-panel);
  border-right: 1px solid var(--border-subtle);
  display: flex;
  flex-direction: column;
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  z-index: 100;
  overflow-y: auto;
}

.sidebar-logo {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 16px 20px;
  border-bottom: 1px solid var(--border-subtle);
}

.sidebar-logo-text {
  font-size: 15px;
  font-weight: 590;
  color: var(--text-primary);
  letter-spacing: -0.165px;
}

.sidebar-nav {
  flex: 1;
  padding: 8px 12px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.nav-section {
  margin-bottom: 4px;
}

.nav-section-label {
  font-size: 11px;
  font-weight: 510;
  color: var(--text-quaternary);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  padding: 12px 8px 4px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 7px 8px;
  border-radius: var(--radius-md);
  font-size: 13px;
  font-weight: 510;
  color: var(--text-secondary);
  transition: all 0.15s ease;
  cursor: pointer;
  text-decoration: none;
  width: 100%;
  border: none;
  background: none;
  text-align: left;
}
.nav-item:hover {
  background: var(--surface-05);
  color: var(--text-primary);
}

.nav-item-active {
  background: var(--surface-05) !important;
  color: var(--text-primary) !important;
}

.sidebar-footer {
  padding: 8px 12px;
  border-top: 1px solid var(--border-subtle);
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px;
  margin-bottom: 4px;
}

.user-avatar {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: var(--brand-indigo);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 590;
  flex-shrink: 0;
}

.user-detail {
  display: flex;
  flex-direction: column;
  min-width: 0;
}

.user-name {
  font-size: 13px;
  font-weight: 510;
  color: var(--text-primary);
  line-height: 1.2;
}

.user-account {
  font-size: 11px;
  color: var(--text-quaternary);
  line-height: 1.2;
}

/* ===== Main Area ===== */
.main-area {
  flex: 1;
  margin-left: var(--sidebar-width);
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.app-header {
  height: var(--header-height);
  display: flex;
  align-items: center;
  padding: 0 32px;
  border-bottom: 1px solid var(--border-subtle);
  background: var(--bg-base);
  position: sticky;
  top: 0;
  z-index: 50;
}

.page-title {
  font-size: 15px;
  font-weight: 590;
  color: var(--text-primary);
  letter-spacing: -0.165px;
}

.main-content {
  flex: 1;
  padding: 24px 32px;
}
</style>
