<template>
  <div class="student-transfer">
    <div class="page-header">
      <h2 class="page-title-text">调档函申请</h2>
      <p class="page-desc">提交调档函，申请将档案转递至毕业去向单位或研究生院校</p>
    </div>

    <!-- 当前档案去向 -->
    <div class="card destination-card" v-if="!loading">
      <h3 class="card-title">我的档案去向</h3>
      <div class="destination-info" v-if="destination">
        <div class="info-row">
          <span class="info-label">去向类型：</span>
          <span class="info-value">{{ destination.destinationType || '-' }}</span>
          <span :class="['badge', destinationBadge(destination)]">{{ destinationStatus(destination) }}</span>
        </div>
        <div class="info-row">
          <span class="info-label">去向单位：</span>
          <span class="info-value">{{ destination.destinationName || '-' }}</span>
        </div>
        <div class="info-row" v-if="destination.destinationAddress">
          <span class="info-label">单位地址：</span>
          <span class="info-value">{{ destination.destinationAddress }}</span>
        </div>
        <div class="info-row" v-if="destination.trackingNumber">
          <span class="info-label">快递单号：</span>
          <span class="info-value">{{ destination.trackingNumber }}</span>
        </div>
      </div>
      <div class="empty-state" v-else>
        <p class="empty-text">暂未设置档案去向，在校期间默认为本校保留</p>
      </div>
    </div>

    <!-- 调档函提交表单 -->
    <div class="card apply-card">
      <h3 class="card-title">提交调档函</h3>
      <form class="apply-form" @submit.prevent="submitLetter">
        <div class="form-group">
          <label class="form-label">去向类型 <span class="required">*</span></label>
          <select v-model="form.destinationType" class="form-input" required>
            <option value="">请选择</option>
            <option value="就业单位">就业单位</option>
            <option value="研究生院校">研究生院校</option>
            <option value="其他">其他</option>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">去向单位名称 <span class="required">*</span></label>
          <input v-model="form.destinationName" class="form-input" placeholder="请输入单位/院校全称" required />
        </div>
        <div class="form-group">
          <label class="form-label">单位地址</label>
          <input v-model="form.destinationAddress" class="form-input" placeholder="请输入单位详细地址" />
        </div>
        <div class="form-row">
          <div class="form-group form-group-half">
            <label class="form-label">联系人</label>
            <input v-model="form.contactPerson" class="form-input" placeholder="联系人姓名" />
          </div>
          <div class="form-group form-group-half">
            <label class="form-label">联系电话</label>
            <input v-model="form.contactPhone" class="form-input" placeholder="联系人电话" />
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">调档函附件 <span class="required">*</span></label>
          <div class="upload-area">
            <input type="file" ref="fileInput" @change="handleFileSelect" accept=".pdf,.jpg,.jpeg,.png" style="display:none" />
            <button type="button" class="btn btn-subtle btn-sm" @click="($refs.fileInput as any).click()">选择文件</button>
            <span class="upload-hint" v-if="!selectedFile">支持 PDF、JPG、PNG，最大 10MB</span>
            <span class="upload-name" v-else>{{ selectedFile.name }}</span>
          </div>
        </div>
        <div class="form-group">
          <label class="form-label">申请备注</label>
          <textarea v-model="form.reason" class="form-input" rows="3" placeholder="选填：补充说明"></textarea>
        </div>
        <div class="form-actions">
          <button type="submit" class="btn btn-primary" :disabled="submitting || !form.destinationType || !form.destinationName || !selectedFile">
            {{ submitting ? '提交中...' : '提交申请' }}
          </button>
        </div>
      </form>
    </div>

    <!-- 申请记录 -->
    <div class="card" v-if="letters.length > 0">
      <h3 class="card-title">我的调档函申请记录</h3>
      <div class="request-list">
        <div class="request-item" v-for="req in letters" :key="req.pkLetter">
          <div class="request-info">
            <span class="request-type">{{ req.destinationType }} → {{ req.destinationName }}</span>
            <span class="request-time">{{ formatDateTime(req.createTime) }}</span>
          </div>
          <div class="request-status">
            <span :class="['badge', letterStatusBadge(req.status)]">{{ letterStatusLabel(req.status) }}</span>
            <span class="tracking-text" v-if="req.trackingNumber">单号：{{ req.trackingNumber }}</span>
          </div>
        </div>
      </div>
    </div>

    <div class="empty-state card" v-if="!student && !loading">
      <p class="empty-text">暂未关联学生信息，请联系管理员</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useUserStore } from '../../stores/user'
import { studentApi, archiveTransferApi, archiveApi } from '../../api/modules'

const userStore = useUserStore()
const student = ref<any>(null)
const loading = ref(true)
const submitting = ref(false)
const destination = ref<any>(null)
const letters = ref<any[]>([])
const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)

const form = reactive({
  destinationType: '',
  destinationName: '',
  destinationAddress: '',
  contactPerson: '',
  contactPhone: '',
  reason: ''
})

onMounted(async () => {
  try {
    const userId = userStore.userInfo?.userId
    if (userId) {
      const stuRes: any = await studentApi.getByUserId(userId)
      if (stuRes.data) {
        student.value = stuRes.data
        await Promise.all([loadDestination(), loadLetters()])
      }
    }
  } catch (e) {
    console.error('加载数据失败', e)
  } finally {
    loading.value = false
  }
})

async function loadDestination() {
  if (!student.value) return
  try {
    const res: any = await archiveTransferApi.getDestinationByStudentId(student.value.pkStudent)
    destination.value = res.data || null
  } catch (e) {
    console.error('加载去向信息失败', e)
  }
}

async function loadLetters() {
  if (!student.value) return
  try {
    const res: any = await archiveTransferApi.getLettersByStudentId(student.value.pkStudent)
    letters.value = res.data || []
  } catch (e) {
    console.error('加载申请记录失败', e)
  }
}

function handleFileSelect(e: Event) {
  const input = e.target as HTMLInputElement
  if (input.files && input.files.length > 0) {
    selectedFile.value = input.files[0]
  }
}

async function submitLetter() {
  if (!student.value?.pkStudent || !selectedFile.value) return
  submitting.value = true
  try {
    // 上传调档函文件
    const formData = new FormData()
    formData.append('file', selectedFile.value)
    formData.append('studentId', student.value.pkStudent.toString())
    formData.append('categoryId', '8') // 使用"其他材料"分类
    formData.append('uploadUserId', userStore.userInfo?.userId?.toString() || '')
    formData.append('description', '调档函')

    const uploadRes: any = await archiveApi.uploadFile(formData)

    // 提交调档函申请
    await archiveTransferApi.submitLetter({
      studentId: student.value.pkStudent,
      destinationType: form.destinationType,
      destinationName: form.destinationName,
      destinationAddress: form.destinationAddress,
      contactPerson: form.contactPerson,
      contactPhone: form.contactPhone,
      reason: form.reason,
      letterFilePath: uploadRes.data?.filePath || '',
      letterFileId: uploadRes.data?.pkArchiveFile || null
    })

    // 重置表单
    form.destinationType = ''
    form.destinationName = ''
    form.destinationAddress = ''
    form.contactPerson = ''
    form.contactPhone = ''
    form.reason = ''
    selectedFile.value = null

    await loadLetters()
  } catch (e: any) {
    alert(e.message || '提交失败')
  } finally {
    submitting.value = false
  }
}

function destinationBadge(d: any): string {
  if (!d) return ''
  if (d.status === '在校' || (!d.destinationType || d.destinationType === '本校')) return 'badge-success'
  if (d.status === '已寄出') return 'badge-warning'
  if (d.status === '已签收') return 'badge-success'
  return 'badge-warning'
}

function destinationStatus(d: any): string {
  if (!d) return '-'
  if (d.status === '在校' || (!d.destinationType || d.destinationType === '本校')) return '在校'
  return d.status || '待处理'
}

function letterStatusBadge(status: number): string {
  return ['badge-warning', 'badge-success', 'badge-danger', 'badge-info'][status] || 'badge-warning'
}

function letterStatusLabel(status: number): string {
  return ['待审核', '已通过', '已驳回', '已寄出'][status] || '未知'
}

function formatDateTime(dateStr: string): string {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleString('zh-CN')
}
</script>

<style scoped>
.student-transfer {
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.page-header { padding: 8px 0; }
.page-title-text {
  font-size: 20px;
  font-weight: 590;
  color: var(--text-primary);
  letter-spacing: -0.24px;
}
.page-desc {
  font-size: 14px;
  color: var(--text-tertiary);
  margin-top: 4px;
}
.card-title {
  font-size: 14px;
  font-weight: 590;
  color: var(--text-primary);
  margin-bottom: 16px;
  letter-spacing: -0.182px;
}
.destination-info {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.info-row {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
}
.info-label {
  color: var(--text-tertiary);
  min-width: 80px;
}
.info-value {
  color: var(--text-primary);
  font-weight: 510;
}
.apply-form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.required { color: var(--status-red); }
.form-row {
  display: flex;
  gap: 16px;
}
.form-group-half {
  flex: 1;
}
.upload-area {
  display: flex;
  align-items: center;
  gap: 10px;
}
.upload-hint {
  font-size: 12px;
  color: var(--text-quaternary);
}
.upload-name {
  font-size: 13px;
  color: var(--text-secondary);
}
.form-actions {
  display: flex;
  justify-content: flex-end;
  padding-top: 8px;
}
.request-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.request-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  background: var(--surface-03);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-md);
}
.request-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.request-type {
  font-size: 14px;
  font-weight: 510;
  color: var(--text-primary);
}
.request-time {
  font-size: 12px;
  color: var(--text-quaternary);
}
.request-status {
  display: flex;
  align-items: center;
  gap: 8px;
}
.tracking-text {
  font-size: 12px;
  color: var(--text-tertiary);
}
.empty-state {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px 24px;
}
.empty-text {
  font-size: 14px;
  color: var(--text-quaternary);
}
</style>
