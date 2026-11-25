
<%@ page import="java.util.ArrayList, aiwa.entity.Lesson" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lessons | LinguaTech</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .lessons-container {
            max-width: 1150px;
            margin: auto;
        }

        .page-header {
            background: white;
            border: 1px solid #e2e5e2;
            border-radius: 18px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }

        .lesson-card {
            border-radius: 16px;
            transition: transform 0.18s ease,
                        box-shadow 0.18s ease,
                        border-color 0.18s ease;
        }

        .lesson-card-free {
            background: white;
            border: 2px solid #b7dfc5;
            box-shadow: 0 4px 12px rgba(25,135,84,0.06);
        }

        .lesson-card-free:hover {
            transform: translateY(-5px);
            border-color: #198754;
            box-shadow: 0 12px 24px rgba(25,135,84,0.14);
        }

        .lesson-card-premium {
            background: #edf1ee;
            border: 1px solid #d5dfd8;
            opacity: 0.8;
        }

        .icon-badge-free,
        .icon-badge-premium {
            width: 55px;
            height: 55px;
            border-radius: 15px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .icon-badge-free {
            background: #e8f5ed;
            color: #198754;
        }

        .icon-badge-premium {
            background: #dfe7e1;
            color: #718078;
        }

        .plan-banner {
            background: white;
            border: 1px solid #dce8df;
            border-radius: 14px;
            padding: 16px 20px;
        }

        .lesson-card .card-body {
            min-height: 190px;
        }

        .header-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            justify-content: flex-end;
        }

        @media (max-width: 576px) {
            .page-header {
                padding: 18px;
            }

            .lesson-card .card-body {
                padding: 20px 10px !important;
                min-height: 165px;
            }

            .page-header {
                align-items: flex-start !important;
                flex-direction: column;
                gap: 18px;
            }

            .header-buttons {
                justify-content: flex-start;
                width: 100%;
            }
        }
    </style>
</head>

<body>

<%
    ArrayList<Lesson> lessons =
        (ArrayList<Lesson>) request.getAttribute("lessons");
%>

<div class="container py-5 lessons-container">

    <!-- Page Header -->
    <div class="page-header d-flex justify-content-between align-items-center mb-4">

        <div>
            <div class="text-success fw-semibold mb-2">
                🌿 LinguaTech Learning
            </div>

            <h1 class="mb-1">My Lessons</h1>

            <small class="text-secondary">
                Choose a lesson and start learning!
            </small>
        </div>

        <!-- Navigation Buttons -->
        <div class="header-buttons">

            <a href="${pageContext.request.contextPath}/selectLanguage.jsp"
                class="btn btn-outline-success px-3 py-2 rounded-3">
                <i class="bi bi-house-door me-1"></i>
                Home
            </a>

            <a href="${pageContext.request.contextPath}/subscription.jsp?lessonNo=5"
                class="btn btn-success px-3 py-2 rounded-3">
                <i class="bi bi-star-fill me-1"></i>
                Subscription
            </a>

            <a href="${pageContext.request.contextPath}/LogoutController"
                class="btn btn-outline-secondary px-3 py-2 rounded-3">
                <i class="bi bi-box-arrow-right me-1"></i>
                Logout
            </a>

        </div>
    </div>

    <!-- Lesson Cards -->
    <div class="row row-cols-2 row-cols-md-5 g-3 g-md-4">

        <% if (lessons != null) {
            for (Lesson l : lessons) { %>

            <div class="col">

                <% if (l.isPremium()) { %>

                    <!-- Premium Lesson -->
                    <div class="card lesson-card lesson-card-premium text-center h-100">

                        <div class="card-body py-4 px-3 d-flex flex-column align-items-center justify-content-center">

                            <div class="icon-badge-premium mb-3">
                                <i class="bi bi-lock-fill fs-4"></i>
                            </div>

                            <span class="badge text-bg-secondary mb-1">
                                Lesson <%= l.getLessonNo() %>
                            </span>

                            <div class="fw-semibold text-secondary mt-1">
                                <%= l.getTitle() %>
                            </div>

                            <small class="text-secondary mt-2">
                                Premium
                            </small>

                        </div>
                    </div>

                <% } else { %>

                    <!-- Free Lesson -->
                    <a href="${pageContext.request.contextPath}/LessonDetailController?id=<%= l.getLessonId() %>"
                        class="text-decoration-none d-block h-100">

                        <div class="card lesson-card lesson-card-free text-center h-100">

                            <div class="card-body py-4 px-3 d-flex flex-column align-items-center justify-content-center">

                                <div class="icon-badge-free mb-3">
                                    <i class="bi bi-book-half fs-4"></i>
                                </div>

                                <span class="badge text-bg-success mb-1">
                                    Lesson <%= l.getLessonNo() %>
                                </span>

                                <div class="fw-semibold text-dark mt-1">
                                    <%= l.getTitle() %>
                                </div>

                                <small class="text-success mt-2">
                                    Start Learning →
                                </small>

                            </div>
                        </div>
                    </a>

                <% } %>

            </div>

        <% }
        } else { %>

            <div class="col-12">
                <div class="alert alert-warning">
                    No lessons available.
                </div>
            </div>

        <% } %>

    </div>

    <!-- Plan Information -->
    <div class="plan-banner mt-4 d-flex flex-wrap justify-content-between align-items-center gap-2">

        <span class="text-secondary small">
            Lesson 1–4 Free | Lesson 5–10 Premium
        </span>

        <span class="text-secondary small">
            <i class="bi bi-check-circle-fill text-success me-1"></i>
            Free

            <i class="bi bi-lock-fill text-secondary ms-3 me-1"></i>
            Premium
        </span>

    </div>

    <div class="text-center mt-4">
        <small class="text-muted">
            Keep learning and improving every day! 🌱
        </small>
    </div>

</div>

</body>
</html>
