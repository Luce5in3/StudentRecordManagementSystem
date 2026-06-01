<template>
  <div class="page">
    <div class="page-toolbar">
      <div class="toolbar-filters">
        <select v-model="filters.status" class="form-select toolbar-input" @change="loadData">
          <option value="">全部状态</option>
          <option :value="0">待审核</option>
          <option :value="1">已通过</option>
          <option :value="2">已驳回</option>
        </select>
        <select v-model="filters.categoryId" class="form-select toolbar-input" @change="loadData">
          <option value="">全部分类</option>
          <option v-for="c in categories" :key="c.pkCategory" :value="c.pkCategory">{{ c.categoryName }}</option>
        </select>
        <button class="btn btn-subtle btn-sm" @click="loadData">查询</button>
      </div>
      <div class="toolbar-stats">
        <span class="stat-badge pending">待审核 {{ pendingCount }}</span>
      </div>
    </div>

    <div class="table-container">
      <table class="data-table">
        <thead>
          <tr>
            <th>学生</th>
            <th>材料分类</th>
            <th>文件名</th>
            <th>描述</th>
            <th>大小</th>
            <th>状态</th>
            <th>上传时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in list" :key="item.pkArchiveFile">
            <td class="text-small-medium" style="color: var(--text-primary)">{{ item.studentName || '-' }}</td>
            <td>{{ item.categoryName || '-' }}</td>
            <td>{{ item.fileName }}</td>
            <td>{{ item.description || '-' }}</td>
            <td>{{ formatSize(item.fileSize) }}</td>
            <td><span :class="['badge', auditBadge(item.status)]">{{ auditLabel(item.status) }}</span></td>
            <td class="text-caption">{{ formatDate(item.uploadTime) }}</td>
            <td>
              <div class="flex gap-4">
                <button class="btn btn-subtle btn-sm" @click="openPreview(item)">预览</button>
                <button v-if="item.status === 0" class="btn btn-primary btn-sm" @click="handleApprove(item)">通过</button>
                <button v-if="item.status === 0" class="btn btn-danger btn-sm" @click="openReject(item)">驳回</button>
                <button v-if="item.status !== 0" class="btn btn-subtle btn-sm" @click="viewAuditInfo(item)">审核详情</button>
              </div>
            </td>
          </tr>
          <tr v-if="list.length === 0">
            <td colspan="8" class="empty-cell">暂无数据</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="pagination" v-if="total > 0">
      <span class="text-caption">共 {{ total }} 条</span>
      <div class="pagination-pages">
        <button class="pagination-btn" :disabled="pageNum <= 1" @click="pageNum--; loadData()">上一页</button>
        <span class="pagination-info">{{ pageNum }} / {{ totalPages }}</span>
        <button class="pagination-btn" :disabled="pageNum >= totalPages" @click="pageNum++; loadData()">下一页</button>
      </div>
    </div>

    <!-- 驳回弹窗 -->
    <div v-if="showRejectModal" class="modal-overlay" @click.self="showRejectModal = false">
      <div class="modal-content" style="max-width: 420px">
        <div class="modal-header"><h3 class="modal-title">驳回档案</h3><button class="btn-icon" @click="showRejectModal = false">✕</button></div>
        <div class="modal-body">
          <p class="reject-info">文件：{{ rejectItem?.fileName }}</p>
          <div class="form-group">
            <label class="form-label">驳回原因</label>
            <textarea v-model="rejectRemark" class="form-input" rows="3" placeholder="请输入驳回原因（选填）"></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-ghost btn-sm" @click="showRejectModal = false">取消</button>
          <button class="btn btn-danger btn-sm" @click="confirmReject" :disabled="rejecting">{{ rejecting ? '处理中...' : '确认驳回' }}</button>
        </div>
      </div>
    </div>

    <!-- 审核详情弹窗 -->
    <div v-if="showAuditInfo" class="modal-overlay" @click.self="showAuditInfo = false">
      <div class="modal-content" style="max-width: 520px">
        <div class="modal-header"><h3 class="modal-title">审核详情</h3><button class="btn-icon" @click="showAuditInfo = false">✕</button></div>
        <div class="modal-body">
          <div class="info-grid">
            <div class="info-item"><span class="info-label">文件名</span><span class="info-value">{{ auditInfoItem?.fileName }}</span></div>
            <div class="info-item"><span class="info-label">审核状态</span><span class="info-value">{{ auditLabel(auditInfoItem?.status) }}</span></div>
            <div class="info-item"><span class="info-label">审核时间</span><span class="info-value">{{ formatDate(auditInfoItem?.auditTime) }}</span></div>
            <div class="info-item"><span class="info-label">文件大小</span><span class="info-value">{{ formatSize(auditInfoItem?.fileSize) }}</span></div>
            <div class="info-item" style="grid-column:span 2"><span class="info-label">审核意见</span><span class="info-value">{{ auditInfoItem?.auditRemark || '无' }}</span></div>
          </div>
          <!-- 上传文件预览区 -->
          <div class="audit-file-section">
            <div class="audit-file-label">上传文件</div>
            <div class="audit-file-preview" v-if="auditPreviewLoading">加载中...</div>
            <div class="audit-file-preview audit-file-error" v-else-if="auditPreviewError">{{ auditPreviewError }}</div>
            <img v-else-if="auditPreviewKind === 'image' && auditPreviewBlobUrl" :src="auditPreviewBlobUrl" class="audit-thumb" />
            <iframe v-else-if="auditPreviewKind === 'pdf' && auditPreviewBlobUrl" :src="auditPreviewBlobUrl" class="audit-pdf-embed"></iframe>
            <div class="audit-file-preview" v-else>
              <span class="audit-file-icon">📄</span>
              <span>{{ auditInfoItem?.fileName }}</span>
            </div>
            <button class="btn btn-subtle btn-sm" @click="openFullPreviewFromAudit">全屏预览</button>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-ghost btn-sm" @click="closeAuditPreview">关闭</button>
        </div>
      </div>
    </div>

    <!-- 文件预览弹窗 -->
    <div v-if="showPreviewModal" class="modal-overlay" @click.self="closePreview">
      <div class="modal-content preview-modal">
        <div class="modal-header">
          <h3 class="modal-title">档案预览 · {{ previewItem?.fileName }}</h3>
          <button class="btn-icon" @click="closePreview">✕</button>
        </div>
        <div class="modal-body preview-body">
          <div class="preview-meta">
            <span class="meta-item">学生：{{ previewItem?.studentName || '-' }}</span>
            <span class="meta-item">分类：{{ previewItem?.categoryName || '-' }}</span>
            <span class="meta-item">大小：{{ formatSize(previewItem?.fileSize) }}</span>
            <span class="meta-item">状态：<span :class="['badge', auditBadge(previewItem?.status)]">{{ auditLabel(previewItem?.status) }}</span></span>
            <span class="meta-item" v-if="previewItem?.description">说明：{{ previewItem.description }}</span>
          </div>
          <div class="preview-viewer">
            <div v-if="previewLoading" class="preview-tip">加载中...</div>
            <div v-else-if="previewError" class="preview-tip preview-error">{{ previewError }}</div>
            <template v-else-if="previewKind === 'image'">
              <img :src="previewBlobUrl" :alt="previewItem?.fileName" class="preview-image" />
            </template>
            <template v-else-if="previewKind === 'pdf'">
              <iframe :src="previewBlobUrl" class="preview-iframe"></iframe>
            </template>
            <template v-else-if="previewKind === 'text'">
              <pre class="preview-text">{{ previewText }}</pre>
            </template>
            <template v-else>
              <div class="preview-tip">
                <p>该文件类型暂不支持在线预览（{{ previewExt || '未知' }}）</p>
                <button class="btn btn-primary btn-sm" @click="downloadPreview">下载查看</button>
              </div>
            </template>
          </div>
        </div>
        <div class="modal-footer">
          <button v-if="previewBlobUrl" class="btn btn-subtle btn-sm" @click="downloadPreview">下载</button>
          <button class="btn btn-ghost btn-sm" @click="closePreview">关闭</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { archiveApi } from '../../api/modules'
import { useUserStore } from '../../stores/user'

const userStore = useUserStore()
const list = ref<any[]>([])
const categories = ref<any[]>([])
const total = ref(0)
const pendingCount = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const filters = reactive({ status: '' as any, categoryId: '' as any })

const showRejectModal = ref(false)
const rejectItem = ref<any>(null)
const rejectRemark = ref('')
const rejecting = ref(false)

const showAuditInfo = ref(false)
const auditInfoItem = ref<any>(null)

// 审核详情中的文件预览
const auditPreviewLoading = ref(false)
const auditPreviewError = ref('')
const auditPreviewKind = ref<'image' | 'pdf' | 'text' | 'other' | ''>('')
const auditPreviewBlobUrl = ref('')

// 预览弹窗状态
const showPreviewModal = ref(false)
const previewItem = ref<any>(null)
const previewBlobUrl = ref('')
const previewKind = ref<'image' | 'pdf' | 'text' | 'other' | ''>('')
const previewExt = ref('')
const previewText = ref('')
const previewLoading = ref(false)
const previewError = ref('')

const totalPages = computed(() => Math.ceil(total.value / pageSize.value) || 1)

function auditBadge(s: number) { return [, 'badge-success', 'badge-danger'][s] || 'badge-warning' }
function auditLabel(s: number) { return ['待审核', '已通过', '已驳回'][s] || '未知' }
function formatSize(bytes: number) {
  if (!bytes) return '-'
  if (bytes < 1024) return bytes + 'B'
  if (bytes < 1048576) return (bytes / 1024).toFixed(1) + 'KB'
  return (bytes / 1048576).toFixed(1) + 'MB'
}
function formatDate(dateStr: string) {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleDateString('zh-CN')
}

async function loadCategories() {
  try {
    const res: any = await archiveApi.getCategoryList()
    categories.value = res.data || []
  } catch (e) { /* ignore */ }
}

async function loadData() {
  try {
    const params: any = { pageNum: pageNum.value, pageSize: pageSize.value }
    if (filters.status !== '') params.status = filters.status
    if (filters.categoryId) params.categoryId = filters.categoryId
    const res: any = await archiveApi.getFileList(params)
    list.value = res.data?.list || []
    total.value = res.data?.total || 0
    // 统计待审核数
    const pendingRes: any = await archiveApi.getFileList({ pageNum: 1, pageSize: 1, status: 0 })
    pendingCount.value = pendingRes.data?.total || 0
  } catch (e) { console.error('加载档案列表失败', e) }
}

async function handleApprove(item: any) {
  if (!confirm(`确认通过「${item.fileName}」？`)) return
  try {
    await archiveApi.auditFile(item.pkArchiveFile, {
      status: 1,
      auditUserId: userStore.userInfo?.userId,
      auditRemark: ''
    })
    loadData()
  } catch (e: any) { alert(e.message || '审核失败') }
}

function openReject(item: any) {
  rejectItem.value = item
  rejectRemark.value = ''
  showRejectModal.value = true
}

async function confirmReject() {
  if (!rejectItem.value) return
  rejecting.value = true
  try {
    await archiveApi.auditFile(rejectItem.value.pkArchiveFile, {
      status: 2,
      auditUserId: userStore.userInfo?.userId,
      auditRemark: rejectRemark.value
    })
    showRejectModal.value = false
    loadData()
  } catch (e: any) { alert(e.message || '驳回失败') }
  finally { rejecting.value = false }
}

function viewAuditInfo(item: any) {
  auditInfoItem.value = item
  showAuditInfo.value = true
  loadAuditPreview(item)
}

async function loadAuditPreview(item: any) {
  auditPreviewLoading.value = true
  auditPreviewError.value = ''
  auditPreviewBlobUrl.value = ''
  const ext = getExt(item.fileName)
  auditPreviewKind.value = kindOf(ext)
  try {
    const res: any = await archiveApi.previewFile(item.pkArchiveFile)
    const blob: Blob = res.data
    auditPreviewBlobUrl.value = URL.createObjectURL(blob)
  } catch (e: any) {
    auditPreviewError.value = e?.message || '加载失败'
  } finally {
    auditPreviewLoading.value = false
  }
}

function openFullPreviewFromAudit() {
  if (!auditInfoItem.value) return
  showAuditInfo.value = false
  openPreview(auditInfoItem.value)
}

function closeAuditPreview() {
  showAuditInfo.value = false
  if (auditPreviewBlobUrl.value) {
    URL.revokeObjectURL(auditPreviewBlobUrl.value)
  }
  auditPreviewBlobUrl.value = ''
  auditPreviewError.value = ''
  auditPreviewLoading.value = false
  auditInfoItem.value = null
}

function getExt(name: string): string {
  if (!name) return ''
  const idx = name.lastIndexOf('.')
  return idx >= 0 ? name.substring(idx + 1).toLowerCase() : ''
}

function kindOf(ext: string): 'image' | 'pdf' | 'text' | 'other' {
  if (['png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp', 'svg'].includes(ext)) return 'image'
  if (ext === 'pdf') return 'pdf'
  if (['txt', 'log', 'md', 'json', 'csv', 'xml', 'html', 'htm'].includes(ext)) return 'text'
  return 'other'
}

async function openPreview(item: any) {
  previewItem.value = item
  showPreviewModal.value = true
  previewLoading.value = true
  previewError.value = ''
  previewBlobUrl.value = ''
  previewText.value = ''
  const ext = getExt(item.fileName)
  previewExt.value = ext
  previewKind.value = kindOf(ext)
  try {
    const res: any = await archiveApi.previewFile(item.pkArchiveFile)
    const blob: Blob = res.data
    previewBlobUrl.value = URL.createObjectURL(blob)
    if (previewKind.value === 'text') {
      previewText.value = await blob.text()
    }
  } catch (e: any) {
    previewError.value = e?.message || '预览加载失败'
  } finally {
    previewLoading.value = false
  }
}

function closePreview() {
  showPreviewModal.value = false
  if (previewBlobUrl.value) {
    URL.revokeObjectURL(previewBlobUrl.value)
  }
  previewBlobUrl.value = ''
  previewText.value = ''
  previewItem.value = null
  previewKind.value = ''
  previewExt.value = ''
  previewError.value = ''
}

function downloadPreview() {
  if (!previewBlobUrl.value || !previewItem.value) return
  const a = document.createElement('a')
  a.href = previewBlobUrl.value
  a.download = previewItem.value.fileName || 'archive-file'
  a.click()
}

onMounted(() => { loadCategories(); loadData() })
</script>

<style scoped>
.page { display: flex; flex-direction: column; gap: 16px; }
.page-toolbar { display: flex; justify-content: space-between; align-items: center; }
.toolbar-filters { display: flex; gap: 8px; align-items: center; }
.toolbar-input { width: 160px; padding: 7px 12px; font-size: 13px; }
.toolbar-stats { display: flex; gap: 8px; }
.stat-badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 510; }
.stat-badge.pending { background: rgba(217, 119, 6, 0.08); color: var(--status-yellow); }
.empty-cell { text-align: center; padding: 40px !important; color: var(--text-quaternary); font-size: 13px; }
.pagination-info { font-size: 13px; color: var(--text-tertiary); padding: 0 8px; }
.reject-info { font-size: 13px; color: var(--text-tertiary); margin-bottom: 12px; }
.info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; }
.info-item { display: flex; flex-direction: column; gap: 2px; }
.info-label { font-size: 12px; font-weight: 510; color: var(--text-quaternary); }
.info-value { font-size: 14px; font-weight: 510; color: var(--text-secondary); }
.preview-modal { max-width: 880px; width: 90vw; }
.preview-body { display: flex; flex-direction: column; gap: 12px; }
.preview-meta { display: flex; flex-wrap: wrap; gap: 8px 16px; padding: 8px 12px; background: var(--surface-03); border-radius: var(--radius-md); font-size: 12px; color: var(--text-tertiary); }
.preview-meta .meta-item { display: inline-flex; align-items: center; gap: 4px; }
.preview-viewer { min-height: 360px; max-height: 65vh; display: flex; align-items: center; justify-content: center; background: var(--surface-02); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); overflow: hidden; }
.preview-image { max-width: 100%; max-height: 65vh; object-fit: contain; }
.preview-iframe { width: 100%; height: 65vh; border: 0; background: #fff; }
.preview-text { width: 100%; max-height: 65vh; overflow: auto; padding: 16px; margin: 0; font-size: 12px; color: var(--text-secondary); white-space: pre-wrap; word-break: break-all; font-family: 'SF Mono', monospace; }
.preview-tip { display: flex; flex-direction: column; align-items: center; gap: 12px; padding: 32px; color: var(--text-tertiary); font-size: 13px; text-align: center; }
.preview-error { color: var(--status-red, #c53030); }
.audit-file-section { margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border-subtle); display: flex; flex-direction: column; gap: 10px; }
.audit-file-label { font-size: 12px; font-weight: 510; color: var(--text-quaternary); }
.audit-file-preview { display: flex; align-items: center; gap: 8px; padding: 12px; background: var(--surface-03); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); font-size: 13px; color: var(--text-tertiary); }
.audit-file-error { color: var(--status-red, #c53030); }
.audit-file-icon { font-size: 20px; }
.audit-thumb { max-width: 100%; max-height: 240px; object-fit: contain; border-radius: var(--radius-sm); background: var(--surface-02); }
.audit-pdf-embed { width: 100%; height: 320px; border: 1px solid var(--border-subtle); border-radius: var(--radius-md); background: #fff; }
</style>
