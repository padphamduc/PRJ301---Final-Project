<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row mb-4">
    <div class="col-md-12">
        <a href="${pageContext.request.contextPath}/doctor" class="btn btn-outline-secondary btn-sm">&larr; Quay lại danh sách lịch khám</a>
    </div>
</div>

<div class="row">
    <!-- Patient Info Summary -->
    <div class="col-md-4">
        <div class="card bg-light border-0 mb-4">
            <div class="card-body">
                <h5 class="card-title text-primary fw-bold">Bệnh Nhân: ${requestScope.appointment.customerName}</h5>
                <hr>
                <p class="mb-2"><strong>Mã lịch hẹn:</strong> #${requestScope.appointment.id}</p>
                <p class="mb-2"><strong>Số điện thoại:</strong> ${requestScope.appointment.customerPhone}</p>
                <p class="mb-2"><strong>Thời gian khám:</strong> ${requestScope.appointment.appointmentDate} | ${requestScope.appointment.timeSlot}</p>
                <p class="mb-0"><strong>Triệu chứng ban đầu:</strong> <br>
                    <span class="text-secondary italic">${requestScope.appointment.symptoms != null ? requestScope.appointment.symptoms : 'Không có ghi chú'}</span>
                </p>
            </div>
        </div>
        
        <!-- Patient Medical History (Thành viên 3 - Lịch sử khám bệnh của khách) -->
        <div class="card border-primary">
            <div class="card-header bg-primary text-white py-2">
                <h6 class="card-title mb-0">📜 Lịch Sử Khám Bệnh</h6>
            </div>
            <div class="card-body p-3" style="max-height: 400px; overflow-y: auto;">
                <c:forEach var="hist" items="${requestScope.medicalHistory}">
                    <c:if var="isNotCurrent" test="${hist.id != requestScope.appointment.id}">
                        <div class="border-bottom pb-2 mb-2">
                            <div class="d-flex justify-content-between">
                                <small class="text-primary fw-bold">📅 Ngày: ${hist.appointmentDate}</small>
                                <span class="badge bg-secondary small">${hist.status}</span>
                            </div>
                            <div class="small"><strong>Chẩn đoán:</strong> ${hist.diagnosis}</div>
                            <div class="small"><strong>Bác sĩ:</strong> ${hist.doctorName}</div>
                            <div class="small"><strong>Triệu chứng:</strong> ${hist.symptoms}</div>
                        </div>
                    </c:if>
                </c:forEach>
                <c:if test="${empty requestScope.medicalHistory || (empty requestScope.medicalHistory[1] && requestScope.medicalHistory[0].id == requestScope.appointment.id)}">
                    <p class="text-muted small text-center mb-0">Chưa có lịch sử khám bệnh trước đây.</p>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Treatment Form -->
    <div class="col-md-8">
        <div class="card">
            <div class="card-header bg-danger text-white py-3">
                <h5 class="card-title mb-0">🩺 Phiếu Chẩn Đoán & Kê Đơn Điều Trị</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/doctor" method="post">
                    <input type="hidden" name="id" value="${requestScope.appointment.id}">
                    
                    <c:choose>
                        <c:when test="${requestScope.appointment.status == 'CheckedIn' || requestScope.appointment.status == 'Examining'}">
                            <!-- Input Symptoms -->
                            <div class="mb-3">
                                <label for="symptoms" class="form-label fw-bold">Triệu chứng lâm sàng ghi nhận</label>
                                <input type="text" class="form-control" id="symptoms" name="symptoms" value="${requestScope.appointment.symptoms}" required>
                            </div>

                            <!-- Input Diagnosis -->
                            <div class="mb-3">
                                <label for="diagnosis" class="form-label fw-bold">Chẩn đoán của bác sĩ <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="diagnosis" name="diagnosis" rows="3" placeholder="Ví dụ: Răng số 46 sâu mặt nhai, sưng nướu nhẹ..." required>${requestScope.appointment.diagnosis}</textarea>
                            </div>

                            <!-- Services Prescribed -->
                            <div class="mb-4">
                                <label class="form-label fw-bold">Chỉ định dịch vụ thực hiện</label>
                                <div class="border rounded p-3 bg-light" style="max-height: 200px; overflow-y: auto;">
                                    <c:forEach var="s" items="${requestScope.allServices}">
                                        <c:set var="isChecked" value="false"/>
                                        <c:forEach var="currS" items="${requestScope.currentServices}">
                                            <c:if test="${currS.id == s.id}">
                                                <c:set var="isChecked" value="true"/>
                                            </c:if>
                                        </c:forEach>
                                        
                                        <div class="form-check mb-2">
                                            <input class="form-check-input" type="checkbox" name="services" value="${s.id}" id="service_${s.id}" ${isChecked ? 'checked' : ''}>
                                            <label class="form-check-label" for="service_${s.id}">
                                                <strong>${s.name}</strong> - <span class="text-success">${s.price}đ</span>
                                                <div class="text-muted small">${s.description}</div>
                                            </label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Medicines Prescribed -->
                            <div class="mb-4">
                                <label class="form-label fw-bold">Kê đơn thuốc điều trị</label>
                                <div class="table-responsive border rounded p-2 bg-light">
                                    <table class="table table-sm table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th style="width: 50px;">Chọn</th>
                                                <th>Tên Thuốc</th>
                                                <th>Đơn Giá</th>
                                                <th style="width: 100px;">Số Lượng</th>
                                                <th>Hướng Dẫn Sử Dụng</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="m" items="${requestScope.allMedicines}">
                                                <tr>
                                                    <td class="text-center">
                                                        <input class="form-check-input" type="checkbox" name="medicines" value="${m.id}" id="med_${m.id}" onchange="toggleMedRow(${m.id})">
                                                    </td>
                                                    <td>
                                                        <label for="med_${m.id}" class="fw-bold m-0">${m.name}</label>
                                                        <div class="text-secondary small">Còn lại: ${m.stockQuantity} ${m.unit}</div>
                                                    </td>
                                                    <td>${m.price}đ / ${m.unit}</td>
                                                    <td>
                                                        <input type="number" name="qty_${m.id}" id="qty_${m.id}" value="1" min="1" max="${m.stockQuantity}" disabled class="form-control form-control-sm" required>
                                                    </td>
                                                    <td>
                                                        <input type="text" name="inst_${m.id}" id="inst_${m.id}" disabled class="form-control form-control-sm" placeholder="Ví dụ: Uống 2 lần/ngày sau ăn">
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-danger w-100 py-2 fw-bold">Hoàn Tất Khám & Lưu Đơn</button>
                        </c:when>
                        
                        <c:otherwise>
                            <!-- View only mode -->
                            <div class="alert alert-success">Ca khám này đã được ghi chẩn đoán và điều trị thành công.</div>
                            <div class="mb-3">
                                <strong>Triệu chứng ghi nhận:</strong> ${requestScope.appointment.symptoms}
                            </div>
                            <div class="mb-3">
                                <strong>Chẩn đoán cuối cùng:</strong> ${requestScope.appointment.diagnosis}
                            </div>
                            <div class="mb-4">
                                <strong>Dịch vụ đã thực hiện:</strong>
                                <ul>
                                    <c:forEach var="currS" items="${requestScope.currentServices}">
                                        <li>${currS.name} (${currS.price}đ)</li>
                                    </c:forEach>
                                </ul>
                            </div>
                            <div class="mb-4">
                                <strong>Đơn thuốc đã kê:</strong>
                                <div class="table-responsive">
                                    <table class="table table-bordered table-sm">
                                        <thead>
                                            <tr>
                                                <th>Tên Thuốc</th>
                                                <th>Đơn Giá</th>
                                                <th>Số Lượng Kê</th>
                                                <th>Đã Mua</th>
                                                <th>Hướng Dẫn</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="p" items="${appointmentDAO.getPrescriptionsByAppointment(requestScope.appointment.id)}">
                                                <tr>
                                                    <td>${p.medicineName}</td>
                                                    <td>${p.medicinePrice}đ</td>
                                                    <td>${p.quantity} ${p.medicineUnit}</td>
                                                    <td>${p.boughtQuantity} ${p.medicineUnit}</td>
                                                    <td>${p.instructions}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function toggleMedRow(id) {
        const checked = document.getElementById('med_' + id).checked;
        document.getElementById('qty_' + id).disabled = !checked;
        document.getElementById('inst_' + id).disabled = !checked;
        if (!checked) {
            document.getElementById('qty_' + id).value = 1;
            document.getElementById('inst_' + id).value = "";
        }
    }
</script>

<%@ include file="../footer.jsp" %>
