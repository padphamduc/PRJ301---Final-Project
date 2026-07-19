<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phòng Khám Nha Khoa DentalCare</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .navbar-brand {
            font-weight: bold;
            color: #0d6efd !important;
        }
        .nav-link {
            font-weight: 500;
        }
        .card {
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom shadow-sm mb-4">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">🦷 DentalCare</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">Trang Chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/services">Dịch Vụ & Bảng Giá</a>
                </li>
                
                <c:if test="${not empty sessionScope.user}">
                    <c:choose>
                        <c:when test="${sessionScope.user.role == 'customer'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/customer">Đặt Lịch Hẹn</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/profile">Hồ Sơ Cá Nhân</a>
                            </li>
                        </c:when>
                        <c:when test="${sessionScope.user.role == 'receptionist'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/receptionist">Quầy Tiếp Đón</a>
                            </li>
                        </c:when>
                        <c:when test="${sessionScope.user.role == 'doctor'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/doctor">Lịch Khám Bác Sĩ</a>
                            </li>
                        </c:when>
                        <c:when test="${sessionScope.user.role == 'admin'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin">Quản Trị Hệ Thống</a>
                            </li>
                        </c:when>
                    </c:choose>
                </c:if>
            </ul>
            
            <div class="d-flex align-items-center">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary btn-sm me-2">Đăng Nhập</a>
                        <a href="${pageContext.request.contextPath}/signup" class="btn btn-primary btn-sm">Đăng Ký</a>
                    </c:when>
                    <c:otherwise>
                        <span class="text-secondary me-3">Xin chào, <strong>${sessionScope.user.fullName}</strong> (${sessionScope.user.role})</span>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Đăng Xuất</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<div class="container pb-5">
    
    <%-- Alerts for success/error messages --%>
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
