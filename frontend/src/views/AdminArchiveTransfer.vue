<template>
  <div class="admin-transfer">
    <!-- Tab 切换 -->
    <div class="tab-bar">
      <button :class="['tab-btn', activeTab === 'letter' ? 'tab-active' : '']" @click="activeTab = 'letter'; pageNum = 1; loadLetters()">调档函审核</button>
      <button :class="['tab-btn', activeTab === 'destination' ? 'tab-active' : '']" @click="activeTab = 'destination'; pageNum = 1; loadDestinations()">档案去向管理</button>
    </div>

    <!-- ===== 调档函审核 Tab ===== -->
    <template v-if="activeTab === 'letter'">
      <div class="page-toolbar">
        <div class="toolbar-filters">
          <select v-model="letterFilters.status" class="form-select toolbar-input" @change="pageNum = 1; loadLetters()">
            <option value="">全部状态</option>
            <option :value="0">待审核</option>
            <option :value="1">已通过</option>
            <option :value="2">已驳回</option>
            <option :value="3">已寄出</option>
          </select>
          <button class="btn btn-subtle btn-sm" @click="loadLetters">查询</button>
        </div>
      </div>

      <div class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>学生</th>
              <th>学号</th>
              <th>去向类型</th>
              <th>去向单位</th>
              <th>状态</th>
              <th>申请时间</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in letterList" :key="item.pkLetter">
              <td class="text-small-medium" style="color: var(--text-primary)">{{ item.studentName || '-' }}</td>
              <td>{{ item.studentNo || '-' }}</td>
              <td>{{ item.destinationType || '-' }}</td>
              <td>{{ item.destinationName || '-' }}</td>
              <td>
                <span :class="['badge', letterBadge(item.status)]">{{ letterLabel(item.status) }}</span>
              </td>
              <td class="text-caption">{{ formatDate(item.createTime) }}</td>
              <td>
                <div class="flex gap-4">
                  <button class="btn btn-subtle btn-sm" @click="openLetterDetail(item)">详情</button>
                  <button v-if="item.status === 0" class="btn btn-primary btn-sm" @click="handleAudit(item, 1)">通过</button>
                  <button v-if="item.status === 0" class="btn btn-danger btn-sm" @click="handleAudit(item, 2)">驳回</button>
                  <button v-if="item.status === 1" class="btn btn-primary btn-sm" @click="openSendModal(item)">档案送出</button>
                </div>
              </td>
            </tr>
            <tr v-if="letterList.length === 0">
              <td colspan="7" class="empty-cell">暂无数据</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="pagination" v-if="letterTotal > 0">
        <span class="text-caption">共 {{ letterTotal }} 条</span>
        <div class="pagination-pages">
          <button class="pagination-btn" :disabled="pageNum <= 1" @click="pageNum--; loadLetters()">上一页</button>
          <span class="pagination-info">{{ pageNum }} / {{ letterTotalPages }}</span>
          <button class="pagination-btn" :disabled="pageNum >= letterTotalPages" @click="pageNum++; loadLetters()">下一页</button>
        </div>
      </div>
    </template>

    <!-- ===== 档案去向管理 Tab ===== -->
    <template v-if="activeTab === 'destination'">
      <div class="page-toolbar">
        <div class="toolbar-filters">
          <select v-model="destFilters.status" class="form-select toolbar-input" @change="pageNum = 1; loadDestinations()">
            <option value="">全部状态</option>
            <option value="待处理">待处理</option>
            <option value="已寄出">已寄出</option>
            <option value="已签收">已签收</option>
          </select>
          <button class="btn btn-subtle btn-sm" @click="loadDestinations">查询</button>
        </div>
      </div>

      <div class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>学生</th>
              <th>学号</th>
              <th>去向类型</th>
              <th>去向单位</th>
              <th>状态</th>
              <th>快递单号</th>
              <th>更新时间</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in destList" :key="item.pkDestination">
              <td class="text-small-medium" style="color: var(--text-primary)">{{ item.studentName || '-' }}</td>
              <td>{{ item.studentNo || '-' }}</td>
              <td>{{ item.destinationType || '-' }}</td>
              <td>{{ item.destinationName || '-' }}</td>
              <td>
                <span :class="['badge', destBadge(item.status)]">{{ item.status || '-' }}</span>
              </td>
              <td>{{ item.trackingNumber || '-' }}</td>
              <td class="text-caption">{{ formatDate(item.updateTime || item.createTime) }}</td>
              <td>
                <div class="flex gap-4">
                  <button v-if="item.status === '待处理'" class="btn btn-primary btn-sm" @click="openDestSendModal(item)">档案送出</button>
                  <button class="btn btn-subtle btn-sm" @click="openDestEdit(item)">编辑</button>
                </div>
              </td>
            </tr>
            <tr v-if="destList.length === 0">
              <td colspan="8" class="empty-cell">暂无数据</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="pagination" v-if="destTotal > 0">
        <span class="text-caption">共 {{ destTotal }} 条</span>
        <div class="pagination-pages">
          <button class="pagination-btn" :disabled="pageNum <= 1" @click="pageNum--; loadDestinations()">上一页</button>
          <span class="pagination-info">{{ pageNum }} / {{ destTotalPages }}</span>
          <button class="pagination-btn" :disabled="pageNum >= destTotalPages" @click="pageNum++; loadDestinations()">下一页</button>
        </div>
      </div>
    </template>

    <!-- 调档函详情弹窗 -->
    <div v-if="showDetailModal" class="modal-overlay" @click.self="closeDetailModal">
      <div class="modal-content" style="max-width: 560px">
        <div class="modal-header"><h3 class="modal-title">调档函详情</h3><button class="btn-icon" @click="closeDetailModal">✕</button></div>
        <div class="modal-body">
          <div class="detail-grid" v-if="detailItem">
            <div class="detail-row"><span class="d-label">学生</span><span class="d-value">{{ detailItem.studentName }} ({{ detailItem.studentNo }})</span></div>
            <div class="detail-row"><span class="d-label">去向类型</span><span class="d-value">{{ detailItem.destinationType }}</span></div>
            <div class="detail-row"><span class="d-label">去向单位</span><span class="d-value">{{ detailItem.destinationName }}</span></div>
            <div class="detail-row"><span class="d-label">单位地址</span><span class="d-value">{{ detailItem.destinationAddress || '-' }}</span></div>
            <div class="detail-row"><span class="d-label">联系人</span><span class="d-value">{{ detailItem.contactPerson || '-' }}</span></div>
            <div class="detail-row"><span class="d-label">联系电话</span><span class="d-value">{{ detailItem.contactPhone || '-' }}</span></div>
            <div class="detail-row"><span class="d-label">申请原因</span><span class="d-value">{{ detailItem.reason || '-' }}</span></div>
            <div class="detail-row"><span class="d-label">状态</span><span class="d-value"><span :class="['badge', letterBadge(detailItem.status)]">{{ letterLabel(detailItem.status) }}</span></span></div>
            <div class="detail-row" v-if="detailItem.trackingNumber"><span class="d-label">快递单号</span><span class="d-value">{{ detailItem.trackingNumber }}</span></div>
            <div class="detail-row" v-if="detailItem.auditRemark"><span class="d-label">审核备注</span><span class="d-value">{{ detailItem.auditRemark }}</span></div>
          </div>
          <!-- 调档函文件预览区 -->
          <div class="audit-file-section" v-if="detailItem?.letterFilePath">
            <div class="audit-file-label">调档函文件</div>
            <div class="audit-file-preview" v-if="detailPreviewLoading">加载中...</div>
            <div class="audit-file-preview audit-file-error" v-else-if="detailPreviewError">{{ detailPreviewError }}</div>
            <img v-else-if="detailPreviewKind === 'image' && detailPreviewBlobUrl" :src="detailPreviewBlobUrl" class="audit-thumb" />
            <iframe v-else-if="detailPreviewKind === 'pdf' && detailPreviewBlobUrl" :src="detailPreviewBlobUrl" class="audit-pdf-embed"></iframe>
            <div class="audit-file-preview" v-else>
              <span class="audit-file-icon">📄</span>
              <span>调档函文件</span>
            </div>
          </div>
          <div class="audit-file-section" v-else>
            <div class="audit-file-label">调档函文件</div>
            <div class="audit-file-preview">未上传调档函附件</div>
          </div>
        </div>
        <div class="modal-footer">
          <button v-if="detailItem?.letterFilePath" class="btn btn-subtle btn-sm" @click="downloadLetterFile">下载文件</button>
          <button class="btn btn-ghost btn-sm" @click="closeDetailModal">关闭</button>
        </div>
      </div>
    </div>

    <!-- 驳回弹窗 -->
    <div v-if="showRejectModal" class="modal-overlay" @click.self="showRejectModal = false">
      <div class="modal-content" style="max-width: 420px">
        <div class="modal-header"><h3 class="modal-title">驳回原因</h3><button class="btn-icon" @click="showRejectModal = false">✕</button></div>
        <div class="modal-body">
          <div class="form-group"><label class="form-label">驳回原因</label>
            <textarea v-model="rejectRemark" class="form-input" rows="3" placeholder="请输入驳回原因"></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-ghost btn-sm" @click="showRejectModal = false">取消</button>
          <button class="btn btn-danger btn-sm" @click="confirmReject">确认驳回</button>
        </div>
      </div>
    </div>

    <!-- 档案送出弹窗 -->
    <div v-if="showSendModal" class="modal-overlay" @click.self="showSendModal = false">
      <div class="modal-content" style="max-width: 420px">
        <div class="modal-header"><h3 class="modal-title">档案送出</h3><button class="btn-icon" @click="showSendModal = false">✕</button></div>
        <div class="modal-body">
          <div class="form-group">
            <label class="form-label">快递单号</label>
            <input v-model="trackingNumber" class="form-input" placeholder="请输入快递单号" />
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-ghost btn-sm" @click="showSendModal = false">取消</button>
          <button class="btn btn-primary btn-sm" @click="confirmSend">确认送出</button>
        </div>
      </div>
    </div>

    <!-- 编辑去向弹窗 -->
    <div v-if="showEditModal" class="modal-overlay" @click.self="showEditModal = false">
      <div class="modal-content" style="max-width: 520px">
        <div class="modal-header"><h3 class="modal-title">编辑档案去向</h3><button class="btn-icon" @click="showEditModal = false">✕</button></div>
        <div class="modal-body">
          <div class="form-group"><label class="form-label">去向类型</label>
            <select v-model="editForm.destinationType" class="form-input">
              <option value="本校">本校</option>
              <option value="就业单位">就业单位</option>
              <option value="研究生院校">研究生院校</option>
              <option value="其他">其他</option>
            </select>
          </div>
          <div class="form-group"><label class="form-label">去向单位名称</label>
            <input v-model="editForm.destinationName" class="form-input" />
          </div>
          <div class="form-group"><label class="form-label">单位地址</label>
            <input v-model="editForm.destinationAddress" class="form-input" />
          </div>
          <div class="form-row">
            <div class="form-group form-group-half"><label class="form-label">联系人</label>
              <input v-model="editForm.contactPerson" class="form-input" />
            </div>
            <div class="form-group form-group-half"><label class="form-label">联系电话</label>
              <input v-model="editForm.contactPhone" class="form-input" />
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-ghost btn-sm" @click="showEditModal = false">取消</button>
          <button class="btn btn-primary btn-sm" @click="confirmEdit">保存</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { archiveTransferApi, archiveApi } from '../api/modules'
import { useUserStore } from '../stores/user'

const userStore = useUserStore()
const activeTab = ref<'letter' | 'destination'>('letter')

// ===== 调档函 =====
const letterList = ref<any[]>([])
const letterTotal = ref(0)
const letterFilters = reactive({ status: '' as any })

// ===== 去向 =====
const destList = ref<any[]>([])
const destTotal = ref(0)
const destFilters = reactive({ status: '' })

// 分页
const pageNum = ref(1)
const pageSize = ref(10)

// 弹窗
const showDetailModal = ref(false)
const detailItem = ref<any>(null)
// 详情中的文件预览
const detailPreviewLoading = ref(false)
const detailPreviewError = ref('')
const detailPreviewKind = ref<'image' | 'pdf' | 'text' | 'other' | ''>('')
const detailPreviewBlobUrl = ref('')
const showRejectModal = ref(false)
const rejectRemark = ref('')
const rejectItem = ref<any>(null)
const showSendModal = ref(false)
const sendItem = ref<any>(null)
const trackingNumber = ref('')
const isDestSend = ref(false)
const showEditModal = ref(false)
const editItem = ref<any>(null)
const editForm = reactive({ destinationType: '', destinationName: '', destinationAddress: '', contactPerson: '', contactPhone: '' })

const letterTotalPages = computed(() => Math.ceil(letterTotal.value / pageSize.value) || 1)
const destTotalPages = computed(() => Math.ceil(destTotal.value / pageSize.value) || 1)

function letterBadge(s: number) {
  return [, 'badge-success', 'badge-danger', 'badge-info'][s] || 'badge-warning'
}
function letterLabel(s: number) {
  return ['待审核', '已通过', '已驳回', '已寄出'][s] || '未知'
}
function destBadge(s: string) {
  if (s === '已签收') return 'badge-success'
  if (s === '已寄出') return 'badge-info'
  return 'badge-warning'
}
function formatDate(dateStr: string) {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleDateString('zh-CN')
}

async function loadLetters() {
  try {
    const params: any = { pageNum: pageNum.value, pageSize: pageSize.value }
    if (letterFilters.status !== '') params.status = letterFilters.status
    const res: any = await archiveTransferApi.getLetterList(params)
    letterList.value = res.data?.list || []
    letterTotal.value = res.data?.total || 0
  } catch (e) { console.error('加载调档函列表失败', e) }
}

async function loadDestinations() {
  try {
    const params: any = { pageNum: pageNum.value, pageSize: pageSize.value }
    if (destFilters.status) params.status = destFilters.status
    const res: any = await archiveTransferApi.getDestinationList(params)
    destList.value = res.data?.list || []
    destTotal.value = res.data?.total || 0
  } catch (e) { console.error('加载去向列表失败', e) }
}

function openLetterDetail(item: any) {
  detailItem.value = item
  showDetailModal.value = true
  loadDetailPreview(item)
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

async function loadDetailPreview(item: any) {
  if (!item.letterFilePath) return
  detailPreviewLoading.value = true
  detailPreviewError.value = ''
  detailPreviewBlobUrl.value = ''
  const ext = getExt(item.letterFilePath)
  detailPreviewKind.value = kindOf(ext)
  try {
    let fileId = item.letterFileId
    // 旧记录无 letterFileId，通过文件路径查找
    if (!fileId) {
      const pathRes: any = await archiveApi.getFileByPath(item.letterFilePath)
      fileId = pathRes.data?.pkArchiveFile
      if (!fileId) throw new Error('未找到关联文件')
    }
    const res: any = await archiveApi.previewFile(fileId)
    const blob: Blob = res.data
    detailPreviewBlobUrl.value = URL.createObjectURL(blob)
  } catch (e: any) {
    detailPreviewError.value = e?.message || '加载失败'
  } finally {
    detailPreviewLoading.value = false
  }
}

function closeDetailModal() {
  showDetailModal.value = false
  if (detailPreviewBlobUrl.value) {
    URL.revokeObjectURL(detailPreviewBlobUrl.value)
  }
  detailPreviewBlobUrl.value = ''
  detailPreviewError.value = ''
  detailPreviewLoading.value = false
  detailItem.value = null
}

async function downloadLetterFile() {
  if (!detailItem.value?.letterFilePath) return
  if (detailPreviewBlobUrl.value) {
    const a = document.createElement('a')
    a.href = detailPreviewBlobUrl.value
    a.download = '调档函.pdf'
    a.click()
  } else {
    // 尝试通过后端预览接口下载
    let fileId = detailItem.value.letterFileId
    if (!fileId) {
      try {
        const pathRes: any = await archiveApi.getFileByPath(detailItem.value.letterFilePath)
        fileId = pathRes.data?.pkArchiveFile
      } catch { /* ignore */ }
    }
    if (fileId) {
      try {
        const res: any = await archiveApi.previewFile(fileId)
        const blob: Blob = res.data
        const url = URL.createObjectURL(blob)
        const a = document.createElement('a')
        a.href = url
        a.download = '调档函.pdf'
        a.click()
        URL.revokeObjectURL(url)
        return
      } catch { /* ignore */ }
    }
    // 最后尝试直接打开链接
    window.open(detailItem.value.letterFilePath, '_blank')
  }
}

async function handleAudit(item: any, status: number) {
  if (status === 2) {
    rejectItem.value = item
    rejectRemark.value = ''
    showRejectModal.value = true
    return
  }
  try {
    await archiveTransferApi.auditLetter(item.pkLetter, {
      status, auditUserId: userStore.userInfo?.userId, auditRemark: ''
    })
    loadLetters()
  } catch (e: any) { alert(e.message || '审核失败') }
}

async function confirmReject() {
  if (!rejectItem.value) return
  try {
    await archiveTransferApi.auditLetter(rejectItem.value.pkLetter, {
      status: 2, auditUserId: userStore.userInfo?.userId, auditRemark: rejectRemark.value
    })
    showRejectModal.value = false
    loadLetters()
  } catch (e: any) { alert(e.message || '驳回失败') }
}

function openSendModal(item: any) {
  sendItem.value = item
  trackingNumber.value = ''
  isDestSend.value = false
  showSendModal.value = true
}

function openDestSendModal(item: any) {
  sendItem.value = item
  trackingNumber.value = ''
  isDestSend.value = true
  showSendModal.value = true
}

async function confirmSend() {
  if (!sendItem.value) return
  try {
    if (isDestSend.value) {
      await archiveTransferApi.sendArchive(sendItem.value.pkDestination, {
        sendUserId: userStore.userInfo?.userId, trackingNumber: trackingNumber.value
      })
      loadDestinations()
    } else {
      await archiveTransferApi.sendTransferArchive(sendItem.value.pkLetter, {
        sendUserId: userStore.userInfo?.userId, trackingNumber: trackingNumber.value
      })
      loadLetters()
    }
    showSendModal.value = false
  } catch (e: any) { alert(e.message || '操作失败') }
}

function openDestEdit(item: any) {
  editItem.value = item
  editForm.destinationType = item.destinationType || ''
  editForm.destinationName = item.destinationName || ''
  editForm.destinationAddress = item.destinationAddress || ''
  editForm.contactPerson = item.contactPerson || ''
  editForm.contactPhone = item.contactPhone || ''
  showEditModal.value = true
}

async function confirmEdit() {
  if (!editItem.value) return
  try {
    await archiveTransferApi.saveOrUpdateDestination({
      studentId: editItem.value.studentId,
      ...editForm
    })
    showEditModal.value = false
    loadDestinations()
  } catch (e: any) { alert(e.message || '保存失败') }
}

onMounted(() => { loadLetters() })
</script>

<style scoped>
.admin-transfer { display: flex; flex-direction: column; gap: 16px; }
.tab-bar { display: flex; gap: 0; border-bottom: 2px solid var(--border-subtle); margin-bottom: 4px; }
.tab-btn { padding: 10px 20px; font-size: 14px; font-weight: 510; border: none; background: none; color: var(--text-tertiary); cursor: pointer; border-bottom: 2px solid transparent; margin-bottom: -2px; transition: all 0.15s; }
.tab-btn:hover { color: var(--text-primary); }
.tab-active { color: var(--text-primary) !important; border-bottom-color: var(--brand-indigo) !important; }
.page-toolbar { display: flex; justify-content: space-between; align-items: center; }
.toolbar-filters { display: flex; gap: 8px; align-items: center; }
.toolbar-input { width: 160px; padding: 7px 12px; font-size: 13px; }
.empty-cell { text-align: center; padding: 40px !important; color: var(--text-quaternary); font-size: 13px; }
.pagination { display: flex; justify-content: space-between; align-items: center; padding-top: 8px; }
.pagination-pages { display: flex; gap: 8px; align-items: center; }
.pagination-btn { padding: 6px 14px; font-size: 12px; }
.pagination-info { font-size: 13px; color: var(--text-tertiary); padding: 0 8px; }
.flex { display: flex; }
.gap-4 { gap: 8px; }
.detail-grid { display: flex; flex-direction: column; gap: 10px; }
.detail-row { display: flex; gap: 8px; font-size: 13px; }
.d-label { color: var(--text-tertiary); min-width: 80px; flex-shrink: 0; }
.d-value { color: var(--text-primary); word-break: break-all; }
.form-row { display: flex; gap: 16px; }
.form-group-half { flex: 1; }
.audit-file-section { margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border-subtle); display: flex; flex-direction: column; gap: 10px; }
.audit-file-label { font-size: 12px; font-weight: 510; color: var(--text-quaternary); }
.audit-file-preview { display: flex; align-items: center; gap: 8px; padding: 12px; background: var(--surface-03); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); font-size: 13px; color: var(--text-tertiary); }
.audit-file-error { color: var(--status-red, #c53030); }
.audit-file-icon { font-size: 20px; }
.audit-thumb { max-width: 100%; max-height: 240px; object-fit: contain; border-radius: var(--radius-sm); background: var(--surface-02); }
.audit-pdf-embed { width: 100%; height: 320px; border: 1px solid var(--border-subtle); border-radius: var(--radius-md); background: #fff; }
</style>
