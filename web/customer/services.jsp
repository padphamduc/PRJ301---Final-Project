<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../header.jsp" %>

<div class="row mb-4">
    <div class="col-md-12 text-center">
        <h2 class="fw-bold text-primary">✨ BẢNG GIÁ & CHI TIẾT DỊCH VỤ NHA KHOA</h2>
        <p class="text-secondary">Cam kết mang lại chất lượng phục vụ tốt nhất cùng bảng giá minh bạch, hợp lý.</p>
    </div>
</div>

<div class="row justify-content-center">
    <div class="col-md-10">
        <div class="card p-3">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 80px;">Mã</th>
                            <th>Tên Dịch Vụ Nha Khoa</th>
                            <th>Mô Tả Chi Tiết</th>
                            <th class="text-end" style="width: 180px;">Đơn Giá (VNĐ)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${requestScope.services}">
                            <tr>
                                <td><span class="badge bg-secondary">DV-${s.id}</span></td>
                                <td class="fw-bold text-primary">${s.name}</td>
                                <td class="text-muted small">${s.description}</td>
                                <td class="text-end fw-bold text-success">
                                    <fmt:formatNumber value="${s.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty requestScope.services}">
                            <tr>
                                <td colspan="4" class="text-center text-secondary py-4">Hiện tại không có dịch vụ nào khả dụng.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <div class="text-center mt-4">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary px-4 fw-bold">Đăng Nhập Để Đặt Lịch Khám</a>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'customer'}">
                        <a href="${pageContext.request.contextPath}/customer" class="btn btn-primary px-4 fw-bold">Đặt Lịch Hẹn Ngay</a>
                    </c:when>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
