<template>
  <div class="page">
    <!-- Tab 切换 -->
    <div class="tab-bar">
      <button :class="['tab-btn', activeTab === 'notification' ? 'tab-active' : '']" @click="activeTab = 'notification'">通知消息</button>
      <button :class="['tab-btn', activeTab === 'history' ? 'tab-active' : '']" @click="activeTab = 'history'; if (logList.length === 0) loadLogs()">操作历史</button>
    </div>

    <!-- ===== 通知消息 Tab ===== -->
    <template v-if="activeTab === 'notification'">
      <div class="page-toolbar">
        <div class="flex gap-8">
          <select v-model="readFilter" class="form-select" style="width:140px;padding:7px 12px;font-size:13px" @change="loadNotices">
            <option value="">全部状态</option>
            <option :value="0">未读</option>
            <option :value="1">已读</option>
          </select>
        </div>
        <button class="btn btn-ghost btn-sm" @click="markAllRead">全部标为已读</button>
      </div>
      <div class="notification-list">
        <div v-for="item in noticeList" :key="item.pkNotification" :class="['notification-item', { unread: !item.isRead }]" @click="markRead(item)">
          <div class="notification-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
          </div>
          <div class="notification-body">
            <div class="notification-header">
              <span class="notification-title">{{ item.title || '系统通知' }}</span>
            </div>
            <p class="notification-content">{{ item.content }}</p>
            <span class="notification-time">{{ formatRelativeTime(item.createTime) }}</span>
          </div>
          <div v-if="!item.isRead" class="notification-dot"></div>
        </div>
        <div v-if="!noticeList.length && !noticeLoading" class="empty-state">
          <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="var(--text-quaternary)" stroke-width="1.5"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
          <p style="color:var(--text-quaternary);font-size:13px;margin-top:12px">暂无通知</p>
        </div>
      </div>
      <div class="pagination" v-if="noticeTotal > pageSize">
        <span class="text-caption">共 {{ noticeTotal }} 条</span>
        <div class="pagination-pages">
          <button class="pagination-btn" :disabled="noticePageNum <= 1" @click="noticePageNum--; loadNotices()">上一页</button>
          <span class="pagination-info">{{ noticePageNum }} / {{ noticeTotalPages }}</span>
          <button class="pagination-btn" :disabled="noticePageNum >= noticeTotalPages" @click="noticePageNum++; loadNotices()">下一页</button>
        </div>
      </div>
    </template>

    <!-- ===== 操作历史 Tab ===== -->
    <template v-if="activeTab === 'history'">
      <div class="page-toolbar">
        <div class="flex gap-8">
          <input v-model="logFilters.module" class="form-input" style="width:150px" placeholder="模块筛选" @keyup.enter="searchLogs" />
          <input v-model="logFilters.operation" class="form-input" style="width:150px" placeholder="操作类型" @keyup.enter="searchLogs" />
          <button class="btn btn-primary btn-sm" @click="searchLogs">搜索</button>
          <button class="btn btn-ghost btn-sm" @click="resetLogFilters">重置</button>
        </div>
      </div>

      <div class="table-wrap">
        <table class="table">
          <thead>
            <tr>
              <th style="width:60px">ID</th>
              <th style="width:100px">操作人</th>
              <th style="width:100px">模块</th>
              <th style="width:120px">操作类型</th>
              <th>描述</th>
              <th style="width:120px">IP</th>
              <th style="width:160px">时间</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in logList" :key="item.pkLog">
              <td>{{ item.pkLog }}</td>
              <td>{{ item.userName || item.userId || '-' }}</td>
              <td><span class="tag">{{ item.module || '-' }}</span></td>
              <td>{{ item.operation || '-' }}</td>
              <td class="text-ellipsis">{{ item.description || '-' }}</td>
              <td>{{ item.ip || '-' }}</td>
              <td>{{ formatDateTime(item.createTime) }}</td>
            </tr>
            <tr v-if="!logList.length && !logLoading">
              <td colspan="7" class="empty-cell">暂无操作记录</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="pagination" v-if="logTotal > logPageSize">
        <span class="text-caption">共 {{ logTotal }} 条</span>
        <div class="pagination-pages">
          <button class="pagination-btn" :disabled="logPageNum <= 1" @click="logPageNum--; loadLogs()">上一页</button>
          <span class="pagination-info">{{ logPageNum }} / {{ logTotalPages }}</span>
          <button class="pagination-btn" :disabled="logPageNum >= logTotalPages" @click="logPageNum++; loadLogs()">下一页</button>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, reactive } from 'vue'
import { notificationApi, operationLogApi } from '../api/modules'
import { useUserStore } from '../stores/user'

const userStore = useUserStore()
const activeTab = ref<'notification' | 'history'>('notification')

// ===== 通知 =====
const noticeList = ref<any[]>([])
const noticeTotal = ref(0)
const noticePageNum = ref(1)
const pageSize = ref(20)
const readFilter = ref('' as any)
const noticeLoading = ref(false)

const noticeTotalPages = computed(() => Math.ceil(noticeTotal.value / pageSize.value) || 1)

// ===== 操作历史 =====
const logList = ref<any[]>([])
const logTotal = ref(0)
const logPageNum = ref(1)
const logPageSize = ref(20)
const logLoading = ref(false)

const logFilters = reactive({
  module: '',
  operation: ''
})

const logTotalPages = computed(() => Math.ceil(logTotal.value / logPageSize.value) || 1)

function formatRelativeTime(dateStr: string) {
  if (!dateStr) return ''
  const d = new Date(dateStr)
  const now = new Date()
  const diff = now.getTime() - d.getTime()
  const mins = Math.floor(diff / 60000)
  if (mins < 1) return '刚刚'
  if (mins < 60) return `${mins}分钟前`
  const hours = Math.floor(mins / 60)
  if (hours < 24) return `${hours}小时前`
  const days = Math.floor(hours / 24)
  if (days < 30) return `${days}天前`
  return d.toLocaleDateString('zh-CN')
}

function formatDateTime(dateStr: string) {
  if (!dateStr) return ''
  const d = new Date(dateStr)
  return d.toLocaleString('zh-CN', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', second: '2-digit' })
}

// ===== 通知 =====
async function loadNotices() {
  noticeLoading.value = true
  try {
    const userId = userStore.userInfo?.userId
    if (!userId) return
    const params: any = { pageNum: noticePageNum.value, pageSize: pageSize.value, targetUserId: userId }
    if (readFilter.value !== '') params.isRead = readFilter.value
    const res: any = await notificationApi.getList(params)
    noticeList.value = res.data?.list || []
    noticeTotal.value = res.data?.total || 0
  } catch (e) { console.error('加载通知失败', e) }
  finally { noticeLoading.value = false }
}

async function markRead(item: any) {
  if (item.isRead) return
  try {
    await notificationApi.markAsRead(item.pkNotification)
    item.isRead = 1
  } catch (e) { /* ignore */ }
}

async function markAllRead() {
  const userId = userStore.userInfo?.userId
  if (!userId) return
  try {
    await notificationApi.markAllAsRead(userId)
    noticeList.value.forEach(i => i.isRead = 1)
  } catch (e: any) { alert(e.message || '操作失败') }
}

// ===== 操作历史 =====
async function loadLogs() {
  logLoading.value = true
  try {
    const params: any = { pageNum: logPageNum.value, pageSize: logPageSize.value }
    if (logFilters.module) params.module = logFilters.module
    if (logFilters.operation) params.operation = logFilters.operation
    // 非管理员只看自己的操作
    if (!userStore.isAdmin) {
      params.userId = userStore.userInfo?.userId
    }
    const res: any = await operationLogApi.getList(params)
    logList.value = res.data?.list || []
    logTotal.value = res.data?.total || 0
  } catch (e) {
    console.error('加载操作历史失败', e)
  } finally {
    logLoading.value = false
  }
}

function searchLogs() {
  logPageNum.value = 1
  loadLogs()
}

function resetLogFilters() {
  logFilters.module = ''
  logFilters.operation = ''
  logPageNum.value = 1
  loadLogs()
}

onMounted(loadNotices)
</script>

<style scoped>
.page { display: flex; flex-direction: column; gap: 16px; }

/* ===== Tab ===== */
.tab-bar { display: flex; gap: 0; border-bottom: 2px solid var(--border-subtle); margin-bottom: 4px; }
.tab-btn { padding: 10px 20px; font-size: 14px; font-weight: 510; border: none; background: none; color: var(--text-tertiary); cursor: pointer; border-bottom: 2px solid transparent; margin-bottom: -2px; transition: all 0.15s; }
.tab-btn:hover { color: var(--text-primary); }
.tab-active { color: var(--text-primary) !important; border-bottom-color: var(--brand-indigo) !important; }

/* ===== Toolbar ===== */
.page-toolbar { display: flex; justify-content: space-between; align-items: center; }

/* ===== 通知列表 ===== */
.notification-list { display: flex; flex-direction: column; gap: 1px; }
.notification-item {
  display: flex; align-items: flex-start; gap: 12px; padding: 16px;
  background: var(--bg-surface); border: 1px solid var(--border-subtle); border-radius: 8px;
  cursor: pointer; transition: background 0.15s;
}
.notification-item:hover { background: var(--bg-secondary); }
.notification-item.unread { background: rgba(94, 106, 210, 0.04); border-color: rgba(94, 106, 210, 0.12); }
.notification-icon { color: var(--text-tertiary); flex-shrink: 0; margin-top: 2px; }
.notification-item.unread .notification-icon { color: var(--accent-violet); }
.notification-body { flex: 1; min-width: 0; }
.notification-header { display: flex; align-items: center; gap: 8px; margin-bottom: 4px; }
.notification-title { font-size: 14px; font-weight: 510; color: var(--text-primary); }
.notification-content { font-size: 13px; color: var(--text-tertiary); line-height: 1.5; margin: 0; }
.notification-time { font-size: 12px; color: var(--text-quaternary); margin-top: 6px; display: inline-block; }
.notification-dot { width: 8px; height: 8px; border-radius: 50%; background: var(--accent-violet); flex-shrink: 0; margin-top: 6px; }

/* ===== 通用 ===== */
.empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 80px 0; }
.pagination { display: flex; justify-content: space-between; align-items: center; padding-top: 8px; }
.pagination-pages { display: flex; gap: 8px; align-items: center; }
.pagination-btn { padding: 6px 14px; font-size: 12px; border: 1px solid var(--border-standard); border-radius: 6px; background: var(--bg-panel); color: var(--text-primary); cursor: pointer; }
.pagination-btn:disabled { opacity: 0.4; cursor: not-allowed; }
.pagination-info { font-size: 13px; color: var(--text-tertiary); padding: 0 8px; }
.text-caption { font-size: 12px; color: var(--text-tertiary); }
.flex { display: flex; align-items: center; }
.gap-8 { gap: 8px; }

/* ===== 表格 ===== */
.table-wrap { overflow-x: auto; border: 1px solid var(--border-standard); border-radius: var(--radius-card); }
.table { width: 100%; border-collapse: collapse; font-size: 13px; }
.table th { background: var(--bg-secondary); font-weight: 510; color: var(--text-secondary); padding: 10px 12px; text-align: left; border-bottom: 1px solid var(--border-standard); }
.table td { padding: 10px 12px; border-bottom: 1px solid var(--border-subtle); color: var(--text-primary); }
.table tr:last-child td { border-bottom: none; }
.table tr:hover td { background: var(--surface-05); }
.tag { display: inline-block; padding: 2px 8px; border-radius: 4px; background: var(--surface-05); font-size: 12px; color: var(--text-secondary); }
.text-ellipsis { max-width: 260px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.empty-cell { text-align: center; padding: 40px 12px !important; color: var(--text-quaternary); }

/* ===== 表单 ===== */
.form-input { padding: 7px 12px; border: 1px solid var(--border-standard); border-radius: 6px; font-size: 13px; background: var(--bg-panel); color: var(--text-primary); outline: none; }
.form-input:focus { border-color: var(--brand-indigo); }
.btn { padding: 7px 14px; border-radius: 6px; font-size: 13px; font-weight: 510; cursor: pointer; border: none; transition: all 0.15s; }
.btn-primary { background: var(--brand-indigo); color: #fff; }
.btn-primary:hover { opacity: 0.9; }
.btn-ghost { background: transparent; color: var(--text-secondary); border: 1px solid var(--border-standard); }
.btn-ghost:hover { background: var(--surface-05); }
.btn-sm { padding: 6px 12px; }
</style>
