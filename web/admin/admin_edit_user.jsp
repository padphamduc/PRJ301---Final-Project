<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-md-7">
        <div class="card">
            <div class="card-header bg-primary text-white py-3">
                <h5 class="card-title mb-0">${requestScope.title}</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="saveUser">
                    <input type="hidden" name="isEdit" value="${requestScope.targetUser != null ? 'true' : 'false'}">
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="username" class="form-label fw-bold">Tên đăng nhập <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="username" name="username" 
                                   value="${requestScope.targetUser.username}" 
                                   ${requestScope.targetUser != null ? 'readonly bg-light' : ''} 
                                   placeholder="Tên tài khoản duy nhất" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="password" class="form-label fw-bold">Mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="password" name="password" 
                                   value="${requestScope.targetUser.password}" placeholder="Mật khẩu tài khoản" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="fullName" class="form-label fw-bold">Họ và tên thành viên <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="fullName" name="fullName" 
                               value="${requestScope.targetUser.fullName}" placeholder="Nhập tên đầy đủ" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label fw-bold">Email</label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   value="${requestScope.targetUser.email}" placeholder="example@dental.com">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="phone" class="form-label fw-bold">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="phone" name="phone" 
                                   value="${requestScope.targetUser.phone}" placeholder="Nhập SĐT" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="role" class="form-label fw-bold">Vai Trò Hệ Thống <span class="text-danger">*</span></label>
                        <select class="form-select" id="role" name="role" required onchange="toggleRoleFields()" 
                                ${requestScope.targetUser != null ? 'disabled bg-light' : ''}>
                            <option value="receptionist" ${requestScope.targetUser.role == 'receptionist' ? 'selected' : ''}>Nhân viên lễ tân (receptionist)</option>
                            <option value="doctor" ${requestScope.targetUser.role == 'doctor' ? 'selected' : ''}>Bác sĩ nha khoa (doctor)</option>
                            <option value="admin" ${requestScope.targetUser.role == 'admin' ? 'selected' : ''}>Quản trị viên (admin)</option>
                        </select>
                        <c:if test="${requestScope.targetUser != null}">
                            <input type="hidden" name="role" value="${requestScope.targetUser.role}">
                        </c:if>
                    </div>

                    <!-- Doctor Specific Fields -->
                    <div id="doctorFields" style="${requestScope.targetUser.role == 'doctor' ? 'display: block;' : 'display: none;'}">
                        <hr>
                        <h6 class="text-danger fw-bold mb-3">Thông Tin Phân Công Bác Sĩ</h6>
                        
                        <div class="mb-3">
                            <label for="specialty" class="form-label fw-bold">Chuyên khoa chuyên môn</label>
                            <input type="text" class="form-control" id="specialty" name="specialty" 
                                   value="${requestScope.targetUser.role == 'doctor' ? requestScope.targetUser.specialty : ''}" 
                                   placeholder="Ví dụ: Chỉnh nha thẩm mỹ...">
                        </div>

                        <div class="mb-3">
                            <label for="room" class="form-label fw-bold">Phòng khám gán</label>
                            <input type="text" class="form-control" id="room" name="room" 
                                   value="${requestScope.targetUser.role == 'doctor' ? requestScope.targetUser.room : ''}" 
                                   placeholder="Ví dụ: Phòng Khám 101 (Tầng 1)">
                        </div>
                    </div>

                    <div class="d-flex justify-content-between mt-4">
                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-secondary">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary px-4 fw-bold">Lưu tài khoản</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function toggleRoleFields() {
        const role = document.getElementById("role").value;
        const doctorFields = document.getElementById("doctorFields");
        const specialty = document.getElementById("specialty");
        const room = document.getElementById("room");
        
        if (role === "doctor") {
            doctorFields.style.display = "block";
            specialty.required = true;
            room.required = true;
        } else {
            doctorFields.style.display = "none";
            specialty.required = false;
            room.required = false;
            specialty.value = "";
            room.value = "";
        }
    }
    
    window.onload = function() {
        toggleRoleFields();
    };
</script>

<%@ include file="../footer.jsp" %>
