
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, aiwa.model.QuizModel" %>
<%
    List<QuizModel> questions = (List<QuizModel>) request.getAttribute("questions");
    Integer lang = (Integer) request.getAttribute("lang");
    if (lang == null && session.getAttribute("quizLang") != null) {
        lang = (Integer) session.getAttribute("quizLang");
    }
    if (lang == null) {
        lang = 1;
    }
    Boolean submitted = (Boolean) request.getAttribute("submitted");
    Integer score = (Integer) request.getAttribute("score");
    Integer total = (Integer) request.getAttribute("total");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>All Lessons Quiz</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>All Lessons Quiz</h2>
        <div>
            <a href="quiz?lang=1" class="btn btn-outline-primary <%= (lang == 1 ? "active" : "") %>">Myanmar</a>
            <a href="quiz?lang=3" class="btn btn-outline-primary <%= (lang == 3 ? "active" : "") %>">Japanese</a>
        </div>
    </div>

    <% if (Boolean.TRUE.equals(submitted)) { %>
        <div class="alert alert-info">
            <strong>Score:</strong> <%= score %> / <%= total %>
            <a href="quiz?lang=<%= lang %>" class="btn btn-sm btn-primary ms-3">Try Again</a>
        </div>
    <% } %>

    <form action="quiz" method="post">
        <% if (questions != null && !questions.isEmpty()) {
            for (int i = 0; i < questions.size(); i++) {
                QuizModel q = questions.get(i);
                String selected = request.getParameter("q_" + i);
        %>
        <div class="card mb-3">
            <div class="card-body">
                <h5 class="card-title"><%= (i + 1) %>. <%= q.getPromptWord() %></h5>
                <% for (String opt : q.getOptions()) {
                    String inputId = "q" + i + "_" + opt.hashCode();
                %>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="q_<%= i %>" id="<%= inputId %>"
                           value="<%= opt %>" <%= (opt.equals(selected) ? "checked" : "") %> required>
                    <label class="form-check-label" for="<%= inputId %>"><%= opt %></label>
                </div>
                <% } %>
                <% if (Boolean.TRUE.equals(submitted)) { %>
                    <div class="mt-2 text-success"><strong>Correct Answer:</strong> <%= q.getCorrectAnswer() %></div>
                <% } %>
            </div>
        </div>
        <%  } %>
        <% if (!Boolean.TRUE.equals(submitted)) { %>
            <button type="submit" class="btn btn-success">Submit Quiz</button>
        <% } %>
        <% } else { %>
            <div class="alert alert-warning">No quiz questions available yet.</div>
        <% } %>
    </form>
</div>
</body>
</html>