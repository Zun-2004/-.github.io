
<%@ page import="java.util.List, aiwa.entity.Language" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%!
    String flag(String code) {
        switch (code) {
            case "my": return "🇲🇲";
            case "en": return "🇬🇧";
            case "ja": return "🇯🇵";
            case "ch": return "🇨🇳";
            case "ko": return "🇰🇷";
            default: return "🌐";
        }
    }
%>

<%
    List<Language> natives =
        (List<Language>) request.getAttribute("natives");

    List<Language> learnings =
        (List<Language>) request.getAttribute("learnings");

    int[] current =
        (int[]) request.getAttribute("current");

    String err = request.getParameter("err");

    int curNative = (current == null) ? -1 : current[0];
    int curLearn = (current == null) ? -1 : current[1];
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Language Setup | LinguaTech</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link rel="stylesheet"
        href="${pageContext.request.contextPath}/style.css">

    <style>

        .language-container {
            max-width: 750px;
            margin: auto;
        }

        .language-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .language-icon {
            font-size: 55px;
            margin-bottom: 10px;
        }

        .language-panel {
            background: white;
            border: 1px solid #e0ebe3;
            border-radius: 22px;
            padding: 30px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.06);
        }

        .step-label {
            font-weight: 700;
            font-size: 0.9rem;
            letter-spacing: 1px;
            color: #198754;
            text-transform: uppercase;
        }

        .language-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 12px;
        }

        .language-pick {
            position: relative;
            cursor: pointer;
        }

        .language-pick input {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .language-card {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 20px 10px;
            border-radius: 16px;
            background: #f8fcf9;
            border: 2px solid #e0ebe3;
            transition: transform 0.2s,
                        border-color 0.2s,
                        background 0.2s;
            height: 100%;
        }

        .language-pick:hover .language-card {
            transform: translateY(-3px);
            border-color: #198754;
        }

        .language-pick input:checked + .language-card {
            background: #e8f5ed;
            border-color: #198754;
            box-shadow: 0 4px 15px rgba(25,135,84,0.15);
        }

        .language-pick input:focus-visible + .language-card {
            outline: 2px solid #198754;
            outline-offset: 3px;
        }

        .language-flag {
            font-size: 2.2rem;
            line-height: 1;
        }

        .language-name {
            font-weight: 700;
            font-size: 1rem;
            color: #26382d;
            text-align: center;
        }

        .language-button {
            background: #198754;
            border: none;
            border-radius: 12px;
            padding: 14px;
            font-weight: 700;
            font-size: 1.05rem;
            color: white;
            transition: background 0.2s,
                        transform 0.2s;
        }

        .language-button:hover {
            background: #146c43;
            color: white;
            transform: translateY(-2px);
        }

        .language-error {
            background: #fff3cd;
            border: 1px solid #ffecb5;
            color: #664d03;
            border-radius: 12px;
            padding: 12px 16px;
            margin-bottom: 20px;
        }

        .language-divider {
            border: none;
            border-top: 1px solid #e5eee7;
            margin: 25px 0;
        }

        @media (max-width: 576px) {
            .language-panel {
                padding: 22px 16px;
            }

            .language-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

    </style>

</head>

<body>

<div class="container py-5 language-container">

    <div class="language-header">

        <div class="language-icon">🌿</div>

        <div class="step-label mb-2">
            Setup · 2 Steps
        </div>

        <h1>Language Setup</h1>

        <p class="text-muted">
            Choose your native language and the language you want to learn.
        </p>

    </div>

    <% if ("same".equals(err)) { %>

        <div class="language-error">
            You can't learn with the same language 😅
            Please choose different languages.
        </div>

    <% } else if (err != null) { %>

        <div class="language-error">
            Something went wrong. Please try again.
        </div>

    <% } %>

    <form method="post"
        action="LanguageController"
        class="language-panel">

        <!-- Native Language -->

        <div class="step-label mb-3">
            01 — Choose Your Native Language
        </div>

        <div class="language-grid mb-4">

            <% for (Language l : natives) {

                boolean on =
                    l.getLanguageId() == curNative;
            %>

                <label class="language-pick">

                    <input type="radio"
                        name="native"
                        value="<%= l.getLanguageId() %>"
                        <%= on ? "checked" : "" %>
                        required>

                    <span class="language-card">

                        <span class="language-flag">
                            <%= flag(l.getLanguageCode()) %>
                        </span>

                        <span class="language-name">
                            <%= l.getLanguageName() %>
                        </span>

                    </span>

                </label>

            <% } %>

        </div>

        <hr class="language-divider">

        <!-- Learning Language -->

        <div class="step-label mb-3">
            02 — Choose the Language You Want to Learn
        </div>

        <div class="language-grid mb-4">

            <% for (Language l : learnings) {

                boolean on =
                    l.getLanguageId() == curLearn;
            %>

                <label class="language-pick">

                    <input type="radio"
                        name="learning"
                        value="<%= l.getLanguageId() %>"
                        <%= on ? "checked" : "" %>
                        required>

                    <span class="language-card">

                        <span class="language-flag">
                            <%= flag(l.getLanguageCode()) %>
                        </span>

                        <span class="language-name">
                            <%= l.getLanguageName() %>
                        </span>

                    </span>

                </label>

            <% } %>

        </div>

        <button type="submit"
            class="btn language-button w-100">

            Start Learning 🚀

        </button>

    </form>

    <div class="text-center mt-4">

        <small class="text-muted">
            Your language journey starts here! 🌱
        </small>

    </div>

</div>

</body>
</html>
