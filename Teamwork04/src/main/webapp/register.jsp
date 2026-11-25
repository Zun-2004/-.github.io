
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Create Account | LinguaTech</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link rel="stylesheet" href="css/style.css">

    <style>
        .register-container {
            min-height: 85vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .register-box {
            width: 100%;
            max-width: 450px;
            padding: 40px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.08);
        }

        .register-title {
            text-align: center;
            margin-bottom: 25px;
        }

        .register-icon {
            font-size: 55px;
            text-align: center;
            margin-bottom: 10px;
        }

        .register-button {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            font-weight: bold;
        }
    </style>

</head>

<body>

<div class="container register-container">

    <div class="register-box">

        <div class="register-icon">🌿</div>

        <div class="register-title">
            <h2>Create Account</h2>
            <p class="text-muted">
                Start your learning journey with LinguaTech.
            </p>
        </div>

        <% if (request.getAttribute("msg") != null) { %>

            <div class="alert alert-warning">
                <%= request.getAttribute("msg") %>
            </div>

        <% } %>

        <form method="post" action="RegisterController">

            <div class="mb-3">
                <label class="form-label">Username</label>

                <input type="text"
                    name="username"
                    class="form-control"
                    placeholder="Enter your username"
                    required>
            </div>

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
                    placeholder="Create your password"
                    required>
            </div>

            <button type="submit"
                class="btn btn-primary register-button">
                Create Account
            </button>

        </form>

        <div class="text-center mt-4">

            <p>
                Already have an account?
                <a href="LoginController">Login</a>
            </p>

            <a href="index.jsp">Back to Homepage</a>

        </div>

    </div>

</div>

</body>
</html>
