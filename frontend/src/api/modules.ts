import api from './index'

// ===== 仪表盘 =====
export const dashboardApi = {
  getStats: () => api.get('/dashboard/stats'),
}

// ===== 认证 =====
export const authApi = {
  login: (data: { username: string; password: string }) => api.post('/auth/login', data),
  getUserInfo: () => api.get('/auth/info'),
}

// ===== 用户管理 =====
export const userApi = {
  getById: (id: number) => api.get(`/user/${id}`),
  getList: (params: any) => api.get('/user/list', { params }),
  add: (data: any) => api.post('/user', data),
  update: (data: any) => api.put('/user', data),
  delete: (id: number) => api.delete(`/user/${id}`),
  updateStatus: (id: number, status: number) => api.put(`/user/${id}/status/${status}`),
  resetPassword: (id: number, newPassword: string) => api.put(`/user/${id}/resetPassword`, null, { params: { newPassword } }),
}

// ===== 角色管理 =====
export const roleApi = {
  getById: (id: number) => api.get(`/role/${id}`),
  getList: () => api.get('/role/list'),
  getByUserId: (userId: number) => api.get(`/role/user/${userId}`),
  add: (data: any) => api.post('/role', data),
  update: (data: any) => api.put('/role', data),
  delete: (id: number) => api.delete(`/role/${id}`),
  assignRoles: (userId: number, roleIds: number[]) => api.post(`/role/assign/${userId}`, roleIds),
}

// ===== 权限管理 =====
export const permissionApi = {
  getList: () => api.get('/permission/list'),
  getByUserId: (userId: number) => api.get(`/permission/user/${userId}`),
  add: (data: any) => api.post('/permission', data),
  update: (data: any) => api.put('/permission', data),
  delete: (id: number) => api.delete(`/permission/${id}`),
  assignPermissions: (roleId: number, permIds: number[]) => api.post(`/permission/assign/${roleId}`, permIds),
}

// ===== 学院管理 =====
export const collegeApi = {
  getById: (id: number) => api.get(`/college/${id}`),
  getAll: () => api.get('/college/all'),
  getList: (params?: any) => api.get('/college/list', { params }),
  add: (data: any) => api.post('/college', data),
  update: (data: any) => api.put('/college', data),
  delete: (id: number) => api.delete(`/college/${id}`),
}

// ===== 专业管理 =====
export const majorApi = {
  getById: (id: number) => api.get(`/major/${id}`),
  getList: (params?: any) => api.get('/major/list', { params }),
  getByCollegeId: (collegeId: number) => api.get(`/major/college/${collegeId}`),
  add: (data: any) => api.post('/major', data),
  update: (data: any) => api.put('/major', data),
  delete: (id: number) => api.delete(`/major/${id}`),
}

// ===== 班级管理 =====
export const classApi = {
  getById: (id: number) => api.get(`/class/${id}`),
  getList: (params?: any) => api.get('/class/list', { params }),
  getByMajorId: (majorId: number) => api.get(`/class/major/${majorId}`),
  add: (data: any) => api.post('/class', data),
  update: (data: any) => api.put('/class', data),
  delete: (id: number) => api.delete(`/class/${id}`),
}

// ===== 学生管理 =====
export const studentApi = {
  getById: (id: number) => api.get(`/student/${id}`),
  getByStudentNo: (no: string) => api.get(`/student/no/${no}`),
  getByUserId: (userId: number) => api.get(`/student/user/${userId}`),
  getDetail: (id: number) => api.get(`/student/${id}/detail`),
  getList: (params: any) => api.get('/student/list', { params }),
  add: (data: any) => api.post('/student', data),
  update: (data: any) => api.put('/student', data),
  delete: (id: number) => api.delete(`/student/${id}`),
  updateStatus: (id: number, status: string) => api.put(`/student/${id}/status`, null, { params: { status } }),
  updateDetail: (id: number, data: any) => api.put(`/student/${id}/detail`, data),
}

// ===== 档案管理 =====
export const archiveApi = {
  getCategoryList: () => api.get('/archive/category/list'),
  addCategory: (data: any) => api.post('/archive/category', data),
  updateCategory: (data: any) => api.put('/archive/category', data),
  deleteCategory: (id: number) => api.delete(`/archive/category/${id}`),
  getFileById: (id: number) => api.get(`/archive/file/${id}`),
  getFileByPath: (filePath: string) => api.get('/archive/file/by-path', { params: { filePath } }),
  getFilesByStudentId: (studentId: number) => api.get(`/archive/file/student/${studentId}`),
  getFileList: (params: any) => api.get('/archive/file/list', { params }),
  addFile: (data: any) => api.post('/archive/file', data),
  uploadFile: (formData: FormData) => api.post('/archive/file/upload', formData, {
    timeout: 60000
  }),
  previewFile: (id: number) => api.get(`/archive/file/${id}/preview`, { responseType: 'blob' }),
  deleteFile: (id: number) => api.delete(`/archive/file/${id}`),
  auditFile: (id: number, params: any) => api.put(`/archive/file/${id}/audit`, null, { params }),
  // 导出申请
  submitExportRequest: (data: any) => api.post('/archive/export-request', data),
  getExportRequestById: (id: number) => api.get(`/archive/export-request/${id}`),
  getExportRequestsByStudentId: (studentId: number) => api.get(`/archive/export-request/student/${studentId}`),
  getExportRequestList: (params: any) => api.get('/archive/export-request/list', { params }),
  auditExportRequest: (id: number, params: any) => api.put(`/archive/export-request/${id}/audit`, null, { params }),
  getValidApprovedRequest: (params: any) => api.get('/archive/export-request/valid', { params }),
}

// ===== 通知管理 =====
export const notificationApi = {
  getList: (params: any) => api.get('/notification/list', { params }),
  getSentList: (params: any) => api.get('/notification/sent', { params }),
  send: (data: { title: string; content: string; senderId: number; targetUserIds: number[] }) => api.post('/notification/send', data),
  countUnread: (targetUserId: number) => api.get('/notification/unread/count', { params: { targetUserId } }),
  markAsRead: (id: number) => api.put(`/notification/${id}/read`),
  markAllAsRead: (targetUserId: number) => api.put('/notification/readAll', null, { params: { targetUserId } }),
}

// ===== 成绩管理 =====
export const gradeApi = {
  getById: (id: number) => api.get(`/grade/${id}`),
  getByStudentId: (studentId: number) => api.get(`/grade/student/${studentId}`),
  getList: (params: any) => api.get('/grade/list', { params }),
  add: (data: any) => api.post('/grade', data),
  batchAdd: (data: any[]) => api.post('/grade/batch', data),
  update: (data: any) => api.put('/grade', data),
  delete: (id: number) => api.delete(`/grade/${id}`),
}

// ===== 奖项管理 =====
export const awardApi = {
  getById: (id: number) => api.get(`/award/${id}`),
  getByStudentId: (studentId: number) => api.get(`/award/student/${studentId}`),
  getList: (params: any) => api.get('/award/list', { params }),
  add: (data: any) => api.post('/award', data),
  batchAdd: (data: any[]) => api.post('/award/batch', data),
  update: (data: any) => api.put('/award', data),
  delete: (id: number) => api.delete(`/award/${id}`),
}

// ===== 操作日志 =====
export const operationLogApi = {
  getList: (params: any) => api.get('/operation-log/list', { params }),
}

// ===== 档案去向 & 调档函 =====
export const archiveTransferApi = {
  // 档案去向
  getDestinationById: (id: number) => api.get(`/archive-transfer/destination/${id}`),
  getDestinationByStudentId: (studentId: number) => api.get(`/archive-transfer/destination/student/${studentId}`),
  getDestinationList: (params: any) => api.get('/archive-transfer/destination/list', { params }),
  saveOrUpdateDestination: (data: any) => api.post('/archive-transfer/destination', data),
  sendArchive: (id: number, params: any) => api.put(`/archive-transfer/destination/${id}/send`, null, { params }),
  // 调档函
  getLetterById: (id: number) => api.get(`/archive-transfer/letter/${id}`),
  getLettersByStudentId: (studentId: number) => api.get(`/archive-transfer/letter/student/${studentId}`),
  getLetterList: (params: any) => api.get('/archive-transfer/letter/list', { params }),
  submitLetter: (data: any) => api.post('/archive-transfer/letter', data),
  auditLetter: (id: number, params: any) => api.put(`/archive-transfer/letter/${id}/audit`, null, { params }),
  sendTransferArchive: (id: number, params: any) => api.put(`/archive-transfer/letter/${id}/send`, null, { params }),
}
