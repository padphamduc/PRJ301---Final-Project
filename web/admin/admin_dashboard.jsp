<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../header.jsp" %>

<div class="row mb-4 text-center">
    <div class="col-md-12">
        <h2 class="fw-bold text-primary">⚙️ BẢNG QUẢN TRỊ HỆ THỐNG</h2>
        <p class="text-secondary">Quản trị phân quyền tài khoản người dùng, cập nhật danh mục dịch vụ điều trị và các loại dược phẩm.</p>
    </div>
</div>

<!-- Tabs Navigation -->
<ul class="nav nav-tabs mb-4" id="adminTabs" role="tablist">
    <li class="nav-item">
        <button class="nav-link active fw-bold" id="users-tab" data-bs-toggle="tab" data-bs-target="#users" type="button" role="tab">👥 Quản Lý Người Dùng</button>
    </li>
    <li class="nav-item">
        <button class="nav-link fw-bold" id="services-tab" data-bs-toggle="tab" data-bs-target="#services" type="button" role="tab">🦷 Danh Mục Dịch Vụ</button>
    </li>
    <li class="nav-item">
        <button class="nav-link fw-bold" id="medicines-tab" data-bs-toggle="tab" data-bs-target="#medicines" type="button" role="tab">💊 Quản Lý Kho Thuốc</button>
    </li>
</ul>

<!-- Tabs Content -->
<div class="tab-content" id="adminTabsContent">
    
    <!-- 1. Users Tab -->
    <div class="tab-pane fade show active" id="users" role="tabpanel">
        <div class="card">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center py-3">
                <h5 class="card-title mb-0">Danh Sách Người Dùng</h5>
                <a href="${pageContext.request.contextPath}/admin?action=addUser" class="btn btn-light btn-sm fw-bold text-primary">+ Thêm Thành Viên Hệ Thống</a>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Tên Tài Khoản</th>
                                <th>Họ Và Tên</th>
                                <th>Vai Trò</th>
                                <th>Liên Hệ</th>
                                <th>Chi Tiết Bác Sĩ</th>
                                <th class="text-center" style="width: 150px;">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${requestScope.users}">
                                <tr>
                                    <td><code class="fw-bold">${u.username}</code></td>
                                    <td class="fw-bold">${u.fullName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.role == 'admin'}"><span class="badge bg-dark">Quản trị viên (Admin)</span></c:when>
                                            <c:when test="${u.role == 'receptionist'}"><span class="badge bg-warning text-dark">Tiếp tân (Recept)</span></c:when>
                                            <c:when test="${u.role == 'doctor'}"><span class="badge bg-danger">Bác sĩ (Doctor)</span></c:when>
                                            <c:when test="${u.role == 'customer'}"><span class="badge bg-secondary">Khách hàng (Customer)</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <small class="d-block">📧 ${u.email}</small>
                                        <small class="d-block">📞 ${u.phone}</small>
                                    </td>
                                    <td>
                                        <!-- Doctor details from doctors mapping -->
                                        <c:if test="${u.role == 'doctor'}">
                                            <c:forEach var="d" items="${requestScope.doctors}">
                                                <c:if test="${d.username == u.username}">
                                                    <div class="small"><strong>CK:</strong> ${d.specialty}</div>
                                                    <div class="small text-danger"><strong>Phòng:</strong> ${d.room}</div>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${u.username == 'admin'}">
                                                <span class="text-muted small">Mặc định</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/admin?action=editUser&username=${u.username}" class="btn btn-outline-primary btn-sm me-1 py-0 px-2">Sửa</a>
                                                <a href="${pageContext.request.contextPath}/admin?action=deleteUser&username=${u.username}" class="btn btn-outline-danger btn-sm py-0 px-2" onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này?')">Xóa</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- 2. Services Tab -->
    <div class="tab-pane fade" id="services" role="tabpanel">
        <div class="card">
            <div class="card-header bg-success text-white d-flex justify-content-between align-items-center py-3">
                <h5 class="card-title mb-0">Danh Mục Dịch Vụ Điều Trị</h5>
                <a href="${pageContext.request.contextPath}/admin?action=addService" class="btn btn-light btn-sm fw-bold text-success">+ Thêm Dịch Vụ Mới</a>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 80px;">Mã DV</th>
                                <th>Tên Dịch Vụ Nha Khoa</th>
                                <th>Chi Tiết Mô Tả</th>
                                <th class="text-end" style="width: 150px;">Bảng Giá (VNĐ)</th>
                                <th class="text-center" style="width: 150px;">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="s" items="${requestScope.services}">
                                <tr>
                                    <td>#${s.id}</td>
                                    <td class="fw-bold text-primary">${s.name}</td>
                                    <td class="text-muted small">${s.description}</td>
                                    <td class="text-end fw-bold text-success">
                                        <fmt:formatNumber value="${s.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/admin?action=editService&id=${s.id}" class="btn btn-outline-primary btn-sm me-1 py-0 px-2">Sửa</a>
                                        <a href="${pageContext.request.contextPath}/admin?action=deleteService&id=${s.id}" class="btn btn-outline-danger btn-sm py-0 px-2" onclick="return confirm('Bạn có chắc muốn xóa dịch vụ này?')">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- 3. Medicines Tab -->
    <div class="tab-pane fade" id="medicines" role="tabpanel">
        <div class="card">
            <div class="card-header bg-info text-white d-flex justify-content-between align-items-center py-3">
                <h5 class="card-title mb-0" style="color: white !important;">Quản Lý Kho Dược Phẩm</h5>
                <a href="${pageContext.request.contextPath}/admin?action=addMedicine" class="btn btn-light btn-sm fw-bold text-info">+ Thêm Dược Phẩm Mới</a>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 80px;">Mã</th>
                                <th>Tên Dược Phẩm</th>
                                <th>Đơn Vị Tính</th>
                                <th class="text-center">Số Lượng Tồn Kho</th>
                                <th class="text-end" style="width: 150px;">Đơn Giá (VNĐ)</th>
                                <th class="text-center" style="width: 150px;">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="m" items="${requestScope.medicines}">
                                <tr>
                                    <td>#${m.id}</td>
                                    <td class="fw-bold">${m.name}</td>
                                    <td><span class="badge bg-secondary">${m.unit}</span></td>
                                    <td class="text-center fw-bold text-danger">
                                        ${m.stockQuantity} ${m.unit}
                                    </td>
                                    <td class="text-end fw-bold text-success">
                                        <fmt:formatNumber value="${m.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </td>
                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/admin?action=editMedicine&id=${m.id}" class="btn btn-outline-primary btn-sm me-1 py-0 px-2">Sửa</a>
                                        <a href="${pageContext.request.contextPath}/admin?action=deleteMedicine&id=${m.id}" class="btn btn-outline-danger btn-sm py-0 px-2" onclick="return confirm('Bạn có chắc muốn xóa dược phẩm này?')">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
