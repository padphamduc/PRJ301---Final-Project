<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-md-5">
        <div class="card p-4">
            <h3 class="text-center mb-4 text-primary fw-bold">Đăng Nhập</h3>
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label for="username" class="form-label">Tên đăng nhập</label>
                    <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required>
                </div>
                <button type="submit" class="btn btn-primary w-100 py-2 fw-bold">Đăng Nhập</button>
            </form>
            <div class="text-center mt-3">
                <span>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/signup" class="text-decoration-none">Đăng ký ngay</a></span>
            </div>
        </div>
        
        <div class="card p-3 mt-3 bg-light text-secondary">
            <h6 class="fw-bold mb-2">Tài khoản chạy thử (Demo Accounts):</h6>
            <ul class="mb-0 small">
                <li>Admin: <code>admin</code> / <code>123</code></li>
                <li>Tiếp tân (Receptionist): <code>recept</code> / <code>123</code></li>
                <li>Bác sĩ 1 (Doctor): <code>doc_minh</code> / <code>123</code></li>
                <li>Bác sĩ 2 (Doctor): <code>doc_kien</code> / <code>123</code></li>
                <li>Khách hàng (Customer): <code>cus_duc</code> / <code>123</code></li>
            </ul>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
