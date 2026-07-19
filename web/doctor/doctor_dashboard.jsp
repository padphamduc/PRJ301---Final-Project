<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header bg-primary text-white py-3">
                <h5 class="card-title mb-0">👨‍⚕️ Lịch Khám & Chỉ Định Điều Trị Của Bác Sĩ</h5>
            </div>
            <div class="card-body">
                <p class="card-text">Bảng theo dõi và tiếp nhận bệnh nhân của bác sĩ trong phòng khám:</p>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Bệnh Nhân</th>
                                <th>Thời Gian Khám</th>
                                <th>Triệu Chứng Ghi Nhận</th>
                                <th>Phòng Khám</th>
                                <th>Trạng Thái</th>
                                <th style="width: 180px;">Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${requestScope.appointments}">
                                <c:if test="${app.status != 'Cancelled'}">
                                    <tr>
                                        <td>
                                            <div class="fw-bold">${app.customerName}</div>
                                            <small class="text-secondary">📞 SĐT: ${app.customerPhone}</small>
                                        </td>
                                        <td>
                                            <div>${app.appointmentDate}</div>
                                            <small class="badge bg-secondary">${app.timeSlot}</small>
                                        </td>
                                        <td>
                                            <div class="text-muted small">${app.symptoms != null ? app.symptoms : 'Không ghi chú'}</div>
                                        </td>
                                        <td>
                                            <span class="fw-semibold text-danger">${app.assignedRoom != null ? app.assignedRoom : 'Chưa xếp phòng'}</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${app.status == 'Pending'}">
                                                    <span class="badge bg-warning text-dark">Lịch online (Chưa check-in)</span>
                                                </c:when>
                                                <c:when test="${app.status == 'CheckedIn'}">
                                                    <span class="badge bg-info text-white">Chờ khám</span>
                                                </c:when>
                                                <c:when test="${app.status == 'Examining'}">
                                                    <span class="badge bg-danger">🩺 Đang Khám...</span>
                                                </c:when>
                                                <c:when test="${app.status == 'Completed'}">
                                                    <span class="badge bg-primary">Khám xong (Chờ TT)</span>
                                                    <div class="small mt-1"><strong>CĐ:</strong> ${app.diagnosis}</div>
                                                </c:when>
                                                <c:when test="${app.status == 'Paid'}">
                                                    <span class="badge bg-success">Hoàn thành & Đã thanh toán</span>
                                                    <div class="small mt-1"><strong>CĐ:</strong> ${app.diagnosis}</div>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${app.status == 'CheckedIn' || app.status == 'Examining'}">
                                                    <a href="${pageContext.request.contextPath}/doctor?id=${app.id}" class="btn btn-danger btn-sm fw-bold w-100">🩺 Vào Khám & Kê Đơn</a>
                                                </c:when>
                                                <c:when test="${app.status == 'Completed' || app.status == 'Paid'}">
                                                    <a href="${pageContext.request.contextPath}/doctor?id=${app.id}" class="btn btn-outline-primary btn-sm w-100 py-0 small">Xem Hồ Sơ Khám</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:if test="${empty requestScope.appointments}">
                                <tr>
                                    <td colspan="6" class="text-center text-secondary py-4">Bác sĩ chưa được gán lịch khám nào hôm nay.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
