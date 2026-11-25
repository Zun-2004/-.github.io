<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String token = (String) session.getAttribute("demoSubscriptionToken");
    if (session.getAttribute("user_id") == null || token == null) {
        response.sendRedirect("SubscriptionController");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Premium Lessons</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="py-5">
    <main class="container" style="max-width: 720px;">
        <h1>Premium Lessons</h1>
        <p>Try lessons 5–10 for free until you sign out.</p>
        <form action="SubscriptionController" method="post" class="d-flex gap-3">
            <input type="hidden" name="token" value="<%= token %>">
            <button type="submit" class="btn btn-info">Unlock demo lessons</button>
            <a href="LessonListController" class="btn btn-outline-light">Back to lessons</a>
        </form>
    </main>
</body>
</html>
