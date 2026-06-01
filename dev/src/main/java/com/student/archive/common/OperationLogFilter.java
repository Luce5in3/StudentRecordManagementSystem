package com.student.archive.common;

import com.student.archive.entity.SysOperationLog;
import com.student.archive.mapper.SysOperationLogMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.core.annotation.Order;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * 操作日志过滤器，在 JWT 认证之后记录 POST/PUT/DELETE 操作
 */
@Component
@Order(10) // 在 JwtAuthenticationFilter 之后
@RequiredArgsConstructor
public class OperationLogFilter extends OncePerRequestFilter {

    private final SysOperationLogMapper sysOperationLogMapper;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        filterChain.doFilter(request, response);

        // 请求完成后记录写操作
        if (!isWriteMethod(request.getMethod())) return;
        String path = request.getRequestURI();
        if (!path.startsWith("/api/")) return;

        int status = response.getStatus();
        if (status < 200 || status >= 400) return;

        SysOperationLog log = new SysOperationLog();
        log.setUserId(getCurrentUserId());
        String module = extractModule(path);
        log.setModule(module);
        log.setOperation(describeOperation(request.getMethod(), path));
        log.setDescription("成功");
        log.setIp(getClientIp(request));

        try {
            sysOperationLogMapper.insert(log);
        } catch (Exception e) {
            // 静默失败，不影响业务流程
        }
    }

    @Override
    protected boolean shouldNotFilterErrorDispatch() {
        return false;
    }

    private boolean isWriteMethod(String method) {
        return "POST".equalsIgnoreCase(method)
                || "PUT".equalsIgnoreCase(method)
                || "DELETE".equalsIgnoreCase(method);
    }

    private Long getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof Long) {
            return (Long) auth.getPrincipal();
        }
        return null;
    }

    private String extractModule(String path) {
        if (path == null || path.isEmpty()) return "系统";
        String[] segments = path.replaceFirst("^/api/", "").split("/");
        String root = segments.length > 0 ? segments[0] : "";
        switch (root) {
            case "archive": return "档案管理";
            case "archive-transfer": return "档案去向";
            case "student": return "学生管理";
            case "user": return "用户管理";
            case "auth": return "认证";
            case "grade": return "成绩管理";
            case "award": return "奖惩管理";
            case "college": return "学院管理";
            case "major": return "专业管理";
            case "class": return "班级管理";
            case "notification": return "通知";
            case "operation-log": return "操作日志";
            case "role": return "角色管理";
            case "permission": return "权限管理";
            case "dashboard": return "仪表盘";
            default: return root.isEmpty() ? "系统" : root;
        }
    }

    private String describeOperation(String method, String path) {
        if (path.contains("/upload")) return "上传文件";
        if (path.contains("/audit")) return "审核";
        if (path.contains("/send")) return "发送";
        if (path.contains("/batch")) return "批量新增";
        if (path.contains("/export")) return "导出";
        if (path.contains("/resetPassword")) return "重置密码";
        if (path.contains("/assign")) return "分配";
        if ("DELETE".equalsIgnoreCase(method)) return "删除";
        if ("PUT".equalsIgnoreCase(method)) return "更新";
        if ("POST".equalsIgnoreCase(method)) return "新增";
        return "操作";
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty()) ip = request.getHeader("X-Real-IP");
        if (ip == null || ip.isEmpty()) ip = request.getRemoteAddr();
        return ip;
    }
}
