<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header bg-primary text-white py-3">
                <h5 class="card-title mb-0">📅 Thay Đổi Ngày Giờ Khám (Đổi Lịch Hẹn #${requestScope.appointment.id})</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/customer" method="post">
                    <input type="hidden" name="action" value="reschedule">
                    <input type="hidden" name="id" value="${requestScope.appointment.id}">
                    
                    <!-- Select Doctor -->
                    <div class="mb-3">
                        <label for="doctor" class="form-label fw-bold">Chọn Bác Sĩ Khám</label>
                        <select class="form-select" id="doctor" name="doctor" required onchange="checkAvailability()">
                            <option value="">-- Chọn bác sĩ --</option>
                            <c:forEach var="d" items="${requestScope.doctors}">
                                <option value="${d.username}" ${d.username == requestScope.appointment.doctorUsername ? 'selected' : ''}>
                                    ${d.fullName} (${d.specialty})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Select Date -->
                    <div class="mb-3">
                        <label for="date" class="form-label fw-bold">Chọn Ngày Khám Mới</label>
                        <input type="date" class="form-control" id="date" name="date" value="${requestScope.appointment.appointmentDate}" required onchange="checkAvailability()">
                    </div>

                    <!-- Select Time Slot -->
                    <div class="mb-3">
                        <label for="timeslot" class="form-label fw-bold">Chọn Khung Giờ Mới</label>
                        <select class="form-select" id="timeslot" name="timeslot" required>
                            <option value="">-- Chọn khung giờ khám --</option>
                            <option value="08:00 - 09:00" ${requestScope.appointment.timeSlot == '08:00 - 09:00' ? 'selected' : ''}>08:00 - 09:00</option>
                            <option value="09:00 - 10:00" ${requestScope.appointment.timeSlot == '09:00 - 10:00' ? 'selected' : ''}>09:00 - 10:00</option>
                            <option value="10:00 - 11:00" ${requestScope.appointment.timeSlot == '10:00 - 11:00' ? 'selected' : ''}>10:00 - 11:00</option>
                            <option value="11:00 - 12:00" ${requestScope.appointment.timeSlot == '11:00 - 12:00' ? 'selected' : ''}>11:00 - 12:00</option>
                            <option value="13:30 - 14:30" ${requestScope.appointment.timeSlot == '13:30 - 14:30' ? 'selected' : ''}>13:30 - 14:30</option>
                            <option value="14:30 - 15:30" ${requestScope.appointment.timeSlot == '14:30 - 15:30' ? 'selected' : ''}>14:30 - 15:30</option>
                            <option value="15:30 - 16:30" ${requestScope.appointment.timeSlot == '15:30 - 16:30' ? 'selected' : ''}>15:30 - 16:30</option>
                            <option value="16:30 - 17:30" ${requestScope.appointment.timeSlot == '16:30 - 17:30' ? 'selected' : ''}>16:30 - 17:30</option>
                        </select>
                        <div id="availabilityNotice" class="form-text text-secondary mt-1"></div>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="${pageContext.request.contextPath}/customer" class="btn btn-outline-secondary">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary px-4 fw-bold">Xác Nhận Thay Đổi</button>
                    </div>
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

        fetch('${pageContext.request.contextPath}/customer?action=getSlots&doctor=' + doctor + '&date=' + date)
            .then(response => response.text())
            .then(data => {
                const bookedSlots = data ? data.split(',') : [];
                
                timeslotSelect.disabled = false;
                notice.innerHTML = "Đang kiểm tra lịch trống của bác sĩ...";
                
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
                notice.innerHTML = "Có " + availableCount + " khung giờ khả dụng cho ngày này.";
            })
            .catch(err => {
                console.error(err);
                notice.innerHTML = "Lỗi khi kiểm tra lịch.";
            });
    }

    // Trigger on load to set up options
    window.onload = function() {
        checkAvailability();
    }
</script>

<%@ include file="../footer.jsp" %>
