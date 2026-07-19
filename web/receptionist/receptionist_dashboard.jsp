<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row">
    <!-- Today's Appointments & Search -->
    <div class="col-md-8">
        <div class="card">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center py-3">
                <h5 class="card-title mb-0">📋 Quầy Lễ Tân - Quản Lý Lịch Khám</h5>
                <form action="${pageContext.request.contextPath}/receptionist" method="get" class="d-flex" style="width: 350px;">
                    <input type="text" class="form-control form-control-sm me-2" name="searchKeyword" placeholder="Tìm bằng Tên hoặc SĐT..." value="${param.searchKeyword}">
                    <button type="submit" class="btn btn-light btn-sm text-primary fw-bold">Tìm Kiếm</button>
                    <c:if test="${not empty param.searchKeyword}">
                        <a href="${pageContext.request.contextPath}/receptionist" class="btn btn-outline-light btn-sm ms-1">Reset</a>
                    </c:if>
                </form>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Khách Hàng</th>
                                <th>Bác Sĩ & Phòng</th>
                                <th>Thời Gian</th>
                                <th>Trạng Thái</th>
                                <th style="width: 250px;">Cập Nhật & Điều Phối</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${requestScope.appointments}">
                                <tr>
                                    <td>
                                        <div class="fw-bold">${app.customerName}</div>
                                        <small class="text-secondary">📞 ${app.customerPhone}</small>
                                    </td>
                                    <td>
                                        <div>${app.doctorName}</div>
                                        <small class="text-danger fw-bold">
                                            Phòng: ${app.assignedRoom != null ? app.assignedRoom : 'Chưa xếp'}
                                        </small>
                                    </td>
                                    <td>
                                        <div>${app.appointmentDate}</div>
                                        <small class="badge bg-secondary">${app.timeSlot}</small>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${app.status == 'Pending'}">
                                                <span class="badge bg-warning text-dark">Chờ khám (Online)</span>
                                            </c:when>
                                            <c:when test="${app.status == 'CheckedIn'}">
                                                <span class="badge bg-info text-white">Đã check-in (Chờ khám)</span>
                                            </c:when>
                                            <c:when test="${app.status == 'Examining'}">
                                                <span class="badge bg-danger">Đang khám</span>
                                            </c:when>
                                            <c:when test="${app.status == 'Completed'}">
                                                <span class="badge bg-primary">Khám xong (Chờ TT)</span>
                                            </c:when>
                                            <c:when test="${app.status == 'Paid'}">
                                                <span class="badge bg-success">Đã thanh toán</span>
                                            </c:when>
                                            <c:when test="${app.status == 'Cancelled'}">
                                                <span class="badge bg-secondary">Đã hủy lịch</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="d-flex flex-column gap-2">
                                            <!-- Checkin Option -->
                                            <c:if test="${app.status == 'Pending'}">
                                                <form action="${pageContext.request.contextPath}/receptionist" method="post" class="d-flex">
                                                    <input type="hidden" name="action" value="checkin">
                                                    <input type="hidden" name="id" value="${app.id}">
                                                    <input type="text" name="assignedRoom" value="Phòng 101" class="form-control form-control-sm me-1" style="width: 100px;" required>
                                                    <button type="submit" class="btn btn-warning btn-sm fw-bold py-0 px-2 text-dark">Checkin</button>
                                                </form>
                                            </c:if>

                                            <!-- Status updates when checked in/examining -->
                                            <c:if test="${app.status == 'CheckedIn' || app.status == 'Examining' || app.status == 'Pending'}">
                                                <form action="${pageContext.request.contextPath}/receptionist" method="post" class="d-flex align-items-center">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="id" value="${app.id}">
                                                    <select name="status" class="form-select form-select-sm me-1" onchange="this.form.submit()">
                                                        <option value="">-- Trạng thái --</option>
                                                        <option value="Pending" ${app.status == 'Pending' ? 'disabled selected' : ''}>Đã đặt (Pending)</option>
                                                        <option value="CheckedIn" ${app.status == 'CheckedIn' ? 'disabled selected' : ''}>Đã đến (CheckedIn)</option>
                                                        <option value="Examining" ${app.status == 'Examining' ? 'disabled selected' : ''}>Đang khám (Examining)</option>
                                                        <option value="Cancelled" ${app.status == 'Cancelled' ? 'disabled selected' : ''}>Hủy lịch (Cancelled)</option>
                                                    </select>
                                                </form>
                                            </c:if>

                                            <!-- Room Coordinator -->
                                            <c:if test="${app.status == 'CheckedIn' || app.status == 'Examining'}">
                                                <form action="${pageContext.request.contextPath}/receptionist" method="post" class="d-flex">
                                                    <input type="hidden" name="action" value="updateRoom">
                                                    <input type="hidden" name="id" value="${app.id}">
                                                    <input type="text" name="assignedRoom" value="${app.assignedRoom}" class="form-control form-control-sm me-1" style="width: 100px;" required>
                                                    <button type="submit" class="btn btn-outline-danger btn-sm py-0 px-1">Chuyển P.</button>
                                                </form>
                                            </c:if>

                                            <!-- Payments -->
                                            <c:if test="${app.status == 'Completed'}">
                                                <a href="${pageContext.request.contextPath}/billing?id=${app.id}" class="btn btn-success btn-sm fw-bold">💵 Thu Tiền & Hóa Đơn</a>
                                            </c:if>
                                            <c:if test="${app.status == 'Paid'}">
                                                <a href="${pageContext.request.contextPath}/billing?id=${app.id}" class="btn btn-outline-secondary btn-sm py-0 small">Xem Hóa Đơn</a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty requestScope.appointments}">
                                <tr>
                                    <td colspan="5" class="text-center text-secondary py-4">Không có lịch hẹn nào tương ứng.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Walk-in Counter Booking Form -->
    <div class="col-md-4">
        <div class="card">
            <div class="card-header bg-success text-white py-3">
                <h5 class="card-title mb-0">🏥 Đăng Ký Khám Tại Quầy</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/receptionist" method="post">
                    <input type="hidden" name="action" value="book">
                    
                    <div class="mb-3">
                        <label for="customerName" class="form-label fw-bold">Họ và tên khách hàng</label>
                        <input type="text" class="form-control" id="customerName" name="customerName" placeholder="Tên khách hàng" required>
                    </div>

                    <div class="mb-3">
                        <label for="customerPhone" class="form-label fw-bold">Số điện thoại khách</label>
                        <input type="text" class="form-control" id="customerPhone" name="customerPhone" placeholder="Số điện thoại khách" required>
                    </div>

                    <div class="mb-3">
                        <label for="doctor" class="form-label fw-bold">Chọn Bác Sĩ Khám</label>
                        <select class="form-select" id="doctor" name="doctor" required onchange="checkAvailability()">
                            <option value="">-- Chọn bác sĩ --</option>
                            <c:forEach var="d" items="${requestScope.doctors}">
                                <option value="${d.username}">${d.fullName} (${d.specialty})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="date" class="form-label fw-bold">Chọn Ngày Khám</label>
                        <input type="date" class="form-control" id="date" name="date" required onchange="checkAvailability()">
                    </div>

                    <div class="mb-3">
                        <label for="timeslot" class="form-label fw-bold">Chọn Khung Giờ</label>
                        <select class="form-select" id="timeslot" name="timeslot" required disabled>
                            <option value="">-- Chọn bác sĩ và ngày trước --</option>
                            <option value="08:00 - 09:00">08:00 - 09:00</option>
                            <option value="09:00 - 10:00">09:00 - 10:00</option>
                            <option value="10:00 - 11:00">10:00 - 11:00</option>
                            <option value="11:00 - 12:00">11:00 - 12:00</option>
                            <option value="13:30 - 14:30">13:30 - 14:30</option>
                            <option value="14:30 - 15:30">14:30 - 15:30</option>
                            <option value="15:30 - 16:30">15:30 - 16:30</option>
                            <option value="16:30 - 17:30">16:30 - 17:30</option>
                        </select>
                        <div id="availabilityNotice" class="form-text text-secondary mt-1"></div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Dịch vụ (Mặc định: Khám tổng quát)</label>
                        <div class="border rounded p-3 bg-light" style="max-height: 150px; overflow-y: auto;">
                            <c:forEach var="s" items="${requestScope.services}">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="services" value="${s.id}" id="service_${s.id}">
                                    <label class="form-check-label" for="service_${s.id}">
                                        ${s.name} (${s.price}đ)
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="symptoms" class="form-label fw-bold">Triệu chứng/Ghi chú</label>
                        <textarea class="form-control" id="symptoms" name="symptoms" rows="2" placeholder="Sưng đau răng..."></textarea>
                    </div>

                    <button type="submit" class="btn btn-success w-100 py-2 fw-bold">Tạo Lịch Khám & Check-in</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('date').min = today;

    function checkAvailability() {
        const doctor = document.getElementById('doctor').value;
        const date = document.getElementById('date').value;
        const timeslotSelect = document.getElementById('timeslot');
        const notice = document.getElementById('availabilityNotice');
        
        if (!doctor || !date) {
            timeslotSelect.disabled = true;
            timeslotSelect.selectedIndex = 0;
            notice.innerHTML = "";
            return;
        }

        fetch('${pageContext.request.contextPath}/receptionist?action=getSlots&doctor=' + doctor + '&date=' + date)
            .then(response => response.text())
            .then(data => {
                const bookedSlots = data ? data.split(',') : [];
                
                timeslotSelect.disabled = false;
                notice.innerHTML = "Đang kiểm tra khung giờ trống...";
                
                let availableCount = 0;
                for (let i = 1; i < timeslotSelect.options.length; i++) {
                    const opt = timeslotSelect.options[i];
                    if (bookedSlots.includes(opt.value)) {
                        opt.disabled = true;
                        opt.text = opt.value + " (Bận)";
                    } else {
                        opt.disabled = false;
                        opt.text = opt.value;
                        availableCount++;
                    }
                }
                
                if (timeslotSelect.value && timeslotSelect.options[timeslotSelect.selectedIndex].disabled) {
                    timeslotSelect.value = "";
                }
                
                notice.innerHTML = "Có " + availableCount + " khung giờ trống.";
                timeslotSelect.options[0].text = availableCount > 0 ? "-- Chọn khung giờ khám --" : "-- Hết giờ --";
            })
            .catch(err => {
                console.error(err);
                notice.innerHTML = "Lỗi khi kiểm tra lịch.";
            });
    }
</script>

<%@ include file="../footer.jsp" %>
