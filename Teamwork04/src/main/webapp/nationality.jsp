
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Select Nationality | LinguaTech</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .nationality-container {
            min-height: 85vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .nationality-box {
            width: 100%;
            max-width: 450px;
            padding: 40px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.08);
        }

        .nationality-icon {
            font-size: 55px;
            text-align: center;
            margin-bottom: 15px;
        }

        .nationality-title {
            text-align: center;
            margin-bottom: 25px;
        }

        .nationality-button {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="container nationality-container">

    <div class="nationality-box">

        <div class="nationality-icon">🌍</div>

        <div class="nationality-title">
            <h2>Select Your Nationality</h2>

            <p class="text-muted">
                Please select your nationality.
            </p>
        </div>

        <% if (request.getAttribute("message") != null) { %>

            <div class="alert alert-warning">
                <%= request.getAttribute("message") %>
            </div>

        <% } %>

        <form action="nationality" method="post">

            <div class="mb-4">

                <label class="form-label">
                    Nationality
                </label>

                <select name="nationality"
                    class="form-select"
                    required>

                    <option value="">-- Select Nationality --</option>

                    <option value="Myanmar">Myanmar</option>
                    <option value="English">English</option>
                    <option value="Japan">Japan</option>
                    <option value="China">China</option>
                    <option value="Korea">Korea</option>

                </select>

            </div>

            <button type="submit"
                class="btn btn-primary nationality-button">

                Continue →

            </button>

        </form>

        <div class="text-center mt-4">
            <a href="login.jsp">
                Back to Login
            </a>
        </div>

    </div>

</div>

</body>
</html>
