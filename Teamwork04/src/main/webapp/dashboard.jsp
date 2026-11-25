
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect("LoginController");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Dashboard | LinguaTech</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link rel="stylesheet"
        href="${pageContext.request.contextPath}/style.css">

    <style>
        .dashboard-container {
            min-height: 85vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .dashboard-box {
            width: 100%;
            max-width: 550px;
            padding: 45px;
            background: white;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 5px 25px rgba(0,0,0,0.08);
        }

        .dashboard-icon {
            font-size: 60px;
            margin-bottom: 15px;
        }

        .dashboard-subtitle {
            color: #6c757d;
            margin-bottom: 25px;
        }

        .dashboard-info {
            background: #e8f5ed;
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 25px;
        }

        .dashboard-button {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="container dashboard-container">

    <div class="dashboard-box">

        <div class="dashboard-icon">🌿</div>

        <h1>Dashboard</h1>

        <h2 class="mt-3">
            Hello, ${sessionScope.username}!
        </h2>

        <p class="dashboard-subtitle">
            You are successfully logged in.
            Welcome to your learning space!
        </p>

        <div class="dashboard-info">
            <p class="mb-0">
                <strong>Email:</strong> ${sessionScope.email}
            </p>
        </div>

        <a href="${pageContext.request.contextPath}/LessonListController"
            class="btn btn-primary dashboard-button mb-3">
            Start Learning
        </a>

        <a href="${pageContext.request.contextPath}/LogoutController"
            class="btn btn-outline-secondary dashboard-button">
            Logout
        </a>

    </div>

</div>

</body>
</html>
