<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row">
    <!-- Booking Form -->
    <div class="col-md-5">
        <div class="card card-primary">
            <div class="card-header bg-primary text-white py-3">
                <h5 class="card-title mb-0">📅 Đặt Lịch Hẹn Khám Online</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/customer" method="post" id="bookingForm">
                    <!-- Select Doctor -->
                    <div class="mb-3">
                        <label for="doctor" class="form-label fw-bold">Chọn Bác Sĩ</label>
                        <select class="form-select" id="doctor" name="doctor" required onchange="checkAvailability()">
                            <option value="">-- Chọn bác sĩ khám --</option>
                            <c:forEach var="d" items="${requestScope.doctors}">
                                <option value="${d.username}">${d.fullName} (${d.specialty})</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Select Date -->
                    <div class="mb-3">
                        <label for="date" class="form-label fw-bold">Chọn Ngày Khám</label>
                        <input type="date" class="form-control" id="date" name="date" required onchange="checkAvailability()">
                    </div>

                    <!-- Select Time Slot -->
                    <div class="mb-3">
                        <label for="timeslot" class="form-label fw-bold">Chọn Khung Giờ</label>
                        <select class="form-select" id="timeslot" name="timeslot" required disabled>
                            <option value="">-- Trước tiên vui lòng chọn bác sĩ và ngày --</option>
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

                    <!-- Services Checkboxes -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">Dịch Vụ Mong Muốn (Hoặc để trống nếu khám tổng quát)</label>
                        <div class="border rounded p-3 bg-light" style="max-height: 200px; overflow-y: auto;">
                            <c:forEach var="s" items="${requestScope.services}">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="checkbox" name="services" value="${s.id}" id="service_${s.id}">
                                    <label class="form-check-label" for="service_${s.id}">
                                        ${s.name} (<span class="text-success fw-bold">${s.price}đ</span>)
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Symptoms -->
                    <div class="mb-3">
                        <label for="symptoms" class="form-label fw-bold">Mô tả triệu chứng / Ghi chú</label>
                        <textarea class="form-control" id="symptoms" name="symptoms" rows="2" placeholder="Ví dụ: Đau nhức răng số 7, sưng nướu..."></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold" id="submitBtn">Xác Nhận Đặt Lịch</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Booking History -->
    <div class="col-md-7">
        <div class="card">
            <div class="card-header bg-success text-white py-3">
                <h5 class="card-title mb-0">📋 Danh Sách Lịch Hẹn Đã Đặt</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Mã Lịch</th>
                                <th>Bác Sĩ</th>
                                <th>Thời Gian</th>
                                <th>Trạng Thái</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${requestScope.myAppointments}">
                                <tr>
                                    <td>#${app.id}</td>
                                    <td>
                                        <div class="fw-bold">${app.doctorName}</div>
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
                                                <span class="badge bg-info text-white">Đã đến (Đang xếp hàng)</span>
                                                <div class="small text-danger fw-bold mt-1">Phòng: ${app.assignedRoom}</div>
                                            </c:when>
                                            <c:when test="${app.status == 'Examining'}">
                                                <span class="badge bg-danger">Đang trong phòng khám</span>
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
                                        <c:choose>
                                            <c:when test="${app.status == 'Pending'}">
                                                <div class="d-flex flex-column gap-1">
                                                    <a href="${pageContext.request.contextPath}/customer?action=reschedule&id=${app.id}" class="btn btn-outline-primary btn-sm py-0 small">Đổi lịch</a>
                                                    <a href="${pageContext.request.contextPath}/customer?action=cancel&id=${app.id}" class="btn btn-outline-danger btn-sm py-0 small" onclick="return confirm('Bạn có chắc muốn hủy lịch khám này?')">Hủy lịch</a>
                                                </div>
                                            </c:when>
                                            <c:when test="${app.status == 'Completed' || app.status == 'Paid'}">
                                                <a href="${pageContext.request.contextPath}/billing?id=${app.id}" class="btn btn-outline-success btn-sm py-0 px-2 small">Xem Hóa Đơn</a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty requestScope.myAppointments}">
                                <tr>
                                    <td colspan="5" class="text-center text-secondary py-4">Bạn chưa đặt lịch hẹn nào.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
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

        fetch('${pageContext.request.contextPath}/customer?action=getSlots&doctor=' + doctor + '&date=' + date)
            .then(response => response.text())
            .then(data => {
                const bookedSlots = data ? data.split(',') : [];
                
                timeslotSelect.disabled = false;
                notice.innerHTML = "Đang tải danh sách khung giờ trống...";
                
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
