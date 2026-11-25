
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, aiwa.model.QuizModel" %>
<%!
    private String escape(String value) {
        return value == null ? "" : value.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    List<QuizModel> questions = (List<QuizModel>) request.getAttribute("questions");
    Integer lang = (Integer) request.getAttribute("lang");
    if (lang == null && session.getAttribute("quizLang") != null) {
        lang = (Integer) session.getAttribute("quizLang");
    }
    if (lang == null) {
        lang = 1;
    }
    Integer lessonId = (Integer) session.getAttribute("quizLessonId");
    if (request.getAttribute("questions") == null && request.getAttribute("submitted") == null) {
        response.sendRedirect("quiz");
        return;
    }
    String retryUrl = lessonId == null ? "quiz?lang=" + lang : "quiz?lessonId=" + lessonId;
    boolean submitted = Boolean.TRUE.equals(request.getAttribute("submitted"));
    int count = questions == null ? 0 : questions.size();
    Integer score = (Integer) request.getAttribute("score");
    Integer total = (Integer) request.getAttribute("total");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><%= lessonId == null ? "All Lessons Quiz" : "Lesson Quiz" %> | LinguaWorld</title>
<style>
    :root { color-scheme: light; --ink: #17233b; --muted: #48576f; --accent: #254b9b; --line: #ccd7e7; }
    * { box-sizing: border-box; }
    body { margin: 0; background: #f0f4fa; color: var(--ink); font: 1rem/1.55 system-ui, "Myanmar Text", "Yu Gothic", sans-serif; }
    main { width: min(48rem, calc(100% - 2rem)); margin: 2rem auto; }
    header { background: #152d54; color: white; padding: clamp(1.25rem, 4vw, 2.5rem); border-radius: 1rem; }
    h1 { margin: .25rem 0 0; font-size: clamp(1.9rem, 5vw, 2.65rem); line-height: 1.15; }
    header a { color: #e1ecff; }
    header p { margin: .6rem 0 0; color: #e1ecff; }
    nav { display: flex; flex-wrap: wrap; gap: .75rem; margin-top: 1rem; }
    nav a[aria-current] { font-weight: 700; }
    .card { min-width: 0; width: 100%; margin: 1rem 0; padding: clamp(1rem, 3vw, 1.5rem); border: 1px solid var(--line); border-radius: .85rem; background: white; }
    .prompt { display: block; margin: 0 0 .8rem; font-size: 1.15rem; font-weight: 650; overflow-wrap: anywhere; }
    .number { color: var(--accent); margin-right: .4rem; }
    .options { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: .65rem; }
    .option { display: flex; align-items: center; gap: .65rem; min-height: 3rem; padding: .65rem .8rem; border: 1px solid var(--line); border-radius: .55rem; overflow-wrap: anywhere; }
    label.option { cursor: pointer; }
    label.option:hover, .option:has(input:checked) { background: #eef4ff; border-color: var(--accent); }
    .option input { flex: none; margin: 0; accent-color: var(--accent); }
    .option.correct { border-color: #388067; background: #e9f7ef; }
    .option.wrong { border-color: #a65749; background: #fff1ed; }
    .answer-note { display: block; font-size: .85rem; font-weight: 650; }
    .summary { display: flex; justify-content: space-between; align-items: center; gap: .75rem; flex-wrap: wrap; }
    .summary p { margin: 0; color: var(--muted); }
    .summary strong { color: var(--ink); font-size: 1.35rem; }
    .button { display: inline-block; border: 0; border-radius: .55rem; padding: .75rem 1.1rem; background: var(--accent); color: white; font: inherit; font-weight: 650; text-decoration: none; cursor: pointer; }
    :focus-visible { outline: 3px solid #557bcb; outline-offset: 3px; }
    @media (max-width: 35rem) { .options { grid-template-columns: 1fr; } main { margin-top: 1rem; } }
</style>
</head>
<body>
<main>
    <header>
        <% if (lessonId != null) { %>
        <a href="LessonDetailController?id=<%= lessonId %>">Back to lesson</a>
        <% } %>
        <h1><%= lessonId == null ? "All Lessons Quiz" : "Lesson Quiz" %></h1>
        <% if (count > 0 && !submitted) { %>
        <p><%= count %> questions. Choose one answer per question.</p>
        <% } %>
        <% if (lessonId == null) { %>
        <nav aria-label="Quiz languages">
            <a href="quiz?lang=1" <%= lang == 1 ? "aria-current=\"page\"" : "" %>>Myanmar</a>
            <a href="quiz?lang=3" <%= lang == 3 ? "aria-current=\"page\"" : "" %>>Japanese</a>
        </nav>
        <% } %>
    </header>

    <% if (submitted) { %>
    <section class="card summary" aria-label="Quiz results">
        <p>Score <strong><%= score %> / <%= total %></strong></p>
        <a href="<%= retryUrl %>" class="button">Try again</a>
    </section>
    <% } %>

    <% if (count == 0) { %>
    <p class="card">No quiz questions available yet.</p>
    <% } else { %>
    <form action="quiz" method="post">
        <% for (int i = 0; i < count; i++) {
            QuizModel q = questions.get(i);
            String selected = request.getParameter("q_" + i);
        %>
        <section class="card" role="group" aria-labelledby="prompt-<%= i %>">
            <h2 id="prompt-<%= i %>" class="prompt"><span class="number"><%= i + 1 %>.</span><%= escape(q.getPromptWord()) %></h2>
            <div class="options">
                <% for (String option : q.getOptions()) {
                    boolean correct = option.equals(q.getCorrectAnswer());
                    boolean chosen = option.equals(selected);
                    if (submitted) {
                %>
                <div class="option <%= correct ? "correct" : chosen ? "wrong" : "" %>">
                    <span><%= escape(option) %>
                    <% if (correct || chosen) { %>
                    <span class="answer-note"><%= correct ? (chosen ? "Your answer · Correct" : "Correct answer") : "Your answer · Incorrect" %></span>
                    <% } %>
                    </span>
                </div>
                <% } else { %>
                <label class="option">
                    <input type="radio" name="q_<%= i %>" value="<%= escape(option) %>" required>
                    <span><%= escape(option) %></span>
                </label>
                <% } } %>
            </div>
        </section>
        <% } %>
        <% if (!submitted) { %>
        <button type="submit" class="button">Submit quiz</button>
        <% } %>
    </form>
    <% } %>
</main>
</body>
</html>
