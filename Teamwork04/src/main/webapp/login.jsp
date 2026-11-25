
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Login | LinguaTech</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link rel="stylesheet" href="style.css">

    <style>
        .login-container {
            min-height: 85vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-box {
            width: 100%;
            max-width: 450px;
            padding: 40px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.08);
        }

        .login-title {
            text-align: center;
            margin-bottom: 25px;
        }

        .login-icon {
            font-size: 55px;
            text-align: center;
        }

        .login-button {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="container login-container">

    <div class="login-box">

        <div class="login-icon">🌿</div>

        <div class="login-title">
            <h2>Welcome Back!</h2>
            <p class="text-muted">
                Login to continue your learning journey.
            </p>
        </div>

        <%
            String error = request.getParameter("error");

            if ("invalid".equals(error)) {
        %>
            <div class="alert alert-danger">
                Incorrect email or password. Please try again.
            </div>
        <%
            } else if ("empty".equals(error)) {
        %>
            <div class="alert alert-warning">
                Please enter your email and password.
            </div>
        <%
            }
        %>

        <form action="LoginController" method="post">

            <div class="mb-3">
                <label class="form-label">Email Address</label>
                <input type="email"
                    name="email"
                    class="form-control"
                    placeholder="Enter your email"
                    required>
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password"
                    name="password"
                    class="form-control"
                    placeholder="Enter your password"
                    required>
            </div>

            <button type="submit"
                class="btn btn-primary login-button">
                Login
            </button>

        </form>

        <div class="text-center mt-4">
            <p>
                Don't have an account?
                <a href="register.jsp">Create Account</a>
            </p>

            <a href="index.jsp">Back to Homepage</a>
        </div>

    </div>

</div>

</body>
</html>
