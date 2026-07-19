<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card p-4">
            <h3 class="text-center mb-4 text-primary fw-bold">⚙️ Quản Lý Hồ Sơ Cá Nhân</h3>
            <form action="${pageContext.request.contextPath}/profile" method="post">
                <div class="mb-3">
                    <label class="form-label fw-bold">Tên đăng nhập (Tài khoản)</label>
                    <input type="text" class="form-control bg-light" value="${sessionScope.user.username}" readonly>
                    <div class="form-text">Tên đăng nhập không thể thay đổi.</div>
                </div>
                
                <div class="mb-3">
                    <label for="fullName" class="form-label fw-bold">Họ và tên <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="fullName" name="fullName" value="${sessionScope.user.fullName}" required>
                </div>
                
                <div class="mb-3">
                    <label for="email" class="form-label fw-bold">Email</label>
                    <input type="email" class="form-control" id="email" name="email" value="${sessionScope.user.email}">
                </div>
                
                <div class="mb-3">
                    <label for="phone" class="form-label fw-bold">Số điện thoại <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="phone" name="phone" value="${sessionScope.user.phone}" required>
                </div>
                
                <div class="mb-3">
                    <label for="password" class="form-label fw-bold">Mật khẩu mới <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="password" name="password" value="${sessionScope.user.password}" placeholder="Nhập mật khẩu" required>
                </div>
                
                <div class="d-flex justify-content-between mt-4">
                    <a href="${pageContext.request.contextPath}/customer" class="btn btn-outline-secondary">Quay lại lịch sử</a>
                    <button type="submit" class="btn btn-primary px-4 fw-bold">Cập Nhật Hồ Sơ</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
