<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../header.jsp" %>

<div class="p-5 mb-4 bg-primary text-white rounded-3 shadow">
    <div class="container-fluid py-3">
        <h1 class="display-5 fw-bold">🦷 Nha Khoa Thẩm Mỹ DentalCare</h1>
        <p class="col-md-8 fs-4">Chăm sóc nụ cười của bạn bằng sự tận tâm, công nghệ hiện đại và đội ngũ bác sĩ chuyên nghiệp hàng đầu.</p>
        <c:choose>
            <c:when test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-light btn-lg text-primary fw-bold">Đặt Lịch Hẹn Ngay</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/${sessionScope.user.role}" class="btn btn-light btn-lg text-primary fw-bold">Vào Trang Quản Lý</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div class="row">
    <!-- Working Hours -->
    <div class="col-md-4 mb-4">
        <div class="card h-100 border-primary">
            <div class="card-header bg-primary text-white py-3">
                <h5 class="card-title mb-0">🕒 Thời Gian Hoạt Động</h5>
            </div>
            <div class="card-body">
                <p class="card-text">Chào mừng quý khách đến với phòng khám của chúng tôi. Lịch làm việc chi tiết:</p>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        Thứ Hai - Thứ Sáu
                        <span class="badge bg-primary rounded-pill">08:00 - 17:30</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        Thứ Bảy & Chủ Nhật
                        <span class="badge bg-primary rounded-pill">08:30 - 17:00</span>
                    </li>
                </ul>
                <div class="alert alert-info mt-3 small mb-0">
                    <strong>Lưu ý:</strong> Vui lòng đặt lịch hẹn trước trên ứng dụng để tránh phải chờ đợi khi đến khám trực tiếp.
                </div>
            </div>
        </div>
    </div>

    <!-- Services & Pricing List -->
    <div class="col-md-8 mb-4">
        <div class="card h-100">
            <div class="card-header bg-success text-white py-3">
                <h5 class="card-title mb-0">✨ Dịch Vụ Nổi Bật</h5>
            </div>
            <div class="card-body">
                <p class="card-text">Chúng tôi cung cấp đa dạng các dịch vụ nha khoa chất lượng cao:</p>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Tên Dịch Vụ</th>
                                <th>Chi Tiết Mô Tả</th>
                                <th class="text-end" style="width: 150px;">Bảng Giá (VNĐ)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="s" items="${requestScope.services}">
                                <tr>
                                    <td class="fw-bold text-primary">${s.name}</td>
                                    <td class="text-muted small">${s.description}</td>
                                    <td class="text-end fw-bold text-success">
                                        <fmt:formatNumber value="${s.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty requestScope.services}">
                                <tr>
                                    <td colspan="3" class="text-center text-secondary py-4">Chưa có dịch vụ nào trong danh sách.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                <div class="text-center mt-3">
                    <a href="${pageContext.request.contextPath}/services" class="btn btn-outline-success btn-sm">Xem Toàn Bộ Dịch Vụ & Bảng Giá</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
