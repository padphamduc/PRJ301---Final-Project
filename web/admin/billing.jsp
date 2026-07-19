<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<style>
    /* CSS for Print Receipt - Thành viên 4 */
    @media print {
        body {
            background-color: #fff !important;
            color: #000 !important;
            font-size: 11pt;
        }
        nav.navbar, footer, .no-print, .btn, .alert {
            display: none !important;
        }
        .container {
            width: 100% !important;
            max-width: 100% !important;
            margin: 0 !important;
            padding: 0 !important;
        }
        .card {
            border: none !important;
            box-shadow: none !important;
        }
        .card-header {
            background: none !important;
            color: #000 !important;
            border-bottom: 2px dashed #000 !important;
            text-align: center !important;
        }
        .table {
            border-collapse: collapse !important;
            width: 100% !important;
        }
        .table th, .table td {
            border: 1px solid #ddd !important;
            padding: 8px !important;
        }
        .table-light {
            background-color: #f2f2f2 !important;
        }
    }
</style>

<div class="row justify-content-center">
    <div class="col-md-9">
        <div class="card shadow-lg border-0 rounded-3">
            <div class="card-header bg-success text-white py-3 text-center">
                <h4 class="mb-0 fw-bold">🏥 HÓA ĐƠN CHI TIẾT DỊCH VỤ & THUỐC</h4>
                <small>Mã hóa đơn: #BILL-${requestScope.appointment.id}</small>
            </div>
            
            <div class="card-body p-4">
                <!-- Patient & Diagnosis Info -->
                <div class="row mb-4">
                    <div class="col-md-6 border-end">
                        <h6 class="text-secondary fw-bold">THÔNG TIN KHÁCH HÀNG</h6>
                        <p class="mb-1"><strong>Họ tên:</strong> ${requestScope.appointment.customerName}</p>
                        <p class="mb-1"><strong>Điện thoại:</strong> ${requestScope.appointment.customerPhone}</p>
                        <p class="mb-0"><strong>Bác sĩ chỉ định:</strong> ${requestScope.appointment.doctorName}</p>
                    </div>
                    <div class="col-md-6 ps-md-4">
                        <h6 class="text-secondary fw-bold">CHẨN ĐOÁN & ĐIỀU TRỊ</h6>
                        <p class="mb-1"><strong>Triệu chứng:</strong> ${requestScope.appointment.symptoms}</p>
                        <p class="mb-1"><strong>Chẩn đoán răng:</strong> <span class="text-danger fw-bold">${requestScope.appointment.diagnosis}</span></p>
                        <p class="mb-0"><strong>Trạng thái:</strong> 
                            <c:choose>
                                <c:when test="${requestScope.appointment.status == 'Completed'}">
                                    <span class="badge bg-warning text-dark">Chờ Thanh Toán</span>
                                </c:when>
                                <c:when test="${requestScope.appointment.status == 'Paid'}">
                                    <span class="badge bg-success">Đã Thanh Toán</span>
                                </c:when>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/billing" method="post" id="paymentForm">
                    <input type="hidden" name="id" value="${requestScope.appointment.id}">
                    
                    <!-- 1. Services Section -->
                    <div class="mb-4">
                        <h6 class="text-primary fw-bold border-bottom pb-2">1. CÁC DỊCH VỤ ĐÃ THỰC HIỆN</h6>
                        <table class="table table-sm align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Tên Dịch Vụ</th>
                                    <th>Mô Tả</th>
                                    <th class="text-end" style="width: 150px;">Đơn Giá (VNĐ)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="servicesTotal" value="0"/>
                                <c:forEach var="s" items="${requestScope.services}">
                                    <tr>
                                        <td class="fw-bold">${s.name}</td>
                                        <td class="text-secondary small">${s.description}</td>
                                        <td class="text-end fw-bold">${s.price}đ</td>
                                    </tr>
                                    <c:set var="servicesTotal" value="${servicesTotal + s.price}"/>
                                </c:forEach>
                                <c:if test="${empty requestScope.services}">
                                    <tr>
                                        <td colspan="3" class="text-center text-secondary py-3">Không thực hiện dịch vụ.</td>
                                    </tr>
                                </c:if>
                                <tr class="table-light fw-bold">
                                    <td colspan="2">Cộng khoản dịch vụ:</td>
                                    <td class="text-end text-primary">${servicesTotal}đ</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 2. Prescriptions Section (Thành viên 4 - Mua một phần thuốc) -->
                    <div class="mb-4">
                        <h6 class="text-primary fw-bold border-bottom pb-2">2. ĐƠN THUỐC ĐÃ KÊ (TÙY CHỌN SỐ LƯỢNG MUA THỰC TẾ)</h6>
                        <table class="table table-sm align-middle" id="medicineTable">
                            <thead class="table-light">
                                <tr>
                                    <th>Tên Thuốc</th>
                                    <th>Đơn Giá</th>
                                    <th>Kê Đơn</th>
                                    <th style="width: 130px;">Số Lượng Mua</th>
                                    <th>Hướng Dẫn</th>
                                    <th class="text-end" style="width: 150px;">Thành Tiền (VNĐ)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="medicinesTotal" value="0"/>
                                <c:forEach var="p" items="${requestScope.prescriptions}">
                                    <tr class="medicine-row" data-price="${p.medicinePrice}">
                                        <td>
                                            <div class="fw-bold">${p.medicineName}</div>
                                            <input type="hidden" name="medIds" value="${p.medicineId}">
                                        </td>
                                        <td>${p.medicinePrice}đ / ${p.medicineUnit}</td>
                                        <td>${p.quantity} ${p.medicineUnit}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${requestScope.appointment.status == 'Completed' && sessionScope.user.role == 'receptionist'}">
                                                    <!-- Editable input for receptionist -->
                                                    <input type="number" name="buyQty_${p.medicineId}" id="buyQty_${p.medicineId}" 
                                                           value="${p.quantity}" min="0" max="${p.quantity}" 
                                                           class="form-control form-control-sm buy-qty-input" 
                                                           onchange="calculateTotal()" onkeyup="calculateTotal()">
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Read-only mode -->
                                                    <c:choose>
                                                        <c:when test="${requestScope.appointment.status == 'Paid'}">
                                                            <strong>${p.boughtQuantity}</strong> ${p.medicineUnit}
                                                            <input type="hidden" name="buyQty_${p.medicineId}" value="${p.boughtQuantity}">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span>${p.quantity} ${p.medicineUnit} (Chờ mua)</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-secondary small">${p.instructions}</td>
                                        <td class="text-end fw-bold medicine-subtotal">
                                            <c:choose>
                                                <c:when test="${requestScope.appointment.status == 'Paid'}">
                                                    ${p.medicinePrice * p.boughtQuantity}đ
                                                    <c:set var="medicinesTotal" value="${medicinesTotal + (p.medicinePrice * p.boughtQuantity)}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    ${p.medicinePrice * p.quantity}đ
                                                    <c:set var="medicinesTotal" value="${medicinesTotal + (p.medicinePrice * p.quantity)}"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty requestScope.prescriptions}">
                                    <tr>
                                        <td colspan="6" class="text-center text-secondary py-3">Không có đơn thuốc.</td>
                                    </tr>
                                </c:if>
                                <tr class="table-light fw-bold">
                                    <td colspan="5">Cộng khoản thuốc:</td>
                                    <td class="text-end text-primary" id="medTotalText">${medicinesTotal}đ</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 3. Grand Total Section -->
                    <div class="alert alert-primary d-flex justify-content-between align-items-center p-3 mb-4">
                        <h5 class="alert-heading mb-0 fw-bold text-primary">TỔNG CỘNG HÓA ĐƠN:</h5>
                        <h3 class="mb-0 fw-bold text-danger" id="grandTotalText">${servicesTotal + medicinesTotal}đ</h3>
                    </div>

                    <!-- Actions -->
                    <div class="d-flex justify-content-between no-print">
                        <c:choose>
                            <c:when test="${sessionScope.user.role == 'receptionist'}">
                                <a href="${pageContext.request.contextPath}/receptionist" class="btn btn-outline-secondary">Quay lại quầy lễ tân</a>
                                <div>
                                    <button type="button" onclick="window.print()" class="btn btn-primary me-2 fw-bold">🖨️ In Hóa Đơn</button>
                                    <c:if test="${requestScope.appointment.status == 'Completed'}">
                                        <button type="submit" class="btn btn-success px-4 py-2 fw-bold">💵 Xác Nhận Thanh Toán</button>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/customer" class="btn btn-outline-secondary">Quay lại lịch sử</a>
                                <button type="button" onclick="window.print()" class="btn btn-primary fw-bold">🖨️ In Hóa Đơn</button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    const servicesTotal = ${servicesTotal};

    function calculateTotal() {
        let medicinesTotal = 0;
        const rows = document.querySelectorAll('.medicine-row');
        
        rows.forEach(row => {
            const price = parseFloat(row.getAttribute('data-price'));
            const input = row.querySelector('.buy-qty-input');
            if (input) {
                const qty = parseInt(input.value) || 0;
                const max = parseInt(input.getAttribute('max')) || 0;
                
                let finalQty = qty;
                if (qty < 0) {
                    finalQty = 0;
                    input.value = 0;
                } else if (qty > max) {
                    finalQty = max;
                    input.value = max;
                }
                
                const subtotal = price * finalQty;
                row.querySelector('.medicine-subtotal').innerText = subtotal + "đ";
                medicinesTotal += subtotal;
            }
        });
        
        document.getElementById('medTotalText').innerText = medicinesTotal + "đ";
        document.getElementById('grandTotalText').innerText = (servicesTotal + medicinesTotal) + "đ";
    }
</script>

<%@ include file="../footer.jsp" %>
