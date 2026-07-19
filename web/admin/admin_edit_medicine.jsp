<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../header.jsp" %>

<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header bg-success text-white py-3">
                <h5 class="card-title mb-0" style="color: white !important;">${requestScope.title}</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin" method="post">
                    <input type="hidden" name="action" value="saveMedicine">
                    <input type="hidden" name="id" value="${requestScope.medicine != null ? requestScope.medicine.id : '0'}">
                    
                    <div class="mb-3">
                        <label for="name" class="form-label fw-bold">Tên Dược Phẩm <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="name" name="name" value="${requestScope.medicine.name}" placeholder="Ví dụ: Paracetamol 500mg" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="price" class="form-label fw-bold">Đơn Giá (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" step="100" class="form-control" id="price" name="price" value="${requestScope.medicine != null ? requestScope.medicine.price : ''}" placeholder="Giá bán" required>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="unit" class="form-label fw-bold">Đơn Vị Tính <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="unit" name="unit" value="${requestScope.medicine != null ? requestScope.medicine.unit : ''}" placeholder="Viên / Chai / Tuýp..." required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="stockQuantity" class="form-label fw-bold">Số Lượng Nhập Kho (Tồn kho) <span class="text-danger">*</span></label>
                        <input type="number" min="0" class="form-control" id="stockQuantity" name="stockQuantity" value="${requestScope.medicine != null ? requestScope.medicine.stockQuantity : '0'}" required>
                    </div>

                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-secondary">Hủy bỏ</a>
                        <button type="submit" class="btn btn-success px-4 fw-bold text-white">Lưu dược phẩm</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
