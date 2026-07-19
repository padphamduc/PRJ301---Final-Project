<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card p-4">
            <h3 class="text-center mb-4 text-primary fw-bold">Đăng Ký Tài Khoản Khách Hàng</h3>
            <form action="${pageContext.request.contextPath}/signup" method="post">
                <div class="mb-3">
                    <label for="username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required>
                </div>
                <div class="mb-3">
                    <label for="fullName" class="form-label">Họ và tên <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Nhập họ và tên đầy đủ" required>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="example@gmail.com">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="phone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="phone" name="phone" placeholder="Nhập số điện thoại" required>
                    </div>
                </div>
                <button type="submit" class="btn btn-success w-100 py-2 fw-bold">Đăng Ký</button>
            </form>
            <div class="text-center mt-3">
                <span>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="text-decoration-none">Đăng nhập</a></span>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
