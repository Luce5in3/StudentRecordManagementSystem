import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/login',
      name: 'Login',
      component: () => import('../views/Login.vue'),
      meta: { requiresAuth: false }
    },
    // ===== 管理员路由 =====
    {
      path: '/',
      component: () => import('../layout/AppLayout.vue'),
      redirect: '/dashboard',
      meta: { roles: ['admin'] },
      children: [
        {
          path: 'dashboard',
          name: 'Dashboard',
          component: () => import('../views/Dashboard.vue'),
          meta: { title: '仪表盘', roles: ['admin'] }
        },
        {
          path: 'students',
          name: 'Students',
          component: () => import('../views/StudentList.vue'),
          meta: { title: '学生管理', roles: ['admin'] }
        },
        {
          path: 'archives',
          name: 'Archives',
          component: () => import('../views/ArchiveList.vue'),
          meta: { title: '档案管理', roles: ['admin'] }
        },
        {
          path: 'colleges',
          name: 'Colleges',
          component: () => import('../views/CollegeList.vue'),
          meta: { title: '学院管理', roles: ['admin'] }
        },
        {
          path: 'majors',
          name: 'Majors',
          component: () => import('../views/MajorList.vue'),
          meta: { title: '专业管理', roles: ['admin'] }
        },
        {
          path: 'classes',
          name: 'Classes',
          component: () => import('../views/ClassList.vue'),
          meta: { title: '班级管理', roles: ['admin'] }
        },
        {
          path: 'users',
          name: 'Users',
          component: () => import('../views/UserList.vue'),
          meta: { title: '用户管理', roles: ['admin'] }
        },
        {
          path: 'roles',
          name: 'Roles',
          component: () => import('../views/RoleList.vue'),
          meta: { title: '角色管理', roles: ['admin'] }
        },
        {
          path: 'notifications',
          name: 'Notifications',
          component: () => import('../views/NotificationCenter.vue'),
          meta: { title: '通知中心', roles: ['admin'] }
        },
        {
          path: 'notification-send',
          name: 'NotificationSend',
          component: () => import('../views/NotificationSend.vue'),
          meta: { title: '发布通知', roles: ['admin'] }
        },
        {
          path: 'export-audit',
          name: 'AdminExportAudit',
          component: () => import('../views/teacher/TeacherExportAudit.vue'),
          meta: { title: '导出审核', roles: ['admin'] }
        },
        {
          path: 'operation-logs',
          name: 'OperationLogs',
          component: () => import('../views/OperationLogList.vue'),
          meta: { title: '操作日志', roles: ['admin'] }
        },
        {
          path: 'archive-transfer',
          name: 'AdminArchiveTransfer',
          component: () => import('../views/AdminArchiveTransfer.vue'),
          meta: { title: '档案去向管理', roles: ['admin'] }
        }
      ]
    },
    // ===== 教师/辅导员路由 =====
    {
      path: '/teacher',
      component: () => import('../layout/AppLayout.vue'),
      redirect: '/teacher/dashboard',
      meta: { roles: ['counselor', 'archive_manager'] },
      children: [
        {
          path: 'dashboard',
          name: 'TeacherDashboard',
          component: () => import('../views/teacher/TeacherDashboard.vue'),
          meta: { title: '工作台', roles: ['counselor', 'archive_manager'] }
        },
        {
          path: 'students',
          name: 'TeacherStudents',
          component: () => import('../views/teacher/TeacherStudentList.vue'),
          meta: { title: '学生管理', roles: ['counselor', 'archive_manager'] }
        },
        {
          path: 'archives',
          name: 'TeacherArchives',
          component: () => import('../views/teacher/TeacherArchiveAudit.vue'),
          meta: { title: '档案审核', roles: ['counselor', 'archive_manager'] }
        },
        {
          path: 'grades',
          name: 'TeacherGrades',
          component: () => import('../views/teacher/TeacherGradeImport.vue'),
          meta: { title: '成绩导入', roles: ['counselor', 'archive_manager'] }
        },
        {
          path: 'awards',
          name: 'TeacherAwards',
          component: () => import('../views/teacher/TeacherAwardImport.vue'),
          meta: { title: '奖惩导入', roles: ['counselor', 'archive_manager'] }
        },
        {
          path: 'export-audit',
          name: 'TeacherExportAudit',
          component: () => import('../views/teacher/TeacherExportAudit.vue'),
          meta: { title: '导出申请审核', roles: ['counselor', 'archive_manager'] }
        },
        {
          path: 'archive-transfer',
          name: 'TeacherArchiveTransfer',
          component: () => import('../views/AdminArchiveTransfer.vue'),
          meta: { title: '档案去向管理', roles: ['counselor', 'archive_manager'] }
        },
        {
          path: 'notifications',
          name: 'TeacherNotifications',
          component: () => import('../views/NotificationCenter.vue'),
          meta: { title: '通知中心', roles: ['counselor', 'archive_manager'] }
        },
        {
          path: 'notification-send',
          name: 'TeacherNotificationSend',
          component: () => import('../views/NotificationSend.vue'),
          meta: { title: '发布通知', roles: ['counselor', 'archive_manager'] }
        }
      ]
    },
    // ===== 学生路由 =====
    {
      path: '/student',
      component: () => import('../layout/AppLayout.vue'),
      redirect: '/student/dashboard',
      meta: { roles: ['student'] },
      children: [
        {
          path: 'dashboard',
          name: 'StudentDashboard',
          component: () => import('../views/student/StudentDashboard.vue'),
          meta: { title: '我的主页', roles: ['student'] }
        },
        {
          path: 'profile',
          name: 'StudentProfile',
          component: () => import('../views/student/StudentProfile.vue'),
          meta: { title: '个人信息', roles: ['student'] }
        },
        {
          path: 'family',
          name: 'StudentFamily',
          component: () => import('../views/student/StudentFamily.vue'),
          meta: { title: '家庭信息', roles: ['student'] }
        },
        {
          path: 'grades',
          name: 'StudentGrades',
          component: () => import('../views/student/StudentGrades.vue'),
          meta: { title: '成绩档案', roles: ['student'] }
        },
        {
          path: 'awards',
          name: 'StudentAwards',
          component: () => import('../views/student/StudentAwards.vue'),
          meta: { title: '奖惩档案', roles: ['student'] }
        },
        {
          path: 'archive-apply',
          name: 'StudentArchiveApply',
          component: () => import('../views/student/StudentArchiveApply.vue'),
          meta: { title: '档案申请', roles: ['student'] }
        },
        {
          path: 'archive-upload',
          name: 'StudentArchiveUpload',
          component: () => import('../views/student/StudentArchiveUpload.vue'),
          meta: { title: '材料上传', roles: ['student'] }
        },
        {
          path: 'archive-history',
          name: 'StudentArchiveHistory',
          component: () => import('../views/student/StudentArchiveHistory.vue'),
          meta: { title: '档案申请记录', roles: ['student'] }
        },
        {
          path: 'transcript',
          name: 'StudentTranscript',
          component: () => import('../views/student/StudentTranscript.vue'),
          meta: { title: '成绩单', roles: ['student'] }
        },
        {
          path: 'export',
          name: 'StudentExport',
          component: () => import('../views/student/StudentExport.vue'),
          meta: { title: '档案导出', roles: ['student'] }
        },
        {
          path: 'transfer',
          name: 'StudentTransfer',
          component: () => import('../views/student/StudentTransferApply.vue'),
          meta: { title: '调档函申请', roles: ['student'] }
        },
        {
          path: 'notifications',
          name: 'StudentNotifications',
          component: () => import('../views/NotificationCenter.vue'),
          meta: { title: '通知中心', roles: ['student'] }
        }
      ]
    }
  ]
})

router.beforeEach((to) => {
  const token = localStorage.getItem('token')

  // 不需要认证的页面
  if (to.meta.requiresAuth === false) {
    return
  }

  // 未登录跳转登录页
  if (!token && to.path !== '/login') {
    return '/login'
  }

  // 检查角色权限
  const userInfoStr = localStorage.getItem('userInfo')
  if (userInfoStr && to.meta.roles) {
    try {
      const userInfo = JSON.parse(userInfoStr)
      const userRoles: string[] = userInfo.roles || []

      // 如果用户没有分配任何角色，重定向到登录页
      if (userRoles.length === 0) {
        return '/login'
      }

      const requiredRoles = to.meta.roles as string[]

      // 检查是否有权限访问
      const hasPermission = userRoles.some(role => requiredRoles.includes(role))
      if (!hasPermission) {
        // 重定向到对应角色的首页（防止循环跳转）
        if (userRoles.includes('student') && !to.path.startsWith('/student')) {
          return '/student/dashboard'
        } else if ((userRoles.includes('counselor') || userRoles.includes('archive_manager')) && !to.path.startsWith('/teacher')) {
          return '/teacher/dashboard'
        } else if (userRoles.includes('admin') && to.path.startsWith('/student') || to.path.startsWith('/teacher')) {
          return '/dashboard'
        }
      }
    } catch {
      // ignore
    }
  }
})

export default router
