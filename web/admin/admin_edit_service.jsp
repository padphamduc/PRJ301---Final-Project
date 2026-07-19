<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header bg-primary text-white py-3">
                <h5 class="card-title mb-0">${requestScope.title}</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="saveService">
                    <input type="hidden" name="id" value="${requestScope.service != null ? requestScope.service.id : '0'}">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label fw-bold">Tên Dịch Vụ Nha Khoa <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" name="name" value="${requestScope.service.name}" placeholder="Ví dụ: Tẩy trắng răng Laser" required>
                    </div>

                    <div class="mb-3">
                        <label for="price" class="form-label fw-bold">Đơn Giá (VNĐ) <span class="text-danger">*</span></label>
                        <input type="number" step="1000" class="form-control" id="price" name="price" value="${requestScope.service != null ? requestScope.service.price : ''}" placeholder="Nhập số tiền" required>
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label fw-bold">Mô tả chi tiết dịch vụ</label>
                        <textarea class="form-control" id="description" name="description" rows="4" placeholder="Nhập mô tả về tác dụng, quy trình thực hiện dịch vụ...">${requestScope.service.description}</textarea>
                    </div>

                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-secondary">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary px-4 fw-bold">Lưu dịch vụ</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
